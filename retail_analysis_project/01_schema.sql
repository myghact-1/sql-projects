CREATE DATABASE retail_db;

-- Create schema (first change the database to retail_db)
CREATE SCHEMA bronze;

CREATE SCHEMA silver;

CREATE SCHEMA gold;

-- 
CREATE TABLE bronze.customers (
    customer_id VARCHAR(50),
    customer_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    city VARCHAR(50),
    state VARCHAR(50),
    customer_segment VARCHAR(50),
    registration_date VARCHAR(50),
    acquisition_source VARCHAR(50),
    is_active VARCHAR(20)
);

CREATE TABLE bronze.order_items (
    order_item_id VARCHAR(50),
    order_id VARCHAR(50),
    product_id VARCHAR(50),
    quantity INT,
    unit_price NUMERIC(10, 2),
    discount_pct NUMERIC,
    tax_rate NUMERIC
);

CREATE TABLE bronze.orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_date VARCHAR(50),
    order_status VARCHAR(50),
    sales_channel VARCHAR(50),
    shipping_city VARCHAR(50),
    shipping_state VARCHAR(50),
    discount_code VARCHAR(50),
    customer_note VARCHAR(120)
);

CREATE TABLE bronze.payments (
    payment_id VARCHAR(50),
    order_id VARCHAR(50),
    payment_date VARCHAR(50),
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    amount NUMERIC(10, 2),
    transaction_ref VARCHAR(100)
);

CREATE TABLE bronze.products (
    product_id VARCHAR(50),
    product_name VARCHAR(100),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    brand VARCHAR(50),
    unit_cost NUMERIC(10, 2),
    unit_price NUMERIC(10, 2),
    supplier VARCHAR(50),
    stock_qty NUMERIC(10, 2),
    launch_date VARCHAR(50)
);
