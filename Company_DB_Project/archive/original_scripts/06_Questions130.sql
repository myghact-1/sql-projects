-- 91
SELECT
    COUNT(*)
FROM
    hr.employees;

-- 92
SELECT
    d.department_name,
    t.total_employees
FROM
    hr.departments AS d
    LEFT JOIN (
        SELECT
            department_id,
            COUNT(DISTINCT employee_id) AS total_employees
        FROM
            hr.employees
        GROUP BY
            department_id
    ) AS t ON d.department_id = t.department_id;

-- 93
WITH
    cte_avg_salary AS (
        SELECT
            department_id,
            ROUND(AVG(salary), 2) AS avg_salary
        FROM
            hr.employees
        GROUP BY
            department_id
    )
SELECT
    d.department_id,
    d.department_name,
    cas.avg_salary
FROM
    hr.departments AS d
    LEFT JOIN cte_avg_salary AS cas ON d.department_id = cas.department_id;

-- 94
SELECT
    MIN(salary),
    MAX(salary),
    AVG(salary)
FROM
    hr.employees;

-- 95
SELECT
    e.department_id,
    SUM(salary) AS total_salary_expenses
FROM
    hr.employees AS e
GROUP BY
    e.department_id;

-- 96
SELECT
    e.status,
    COUNT(DISTINCT e.employee_id) AS total_employees
FROM
    hr.employees AS e
GROUP BY
    e.status;

-- 97
SELECT
    e.job_title,
    COUNT(*)
FROM
    hr.employees AS e
GROUP BY
    e.job_title;

-- 98
SELECT
    d.department_name,
    COUNT(DISTINCT e.employee_id) AS total_employees
FROM
    hr.departments AS d
    LEFT JOIN hr.employees AS e ON d.department_id = e.department_id
GROUP BY
    d.department_name
HAVING
    COUNT(DISTINCT e.employee_id) > 15;

-- 99
SELECT
    d.department_name,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM
    hr.departments AS d
    INNER JOIN hr.employees AS e ON d.department_id = e.department_id
GROUP BY
    d.department_name
ORDER BY
    avg_salary DESC NULLS LAST
FETCH FIRST
    1 rows
WITH
    ties;

-- 100
SELECT
    department_id,
    job_title,
    ROUND(AVG(salary), 2) AS avg_salary
FROM
    hr.employees
GROUP BY
    department_id,
    job_title;

-- 101
SELECT
    city,
    COUNT(*)
FROM
    sales.customers
GROUP BY
    city;

-- 102
SELECT
    customer_segment,
    COUNT(*)
FROM
    sales.customers
GROUP BY
    customer_segment;

-- 103
SELECT
    is_active,
    COUNT(*)
FROM
    sales.customers
GROUP BY
    is_active;

-- 104
SELECT
    EXTRACT(
        YEAR
        FROM
            order_date
    ) AS YEAR,
    COUNT(*)
FROM
    sales.orders
GROUP BY
    EXTRACT(
        YEAR
        FROM
            order_date
    );

-- 106
SELECT
    TO_CHAR(order_date, 'Mon-YY') AS year_month,
    COUNT(*)
FROM
    sales.orders
GROUP BY
    TO_CHAR(order_date, 'Mon-YY');

-- 107
SELECT
    EXTRACT(
        YEAR
        FROM
            order_date
    ) AS YEAR,
    SUM(shipping_cost)
FROM
    sales.orders
GROUP BY
    EXTRACT(
        YEAR
        FROM
            order_date
    );

-- 108
SELECT
    payment_method,
    ROUND(AVG(shipping_cost), 2) AS avg_ship_cost
FROM
    sales.orders
GROUP BY
    payment_method;

-- 109
SELECT
    SUM(
        quantity * unit_price * (1 - COALESCE(discount, 0))
    ) AS total_revenue
FROM
    sales.order_items;

-- 110
SELECT
    p.product_name,
    COALESCE(
        SUM(
            oi.unit_price * oi.quantity * (1 - COALESCE(oi.discount, 0))
        ),
        0
    ) AS total_revenue
FROM
    inventory.products AS p
    LEFT JOIN sales.order_items AS oi ON p.product_id = oi.product_id
GROUP BY
    p.product_name
ORDER BY
    p.product_name ASC;

-- 111
SELECT
    cat.category_name,
    COALESCE(
        SUM(
            oi.unit_price * oi.quantity * (1 - COALESCE(oi.discount, 0))
        ),
        0
    ) AS revenue
FROM
    inventory.categories AS cat
    LEFT JOIN inventory.products AS p ON cat.category_id = p.category_id
    LEFT JOIN sales.order_items AS oi ON p.product_id = oi.product_id
GROUP BY
    cat.category_name
ORDER BY
    cat.category_name ASC;

-- 112
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS full_name,
    COALESCE(
        SUM(
            oi.unit_price * oi.quantity * (1 - COALESCE(oi.discount, 0))
        ),
        0
    ) AS revenue
FROM
    sales.customers AS c
    LEFT JOIN sales.orders AS o ON c.customer_id = o.customer_id
    LEFT JOIN sales.order_items AS oi ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY
    revenue DESC;

-- 113
SELECT
    p.product_id,
    p.product_name,
    SUM(
        oi.unit_price * oi.quantity * (1 - COALESCE(oi.discount, 0))
    ) AS revenue
FROM
    inventory.products AS p
    LEFT JOIN sales.order_items AS oi ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY
    revenue DESC
FETCH FIRST
    10 ROWS
WITH
    ties;

-- 114
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(
        oi.unit_price * oi.quantity * (1 - COALESCE(oi.discount, 0))
    ) AS revenue
FROM
    sales.customers AS c
    LEFT JOIN sales.orders AS o ON c.customer_id = o.customer_id
    LEFT JOIN sales.order_items AS oi ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY
    revenue DESC NULLS LAST
FETCH FIRST
    10 ROWS
WITH
    ties;

-- 115
SELECT
    o.order_id,
    ROUND(
        SUM(oi.unit_price * oi.quantity) / SUM(oi.quantity),
        2
    ) AS avg_order_value
FROM
    sales.orders AS o
    LEFT JOIN sales.order_items AS oi ON o.order_id = oi.order_id
GROUP BY
    o.order_id
ORDER BY
    o.order_id ASC;

-- 116
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS full_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM
    sales.customers AS c
    INNER JOIN sales.orders AS o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING
    COUNT(DISTINCT o.order_id) > 5;

-- 117
SELECT
    p.product_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM
    inventory.products AS p
    INNER JOIN sales.order_items AS oi ON p.product_id = oi.product_id
    INNER JOIN sales.orders AS o ON oi.order_id = o.order_id
GROUP BY
    p.product_name
HAVING
    COUNT(DISTINCT o.order_id) > 50;

-- 118
SELECT
    oi.order_id,
    SUM(oi.quantity)
FROM
    sales.order_items AS oi
GROUP BY
    oi.order_id;

-- 119
SELECT
    oi.order_id,
    COUNT(DISTINCT oi.product_id) AS unique_items
FROM
    sales.order_items AS oi
GROUP BY
    oi.order_id
HAVING
    COUNT(DISTINCT oi.product_id) > 3;

-- 120
SELECT
    p.project_name,
    SUM(ep.hours_worked) AS total_hours
FROM
    hr.projects AS p
    LEFT JOIN hr.employee_projects AS ep ON p.project_id = ep.project_id
GROUP BY
    p.project_name;

-- 121
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    SUM(ep.hours_worked) AS total_hours
FROM
    hr.employees AS e
    LEFT JOIN hr.employee_projects AS ep ON e.employee_id = ep.employee_id
GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name
ORDER BY
    total_hours DESC NULLS LAST;

-- 122
SELECT
    p.project_name,
    SUM(ep.hours_worked) AS total_hours
FROM
    hr.projects AS p
    LEFT JOIN hr.employee_projects AS ep ON p.project_id = ep.project_id
GROUP BY
    p.project_name
HAVING
    SUM(ep.hours_worked) > 1000;

-- 123
SELECT
    p.project_name,
    ROUND(AVG(ep.hours_allocated), 2) avg_hours_allocated,
    SUM(ep.hours_worked) AS total_hours
FROM
    hr.projects AS p
    LEFT JOIN hr.employee_projects AS ep ON p.project_id = ep.project_id
GROUP BY
    p.project_name;

-- 124
SELECT
    p.project_name,
    COUNT(DISTINCT ep.employee_id) AS total_employees
FROM
    hr.employee_projects AS ep
    INNER JOIN hr.projects AS p ON ep.project_id = p.project_id
GROUP BY
    p.project_name;

-- 125
SELECT
    p.project_name,
    SUM(ep.hours_allocated) AS total_hours
FROM
    hr.projects AS p
    LEFT JOIN hr.employee_projects AS ep ON p.project_id = ep.project_id
GROUP BY
    p.project_name
ORDER BY
    total_hours DESC
LIMIT
    1;

-- 126
SELECT
    EXTRACT(
        YEAR
        FROM
            hire_date
    ) AS YEAR,
    COUNT(*) AS total_employees
FROM
    hr.employees
GROUP BY
    EXTRACT(
        YEAR
        FROM
            hire_date
    )
ORDER BY
    YEAR;

-- 127
SELECT
    EXTRACT(
        YEAR
        FROM
            hire_date
    ) AS YEAR,
    ROUND(AVG(salary), 2) AS avg_salary
FROM
    hr.employees
GROUP BY
    EXTRACT(
        YEAR
        FROM
            hire_date
    )
ORDER BY
    YEAR;

-- 128
SELECT
    SUM(budget) AS total_budget
FROM
    hr.projects
WHERE
    status = 'In Progress';

-- 129
SELECT
    is_discontinued,
    COUNT(*) AS total
FROM
    inventory.products
GROUP BY
    is_discontinued;

-- 130
SELECT
    cat.category_name,
    ROUND(SUM(p.stock_quantity * p.cost), 2) AS stock_value
FROM
    inventory.categories AS cat
    INNER JOIN inventory.products AS p ON cat.category_id = p.category_id
GROUP BY
    cat.category_name;
