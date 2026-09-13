-- Purpose: Segment product catalog into cost buckets.
-- Strategy: Aggregate directly on the CASE expression to avoid intermediate CTE/subquery overhead.
SELECT
    CASE
        WHEN cost <= 100 THEN 'Below 100'
        WHEN cost <= 500 THEN '101-500'
        WHEN cost <= 1000 THEN '501-1000'
        ELSE 'Above 1000'
    END AS cost_range,
    COUNT(*) AS total_products
FROM
    gold.dim_products
GROUP BY
    CASE
        WHEN cost <= 100 THEN 'Below 100'
        WHEN cost <= 500 THEN '101-500'
        WHEN cost <= 1000 THEN '501-1000'
        ELSE 'Above 1000'
    END
ORDER BY
    MIN(cost) ASC;