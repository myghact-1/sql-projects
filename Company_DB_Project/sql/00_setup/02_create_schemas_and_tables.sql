-- ================================================================
-- Company DB Project — Schemas & Tables
-- ================================================================
-- Run this script after connecting to the company_db database.
-- The project uses three logical schemas:
--   hr        -> employees, departments and project assignments
--   sales     -> customers, orders and order items
--   inventory -> products and categories
-- ================================================================

-- ----------------------------------------------------------------
-- 1. Create schemas
-- ----------------------------------------------------------------

CREATE SCHEMA hr;
CREATE SCHEMA sales;
CREATE SCHEMA inventory;

-- ----------------------------------------------------------------
-- 2. Inventory tables
-- ----------------------------------------------------------------

CREATE TABLE inventory.categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50),
    parent_category_id INT
);

CREATE TABLE inventory.products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category_id INT,
    unit_price NUMERIC(10, 2),
    cost NUMERIC(10, 2),
    stock_quantity INT,
    supplier VARCHAR(50),
    is_discontinued BOOLEAN,
    CONSTRAINT fk_category_id
        FOREIGN KEY (category_id)
        REFERENCES inventory.categories(category_id)
);

-- ----------------------------------------------------------------
-- 3. HR tables
-- ----------------------------------------------------------------

CREATE TABLE hr.departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50),
    budget BIGINT
);

CREATE TABLE hr.employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(50),
    hire_date DATE,
    job_title VARCHAR(50),
    department_id INT,
    manager_id INT,
    salary BIGINT,
    status VARCHAR(50),
    CONSTRAINT fk_department_id
        FOREIGN KEY (department_id)
        REFERENCES hr.departments(department_id),
    CONSTRAINT fk_manager_id
        FOREIGN KEY (manager_id)
        REFERENCES hr.employees(employee_id)
);

CREATE TABLE hr.projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    start_date DATE,
    end_date DATE,
    budget BIGINT,
    status VARCHAR(50)
);

CREATE TABLE hr.employee_projects (
    employee_id INT,
    project_id INT,
    role VARCHAR(50),
    hours_allocated INT,
    hours_worked INT,
    CONSTRAINT fk_employee_id
        FOREIGN KEY (employee_id)
        REFERENCES hr.employees(employee_id),
    CONSTRAINT fk_project_id
        FOREIGN KEY (project_id)
        REFERENCES hr.projects(project_id)
);

-- ----------------------------------------------------------------
-- 4. Sales tables
-- ----------------------------------------------------------------

CREATE TABLE sales.customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    phone VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    signup_date DATE,
    customer_segment VARCHAR(50),
    is_active BOOLEAN
);

CREATE TABLE sales.archived_customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    phone VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    signup_date DATE,
    customer_segment VARCHAR(50),
    is_active BOOLEAN
);

CREATE TABLE sales.orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    ship_date DATE,
    status VARCHAR(50),
    shipping_cost NUMERIC(10, 2),
    payment_method VARCHAR(50),
    CONSTRAINT fk_customer_id
        FOREIGN KEY (customer_id)
        REFERENCES sales.customers(customer_id)
);

CREATE TABLE sales.order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price NUMERIC(10, 2),
    discount NUMERIC(10, 2),
    CONSTRAINT fk_order_id
        FOREIGN KEY (order_id)
        REFERENCES sales.orders(order_id),
    CONSTRAINT fk_product_id
        FOREIGN KEY (product_id)
        REFERENCES inventory.products(product_id)
);
