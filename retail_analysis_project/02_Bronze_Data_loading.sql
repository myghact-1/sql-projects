CREATE OR REPLACE PROCEDURE bronze.load_retail_data () LANGUAGE plpgsql AS $$

DECLARE
    -- ============================================================
    -- Variables for logging and row counts
    -- ============================================================

    start_time      TIMESTAMP;
    end_time        TIMESTAMP;
    execution_time  INTERVAL;

    customers_count    INTEGER;
    order_items_count  INTEGER;
    orders_count       INTEGER;
    payments_count     INTEGER;
    products_count     INTEGER;
    total_records      INTEGER;

BEGIN

    -- ============================================================
    -- Start logging
    -- ============================================================

    start_time := clock_timestamp();

    RAISE NOTICE '============================================================';
    RAISE NOTICE 'BRONZE DATA LOAD STARTED';
    RAISE NOTICE 'Start Time: %', start_time;
    RAISE NOTICE '============================================================';


    -- ============================================================
    -- 1. Clear existing Bronze data
    -- ============================================================
    -- Bronze contains raw data, so the complete dataset is
    -- reloaded each time the procedure runs.
    --
    -- CASCADE removes dependent data if foreign keys exist.
    -- RESTART IDENTITY resets identity/sequence values.
    -- ============================================================

    RAISE NOTICE 'Step 1: Clearing existing Bronze tables...';

    TRUNCATE TABLE
        bronze.customers,
        bronze.order_items,
        bronze.orders,
        bronze.payments,
        bronze.products
    RESTART IDENTITY CASCADE;

    RAISE NOTICE 'Bronze tables cleared successfully.';


    -- ============================================================
    -- 2. Load Customers
    -- ============================================================

    RAISE NOTICE 'Step 2: Loading customers...';

    COPY bronze.customers
    FROM 'S:\sql-projects\retail_analysis_project\datasets\customers.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    GET DIAGNOSTICS customers_count = ROW_COUNT;

    RAISE NOTICE 'Customers loaded: % records', customers_count;


    -- ============================================================
    -- 3. Load Order Items
    -- ============================================================

    RAISE NOTICE 'Step 3: Loading order items...';

    COPY bronze.order_items
    FROM 'S:\sql-projects\retail_analysis_project\datasets\order_items.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    GET DIAGNOSTICS order_items_count = ROW_COUNT;

    RAISE NOTICE 'Order items loaded: % records', order_items_count;


    -- ============================================================
    -- 4. Load Orders
    -- ============================================================

    RAISE NOTICE 'Step 4: Loading orders...';

    COPY bronze.orders
    FROM 'S:\sql-projects\retail_analysis_project\datasets\orders.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    GET DIAGNOSTICS orders_count = ROW_COUNT;

    RAISE NOTICE 'Orders loaded: % records', orders_count;


    -- ============================================================
    -- 5. Load Payments
    -- ============================================================

    RAISE NOTICE 'Step 5: Loading payments...';

    COPY bronze.payments
    FROM 'S:\sql-projects\retail_analysis_project\datasets\payments.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    GET DIAGNOSTICS payments_count = ROW_COUNT;

    RAISE NOTICE 'Payments loaded: % records', payments_count;


    -- ============================================================
    -- 6. Load Products
    -- ============================================================

    RAISE NOTICE 'Step 6: Loading products...';

    COPY bronze.products
    FROM 'S:\sql-projects\retail_analysis_project\datasets\products.csv'
    WITH (
        FORMAT CSV,
        HEADER TRUE,
        DELIMITER ','
    );

    GET DIAGNOSTICS products_count = ROW_COUNT;

    RAISE NOTICE 'Products loaded: % records', products_count;


    -- ============================================================
    -- 7. Calculate total records
    -- ============================================================

    total_records :=
          customers_count
        + order_items_count
        + orders_count
        + payments_count
        + products_count;


    -- ============================================================
    -- 8. Calculate execution time
    -- ============================================================

    end_time := clock_timestamp();
    execution_time := end_time - start_time;


    -- ============================================================
    -- 9. Final success message
    -- ============================================================

    RAISE NOTICE '============================================================';
    RAISE NOTICE 'BRONZE DATA LOAD COMPLETED SUCCESSFULLY';
    RAISE NOTICE '============================================================';

    RAISE NOTICE 'Customers   : %', customers_count;
    RAISE NOTICE 'Order Items : %', order_items_count;
    RAISE NOTICE 'Orders      : %', orders_count;
    RAISE NOTICE 'Payments    : %', payments_count;
    RAISE NOTICE 'Products    : %', products_count;
    RAISE NOTICE '------------------------------------------------------------';
    RAISE NOTICE 'Total Records: %', total_records;
    RAISE NOTICE 'Start Time   : %', start_time;
    RAISE NOTICE 'End Time     : %', end_time;
    RAISE NOTICE 'Execution    : %', execution_time;
    RAISE NOTICE '============================================================';


EXCEPTION
    WHEN OTHERS THEN

        -- ========================================================
        -- Error handling
        -- ========================================================
        -- SQLERRM contains the actual PostgreSQL error message.
        -- SQLSTATE contains the PostgreSQL error code.
        -- ========================================================

        end_time := clock_timestamp();
        execution_time := end_time - start_time;

        RAISE NOTICE '============================================================';
        RAISE NOTICE 'BRONZE DATA LOAD FAILED';
        RAISE NOTICE '============================================================';
        RAISE NOTICE 'Error Code   : %', SQLSTATE;
        RAISE NOTICE 'Error Message: %', SQLERRM;
        RAISE NOTICE 'Failed At    : %', end_time;
        RAISE NOTICE 'Execution    : %', execution_time;
        RAISE NOTICE '============================================================';

        -- Re-throw the error so PostgreSQL does not hide the failure.
        RAISE;

END;
$$;

-- ================================================================
-- Execute the Bronze loading procedure
-- ================================================================
CALL bronze.load_retail_data ();
