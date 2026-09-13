WITH
    first_purchase AS (
        SELECT
            customer_id,
            DATE_TRUNC('month', MIN(invoice_date)) AS cohort_month
        FROM
            v_clean_retail
        GROUP BY
            customer_id
    ),
    customer_activities AS (
        SELECT
            r.customer_id,
            fp.cohort_month,
            (
                DATE_PART('year', r.invoice_date) - DATE_PART('year', fp.cohort_month)
            ) * 12 + (
                DATE_PART('month', r.invoice_date) - DATE_PART('month', fp.cohort_month)
            ) AS month_number
        FROM
            v_clean_retail r
            JOIN first_purchase fp ON r.customer_id = fp.customer_id
    ),
    cohort_size AS (
        SELECT
            cohort_month,
            COUNT(DISTINCT customer_id) AS num_customers
        FROM
            first_purchase
        GROUP BY
            cohort_month
    ),
    retention_matrix AS (
        SELECT
            ca.cohort_month,
            ca.month_number,
            COUNT(DISTINCT ca.customer_id) AS active_customers
        FROM
            customer_activities ca
        GROUP BY
            ca.cohort_month,
            ca.month_number
    )
SELECT
    TO_CHAR(rm.cohort_month, 'YYYY-MM') AS cohort,
    cs.num_customers AS initial_size,
    rm.month_number,
    rm.active_customers,
    ROUND(100.0 * rm.active_customers / cs.num_customers, 2) AS retention_rate_pct
FROM
    retention_matrix rm
    JOIN cohort_size cs ON rm.cohort_month = cs.cohort_month
WHERE
    rm.month_number <= 6
ORDER BY
    rm.cohort_month,
    rm.month_number;