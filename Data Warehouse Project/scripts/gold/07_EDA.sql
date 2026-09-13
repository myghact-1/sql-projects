SELECT
    *
FROM
    information_schema.tables
WHERE
    table_schema != 'pg_catalog'
    AND table_schema != 'information_schema';

--  Dimentions Explorations
SELECT DISTINCT
    country
FROM
    gold.dim_customer;

SELECT DISTINCT
    category,
    subcategory,
    product_name
FROM
    gold.dim_products
ORDER BY
    category,
    subcategory,
    product_name;

-- Explore the date
-- What are the earliest and recent dates
SELECT
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order,
    age (MAX(order_date), MIN(order_date))
FROM
    gold.fact_sales;

-- find the youngest and oldest customers
SELECT
    MIN(birth_date) AS oldest_customer,
    MAX(birth_date) AS youngest_customer
FROM
    gold.dim_customer;

-- 
SELECT
    SUM(sales_amount) AS total_sales
FROM
    gold.fact_sales;

SELECT
    SUM(quantity) AS total_quantity
FROM
    gold.fact_sales;

SELECT
    AVG(price) AS AVG_price
FROM
    gold.fact_sales;

SELECT
    COUNT(*),
    COUNT(DISTINCT order_number) AS total_orders
FROM
    gold.fact_sales;

SELECT
    COUNT(DISTINCT product_name) AS total_products
FROM
    gold.dim_products;

-- 
SELECT
    COUNT(DISTINCT customer_key)
FROM
    gold.dim_customer;

-- 
SELECT
    COUNT(DISTINCT customer_key)
FROM
    gold.fact_sales;

-- Magnitude Analysis
SELECT
    country,
    COUNT(*) AS total_customers
FROM
    gold.dim_customer
GROUP BY
    country
ORDER BY
    total_customers DESC;

-- 
SELECT
    gender,
    COUNT(*) AS total_gender
FROM
    gold.dim_customer
GROUP BY
    gender
ORDER BY
    total_gender DESC;

-- 
SELECT
    category,
    COUNT(DISTINCT product_key) AS total_products
FROM
    gold.dim_products
GROUP BY
    category
ORDER BY
    total_products DESC;

-- 
SELECT
    category,
    AVG(cost) AS avg_cost
FROM
    gold.dim_products
GROUP BY
    category
ORDER BY
    avg_cost DESC;

-- 
SELECT
    pc.category,
    SUM(s.sales_amount) AS total_sales
FROM
    gold.dim_products AS pc
    LEFT JOIN gold.fact_sales AS s ON pc.product_key = s.product_key
GROUP BY
    pc.category
ORDER BY
    total_sales DESC NULLS LAST;

-- 
SELECT
    COALESCE(c.first_name, '') || ' ' || COALESCE(c.last_name, '') AS full_name,
    SUM(f.sales_amount) AS total_sales
FROM
    gold.fact_sales AS f
    LEFT JOIN gold.dim_customer AS c ON f.customer_key = c.customer_key
GROUP BY
    c.first_name,
    c.last_name
ORDER BY
    total_sales DESC;

-- 
SELECT
    c.country,
    SUM(f.quantity) AS total_sold_items
FROM
    gold.fact_sales AS f
    LEFT JOIN gold.dim_customer AS c ON f.customer_key = c.customer_key
GROUP BY
    c.country
ORDER BY
    total_sold_items DESC;

-- 
SELECT
    pc.product_name,
    SUM(s.sales_amount) AS total_revenue
FROM
    gold.dim_products AS pc
    LEFT JOIN gold.fact_sales AS s ON pc.product_key = s.product_key
GROUP BY
    pc.product_name
ORDER BY
    total_revenue DESC NULLS LAST
LIMIT
    5;

SELECT
    pc.subcategory,
    SUM(s.sales_amount) AS total_revenue
FROM
    gold.dim_products AS pc
    LEFT JOIN gold.fact_sales AS s ON pc.product_key = s.product_key
GROUP BY
    pc.subcategory
ORDER BY
    total_revenue DESC NULLS LAST
LIMIT
    5;

-- 
SELECT
    pc.product_name,
    SUM(s.sales_amount) AS total_revenue,
    ROW_NUMBER() OVER (
        ORDER BY
            SUM(s.sales_amount) DESC
    ) AS rank_products
FROM
    gold.dim_products AS pc
    LEFT JOIN gold.fact_sales AS s ON pc.product_key = s.product_key
GROUP BY
    pc.product_name
HAVING
    SUM(s.sales_amount) > 0
ORDER BY
    rank_products
LIMIT
    5;

-- 
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_sales,
    ROW_NUMBER() OVER (
        ORDER BY
            SUM(f.sales_amount) DESC
    ) AS rank_customer
FROM
    gold.fact_sales AS f
    LEFT JOIN gold.dim_customer AS c ON f.customer_key = c.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
HAVING
    SUM(f.sales_amount) > 0
ORDER BY
    rank_customer;
