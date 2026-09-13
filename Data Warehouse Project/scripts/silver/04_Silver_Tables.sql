/* =====================================================================
SILVER LAYER - TABLE CREATION SCRIPT
=====================================================================

Purpose:
--------
Creates the Silver-layer tables used to store cleaned and
standardized data.

Silver Layer Principles:
------------------------
- Cleaned data
- Standardized data types
- Standardized values
- Derived columns where required
- Data-quality rules
- Suitable structure for Gold-layer transformations

Bronze vs Silver:
-----------------
Bronze = Raw source data
Silver = Cleaned and standardized data

Important:
----------
Primary keys are intentionally not defined at this stage.

They should be added after data-quality validation confirms that
the source data actually satisfies the required uniqueness rules.

dwh_create_date:
----------------
Records when a row was inserted into the Silver layer.

===================================================================== */
/* =====================================================================
STEP 1 - CRM CUSTOMER INFORMATION
===================================================================== */
DO $$
BEGIN

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 1: Preparing silver.crm_cust_info';
    RAISE NOTICE 'Dropping existing table if it exists...';

END $$;

DROP TABLE IF EXISTS silver.crm_cust_info;

/*
Silver CRM Customer table.

Data cleaning/transformation will be performed when loading
data from Bronze into this table.

Typical Silver transformations:
- Remove duplicate customers
- Standardize marital status
- Standardize gender
- Validate customer IDs
- Clean customer names
*/
CREATE TABLE silver.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE,
    dwh_create_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

DO $$
BEGIN

    RAISE NOTICE 'SUCCESS: silver.crm_cust_info created.';
    RAISE NOTICE '';

END $$;

/* =====================================================================
STEP 2 - CRM PRODUCT INFORMATION
===================================================================== */
DO $$
BEGIN

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 2: Preparing silver.crm_prd_info';
    RAISE NOTICE 'Dropping existing table if it exists...';

END $$;

DROP TABLE IF EXISTS silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info (
    prd_id INT,
    cat_id VARCHAR(50),
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE,
    dwh_create_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

DO $$
BEGIN

    RAISE NOTICE 'SUCCESS: silver.crm_prd_info created.';
    RAISE NOTICE '';

END $$;

/* =====================================================================
STEP 3 - CRM SALES DETAILS
===================================================================== */
DO $$
BEGIN

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 3: Preparing silver.crm_sales_details';
    RAISE NOTICE 'Dropping existing table if it exists...';

END $$;

DROP TABLE IF EXISTS silver.crm_sales_details;

/*
Silver CRM Sales table.

Unlike Bronze, the date fields are stored as DATE.

Bronze:
sls_order_dt INT
sls_ship_dt  INT
sls_due_dt   INT

Silver:
sls_order_dt DATE
sls_ship_dt  DATE
sls_due_dt   DATE

The conversion should happen during the Bronze → Silver load.
*/
CREATE TABLE silver.crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT,
    dwh_create_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

DO $$
BEGIN

    RAISE NOTICE 'SUCCESS: silver.crm_sales_details created.';
    RAISE NOTICE '';

END $$;

/* =====================================================================
STEP 4 - ERP LOCATION
===================================================================== */
DO $$
BEGIN

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 4: Preparing silver.erp_loc_a101';
    RAISE NOTICE 'Dropping existing table if it exists...';

END $$;

DROP TABLE IF EXISTS silver.erp_loc_a101;

CREATE TABLE silver.erp_loc_a101 (
    cid VARCHAR(50),
    cntry VARCHAR(50),
    dwh_create_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

DO $$
BEGIN

    RAISE NOTICE 'SUCCESS: silver.erp_loc_a101 created.';
    RAISE NOTICE '';

END $$;

/* =====================================================================
STEP 5 - ERP CUSTOMER
===================================================================== */
DO $$
BEGIN

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 5: Preparing silver.erp_cust_az12';
    RAISE NOTICE 'Dropping existing table if it exists...';

END $$;

DROP TABLE IF EXISTS silver.erp_cust_az12;

CREATE TABLE silver.erp_cust_az12 (
    cid VARCHAR(50),
    bdate DATE,
    gen VARCHAR(50),
    dwh_create_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

DO $$
BEGIN

    RAISE NOTICE 'SUCCESS: silver.erp_cust_az12 created.';
    RAISE NOTICE '';

END $$;

/* =====================================================================
STEP 6 - ERP PRODUCT CATEGORY
===================================================================== */
DO $$
BEGIN

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 6: Preparing silver.erp_px_cat_glv2';
    RAISE NOTICE 'Dropping existing table if it exists...';

END $$;

DROP TABLE IF EXISTS silver.erp_px_cat_glv2;

CREATE TABLE silver.erp_px_cat_glv2 (
    id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50),
    dwh_create_date TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

DO $$
BEGIN

    RAISE NOTICE 'SUCCESS: silver.erp_px_cat_glv2 created.';
    RAISE NOTICE '';

END $$;

/* =====================================================================
STEP 7 - VALIDATION
=====================================================================

Verify that all six Silver tables were successfully created.

Expected result:
6 rows
===================================================================== */
DO $$
DECLARE
    v_table_count INT;
BEGIN

    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'STEP 7: Validating Silver tables';
    RAISE NOTICE '------------------------------------------------------------';

    SELECT COUNT(*)
    INTO v_table_count
    FROM information_schema.tables
    WHERE table_schema = 'silver'
      AND table_name IN
      (
          'crm_cust_info',
          'crm_prd_info',
          'crm_sales_details',
          'erp_loc_a101',
          'erp_cust_az12',
          'erp_px_cat_glv2'
      );

    RAISE NOTICE 'Silver tables found: %', v_table_count;

    IF v_table_count = 6 THEN

        RAISE NOTICE 'SUCCESS: All 6 Silver tables exist.';

    ELSE

        RAISE WARNING
            'VALIDATION WARNING: Expected 6 tables but found %.',
            v_table_count;

    END IF;

END $$;

/* =====================================================================
STEP 8 - FINAL STATUS
===================================================================== */
DO $$
BEGIN

    RAISE NOTICE '';
    RAISE NOTICE '============================================================';
    RAISE NOTICE 'SILVER LAYER TABLE INITIALIZATION COMPLETED';
    RAISE NOTICE '============================================================';
    RAISE NOTICE 'All Silver-layer table definitions have been processed.';
    RAISE NOTICE 'Ready for Bronze → Silver transformation.';
    RAISE NOTICE '============================================================';
    RAISE NOTICE '';

END $$;