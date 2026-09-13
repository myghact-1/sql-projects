-- Purpose: Optimized temporal sales metrics (Yearly, Monthly, Cumulative YTD)
-- Strategy: Aggregate once at the month level, then roll up using CTEs to eliminate 3 redundant table scans.

WITH monthly_aggregates AS (
    -- Single base scan over fact_sales to capture core metrics grouped by year and month
    SELECT
        EXTRACT(YEAR FROM order_date)::INT AS order_year,
        EXTRACT(MONTH FROM order_date)::INT AS order_month,
        TO_CHAR(order_date, 'YYYY-MM') AS order_year_month,
        SUM(sales_amount) AS total_sales,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(quantity) AS total_quantity
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY 
        EXTRACT(YEAR FROM order_date)::INT,
        EXTRACT(MONTH FROM order_date)::INT,
        TO_CHAR(order_date, 'YYYY-MM')
)
-- 1. Yearly Aggregation (Rolled up from CTE)
SELECT
    order_year,
    SUM(total_sales) AS total_sales,
    SUM(total_customers) AS total_customers,
    SUM(total_quantity) AS total_quantity
FROM monthly_aggregates
GROUP BY order_year
ORDER BY order_year;

-- 2. Overall Monthly Aggregation (Rolled up across all years)
SELECT
    order_month,
    SUM(total_sales) AS total_sales,
    SUM(total_customers) AS total_customers,
    SUM(total_quantity) AS total_quantity
FROM monthly_aggregates
GROUP BY order_month
ORDER BY order_month;

-- 3. Monthly Breakdown with YTD Cumulative Sales
SELECT
    order_year_month,
    total_sales,
    total_customers,
    total_quantity,
    SUM(total_sales) OVER (
        PARTITION BY order_year 
        ORDER BY order_year_month
    ) AS cumulative_sales_ytd
FROM monthly_aggregates
ORDER BY order_year_month;