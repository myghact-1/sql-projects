/* =====================================================================
BRONZE LAYER - DATA LOADING PROCEDURE
=====================================================================

Purpose:
--------
Loads raw CRM and ERP CSV files into the Bronze layer.

Process:
--------
1. Truncate existing Bronze tables
2. Load CRM customer data
3. Load CRM product data
4. Load CRM sales data
5. Load ERP customer data
6. Load ERP product/category data
7. Load ERP location data
8. Display row counts and execution messages
9. Handle and report errors

Important:
---------
COPY FROM reads the file from the PostgreSQL SERVER's filesystem.
If PostgreSQL is running on another machine, Docker container,
WSL, or VM, the S:\ drive may not be accessible to PostgreSQL.
===================================================================== */
CREATE OR REPLACE PROCEDURE bronze.load_bronze () LANGUAGE plpgsql AS $$

DECLARE

    /* ---------------------------------------------------------------
       Variables used for debugging and reporting
       --------------------------------------------------------------- */

    v_start_time      TIMESTAMP := clock_timestamp();
    v_end_time        TIMESTAMP;

    v_rows_loaded     BIGINT := 0;
    v_total_rows      BIGINT := 0;

BEGIN

    /* ===============================================================
       PROCEDURE START
       =============================================================== */

    RAISE NOTICE '';
    RAISE NOTICE '============================================================';
    RAISE NOTICE 'BRONZE LAYER LOAD STARTED';
    RAISE NOTICE 'Start Time: %', v_start_time;
    RAISE NOTICE '============================================================';
    RAISE NOTICE '';


    /* ===============================================================
       STEP 1 - CLEAR BRONZE TABLES
       ===============================================================

       All six tables can be truncated in a single statement.
       =============================================================== */

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 1: Truncating Bronze tables';
    RAISE NOTICE '------------------------------------------------------------';

    RAISE NOTICE 'Truncating CRM and ERP Bronze tables...';

    TRUNCATE TABLE
        bronze.crm_cust_info,
        bronze.crm_prd_info,
        bronze.crm_sales_details,
        bronze.erp_cust_az12,
        bronze.erp_px_cat_glv2,
        bronze.erp_loc_a101;

    RAISE NOTICE 'All Bronze tables truncated successfully.';
    RAISE NOTICE '';


    /* ===============================================================
       STEP 2 - LOAD CRM CUSTOMER DATA
       =============================================================== */

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 2: Loading bronze.crm_cust_info';
    RAISE NOTICE '------------------------------------------------------------';

    RAISE NOTICE 'Source file: cust_info.csv';
    RAISE NOTICE 'Starting COPY...';

    COPY bronze.crm_cust_info
    FROM 'S:\SQL\sql-projects\Data Warehouse Project\datasets\source_crm\cust_info.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    GET DIAGNOSTICS v_rows_loaded = ROW_COUNT;

    v_total_rows := v_total_rows + v_rows_loaded;

    RAISE NOTICE 'SUCCESS: crm_cust_info loaded.';
    RAISE NOTICE 'Rows loaded: %', v_rows_loaded;
    RAISE NOTICE '';


    /* ===============================================================
       STEP 3 - LOAD CRM PRODUCT DATA
       =============================================================== */

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 3: Loading bronze.crm_prd_info';
    RAISE NOTICE '------------------------------------------------------------';

    RAISE NOTICE 'Source file: prd_info.csv';
    RAISE NOTICE 'Starting COPY...';

    COPY bronze.crm_prd_info
    FROM 'S:\SQL\sql-projects\Data Warehouse Project\datasets\source_crm\prd_info.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    GET DIAGNOSTICS v_rows_loaded = ROW_COUNT;

    v_total_rows := v_total_rows + v_rows_loaded;

    RAISE NOTICE 'SUCCESS: crm_prd_info loaded.';
    RAISE NOTICE 'Rows loaded: %', v_rows_loaded;
    RAISE NOTICE '';


    /* ===============================================================
       STEP 4 - LOAD CRM SALES DATA
       =============================================================== */

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 4: Loading bronze.crm_sales_details';
    RAISE NOTICE '------------------------------------------------------------';

    RAISE NOTICE 'Source file: sales_details.csv';
    RAISE NOTICE 'Starting COPY...';

    COPY bronze.crm_sales_details
    FROM 'S:\SQL\sql-projects\Data Warehouse Project\datasets\source_crm\sales_details.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    GET DIAGNOSTICS v_rows_loaded = ROW_COUNT;

    v_total_rows := v_total_rows + v_rows_loaded;

    RAISE NOTICE 'SUCCESS: crm_sales_details loaded.';
    RAISE NOTICE 'Rows loaded: %', v_rows_loaded;
    RAISE NOTICE '';


    /* ===============================================================
       STEP 5 - LOAD ERP CUSTOMER DATA
       =============================================================== */

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 5: Loading bronze.erp_cust_az12';
    RAISE NOTICE '------------------------------------------------------------';

    RAISE NOTICE 'Source file: CUST_AZ12.csv';
    RAISE NOTICE 'Starting COPY...';

    COPY bronze.erp_cust_az12
    FROM 'S:\SQL\sql-projects\Data Warehouse Project\datasets\source_erp\CUST_AZ12.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    GET DIAGNOSTICS v_rows_loaded = ROW_COUNT;

    v_total_rows := v_total_rows + v_rows_loaded;

    RAISE NOTICE 'SUCCESS: erp_cust_az12 loaded.';
    RAISE NOTICE 'Rows loaded: %', v_rows_loaded;
    RAISE NOTICE '';


    /* ===============================================================
       STEP 6 - LOAD ERP PRODUCT CATEGORY DATA
       =============================================================== */

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 6: Loading bronze.erp_px_cat_glv2';
    RAISE NOTICE '------------------------------------------------------------';

    RAISE NOTICE 'Source file: PX_CAT_G1V2.csv';
    RAISE NOTICE 'Starting COPY...';

    COPY bronze.erp_px_cat_glv2
    FROM 'S:\SQL\sql-projects\Data Warehouse Project\datasets\source_erp\PX_CAT_G1V2.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    GET DIAGNOSTICS v_rows_loaded = ROW_COUNT;

    v_total_rows := v_total_rows + v_rows_loaded;

    RAISE NOTICE 'SUCCESS: erp_px_cat_glv2 loaded.';
    RAISE NOTICE 'Rows loaded: %', v_rows_loaded;
    RAISE NOTICE '';


    /* ===============================================================
       STEP 7 - LOAD ERP LOCATION DATA
       =============================================================== */

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 7: Loading bronze.erp_loc_a101';
    RAISE NOTICE '------------------------------------------------------------';

    RAISE NOTICE 'Source file: LOC_A101.csv';
    RAISE NOTICE 'Starting COPY...';

    COPY bronze.erp_loc_a101
    FROM 'S:\SQL\sql-projects\Data Warehouse Project\datasets\source_erp\LOC_A101.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    GET DIAGNOSTICS v_rows_loaded = ROW_COUNT;

    v_total_rows := v_total_rows + v_rows_loaded;

    RAISE NOTICE 'SUCCESS: erp_loc_a101 loaded.';
    RAISE NOTICE 'Rows loaded: %', v_rows_loaded;
    RAISE NOTICE '';


    /* ===============================================================
       STEP 8 - CALCULATE EXECUTION TIME
       =============================================================== */

    v_end_time := clock_timestamp();

    RAISE NOTICE '============================================================';
    RAISE NOTICE 'BRONZE LAYER LOAD COMPLETED SUCCESSFULLY';
    RAISE NOTICE '============================================================';

    RAISE NOTICE 'Total rows loaded: %', v_total_rows;
    RAISE NOTICE 'Start Time: %', v_start_time;
    RAISE NOTICE 'End Time:   %', v_end_time;
    RAISE NOTICE 'Duration:   %', v_end_time - v_start_time;

    RAISE NOTICE '============================================================';
    RAISE NOTICE 'CRM + ERP DATA LOADED SUCCESSFULLY';
    RAISE NOTICE '============================================================';


/* =====================================================================
   ERROR HANDLING
   ===================================================================== */

EXCEPTION
    WHEN OTHERS THEN

        v_end_time := clock_timestamp();

        RAISE NOTICE '';
        RAISE NOTICE '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';
        RAISE NOTICE 'BRONZE LOAD FAILED';
        RAISE NOTICE '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';

        RAISE NOTICE 'Error Time: %', v_end_time;
        RAISE NOTICE 'SQLSTATE:   %', SQLSTATE;
        RAISE NOTICE 'Error:      %', SQLERRM;

        RAISE NOTICE 'Rows successfully loaded before failure: %', v_total_rows;
        RAISE NOTICE 'Execution time before failure: %',
                     v_end_time - v_start_time;

        RAISE NOTICE '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!';

        /*
           RAISE rethrows the original exception.

           This is important because otherwise the procedure could
           display an error message but PostgreSQL would consider the
           procedure successful.
        */

        RAISE;

END;
$$;

/* =====================================================================
EXECUTE THE PROCEDURE
===================================================================== */
CALL bronze.load_bronze ();