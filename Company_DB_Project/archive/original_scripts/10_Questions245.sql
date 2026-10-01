-- 211
SELECT
    employee_id,
    first_name,
    last_name,
    salary
FROM
    hr.employees
WHERE
    salary > (
        SELECT
            AVG(COALESCE(salary, 0))
        FROM
            hr.employees
    );

-- 212
WITH
    cte_dept_avg_salary AS (
        SELECT
            department_id,
            ROUND(AVG(COALESCE(salary, 0)), 2) AS avg_salary
        FROM
            hr.employees
        GROUP BY
            department_id
    )
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary,
    cda.avg_salary
FROM
    hr.employees AS e
    LEFT JOIN cte_dept_avg_salary AS cda ON e.department_id = cda.department_id
WHERE
    e.salary > cda.avg_salary;

-- 213
WITH
    cte_total_salary AS (
        SELECT
            department_id,
            SUM(salary) AS total_salary
        FROM
            hr.employees
        GROUP BY
            department_id
    )
SELECT
    d.department_name,
    cts.total_salary
FROM
    hr.departments AS d
    INNER JOIN cte_total_salary AS cts ON d.department_id = cts.department_id
ORDER BY
    cts.total_salary DESC
FETCH FIRST
    1 rows
WITH
    ties;

-- 214
WITH
    cte_total_orders AS (
        SELECT
            customer_id,
            COUNT(*) AS total_orders
        FROM
            sales.orders
        GROUP BY
            customer_id
    )
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    cto.total_orders
FROM
    sales.customers AS c
    INNER JOIN cte_total_orders AS cto ON c.customer_id = cto.customer_id
WHERE
    cto.total_orders > (
        SELECT
            ROUND(AVG(total_orders), 2)
        FROM
            cte_total_orders
    );

-- 215
SELECT
    product_name,
    unit_price
FROM
    inventory.products
WHERE
    unit_price > (
        SELECT
            AVG(unit_price)
        FROM
            inventory.products
    );

-- 216
WITH
    cte_order_total AS (
        SELECT
            order_id,
            SUM(quantity * unit_price * (1 - discount)) AS total_price
        FROM
            sales.order_items
        GROUP BY
            order_id
    )
SELECT
    *
FROM
    cte_order_total
WHERE
    total_price > (
        SELECT
            AVG(total_price)
        FROM
            cte_order_total
    );

-- 217
SELECT
    employee_id,
    first_name,
    last_name,
    job_title,
    salary
FROM
    hr.employees
WHERE
    employee_id IN (
        SELECT
            manager_id
        FROM
            hr.employees
        WHERE
            manager_id IS NOT NULL
    );

-- 218
SELECT
    employee_id,
    first_name,
    last_name,
    job_title,
    salary
FROM
    hr.employees
WHERE
    employee_id NOT IN (
        SELECT
            manager_id
        FROM
            hr.employees
        WHERE
            manager_id IS NOT NULL
    );

-- 219
WITH
    cte_salary_rank AS (
        SELECT
            employee_id,
            first_name,
            last_name,
            salary,
            department_id,
            DENSE_RANK() OVER (
                PARTITION BY
                    department_id
                ORDER BY
                    salary DESC
            ) AS salary_rank
        FROM
            hr.employees
    )
SELECT
    csr.employee_id,
    csr.first_name,
    csr.last_name,
    csr.salary,
    d.department_name,
    csr.salary_rank
FROM
    cte_salary_rank AS csr
    INNER JOIN hr.departments AS d ON csr.department_id = d.department_id
WHERE
    salary_rank = 1;

-- 220
WITH
    cte_order_items AS (
        SELECT
            order_id,
            MAX(unit_price) AS max_unit_price
        FROM
            sales.order_items
        GROUP BY
            order_id
    )
SELECT
    coi.order_id,
    c.first_name,
    c.last_name,
    coi.max_unit_price
FROM
    cte_order_items AS coi
    INNER JOIN sales.orders AS o ON coi.order_id = o.order_id
    INNER JOIN sales.customers AS c ON o.customer_id = c.customer_id
ORDER BY
    coi.max_unit_price DESC
FETCH FIRST
    1 rows
WITH
    ties;

-- 221
SELECT
    e.employee_id,
    m.employee_id AS manager_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.hire_date AS employee_hire_date,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    m.hire_date AS manager_hire_date
FROM
    hr.employees AS e
    INNER JOIN hr.employees AS m ON e.manager_id = m.employee_id
WHERE
    e.hire_date < m.hire_date;

-- 222
WITH
    cte_order_item AS (
        SELECT
            order_id,
            ROUND(SUM(quantity * unit_price * (1 - discount)), 2) AS revenue
        FROM
            sales.order_items
        GROUP BY
            order_id
    )
SELECT
    *
FROM
    cte_order_item
ORDER BY
    revenue DESC
FETCH FIRST
    20 rows
WITH
    ties;

-- 223
WITH
    cte_order_items AS (
        SELECT
            order_id,
            SUM(quantity * unit_price * (1 - discount)) AS revenue
        FROM
            sales.order_items
        GROUP BY
            order_id
    ),
    cte_cust_revenue AS (
        SELECT
            o.customer_id,
            SUM(oi.revenue) AS revenue
        FROM
            sales.orders AS o
            INNER JOIN cte_order_items oi ON o.order_id = oi.order_id
        GROUP BY
            o.customer_id
    ),
    cte_revenue_quintile AS (
        SELECT
            c.customer_id,
            c.first_name,
            c.last_name,
            c.state,
            c.city,
            cr.revenue,
            DENSE_RANK() OVER (
                ORDER BY
                    cr.revenue DESC
            ) AS revenue_rank,
            NTILE(10) OVER (
                ORDER BY
                    cr.revenue DESC
            ) AS revenue_quintile
        FROM
            cte_cust_revenue AS cr
            INNER JOIN sales.customers AS c ON cr.customer_id = c.customer_id
    )
SELECT
    *
FROM
    cte_revenue_quintile
WHERE
    revenue_quintile = 1;

-- 224
SELECT
    *
FROM
    sales.order_items
WHERE
    product_id NOT IN (
        SELECT
            product_id
        FROM
            inventory.products
    );

-- 225 - Find customers who have ordered every product in a specific category
WITH
    cte_prod_in_cat AS (
        SELECT
            cat.category_id,
            cat.category_name,
            p.product_id,
            p.product_name
        FROM
            inventory.categories AS cat
            INNER JOIN inventory.products AS p ON cat.category_id = p.category_id
    ),
    cte_customer_ordered_prod AS (
        SELECT
            c.customer_id,
            c.first_name,
            c.last_name,
            o.order_id,
            oi.product_id
        FROM
            sales.customers AS c
            INNER JOIN sales.orders AS o ON c.customer_id = o.customer_id
            INNER JOIN sales.order_items AS oi ON o.order_id = oi.order_id
    ),
    cte_customer_ordered_category_count AS (
        SELECT
            co.customer_id,
            co.first_name,
            co.last_name,
            cp.category_id,
            cp.category_name,
            COUNT(DISTINCT co.product_id) AS products_ordered
        FROM
            cte_customer_ordered_prod AS co
            INNER JOIN cte_prod_in_cat AS cp ON co.product_id = cp.product_id
        GROUP BY
            co.customer_id,
            co.first_name,
            co.last_name,
            cp.category_id,
            cp.category_name
    )
SELECT
    co.customer_id,
    co.first_name,
    co.last_name,
    co.category_name
FROM
    cte_customer_ordered_category_count AS co
WHERE
    co.products_ordered = (
        SELECT
            COUNT(DISTINCT cp.product_id)
        FROM
            cte_prod_in_cat AS cp
        WHERE
            cp.category_id = co.category_id
    );

-- 226
WITH
    cte_monthly_revenue AS (
        SELECT
            TO_CHAR(DATE_TRUNC('month', o.order_date), 'YYYY-MM') AS month_year,
            ROUND(
                SUM(oi.unit_price * oi.quantity * (1 - oi.discount)),
                2
            ) AS monthly_revenue
        FROM
            sales.order_items AS oi
            LEFT JOIN sales.orders AS o ON oi.order_id = o.order_id
        GROUP BY
            DATE_TRUNC('month', o.order_date)
    ),
    cte_mom_revenue AS (
        SELECT
            month_year,
            monthly_revenue,
            LAG(monthly_revenue) OVER (
                ORDER BY
                    month_year
            ) AS prev_month_revenue,
            ROUND(
                (
                    (
                        monthly_revenue - LAG(monthly_revenue) OVER (
                            ORDER BY
                                month_year
                        )
                    ) * 100.0 / LAG(monthly_revenue) OVER (
                        ORDER BY
                            month_year
                    )
                ),
                2
            ) AS mom_change_percent
        FROM
            cte_monthly_revenue
    )
SELECT
    *
FROM
    cte_mom_revenue;

-- 227
WITH
    cte_projects AS (
        SELECT
            employee_id,
            COUNT(DISTINCT project_id) AS total_projects
        FROM
            hr.employee_projects
        GROUP BY
            employee_id
        HAVING
            COUNT(DISTINCT project_id) > 2
    )
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    cp.total_projects
FROM
    hr.employees AS e
    INNER JOIN cte_projects AS cp ON e.employee_id = cp.employee_id;

-- 228
WITH
    cte_emp_per_project AS (
        SELECT
            project_id,
            COUNT(DISTINCT employee_id) AS total_emp
        FROM
            hr.employee_projects
        GROUP BY
            project_id
    )
SELECT
    p.project_id,
    p.project_name,
    c.total_emp
FROM
    cte_emp_per_project AS c
    INNER JOIN hr.projects AS p ON c.project_id = p.project_id
WHERE
    total_emp > (
        SELECT
            AVG(total_emp)
        FROM
            cte_emp_per_project
    );

-- 229
WITH
    cte_first_order AS (
        SELECT
            c.customer_id,
            c.first_name,
            c.last_name,
            MIN(o.order_date) AS first_order_date,
            MAX(o.order_date) AS last_order_date,
            COUNT(o.order_id) AS total_order
        FROM
            sales.customers AS c
            LEFT JOIN sales.orders AS o ON c.customer_id = o.customer_id
        GROUP BY
            c.customer_id,
            c.first_name,
            c.last_name
    )
SELECT
    *
FROM
    cte_first_order;

-- 230
SELECT
    project_id,
    project_name,
    end_date - start_date AS duration
FROM
    hr.projects
WHERE
    (end_date - start_date) = (
        SELECT
            MAX(end_date - start_date)
        FROM
            hr.projects
    );

-- 231
WITH
    cte_salary_per_dept AS (
        SELECT
            department_id,
            ROUND(AVG(salary), 2) AS avg_salary
        FROM
            hr.employees
        GROUP BY
            department_id
    )
SELECT
    csd.department_id,
    d.department_name,
    csd.avg_salary
FROM
    cte_salary_per_dept AS csd
    INNER JOIN hr.departments AS d ON csd.department_id = d.department_id
WHERE
    csd.avg_salary < (
        SELECT
            ROUND(AVG(salary), 2)
        FROM
            hr.employees
    );

-- 232
WITH
    cte_revenue AS (
        SELECT
            product_id,
            order_id,
            ROUND(quantity * unit_price * (1 - discount)) AS revenue
        FROM
            sales.order_items
    ),
    cte_product_cat AS (
        SELECT
            cat.category_id,
            p.product_id,
            cat.category_name,
            p.product_name,
            p.stock_quantity,
            p.cost,
            p.stock_quantity * p.cost AS total_stock_value
        FROM
            inventory.categories AS cat
            LEFT JOIN inventory.products AS p ON cat.category_id = p.category_id
    )
SELECT
    TO_CHAR(o.order_date, 'YYYY-MM') AS monthly,
    cpc.category_name,
    SUM(cr.revenue) AS monthly_revenue
FROM
    sales.orders AS o
    LEFT JOIN cte_revenue AS cr ON o.order_id = cr.order_id
    LEFT JOIN cte_product_cat AS cpc ON cr.product_id = cpc.product_id
GROUP BY
    TO_CHAR(o.order_date, 'YYYY-MM'),
    cpc.category_name
ORDER BY
    monthly;

-- 233
SELECT
    order_item_id
FROM
    sales.order_items
WHERE
    discount = (
        SELECT
            MAX(discount)
        FROM
            sales.order_items
    );

-- 234
SELECT
    e.employee_id,
    CONCAT_WS(' ', e.first_name, e.last_name) AS emp_name,
    ep.hours_worked
FROM
    hr.employees AS e
    INNER JOIN hr.employee_projects AS ep ON e.employee_id = ep.employee_id
WHERE
    ep.hours_worked = (
        SELECT
            MAX(hours_worked)
        FROM
            hr.employee_projects
    );

-- 235
SELECT
    c.customer_id,
    CONCAT_WS(' ', c.first_name, c.last_name) AS custmer_name
FROM
    sales.customers AS c
WHERE
    EXISTS (
        SELECT
            1
        FROM
            sales.orders AS o
        WHERE
            o.customer_id = c.customer_id
            AND status = 'Delivered'
    );

-- 236
SELECT
    p.product_id,
    p.product_name
FROM
    inventory.products AS p
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            sales.order_items AS oi
        WHERE
            p.product_id = oi.product_id
    );

-- 237
SELECT
    oi1.product_id AS product_1,
    oi2.product_id AS product_2,
    COUNT(DISTINCT oi1.order_id) AS times_together
FROM
    sales.order_items AS oi1
    INNER JOIN sales.order_items AS oi2 ON oi1.order_id = oi2.order_id
    AND oi1.product_id < oi2.product_id
GROUP BY
    oi1.product_id,
    oi2.product_id
HAVING
    COUNT(DISTINCT oi1.order_id) > 1
ORDER BY
    times_together DESC;

-- 238
WITH
    cte_order_revenue AS (
        SELECT
            order_id,
            SUM(ROUND(quantity * unit_price * (1 - discount), 2)) AS revenue_per_order
        FROM
            sales.order_items
        GROUP BY
            order_id
    ),
    cte_monthly_revenue AS (
        SELECT
            o.order_date,
            SUM(co.revenue_per_order) AS monthly_revenue
        FROM
            sales.orders AS o
            INNER JOIN cte_order_revenue AS co ON o.order_id = co.order_id
        GROUP BY
            o.order_date
    )
SELECT
    *,
    SUM(monthly_revenue) OVER (
        ORDER BY
            order_date
    ) AS running_total
FROM
    cte_monthly_revenue;

-- 239
WITH
    cte_salary_rank AS (
        SELECT
            employee_id,
            first_name,
            last_name,
            salary,
            DENSE_RANK() OVER (
                ORDER BY
                    salary DESC
            ) AS rnk
        FROM
            hr.employees
    )
SELECT
    *
FROM
    cte_salary_rank
WHERE
    rnk = 2;

-- 240
WITH
    cte_salary_dept_rank AS (
        SELECT
            department_id,
            employee_id,
            first_name,
            last_name,
            salary,
            DENSE_RANK() OVER (
                PARTITION BY
                    department_id
                ORDER BY
                    salary DESC
            ) AS rnk
        FROM
            hr.employees
    )
SELECT
    d.department_name,
    cdr.employee_id,
    cdr.first_name,
    cdr.last_name,
    cdr.salary
FROM
    cte_salary_dept_rank AS cdr
    INNER JOIN hr.departments AS d ON cdr.department_id = d.department_id
WHERE
    rnk = 2;

-- 241
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary,
    e.department_id
FROM
    hr.employees AS e
WHERE
    e.salary > (
        SELECT
            MAX(salary)
        FROM
            hr.employees
        WHERE
            department_id = 4
    );

-- 242
WITH
    customer_total_spend AS (
        SELECT
            o.customer_id,
            SUM(oi.quantity * oi.unit_price) AS total_spend
        FROM
            sales.orders AS o
            JOIN sales.order_items AS oi ON o.order_id = oi.order_id
        GROUP BY
            o.customer_id
    ),
    customer_5012_orders AS (
        SELECT
            o.order_id,
            SUM(oi.quantity * oi.unit_price) AS order_value
        FROM
            sales.orders AS o
            JOIN sales.order_items AS oi ON o.order_id = oi.order_id
        WHERE
            o.customer_id = 5012
        GROUP BY
            o.order_id
    )
SELECT
    cts.customer_id,
    cts.total_spend
FROM
    customer_total_spend AS cts
WHERE
    cts.total_spend > ANY (
        SELECT
            order_value
        FROM
            customer_5012_orders
    )
ORDER BY
    cts.total_spend DESC;

-- 243
WITH RECURSIVE
    employee_hierarchy AS (
        -- 1. Start with top-level employees
        SELECT
            employee_id,
            first_name,
            last_name,
            manager_id,
            1 AS level
        FROM
            hr.employees
        WHERE
            manager_id IS NULL
        UNION ALL
        -- 2. Find employees who report to them
        SELECT
            e.employee_id,
            e.first_name,
            e.last_name,
            e.manager_id,
            eh.level + 1
        FROM
            hr.employees AS e
            INNER JOIN employee_hierarchy AS eh ON e.manager_id = eh.employee_id
    )
SELECT
    employee_id,
    first_name,
    last_name,
    manager_id,
    level
FROM
    employee_hierarchy
ORDER BY
    level,
    employee_id;

-- 244
WITH
    cte_high_value_cust AS (
        SELECT
            customer_id,
            first_name,
            last_name,
            city,
            state,
            customer_segment
        FROM
            sales.customers
        WHERE
            is_active
            AND (
                customer_segment = 'Gold'
                OR customer_segment = 'Platinum'
            )
    )
SELECT
    o.customer_id,
    chv.first_name,
    chv.last_name,
    chv.customer_segment,
    MAX(o.order_date) AS recent_order
FROM
    sales.orders AS o
    INNER JOIN cte_high_value_cust AS chv ON o.customer_id = chv.customer_id
GROUP BY
    o.customer_id,
    chv.first_name,
    chv.last_name,
    chv.customer_segment;

-- 245
WITH
    department_cost AS (
        SELECT
            d.department_id,
            d.department_name,
            COUNT(e.employee_id) AS employee_count,
            COALESCE(SUM(e.salary), 0) AS employee_cost
        FROM
            hr.departments AS d
            LEFT JOIN hr.employees AS e ON d.department_id = e.department_id
        GROUP BY
            d.department_id,
            d.department_name
    ),
    project_budget AS (
        SELECT
            d.department_id,
            COALESCE(COUNT(p.project_id), 0) AS project_count,
            COALESCE(SUM(p.budget), 0) AS total_project_budget
        FROM
            hr.departments AS d
            LEFT JOIN hr.employees AS e ON d.department_id = e.department_id
            LEFT JOIN hr.employee_projects AS ep ON ep.employee_id = e.employee_id
            LEFT JOIN hr.projects AS p ON ep.project_id = p.project_id
        GROUP BY
            d.department_id
    ),
    project_cost AS (
        SELECT
            e.department_id,
            COALESCE(SUM(e.salary), 0) AS assigned_employee_cost
        FROM
            hr.projects AS p
            JOIN hr.employee_projects AS ep ON p.project_id = ep.project_id
            JOIN hr.employees AS e ON ep.employee_id = e.employee_id
        GROUP BY
            e.department_id
    ),
    department_report AS (
        -- Combine all departmental information
        SELECT
            dc.department_id,
            dc.department_name,
            dc.employee_count,
            pb.project_count,
            dc.employee_cost,
            pb.total_project_budget,
            COALESCE(pc.assigned_employee_cost, 0) AS assigned_employee_cost
        FROM
            department_cost AS dc
            LEFT JOIN project_budget AS pb ON dc.department_id = pb.department_id
            LEFT JOIN project_cost AS pc ON dc.department_id = pc.department_id
    )
    -- 5. Final report
SELECT
    department_id,
    department_name,
    employee_count,
    project_count,
    employee_cost,
    assigned_employee_cost,
    total_project_budget,
    total_project_budget - assigned_employee_cost AS budget_remaining,
    ROUND(
        100.0 * assigned_employee_cost / NULLIF(total_project_budget, 0),
        2
    ) AS budget_used_pct
FROM
    department_report
ORDER BY
    department_id;