WITH
    rfm_base AS (
        SELECT
            customer_id,
            -- Fixed benchmark relative to dataset's max date
            DATE_PART(
                'day',
                '2011-12-10 00:00:00'::TIMESTAMP - MAX(invoice_date)
            ) AS recency,
            COUNT(DISTINCT invoice_no) AS frequency,
            SUM(total_amount) AS monetary
        FROM
            v_clean_retail
        GROUP BY
            customer_id
    ),
    rfm_scores AS (
        SELECT
            customer_id,
            recency,
            frequency,
            monetary,
            NTILE(5) OVER (
                ORDER BY
                    recency DESC
            ) AS r_score, -- Lower recency days = higher score
            NTILE(5) OVER (
                ORDER BY
                    frequency ASC
            ) AS f_score,
            NTILE(5) OVER (
                ORDER BY
                    monetary ASC
            ) AS m_score
        FROM
            rfm_base
    ),
    customer_segments AS (
        SELECT
            customer_id,
            recency,
            frequency,
            monetary,
            r_score,
            f_score,
            m_score,
            CASE
                WHEN r_score >= 4
                AND f_score >= 4
                AND m_score >= 4 THEN 'Champions'
                WHEN f_score >= 3
                AND m_score >= 3 THEN 'Loyal Customers'
                WHEN r_score >= 4
                AND f_score <= 2 THEN 'New Customers'
                WHEN r_score <= 2
                AND f_score >= 3 THEN 'At Risk / Churning'
                WHEN r_score <= 2
                AND f_score <= 2 THEN 'Lost Customers'
                ELSE 'Potential Loyalists'
            END AS segment
        FROM
            rfm_scores
    )
    -- Executive Summary Breakdown
SELECT
    segment,
    COUNT(customer_id) AS total_customers,
    ROUND(
        100.0 * COUNT(customer_id) / SUM(COUNT(customer_id)) OVER (),
        2
    ) AS customer_share_pct,
    ROUND(SUM(monetary), 2) AS total_revenue,
    ROUND(
        100.0 * SUM(monetary) / SUM(SUM(monetary)) OVER (),
        2
    ) AS revenue_share_pct,
    ROUND(AVG(monetary), 2) AS avg_monetary_per_customer,
    ROUND(AVG(recency::NUMERIC), 1) AS avg_days_since_last_order
FROM
    customer_segments
GROUP BY
    segment
ORDER BY
    total_revenue DESC;