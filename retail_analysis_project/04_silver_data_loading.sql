/*
===============================================================================
04 - SILVER DATA CLEANING & LOADING
===============================================================================
Purpose: Reload Silver from Bronze after standardization and basic cleansing.

Notes:
- Missing text is represented as 'n/a' to match the existing project approach.
- Customer duplicate rows are excluded by the existing 6-character ID rule.
- Ambiguous dates such as 08/12/2022 cannot be reliably identified as
  DD/MM/YYYY or MM/DD/YYYY without a source/business rule, so they become NULL.
- Invalid product stock is kept as NULL rather than incorrectly treating it
  as zero.
===============================================================================
*/

-- ============================================================================
-- CUSTOMERS
-- ============================================================================
TRUNCATE TABLE silver.customers;

INSERT INTO silver.customers (
    customer_id, customer_name, email, phone, city, state,
    customer_segment, registration_date, acquisition_source, is_active
)
SELECT
    TRIM(customer_id),
    NULLIF(TRIM(INITCAP(customer_name)), ''),
    COALESCE(NULLIF(TRIM(LOWER(email)), ''), 'n/a'),
    COALESCE(NULLIF(REGEXP_REPLACE(TRIM(phone), '^\+91[- ]?', ''), ''), 'n/a'),
    COALESCE(NULLIF(TRIM(INITCAP(city)), ''), 'n/a'),
    COALESCE(NULLIF(TRIM(INITCAP(state)), ''), 'n/a'),
    COALESCE(NULLIF(TRIM(INITCAP(customer_segment)), ''), 'n/a'),

    -- Convert supported date formats to DATE.
    CASE
        WHEN registration_date ~ '^\d{4}-\d{2}-\d{2}$'
            THEN TO_DATE(registration_date, 'YYYY-MM-DD')
        WHEN registration_date ~ '^\d{2}-\d{2}-\d{4}$'
            THEN TO_DATE(registration_date, 'MM-DD-YYYY')
        WHEN registration_date ~ '^\d{2}/\d{2}/\d{4}$'
             AND SPLIT_PART(registration_date, '/', 1)::INT > 12
            THEN TO_DATE(registration_date, 'DD/MM/YYYY')
        WHEN registration_date ~ '^\d{2}/\d{2}/\d{4}$'
             AND SPLIT_PART(registration_date, '/', 2)::INT > 12
            THEN TO_DATE(registration_date, 'MM/DD/YYYY')
        ELSE NULL
    END,

    COALESCE(NULLIF(TRIM(INITCAP(acquisition_source)), ''), 'n/a'),

    CASE
        WHEN LOWER(TRIM(is_active)) IN ('1','y','yes') THEN 'Yes'
        WHEN LOWER(TRIM(is_active)) IN ('0','n','no') THEN 'No'
        ELSE 'n/a'
    END
FROM bronze.customers
WHERE LENGTH(TRIM(customer_id)) = 6;


-- ============================================================================
-- ORDER ITEMS
-- ============================================================================
TRUNCATE TABLE silver.order_items;

INSERT INTO silver.order_items (
    order_item_id, order_id, product_id, quantity,
    unit_price, discount_pct, tax_rate
)
SELECT
    TRIM(order_item_id),
    TRIM(order_id),
    TRIM(product_id),
    quantity,
    ROUND(unit_price, 2),
    ROUND(ABS(COALESCE(discount_pct, 0)), 2),
    ROUND(COALESCE(tax_rate, 0), 2)
FROM bronze.order_items;


-- ============================================================================
-- ORDERS
-- ============================================================================
TRUNCATE TABLE silver.orders;

INSERT INTO silver.orders (
    order_id, customer_id, order_date, order_status, sales_channel,
    shipping_city, shipping_state, discount_code, customer_note
)
SELECT
    TRIM(order_id),
    TRIM(customer_id),

    -- Convert supported date formats to DATE.
    CASE
        WHEN order_date ~ '^\d{4}-\d{2}-\d{2}$'
            THEN TO_DATE(order_date, 'YYYY-MM-DD')
        WHEN order_date ~ '^\d{2}-\d{2}-\d{4}$'
            THEN TO_DATE(order_date, 'MM-DD-YYYY')
        WHEN order_date ~ '^\d{2}/\d{2}/\d{4}$'
             AND SPLIT_PART(order_date, '/', 1)::INT > 12
            THEN TO_DATE(order_date, 'DD/MM/YYYY')
        WHEN order_date ~ '^\d{2}/\d{2}/\d{4}$'
             AND SPLIT_PART(order_date, '/', 2)::INT > 12
            THEN TO_DATE(order_date, 'MM/DD/YYYY')
        ELSE NULL
    END,

    NULLIF(TRIM(INITCAP(order_status)), ''),
    NULLIF(TRIM(INITCAP(sales_channel)), ''),
    COALESCE(NULLIF(TRIM(INITCAP(shipping_city)), ''), 'n/a'),
    COALESCE(NULLIF(TRIM(INITCAP(shipping_state)), ''), 'n/a'),
    COALESCE(NULLIF(TRIM(UPPER(discount_code)), ''), 'n/a'),
    COALESCE(NULLIF(TRIM(customer_note), ''), 'n/a')
FROM bronze.orders;


-- ============================================================================
-- PRODUCTS
-- ============================================================================
TRUNCATE TABLE silver.products;

INSERT INTO silver.products (
    product_id, product_name, category, sub_category, brand,
    unit_cost, unit_price, supplier, stock_qty, launch_date
)
SELECT
    TRIM(product_id),
    NULLIF(TRIM(INITCAP(product_name)), ''),
    NULLIF(TRIM(INITCAP(category)), ''),       -- Corrected category mapping.
    NULLIF(TRIM(INITCAP(sub_category)), ''),
    NULLIF(TRIM(INITCAP(brand)), ''),
    ROUND(unit_cost, 2),
    ROUND(unit_price, 2),
    NULLIF(TRIM(INITCAP(supplier)), ''),

    -- Invalid/suspicious stock is unknown, not zero.
    CASE
        WHEN stock_qty BETWEEN 0 AND 250 THEN ROUND(stock_qty, 2)
        ELSE NULL
    END,

    NULLIF(TRIM(launch_date), '')::DATE
FROM bronze.products;


-- ============================================================================
-- PAYMENTS
-- ============================================================================
TRUNCATE TABLE silver.payments;

INSERT INTO silver.payments (
    payment_id, order_id, payment_date, payment_method,
    payment_status, amount, transaction_ref
)
SELECT
    TRIM(payment_id),
    TRIM(order_id),
    payment_date::DATE,
    NULLIF(TRIM(INITCAP(payment_method)), ''), -- Corrected column mapping.
    NULLIF(TRIM(INITCAP(payment_status)), ''),
    ROUND(ABS(amount), 2),
    NULLIF(TRIM(transaction_ref), '')
FROM bronze.payments;
