/* =====================================================================
BRONZE LAYER - TABLE CREATION / INITIALIZATION
=====================================================================

Purpose:
--------
Creates the raw Bronze-layer tables used by the Data Warehouse.

Bronze Layer Principles:
------------------------
- Store raw source data
- Minimal transformation
- Preserve source structure
- Avoid business rules
- Avoid unnecessary constraints

Important:
----------
These tables intentionally DO NOT have primary keys.

Primary keys, data-quality rules, transformations, etc. can be
handled in the Silver layer.

===================================================================== */
/* =====================================================================
START
===================================================================== */
/* =====================================================================
STEP 1 - CRM CUSTOMER INFORMATION
===================================================================== */
/*
Remove the old table if it exists.
*/
DROP TABLE IF EXISTS bronze.crm_cust_info;

/*
Create the raw CRM customer table.
Data is kept close to the source CSV structure.
*/
CREATE TABLE bronze.crm_cust_info (
       cst_id INT,
       cst_key VARCHAR(50),
       cst_firstname VARCHAR(50),
       cst_lastname VARCHAR(50),
       cst_marital_status VARCHAR(50),
       cst_gndr VARCHAR(50),
       cst_create_date DATE
);

/* =====================================================================
STEP 2 - CRM PRODUCT INFORMATION
===================================================================== */
DROP TABLE IF EXISTS bronze.crm_prd_info;

/*
Raw CRM product information.

prd_id       = Product identifier
prd_key      = Product business key
prd_nm       = Product name
prd_cost     = Product cost
prd_line     = Product category/line
prd_start_dt = Product start date
prd_end_dt   = Product end date
*/
CREATE TABLE bronze.crm_prd_info (
       prd_id INT,
       prd_key VARCHAR(50),
       prd_nm VARCHAR(50),
       prd_cost INT,
       prd_line VARCHAR(50),
       prd_start_dt DATE,
       prd_end_dt DATE
);

/* =====================================================================
STEP 3 - CRM SALES DETAILS
===================================================================== */
DROP TABLE IF EXISTS bronze.crm_sales_details;

/*
Raw sales transaction information.

IMPORTANT:
----------
The source currently stores order/ship/due dates as INT.

Example:
20240115

This is intentionally kept as INT in Bronze.

Date conversion and validation can be performed in Silver.
*/
CREATE TABLE bronze.crm_sales_details (
       sls_ord_num VARCHAR(50),
       sls_prd_key VARCHAR(50),
       sls_cust_id INT,
       sls_order_dt INT,
       sls_ship_dt INT,
       sls_due_dt INT,
       sls_sales INT,
       sls_quantity INT,
       sls_price INT
);

/* =====================================================================
STEP 4 - ERP LOCATION
===================================================================== */
DROP TABLE IF EXISTS bronze.erp_loc_a101;

/*
Raw ERP location information.

cid   = Customer/location identifier
cntry = Country
*/
CREATE TABLE bronze.erp_loc_a101 (cid VARCHAR(50), cntry VARCHAR(50));

/* =====================================================================
STEP 5 - ERP CUSTOMER
===================================================================== */
DROP TABLE IF EXISTS bronze.erp_cust_az12;

/*
Raw ERP customer information.

bdate = Birth date
gen   = Gender
*/
CREATE TABLE bronze.erp_cust_az12 (cid VARCHAR(50), bdate DATE, gen VARCHAR(50));

/* =====================================================================
STEP 6 - ERP PRODUCT CATEGORY
===================================================================== */
DROP TABLE IF EXISTS bronze.erp_px_cat_glv2;

/*
Raw ERP product category information.

id          = Product/category identifier
cat         = Category
subcat      = Sub-category
maintenance = Maintenance classification
*/
CREATE TABLE bronze.erp_px_cat_glv2 (
       id VARCHAR(50),
       cat VARCHAR(50),
       subcat VARCHAR(50),
       maintenance VARCHAR(50)
);

/* =====================================================================
STEP 7 - VALIDATION
=====================================================================

Verify that all required Bronze tables exist.
===================================================================== */
/*
Check all expected tables.

This query should return 6 rows.
*/
SELECT
       schemaname,
       tablename,
       'EXISTS' AS status
FROM
       pg_tables
WHERE
       schemaname = 'bronze'
       AND tablename IN (
              'crm_cust_info',
              'crm_prd_info',
              'crm_sales_details',
              'erp_loc_a101',
              'erp_cust_az12',
              'erp_px_cat_glv2'
       )
ORDER BY
       tablename;