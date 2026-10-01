/* ============================================================
276. Mean, Median, Min, Max and Standard Deviation of Salary
============================================================ */
SELECT
    ROUND(AVG(salary)::NUMERIC, 2) AS mean_salary,
    ROUND(
        PERCENTILE_CONT(0.50) WITHIN GROUP (
            ORDER BY
                salary
        )::NUMERIC,
        2
    ) AS median_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    ROUND(STDDEV(salary), 2) AS stddev_salary
FROM
    hr.employees;

/* ============================================================
277. Statistical Summary of unit_price and cost
============================================================ */
SELECT
    'unit_price' AS metric,
    COUNT(unit_price) AS count,
    ROUND(AVG(unit_price)::NUMERIC, 2) AS mean,
    ROUND(
        PERCENTILE_CONT(0.50) WITHIN GROUP (
            ORDER BY
                unit_price
        )::NUMERIC,
        2
    ) AS median,
    MIN(unit_price) AS min,
    MAX(unit_price) AS max,
    ROUND(STDDEV(unit_price), 2) AS stddev,
    ROUND(VAR_SAMP(unit_price), 2) AS variance
FROM
    inventory.products
UNION ALL
SELECT
    'cost' AS metric,
    COUNT(cost),
    ROUND(AVG(cost)::NUMERIC, 2),
    ROUND(
        PERCENTILE_CONT(0.50) WITHIN GROUP (
            ORDER BY
                cost
        )::NUMERIC,
        2
    ),
    MIN(cost),
    MAX(cost),
    ROUND(STDDEV(cost), 2),
    ROUND(VAR_SAMP(cost), 2)
FROM
    inventory.products;

/* ============================================================
278. Average Order Value and Standard Deviation
============================================================ */
WITH
    order_values AS (
        SELECT
            o.order_id,
            SUM(
                oi.quantity * oi.unit_price * (1 - COALESCE(oi.discount, 0))
            ) AS order_value
        FROM
            sales.orders AS o
            JOIN sales.order_items AS oi ON o.order_id = oi.order_id
        GROUP BY
            o.order_id
    )
SELECT
    ROUND(AVG(order_value), 2) AS average_order_value,
    ROUND(STDDEV(order_value), 2) AS order_value_stddev,
    ROUND(MIN(order_value), 2) AS min_order_value,
    ROUND(MAX(order_value), 2) AS max_order_value
FROM
    order_values;

/* ============================================================
279. Correlation-like relationship:
Higher paid employees vs project hours
============================================================ */
WITH
    employee_project_hours AS (
        SELECT
            e.employee_id,
            e.salary,
            COALESCE(SUM(ep.hours_worked), 0) AS total_hours_worked
        FROM
            hr.employees AS e
            LEFT JOIN hr.employee_projects AS ep ON e.employee_id = ep.employee_id
        GROUP BY
            e.employee_id,
            e.salary
    )
SELECT
    ROUND(CORR(salary, total_hours_worked)::NUMERIC, 4) AS salary_hours_correlation
FROM
    employee_project_hours;

/* ============================================================
280. Variance of shipping_cost
============================================================ */
SELECT
    ROUND(VAR_SAMP(shipping_cost), 2) AS shipping_cost_variance
FROM
    sales.orders;

/* ============================================================
281. 25th, 50th and 75th Percentile of Salary
============================================================ */
SELECT
    ROUND(
        PERCENTILE_CONT(0.25) WITHIN GROUP (
            ORDER BY
                salary
        )::NUMERIC,
        2
    ) AS percentile_25,
    ROUND(
        PERCENTILE_CONT(0.50) WITHIN GROUP (
            ORDER BY
                salary
        )::NUMERIC,
        2
    ) AS percentile_50,
    ROUND(
        PERCENTILE_CONT(0.75) WITHIN GROUP (
            ORDER BY
                salary
        )::NUMERIC,
        2
    ) AS percentile_75
FROM
    hr.employees;

/* ============================================================
282. Interquartile Range (IQR) of Salaries

IQR = Q3 - Q1
============================================================ */
SELECT
    ROUND(
        PERCENTILE_CONT(0.75) WITHIN GROUP (
            ORDER BY
                salary
        )::NUMERIC - PERCENTILE_CONT(0.25) WITHIN GROUP (
            ORDER BY
                salary
        )::NUMERIC,
        2
    ) AS salary_iqr
FROM
    hr.employees;

/* ============================================================
283. Find Salary Outliers using 1.5 * IQR Rule
============================================================ */
WITH
    salary_quartiles AS (
        SELECT
            PERCENTILE_CONT(0.25) WITHIN GROUP (
                ORDER BY
                    salary
            )::NUMERIC AS q1,
            PERCENTILE_CONT(0.75) WITHIN GROUP (
                ORDER BY
                    salary
            )::NUMERIC AS q3
        FROM
            hr.employees
    ),
    salary_bounds AS (
        SELECT
            q1,
            q3,
            q3 - q1 AS iqr,
            q1 - 1.5 * (q3 - q1) AS lower_bound,
            q3 + 1.5 * (q3 - q1) AS upper_bound
        FROM
            salary_quartiles
    )
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary,
    sb.q1,
    sb.q3,
    sb.iqr,
    sb.lower_bound,
    sb.upper_bound
FROM
    hr.employees AS e
    CROSS JOIN salary_bounds AS sb
WHERE
    e.salary < sb.lower_bound
    OR e.salary > sb.upper_bound
ORDER BY
    e.salary DESC;

/* ============================================================
284. Average Discount and Discount Distribution
============================================================ */
SELECT
    ROUND(AVG(COALESCE(discount, 0))::NUMERIC, 4) AS average_discount,
    ROUND(
        PERCENTILE_CONT(0.25) WITHIN GROUP (
            ORDER BY
                COALESCE(discount, 0)
        )::NUMERIC,
        4
    ) AS discount_q1,
    ROUND(
        PERCENTILE_CONT(0.50) WITHIN GROUP (
            ORDER BY
                COALESCE(discount, 0)
        )::NUMERIC,
        4
    ) AS discount_median,
    ROUND(
        PERCENTILE_CONT(0.75) WITHIN GROUP (
            ORDER BY
                COALESCE(discount, 0)
        )::NUMERIC,
        4
    ) AS discount_q3,
    MIN(COALESCE(discount, 0)) AS min_discount,
    MAX(COALESCE(discount, 0)) AS max_discount,
    ROUND(STDDEV(COALESCE(discount, 0)), 4) AS discount_stddev
FROM
    sales.order_items;

/* ============================================================
285. Mode of customer_segment and order status
============================================================ */
-- Mode of customer segment
SELECT
    customer_segment,
    COUNT(*) AS frequency
FROM
    sales.customers
GROUP BY
    customer_segment
ORDER BY
    frequency DESC
LIMIT
    1;

-- Mode of order status
SELECT
    status,
    COUNT(*) AS frequency
FROM
    sales.orders
GROUP BY
    status
ORDER BY
    frequency DESC
LIMIT
    1;

/* ============================================================
286. Average Number of Items per Order and its Spread
============================================================ */
WITH
    order_item_counts AS (
        SELECT
            order_id,
            SUM(quantity) AS item_count
        FROM
            sales.order_items
        GROUP BY
            order_id
    )
SELECT
    ROUND(AVG(item_count)::NUMERIC, 2) AS avg_items_per_order,
    ROUND(STDDEV(item_count)::NUMERIC, 2) AS stddev_items,
    MIN(item_count) AS min_items,
    MAX(item_count) AS max_items,
    ROUND(
        PERCENTILE_CONT(0.50) WITHIN GROUP (
            ORDER BY
                item_count
        )::NUMERIC,
        2
    ) AS median_items
FROM
    order_item_counts;

/* ============================================================
287. Total Revenue, Average Revenue per Order
and Average Revenue per Customer
============================================================ */
WITH
    order_revenue AS (
        SELECT
            o.order_id,
            o.customer_id,
            SUM(
                oi.quantity * oi.unit_price * (1 - COALESCE(oi.discount, 0))
            ) AS revenue
        FROM
            sales.orders AS o
            JOIN sales.order_items AS oi ON o.order_id = oi.order_id
        GROUP BY
            o.order_id,
            o.customer_id
    ),
    customer_revenue AS (
        SELECT
            customer_id,
            SUM(revenue) AS customer_total_revenue
        FROM
            order_revenue
        GROUP BY
            customer_id
    )
SELECT
    ROUND(
        (
            SELECT
                SUM(revenue)
            FROM
                order_revenue
        ),
        2
    ) AS total_revenue,
    ROUND(
        (
            SELECT
                AVG(revenue)
            FROM
                order_revenue
        ),
        2
    ) AS avg_revenue_per_order,
    ROUND(
        (
            SELECT
                AVG(customer_total_revenue)
            FROM
                customer_revenue
        ),
        2
    ) AS avg_revenue_per_customer;

/* ============================================================
288. Year-over-Year Revenue Growth
============================================================ */
WITH
    yearly_revenue AS (
        SELECT
            EXTRACT(
                YEAR
                FROM
                    o.order_date
            )::INT AS YEAR,
            SUM(
                oi.quantity * oi.unit_price * (1 - COALESCE(oi.discount, 0))
            ) AS revenue
        FROM
            sales.orders AS o
            JOIN sales.order_items AS oi ON o.order_id = oi.order_id
        GROUP BY
            EXTRACT(
                YEAR
                FROM
                    o.order_date
            )
    ),
    revenue_with_previous AS (
        SELECT
            YEAR,
            revenue,
            LAG(revenue) OVER (
                ORDER BY
                    YEAR
            ) AS previous_year_revenue
        FROM
            yearly_revenue
    )
SELECT
    YEAR,
    ROUND(revenue, 2) AS revenue,
    ROUND(previous_year_revenue, 2) AS previous_year_revenue,
    ROUND(
        100.0 * (revenue - previous_year_revenue) / NULLIF(previous_year_revenue, 0),
        2
    ) AS yoy_growth_pct
FROM
    revenue_with_previous
ORDER BY
    YEAR;

/* ============================================================
289. Proportion of Orders that are Cancelled or Returned
============================================================ */
SELECT
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (
        WHERE
            LOWER(status) IN ('cancelled', 'returned')
    ) AS cancelled_or_returned_orders,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE
                LOWER(status) IN ('cancelled', 'returned')
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS cancelled_or_returned_pct
FROM
    sales.orders;

/* ============================================================
290. Average Employee Tenure per Department and Overall
============================================================ */
/* ============================================================
291. Average Project Budget Utilization
hours_worked / hours_allocated
============================================================ */
SELECT
    ROUND(
        AVG(hours_worked / NULLIF(hours_allocated, 0))::NUMERIC,
        4
    ) AS avg_budget_utilization,
    ROUND(
        100.0 * AVG(hours_worked / NULLIF(hours_allocated, 0))::NUMERIC,
        2
    ) AS avg_budget_utilization_pct
FROM
    hr.employee_projects;

/* ============================================================
292. Statistical Summary of stock_quantity by category
============================================================ */
SELECT
    c.category_id,
    c.category_name,
    COUNT(p.product_id) AS product_count,
    ROUND(AVG(p.stock_quantity)::NUMERIC, 2) AS avg_stock,
    ROUND(
        PERCENTILE_CONT(0.50) WITHIN GROUP (
            ORDER BY
                p.stock_quantity
        )::NUMERIC,
        2
    ) AS median_stock,
    MIN(p.stock_quantity) AS min_stock,
    MAX(p.stock_quantity) AS max_stock,
    ROUND(STDDEV(p.stock_quantity), 2) AS stock_stddev
FROM
    inventory.categories AS c
    LEFT JOIN inventory.products AS p ON c.category_id = p.category_id
GROUP BY
    c.category_id,
    c.category_name
ORDER BY
    c.category_id;

/* ============================================================
293. Percentage of Active vs Terminated Employees
============================================================ */
/* ============================================================
294. Average Revenue Contribution:
Platinum vs Bronze Customers
============================================================ */
WITH
    customer_revenue AS (
        SELECT
            o.customer_id,
            SUM(
                oi.quantity * oi.unit_price * (1 - COALESCE(oi.discount, 0))
            ) AS revenue
        FROM
            sales.orders AS o
            JOIN sales.order_items AS oi ON o.order_id = oi.order_id
        GROUP BY
            o.customer_id
    )
SELECT
    c.customer_segment,
    COUNT(c.customer_id) AS customer_count,
    ROUND(AVG(COALESCE(cr.revenue, 0))::NUMERIC, 2) AS avg_customer_revenue,
    ROUND(SUM(COALESCE(cr.revenue, 0))::NUMERIC, 2) AS total_segment_revenue,
    ROUND(
        100.0 * SUM(COALESCE(cr.revenue, 0)) / NULLIF(SUM(SUM(COALESCE(cr.revenue, 0))) OVER (), 0)::NUMERIC,
        2
    ) AS revenue_contribution_pct
FROM
    sales.customers AS c
    LEFT JOIN customer_revenue AS cr ON c.customer_id = cr.customer_id
WHERE
    c.customer_segment IN ('Platinum', 'Bronze')
GROUP BY
    c.customer_segment
ORDER BY
    CASE c.customer_segment
        WHEN 'Platinum' THEN 1
        WHEN 'Bronze' THEN 2
    END;

/* ============================================================
295. COMPREHENSIVE STATISTICAL REPORT
Salaries + Orders + Project Hours
============================================================ */
WITH
    salary_stats AS (
        SELECT
            'SALARY' AS metric_group,
            COUNT(salary)::NUMERIC AS observations,
            ROUND(AVG(salary)::NUMERIC, 2) AS mean_value,
            ROUND(
                PERCENTILE_CONT(0.50) WITHIN GROUP (
                    ORDER BY
                        salary
                )::NUMERIC,
                2
            ) AS median_value,
            ROUND(MIN(salary), 2) AS min_value,
            ROUND(MAX(salary), 2) AS max_value,
            ROUND(STDDEV(salary), 2) AS stddev_value,
            ROUND(VAR_SAMP(salary), 2) AS variance_value
        FROM
            hr.employees
    ),
    order_stats AS (
        SELECT
            'ORDER VALUE' AS metric_group,
            COUNT(*)::NUMERIC AS observations,
            ROUND(AVG(order_value)::NUMERIC, 2) AS mean_value,
            ROUND(
                PERCENTILE_CONT(0.50) WITHIN GROUP (
                    ORDER BY
                        order_value
                )::NUMERIC,
                2
            ) AS median_value,
            ROUND(MIN(order_value), 2) AS min_value,
            ROUND(MAX(order_value), 2) AS max_value,
            ROUND(STDDEV(order_value), 2) AS stddev_value,
            ROUND(VAR_SAMP(order_value), 2) AS variance_value
        FROM
            (
                SELECT
                    o.order_id,
                    SUM(
                        oi.quantity * oi.unit_price * (1 - COALESCE(oi.discount, 0))
                    ) AS order_value
                FROM
                    sales.orders AS o
                    JOIN sales.order_items AS oi ON o.order_id = oi.order_id
                GROUP BY
                    o.order_id
            ) AS orders
    ),
    project_hour_stats AS (
        SELECT
            'PROJECT HOURS' AS metric_group,
            COUNT(hours_worked)::NUMERIC AS observations,
            ROUND(AVG(hours_worked)::NUMERIC, 2) AS mean_value,
            ROUND(
                PERCENTILE_CONT(0.50) WITHIN GROUP (
                    ORDER BY
                        hours_worked
                )::NUMERIC,
                2
            ) AS median_value,
            ROUND(MIN(hours_worked), 2) AS min_value,
            ROUND(MAX(hours_worked), 2) AS max_value,
            ROUND(STDDEV(hours_worked), 2) AS stddev_value,
            ROUND(VAR_SAMP(hours_worked), 2) AS variance_value
        FROM
            hr.employee_projects
    )
SELECT
    *
FROM
    salary_stats
UNION ALL
SELECT
    *
FROM
    order_stats
UNION ALL
SELECT
    *
FROM
    project_hour_stats;