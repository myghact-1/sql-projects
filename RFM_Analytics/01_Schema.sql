-- 1. Create Database
CREATE DATABASE ecommerce_db;

-- 2. Connect to ecommerce_db before executing below
CREATE TABLE raw_retail (
    invoice_no VARCHAR(20),
    stock_code VARCHAR(20),
    description TEXT,
    quantity INT,
    invoice_date TIMESTAMP,
    unit_price NUMERIC(10, 2),
    customer_id VARCHAR(20),
    country VARCHAR(50)
);

-- 3. Load CSV Data
COPY raw_retail (
    invoice_no,
    stock_code,
    description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country
)
FROM
    'S:\SQL\sql-projects\RFM_Analytics\dataset\online_retail_II.csv'
WITH
    (format CSV, HEADER TRUE, DELIMITER ',');

-- 4. Create Indexes for Query Optimization
CREATE INDEX idx_raw_customer ON raw_retail (customer_id);

CREATE INDEX idx_raw_invoice_date ON raw_retail (invoice_date);