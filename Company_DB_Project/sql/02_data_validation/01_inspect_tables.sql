-- ================================================================
-- Company DB Project — Initial Data Validation
-- ================================================================
-- Use this script after loading the CSV files.
-- The first section previews the tables; the second section checks
-- row counts so loading problems are easier to spot.
-- ================================================================
-- ----------------------------------------------------------------
-- 1. Preview Inventory
-- ----------------------------------------------------------------
SELECT
    *
FROM
    inventory.categories;

SELECT
    *
FROM
    inventory.products;

-- ----------------------------------------------------------------
-- 2. Preview HR
-- ----------------------------------------------------------------
SELECT
    *
FROM
    hr.departments;

SELECT
    *
FROM
    hr.employees;

SELECT
    *
FROM
    hr.projects;

SELECT
    *
FROM
    hr.employee_projects;

-- ----------------------------------------------------------------
-- 3. Preview Sales
-- ----------------------------------------------------------------
SELECT
    *
FROM
    sales.customers;

SELECT
    *
FROM
    sales.archived_customers;

SELECT
    *
FROM
    sales.orders;

SELECT
    *
FROM
    sales.order_items;

-- ----------------------------------------------------------------
-- 4. Row-count validation
-- ----------------------------------------------------------------
SELECT
    'inventory.categories' AS table_name,
    COUNT(*) AS row_count
FROM
    inventory.categories
UNION ALL
SELECT
    'inventory.products',
    COUNT(*)
FROM
    inventory.products
UNION ALL
SELECT
    'hr.departments',
    COUNT(*)
FROM
    hr.departments
UNION ALL
SELECT
    'hr.employees',
    COUNT(*)
FROM
    hr.employees
UNION ALL
SELECT
    'hr.projects',
    COUNT(*)
FROM
    hr.projects
UNION ALL
SELECT
    'hr.employee_projects',
    COUNT(*)
FROM
    hr.employee_projects
UNION ALL
SELECT
    'sales.customers',
    COUNT(*)
FROM
    sales.customers
UNION ALL
SELECT
    'sales.archived_customers',
    COUNT(*)
FROM
    sales.archived_customers
UNION ALL
SELECT
    'sales.orders',
    COUNT(*)
FROM
    sales.orders
UNION ALL
SELECT
    'sales.order_items',
    COUNT(*)
FROM
    sales.order_items
ORDER BY
    table_name;