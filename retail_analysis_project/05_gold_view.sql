/*
===============================================================================
06 - GOLD LAYER (SIMPLE) - FIXED
===============================================================================
3 Dimensions + 2 Facts

IMPORTANT:
DROP the old views first. CREATE OR REPLACE cannot change/drop columns.
===============================================================================
*/
-- ============================================================================
-- DROP OLD VIEWS (order matters because of dependencies)
-- ============================================================================
DROP VIEW IF EXISTS gold.fact_sales CASCADE;

DROP VIEW IF EXISTS gold.fact_payments CASCADE;

DROP VIEW IF EXISTS gold.dim_customer CASCADE;

DROP VIEW IF EXISTS gold.dim_product CASCADE;

DROP VIEW IF EXISTS gold.dim_date CASCADE;

-- ============================================================================
-- DIMENSION: CUSTOMER
-- ============================================================================
CREATE OR REPLACE VIEW gold.dim_customer AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY
            c.customer_id
    ) AS customer_key,
    c.customer_id,
    c.customer_name,
    c.email,
    c.phone,
    c.city,
    c.state,
    c.customer_segment,
    c.registration_date,
    c.acquisition_source,
    c.is_active
FROM
    silver.customers AS c;

-- ============================================================================
-- DIMENSION: PRODUCT
-- ============================================================================
CREATE OR REPLACE VIEW gold.dim_product AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY
            p.product_id
    ) AS product_key,
    p.product_id,
    p.product_name,
    p.category,
    p.sub_category,
    p.brand,
    p.supplier,
    ROUND(p.unit_cost, 2) AS unit_cost,
    ROUND(p.unit_price, 2) AS unit_price,
    ROUND(p.stock_qty, 2) AS stock_qty,
    p.launch_date
FROM
    silver.products AS p;

-- ============================================================================
-- DIMENSION: DATE
-- ============================================================================
CREATE OR REPLACE VIEW gold.dim_date AS
SELECT
    TO_CHAR(d.full_date, 'YYYYMMDD')::INT AS date_key,
    d.full_date,
    EXTRACT(
        YEAR
        FROM
            d.full_date
    )::INT AS YEAR,
    EXTRACT(
        QUARTER
        FROM
            d.full_date
    )::INT AS quarter,
    EXTRACT(
        MONTH
        FROM
            d.full_date
    )::INT AS MONTH,
    TRIM(TO_CHAR(d.full_date, 'Month')) AS month_name,
    EXTRACT(
        WEEK
        FROM
            d.full_date
    )::INT AS week,
    EXTRACT(
        DAY
        FROM
            d.full_date
    )::INT AS DAY,
    TRIM(TO_CHAR(d.full_date, 'Day')) AS day_name
FROM
    GENERATE_SERIES(
        (
            SELECT
                MIN(order_date)
            FROM
                silver.orders
            WHERE
                order_date IS NOT NULL
        ),
        (
            SELECT
                MAX(order_date)
            FROM
                silver.orders
            WHERE
                order_date IS NOT NULL
        ),
        INTERVAL '1 day'
    ) AS d (full_date);

-- ============================================================================
-- FACT: SALES  (one row per order item)
-- ============================================================================
CREATE OR REPLACE VIEW gold.fact_sales AS
WITH
    base AS (
        SELECT
            oi.order_item_id,
            oi.order_id,
            o.order_date,
            o.order_status,
            o.sales_channel,
            o.shipping_city,
            o.shipping_state,
            oi.quantity,
            ROUND(oi.unit_price, 2) AS unit_price,
            ROUND(COALESCE(oi.discount_pct, 0), 2) AS discount_pct,
            ROUND(COALESCE(oi.tax_rate, 0), 2) AS tax_rate,
            ROUND(COALESCE(p.unit_cost, 0), 2) AS unit_cost,
            c.customer_key,
            p.product_key,
            ROUND(oi.quantity * oi.unit_price, 2) AS gross_amount
        FROM
            silver.order_items AS oi
            LEFT JOIN silver.orders AS o ON oi.order_id = o.order_id
            LEFT JOIN gold.dim_product AS p ON oi.product_id = p.product_id
            LEFT JOIN gold.dim_customer AS c ON o.customer_id = c.customer_id
    ),
    calc AS (
        SELECT
            *,
            ROUND(gross_amount * discount_pct / 100, 2) AS discount_amount
        FROM
            base
    )
SELECT
    ROW_NUMBER() OVER (
        ORDER BY
            order_item_id
    ) AS sales_key,
    customer_key,
    product_key,
    order_item_id,
    order_id,
    order_date,
    order_status,
    sales_channel,
    shipping_city,
    shipping_state,
    quantity,
    unit_price,
    discount_pct,
    tax_rate,
    gross_amount,
    discount_amount,
    ROUND(gross_amount - discount_amount, 2) AS sales_amount_before_tax,
    ROUND(
        (gross_amount - discount_amount) * tax_rate / 100,
        2
    ) AS tax_amount,
    ROUND(
        (gross_amount - discount_amount) + ((gross_amount - discount_amount) * tax_rate / 100),
        2
    ) AS net_amount,
    ROUND(quantity * unit_cost, 2) AS cost_amount,
    ROUND(
        (gross_amount - discount_amount) - (quantity * unit_cost),
        2
    ) AS gross_profit,
    ROUND(
        CASE
            WHEN (gross_amount - discount_amount) <> 0 THEN (
                (gross_amount - discount_amount) - (quantity * unit_cost)
            ) / (gross_amount - discount_amount) * 100
            ELSE NULL
        END,
        2
    ) AS gross_margin_pct
FROM
    calc;

-- ============================================================================
-- FACT: PAYMENTS  (one row per payment)
-- ============================================================================
CREATE OR REPLACE VIEW gold.fact_payments AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY
            pay.payment_id
    ) AS payment_key,
    d.date_key,
    c.customer_key,
    pay.payment_id,
    pay.order_id,
    pay.payment_date,
    pay.payment_method,
    pay.payment_status,
    ROUND(pay.amount, 2) AS amount,
    pay.transaction_ref,
    CASE
        WHEN LOWER(TRIM(pay.payment_status)) = 'completed' THEN 1
        ELSE 0
    END AS successful_payment_flag,
    CASE
        WHEN LOWER(TRIM(pay.payment_status)) IN ('failed', 'declined') THEN 1
        ELSE 0
    END AS failed_payment_flag,
    CASE
        WHEN pay.amount > 0 THEN 1
        ELSE 0
    END AS valid_amount_flag
FROM
    silver.payments AS pay
    LEFT JOIN silver.orders AS o ON pay.order_id = o.order_id
    LEFT JOIN gold.dim_customer AS c ON o.customer_id = c.customer_id
    LEFT JOIN gold.dim_date AS d ON pay.payment_date = d.full_date;

-- ============================================================================
-- QUICK VALIDATION (uncomment to check)
-- ============================================================================
-- SELECT COUNT(*) AS sales_rows     FROM gold.fact_sales;
-- SELECT COUNT(*) AS payment_rows   FROM gold.fact_payments;
-- SELECT COUNT(*) AS customers      FROM gold.dim_customer;
-- SELECT COUNT(*) AS products       FROM gold.dim_product;
-- SELECT COUNT(*) AS dates          FROM gold.dim_date;
