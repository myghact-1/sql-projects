/* =====================================================================
BRONZE → SILVER - ETL PROCEDURE
=====================================================================

Procedure:
silver.load_silver()

Purpose:
1. Clear existing Silver CRM + ERP data
2. Clean and transform Bronze CRM data
3. Clean and transform Bronze ERP data
4. Load all six Silver tables
5. Report row counts and execution time
6. Report SQLSTATE / SQLERRM on failure

Design:
Bronze = raw source data
Silver = cleaned + standardized data

Full-load behavior:
The six Silver tables are truncated before loading.
Running the procedure repeatedly produces the same result
for the same Bronze input.

IMPORTANT:
The procedure must be executed with:

CALL silver.load_silver();

===================================================================== */
CREATE OR REPLACE PROCEDURE silver.load_silver () LANGUAGE plpgsql AS $$
DECLARE

    /* =================================================================
       VARIABLES
       ================================================================= */

    v_start_time        TIMESTAMPTZ := clock_timestamp();
    v_end_time          TIMESTAMPTZ;

    v_rows_inserted     BIGINT := 0;
    v_total_rows        BIGINT := 0;

BEGIN

    /* =================================================================
       STEP 0 - START
       ================================================================= */

    RAISE NOTICE '';
    RAISE NOTICE '============================================================';
    RAISE NOTICE 'BRONZE → SILVER ETL STARTED';
    RAISE NOTICE '============================================================';
    RAISE NOTICE 'Start time: %', v_start_time;
    RAISE NOTICE '';


    /* =================================================================
       STEP 1 - CLEAR SILVER TABLES
       =================================================================

       This is a full-load ETL process.

       TRUNCATE is used instead of DELETE because all existing Silver
       records are replaced during every load.

       Keeping all six tables in one TRUNCATE statement also makes the
       initialization easier to manage.
       ================================================================= */

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 1: Clearing existing Silver data';
    RAISE NOTICE '------------------------------------------------------------';

    RAISE NOTICE 'Truncating CRM and ERP Silver tables...';

    TRUNCATE TABLE
        silver.crm_cust_info,
        silver.crm_prd_info,
        silver.crm_sales_details,
        silver.erp_cust_az12,
        silver.erp_loc_a101,
        silver.erp_px_cat_glv2;

    RAISE NOTICE 'SUCCESS: All six Silver tables cleared.';
    RAISE NOTICE '';


    /* =================================================================
       STEP 2 - CRM CUSTOMER
       =================================================================

       Transformations:
           - Remove duplicate cst_id records
           - Keep latest customer record
           - Trim text
           - Convert empty names to NULL
           - Standardize marital status
           - Standardize gender
           - Ignore NULL customer IDs
       ================================================================= */

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 2: Transforming CRM customer data';
    RAISE NOTICE '------------------------------------------------------------';

    INSERT INTO silver.crm_cust_info
    (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gndr,
        cst_create_date
    )
    SELECT
        cst_id,
        NULLIF(TRIM(cst_key), ''),
        NULLIF(TRIM(cst_firstname), ''),
        NULLIF(TRIM(cst_lastname), ''),

        CASE
            WHEN UPPER(TRIM(cst_marital_status)) = 'S'
                THEN 'Single'
            WHEN UPPER(TRIM(cst_marital_status)) = 'M'
                THEN 'Married'
            ELSE 'n/a'
        END AS cst_marital_status,

        CASE
            WHEN UPPER(TRIM(cst_gndr)) = 'F'
                THEN 'Female'
            WHEN UPPER(TRIM(cst_gndr)) = 'M'
                THEN 'Male'
            ELSE 'n/a'
        END AS cst_gndr,

        cst_create_date

    FROM
    (
        SELECT
            c.*,

            /*
               Keep the latest record for each customer.

               ctid is used only as a final tie-breaker when both
               cst_id and cst_create_date are identical. It is not
               stored as a business key.
            */
            ROW_NUMBER() OVER
            (
                PARTITION BY cst_id
                ORDER BY
                    cst_create_date DESC NULLS LAST,
                    ctid DESC
            ) AS rn

        FROM bronze.crm_cust_info AS c
        WHERE cst_id IS NOT NULL
    ) AS customer_data

    WHERE rn = 1;

    GET DIAGNOSTICS v_rows_inserted = ROW_COUNT;
    v_total_rows := v_total_rows + v_rows_inserted;

    RAISE NOTICE 'SUCCESS: silver.crm_cust_info loaded.';
    RAISE NOTICE 'Rows inserted: %', v_rows_inserted;
    RAISE NOTICE '';


    /* =================================================================
       STEP 3 - CRM PRODUCT
       =================================================================

       Transformations:
           - Extract category ID
           - Extract product key
           - Clean product name
           - Replace NULL cost with zero
           - Standardize product line
           - Generate product end dates using LEAD()
       ================================================================= */

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 3: Transforming CRM product data';
    RAISE NOTICE '------------------------------------------------------------';

    INSERT INTO silver.crm_prd_info
    (
        prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )
    SELECT
        prd_id,

        /*
           Example:
               AC-HE-123
               -----------
               AC_HE
        */
        REPLACE(SUBSTRING(TRIM(prd_key) FROM 1 FOR 5), '-', '_')
            AS cat_id,

        /*
           Remove category prefix.

           Example:
               AC-HE-123
                   ↓
               123
        */
        NULLIF(SUBSTRING(TRIM(prd_key) FROM 7), '') AS prd_key,

        NULLIF(TRIM(prd_nm), '') AS prd_nm,

        COALESCE(prd_cost, 0) AS prd_cost,

        CASE
            WHEN UPPER(TRIM(prd_line)) = 'M'
                THEN 'Mountain'
            WHEN UPPER(TRIM(prd_line)) = 'R'
                THEN 'Road'
            WHEN UPPER(TRIM(prd_line)) = 'S'
                THEN 'Other Sales'
            WHEN UPPER(TRIM(prd_line)) = 'T'
                THEN 'Touring'
            ELSE 'n/a'
        END AS prd_line,

        prd_start_dt,

        /*
           The next start date becomes the previous record's end date
           minus one day.

           The final/current record receives NULL as its end date.
        */
        (
            LEAD(prd_start_dt) OVER
            (
                PARTITION BY prd_key
                ORDER BY prd_start_dt
            ) - INTERVAL '1 day'
        )::DATE AS prd_end_dt

    FROM bronze.crm_prd_info;

    GET DIAGNOSTICS v_rows_inserted = ROW_COUNT;
    v_total_rows := v_total_rows + v_rows_inserted;

    RAISE NOTICE 'SUCCESS: silver.crm_prd_info loaded.';
    RAISE NOTICE 'Rows inserted: %', v_rows_inserted;
    RAISE NOTICE '';


    /* =================================================================
       STEP 4 - CRM SALES
       =================================================================

       Transformations:
           - Convert YYYYMMDD integers to DATE
           - Convert 0 / malformed dates to NULL
           - Correct invalid sales
           - Correct invalid prices
           - Prevent division by zero
       ================================================================= */

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 4: Transforming CRM sales data';
    RAISE NOTICE '------------------------------------------------------------';

    INSERT INTO silver.crm_sales_details
    (
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price
    )
    SELECT
        sls_ord_num,
        NULLIF(TRIM(sls_prd_key), ''),
        sls_cust_id,

        /* =============================================================
           ORDER DATE
           ============================================================= */
        CASE
            WHEN sls_order_dt IS NULL
                OR sls_order_dt = 0
                OR LENGTH(sls_order_dt::TEXT) <> 8
                THEN NULL

            WHEN TO_CHAR(
                     TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD'),
                     'YYYYMMDD'
                 ) = sls_order_dt::TEXT
                THEN TO_DATE(sls_order_dt::TEXT, 'YYYYMMDD')

            ELSE NULL
        END AS sls_order_dt,

        /* =============================================================
           SHIP DATE
           ============================================================= */
        CASE
            WHEN sls_ship_dt IS NULL
                OR sls_ship_dt = 0
                OR LENGTH(sls_ship_dt::TEXT) <> 8
                THEN NULL

            WHEN TO_CHAR(
                     TO_DATE(sls_ship_dt::TEXT, 'YYYYMMDD'),
                     'YYYYMMDD'
                 ) = sls_ship_dt::TEXT
                THEN TO_DATE(sls_ship_dt::TEXT, 'YYYYMMDD')

            ELSE NULL
        END AS sls_ship_dt,

        /* =============================================================
           DUE DATE
           ============================================================= */
        CASE
            WHEN sls_due_dt IS NULL
                OR sls_due_dt = 0
                OR LENGTH(sls_due_dt::TEXT) <> 8
                THEN NULL

            WHEN TO_CHAR(
                     TO_DATE(sls_due_dt::TEXT, 'YYYYMMDD'),
                     'YYYYMMDD'
                 ) = sls_due_dt::TEXT
                THEN TO_DATE(sls_due_dt::TEXT, 'YYYYMMDD')

            ELSE NULL
        END AS sls_due_dt,

        /* =============================================================
           SALES AMOUNT
           =============================================================

           If sales is missing, non-positive, or inconsistent with
           quantity × price, calculate it from quantity × ABS(price).

           GREATEST() prevents negative quantities from creating a
           negative derived sales value.
           ============================================================= */
        CASE
            WHEN sls_sales IS NULL
                OR sls_sales <= 0
                OR sls_sales <> sls_quantity * ABS(sls_price)
                THEN
                    GREATEST(COALESCE(sls_quantity, 0), 0)
                    * ABS(COALESCE(sls_price, 0))
            ELSE sls_sales
        END AS sls_sales,

        /* Quantity is retained from the source. */
        sls_quantity,

        /* =============================================================
           PRICE
           =============================================================

           If source price is missing/invalid, derive it from
           sales ÷ quantity.

           NULLIF prevents division by zero.
           ============================================================= */
        CASE
            WHEN sls_price IS NULL
                OR sls_price <= 0
                THEN
                    CASE
                        WHEN sls_quantity > 0
                            AND sls_sales > 0
                            THEN sls_sales / NULLIF(sls_quantity, 0)
                        ELSE NULL
                    END
            ELSE sls_price
        END AS sls_price

    FROM bronze.crm_sales_details;

    GET DIAGNOSTICS v_rows_inserted = ROW_COUNT;
    v_total_rows := v_total_rows + v_rows_inserted;

    RAISE NOTICE 'SUCCESS: silver.crm_sales_details loaded.';
    RAISE NOTICE 'Rows inserted: %', v_rows_inserted;
    RAISE NOTICE '';


    /* =================================================================
       STEP 5 - ERP CUSTOMER
       =================================================================

       Transformations:
           - Remove NAS prefix from cid
           - Trim customer ID
           - Convert future birth dates to NULL
           - Standardize gender
       ================================================================= */

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 5: Transforming ERP customer data';
    RAISE NOTICE '------------------------------------------------------------';

    INSERT INTO silver.erp_cust_az12
    (
        cid,
        bdate,
        gen
    )
    SELECT

        CASE
            WHEN UPPER(TRIM(cid)) LIKE 'NAS%'
                THEN SUBSTRING(TRIM(cid) FROM 4)
            ELSE NULLIF(TRIM(cid), '')
        END AS cid,

        CASE
            WHEN bdate IS NULL
                THEN NULL
            WHEN bdate > CURRENT_DATE
                THEN NULL
            ELSE bdate
        END AS bdate,

        CASE
            WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE')
                THEN 'Female'
            WHEN UPPER(TRIM(gen)) IN ('M', 'MALE')
                THEN 'Male'
            ELSE 'n/a'
        END AS gen

    FROM bronze.erp_cust_az12;

    GET DIAGNOSTICS v_rows_inserted = ROW_COUNT;
    v_total_rows := v_total_rows + v_rows_inserted;

    RAISE NOTICE 'SUCCESS: silver.erp_cust_az12 loaded.';
    RAISE NOTICE 'Rows inserted: %', v_rows_inserted;
    RAISE NOTICE '';


    /* =================================================================
       STEP 6 - ERP LOCATION
       =================================================================

       Transformations:
           - Remove '-' from customer IDs
           - Trim values
           - Standardize Germany
           - Standardize United States
           - Handle NULL/empty country values
       ================================================================= */

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 6: Transforming ERP location data';
    RAISE NOTICE '------------------------------------------------------------';

    INSERT INTO silver.erp_loc_a101
    (
        cid,
        cntry
    )
    SELECT

        NULLIF(
            REPLACE(TRIM(cid), '-', ''),
            ''
        ) AS cid,

        CASE
            WHEN UPPER(TRIM(cntry)) = 'DE'
                THEN 'Germany'

            WHEN UPPER(TRIM(cntry)) IN ('USA', 'US')
                THEN 'United States'

            WHEN cntry IS NULL
                OR TRIM(cntry) = ''
                THEN 'n/a'

            ELSE TRIM(cntry)
        END AS cntry

    FROM bronze.erp_loc_a101;

    GET DIAGNOSTICS v_rows_inserted = ROW_COUNT;
    v_total_rows := v_total_rows + v_rows_inserted;

    RAISE NOTICE 'SUCCESS: silver.erp_loc_a101 loaded.';
    RAISE NOTICE 'Rows inserted: %', v_rows_inserted;
    RAISE NOTICE '';


    /* =================================================================
       STEP 7 - ERP PRODUCT CATEGORY
       =================================================================

       Transformations:
           - Trim text
           - Convert empty strings to NULL

       The original ERP category transformation was a direct copy.
       Basic cleanup is applied here because this is the Silver layer.
       ================================================================= */

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 7: Transforming ERP product category data';
    RAISE NOTICE '------------------------------------------------------------';

    INSERT INTO silver.erp_px_cat_glv2
    (
        id,
        cat,
        subcat,
        maintenance
    )
    SELECT
        NULLIF(TRIM(id), ''),
        NULLIF(TRIM(cat), ''),
        NULLIF(TRIM(subcat), ''),
        NULLIF(TRIM(maintenance), '')

    FROM bronze.erp_px_cat_glv2;

    GET DIAGNOSTICS v_rows_inserted = ROW_COUNT;
    v_total_rows := v_total_rows + v_rows_inserted;

    RAISE NOTICE 'SUCCESS: silver.erp_px_cat_glv2 loaded.';
    RAISE NOTICE 'Rows inserted: %', v_rows_inserted;
    RAISE NOTICE '';


    /* =================================================================
       STEP 8 - FINAL VALIDATION
       ================================================================= */

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 8: Validating Silver row counts';
    RAISE NOTICE '------------------------------------------------------------';

    RAISE NOTICE 'silver.crm_cust_info       : % rows',
        (SELECT COUNT(*) FROM silver.crm_cust_info);

    RAISE NOTICE 'silver.crm_prd_info        : % rows',
        (SELECT COUNT(*) FROM silver.crm_prd_info);

    RAISE NOTICE 'silver.crm_sales_details   : % rows',
        (SELECT COUNT(*) FROM silver.crm_sales_details);

    RAISE NOTICE 'silver.erp_cust_az12       : % rows',
        (SELECT COUNT(*) FROM silver.erp_cust_az12);

    RAISE NOTICE 'silver.erp_loc_a101        : % rows',
        (SELECT COUNT(*) FROM silver.erp_loc_a101);

    RAISE NOTICE 'silver.erp_px_cat_glv2     : % rows',
        (SELECT COUNT(*) FROM silver.erp_px_cat_glv2);


    /* =================================================================
       STEP 9 - FINAL SUMMARY
       ================================================================= */

    v_end_time := clock_timestamp();

    RAISE NOTICE '';
    RAISE NOTICE '============================================================';
    RAISE NOTICE 'BRONZE → SILVER ETL COMPLETED SUCCESSFULLY';
    RAISE NOTICE '============================================================';

    RAISE NOTICE 'CRM customer rows       : %',
        (SELECT COUNT(*) FROM silver.crm_cust_info);

    RAISE NOTICE 'CRM product rows        : %',
        (SELECT COUNT(*) FROM silver.crm_prd_info);

    RAISE NOTICE 'CRM sales rows          : %',
        (SELECT COUNT(*) FROM silver.crm_sales_details);

    RAISE NOTICE 'ERP customer rows       : %',
        (SELECT COUNT(*) FROM silver.erp_cust_az12);

    RAISE NOTICE 'ERP location rows       : %',
        (SELECT COUNT(*) FROM silver.erp_loc_a101);

    RAISE NOTICE 'ERP category rows       : %',
        (SELECT COUNT(*) FROM silver.erp_px_cat_glv2);

    RAISE NOTICE 'Total rows inserted     : %', v_total_rows;

    RAISE NOTICE 'Start time              : %', v_start_time;
    RAISE NOTICE 'End time                : %', v_end_time;
    RAISE NOTICE 'Total duration          : %',
                 v_end_time - v_start_time;

    RAISE NOTICE '============================================================';
    RAISE NOTICE 'SILVER LAYER IS READY';
    RAISE NOTICE '============================================================';
    RAISE NOTICE '';


/* =====================================================================
   ERROR HANDLING
   ===================================================================== */

EXCEPTION
    WHEN OTHERS THEN

        v_end_time := clock_timestamp();

        RAISE NOTICE '';
        RAISE NOTICE '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';
        RAISE NOTICE 'BRONZE → SILVER ETL FAILED';
        RAISE NOTICE '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';

        RAISE NOTICE 'Failure time          : %', v_end_time;
        RAISE NOTICE 'SQLSTATE              : %', SQLSTATE;
        RAISE NOTICE 'SQL error             : %', SQLERRM;
        RAISE NOTICE 'Rows processed before failure: %',
                     v_total_rows;
        RAISE NOTICE 'Execution time before failure: %',
                     v_end_time - v_start_time;

        RAISE NOTICE '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';

        /*
           Re-throw the original error.

           Because this procedure is executed transactionally, a
           failure causes the failed transaction to roll back rather
           than leaving a partially loaded Silver layer.
        */
        RAISE;

END;
$$;

/* =====================================================================
EXECUTE THE UNIFIED PROCEDURE
===================================================================== */
CALL silver.load_silver ();
