-- Purpose: Calculate category contribution to overall revenue.
-- Strategy: Replaced full-table scan scalar subquery with a window function OVER() total sum.

WITH category_sales AS (
    SELECT
        COALESCE(p.category, 'Unassigned') AS category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales AS f
    INNER JOIN gold.dim_products AS p ON f.product_key = p.product_key
    GROUP BY COALESCE(p.category, 'Unassigned')
)
SELECT
    category,
    total_sales,
    ROUND(
        (total_sales / SUM(total_sales) OVER ()) * 100, 
        2
    ) AS pct_share
FROM category_sales
ORDER BY total_sales DESC;