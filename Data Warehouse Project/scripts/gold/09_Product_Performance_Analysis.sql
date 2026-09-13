-- Purpose: Analyze yearly product performance relative to its historical average and prior year.
-- Strategy: Aggregate by surrogate product_key first to speed up GROUP BY, re-use window expressions in CTEs.

WITH yearly_product_sales AS (
    -- Aggregate by product_key and year first to optimize hash-grouping speed
    SELECT
        EXTRACT(YEAR FROM f.order_date)::INT AS order_year,
        f.product_key,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales AS f
    INNER JOIN gold.dim_products AS p ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY 
        EXTRACT(YEAR FROM f.order_date)::INT,
        f.product_key,
        p.product_name
),
yearly_metrics AS (
    -- Compute window calculations once without duplicate function calls
    SELECT
        order_year,
        product_name,
        current_sales,
        ROUND(AVG(current_sales) OVER (PARTITION BY product_key), 2) AS avg_sales,
        LAG(current_sales) OVER (PARTITION BY product_key ORDER BY order_year) AS py_sales
    FROM yearly_product_sales
)
SELECT
    order_year,
    product_name,
    current_sales,
    avg_sales,
    (current_sales - avg_sales) AS diff_avg,
    CASE 
        WHEN current_sales > avg_sales THEN 'Above Average'
        WHEN current_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS avg_change,
    py_sales,
    (current_sales - py_sales) AS sales_change,
    ROUND(
        (current_sales - py_sales)::NUMERIC / NULLIF(py_sales, 0) * 100, 
        2
    ) AS pct_change
FROM yearly_metrics
ORDER BY product_name, order_year;