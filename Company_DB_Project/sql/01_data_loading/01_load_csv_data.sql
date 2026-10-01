-- ================================================================
-- Company DB Project — Load CSV Data
-- ================================================================
-- PostgreSQL psql script.
-- Run this from the project root while connected to company_db.
-- ================================================================
-- Inventory
COPY inventory.categories
FROM
    'data/raw/categories.csv'
WITH
    (FORMAT csv, HEADER TRUE);

-- 
COPY inventory.products
FROM
    'data/raw/products.csv'
WITH
    (FORMAT csv, HEADER TRUE);

-- HR
COPY hr.departments
FROM
    'data/raw/departments.csv'
WITH
    (FORMAT csv, HEADER TRUE);

-- 
COPY hr.employees
FROM
    'data/raw/employees.csv'
WITH
    (FORMAT csv, HEADER TRUE);

-- 
COPY hr.projects
FROM
    'data/raw/projects.csv'
WITH
    (FORMAT csv, HEADER TRUE);

-- 
COPY hr.employee_projects
FROM
    'data/raw/employee_projects.csv'
WITH
    (FORMAT csv, HEADER TRUE);

-- Sales
COPY sales.customers
FROM
    'data/raw/customers.csv'
WITH
    (FORMAT csv, HEADER TRUE);

-- 
COPY sales.archived_customers
FROM
    'data/raw/archived_customers.csv'
WITH
    (FORMAT csv, HEADER TRUE);

-- 
COPY sales.orders
FROM
    'data/raw/orders.csv'
WITH
    (FORMAT csv, HEADER TRUE);

-- 
COPY sales.order_items
FROM
    'data/raw/order_items.csv'
WITH
    (FORMAT csv, HEADER TRUE);
