-- Purpose: Classify customers into VIP, Regular, and New segments based on lifespan and spend.
-- Strategy: Group on fact table directly to eliminate dimension join, collapse subquery layers into a single CTE.
WITH
    customer_aggregates AS (
        SELECT
            f.customer_key,
            SUM(f.sales_amount) AS total_spending,
            (MAX(f.order_date) - MIN(f.order_date)) AS tenure_days
        FROM
            gold.fact_sales AS f
        WHERE
            f.customer_key IS NOT NULL
        GROUP BY
            f.customer_key
    )
SELECT
    CASE
        WHEN tenure_days > 365
        AND total_spending >= 5000 THEN 'VIP'
        WHEN tenure_days > 365 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,
    COUNT(*) AS total_customers
FROM
    customer_aggregates
GROUP BY
    CASE
        WHEN tenure_days > 365
        AND total_spending >= 5000 THEN 'VIP'
        WHEN tenure_days > 365 THEN 'Regular'
        ELSE 'New'
    END
ORDER BY
    total_customers DESC;