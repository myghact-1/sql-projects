-- ================================================================
-- 03 — GROUP BY & Aggregations
-- Questions 91–130
-- PostgreSQL practice solutions from the Company DB project.
-- ================================================================
-- Question 91: Count the total number of employees.
SELECT
    COUNT(*)
FROM
    hr.employees;

-- Question 92: Count employees per department.
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

-- Question 93: Calculate average salary per department.
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

-- Question 94: Calculate min, max and average salary overall.
SELECT
    MIN(salary),
    MAX(salary),
    AVG(salary)
FROM
    hr.employees;

-- Question 95: Find the total salary expense per department.
SELECT
    e.department_id,
    SUM(salary) AS total_salary_expenses
FROM
    hr.employees AS e
GROUP BY
    e.department_id;

-- Question 96: Count employees by status.
SELECT
    e.status,
    COUNT(DISTINCT e.employee_id) AS total_employees
FROM
    hr.employees AS e
GROUP BY
    e.status;

-- Question 97: Count employees by job_title.
SELECT
    e.job_title,
    COUNT(*)
FROM
    hr.employees AS e
GROUP BY
    e.job_title;

-- Question 98: Find departments with more than 15 employees.
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

-- Question 99: Find the department with the highest average salary.
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

-- Question 100: Calculate average salary by job_title and department.
SELECT
    department_id,
    job_title,
    ROUND(AVG(salary), 2) AS avg_salary
FROM
    hr.employees
GROUP BY
    department_id,
    job_title;

-- Question 101: Count customers per state.
SELECT
    city,
    COUNT(*)
FROM
    sales.customers
GROUP BY
    city;

-- Question 102: Count customers per customer_segment.
SELECT
    customer_segment,
    COUNT(*)
FROM
    sales.customers
GROUP BY
    customer_segment;

-- Question 103: Find the number of active vs inactive customers.
SELECT
    is_active,
    COUNT(*)
FROM
    sales.customers
GROUP BY
    is_active;

-- Question 104: Count orders per status.
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

-- Question 106: Count orders per month (year-month).
SELECT
    TO_CHAR(order_date, 'Mon-YY') AS year_month,
    COUNT(*)
FROM
    sales.orders
GROUP BY
    TO_CHAR(order_date, 'Mon-YY');

-- Question 107: Calculate total shipping cost per year.
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

-- Question 108: Find the average shipping cost by payment_method.
SELECT
    payment_method,
    ROUND(AVG(shipping_cost), 2) AS avg_ship_cost
FROM
    sales.orders
GROUP BY
    payment_method;

-- Question 109: Calculate total revenue (sum of quantity * unit_price * (1-discount)).
SELECT
    SUM(
        quantity * unit_price * (1 - COALESCE(discount, 0))
    ) AS total_revenue
FROM
    sales.order_items;

-- Question 110: Calculate revenue per product.
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

-- Question 111: Calculate revenue per category.
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

-- Question 112: Calculate revenue per customer.
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

-- Question 113: Find the top 10 products by revenue.
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

-- Question 114: Find the top 10 customers by revenue.
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

-- Question 115: Calculate average order value.
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

-- Question 116: Find customers with more than 5 orders.
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

-- Question 117: Find products ordered more than 50 times.
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

-- Question 118: Count the number of items per order.
SELECT
    oi.order_id,
    SUM(oi.quantity)
FROM
    sales.order_items AS oi
GROUP BY
    oi.order_id;

-- Question 119: Find orders that contain more than 3 different products.
SELECT
    oi.order_id,
    COUNT(DISTINCT oi.product_id) AS unique_items
FROM
    sales.order_items AS oi
GROUP BY
    oi.order_id
HAVING
    COUNT(DISTINCT oi.product_id) > 3;

-- Question 120: Calculate total hours_worked per project.
SELECT
    p.project_name,
    SUM(ep.hours_worked) AS total_hours
FROM
    hr.projects AS p
    LEFT JOIN hr.employee_projects AS ep ON p.project_id = ep.project_id
GROUP BY
    p.project_name;

-- Question 121: Calculate total hours_worked per employee.
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

-- Question 122: Find projects with total hours_worked > 1000.
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

-- Question 123: Average hours_allocated vs hours_worked per project.
SELECT
    p.project_name,
    ROUND(AVG(ep.hours_allocated), 2) avg_hours_allocated,
    SUM(ep.hours_worked) AS total_hours
FROM
    hr.projects AS p
    LEFT JOIN hr.employee_projects AS ep ON p.project_id = ep.project_id
GROUP BY
    p.project_name;

-- Question 124: Count employees per project.
SELECT
    p.project_name,
    COUNT(DISTINCT ep.employee_id) AS total_employees
FROM
    hr.employee_projects AS ep
    INNER JOIN hr.projects AS p ON ep.project_id = p.project_id
GROUP BY
    p.project_name;

-- Question 125: Find the project with the highest total hours.
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

-- Question 126: Group employees by year of hire and count them.
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

-- Question 127: Calculate average salary by year of hire.
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

-- Question 128: Find the total budget of all 'In Progress' projects.
SELECT
    SUM(budget) AS total_budget
FROM
    hr.projects
WHERE
    status = 'In Progress';

-- Question 129: Count discontinued vs active products.
SELECT
    is_discontinued,
    COUNT(*) AS total
FROM
    inventory.products
GROUP BY
    is_discontinued;

-- Question 130: Calculate total stock value (stock_quantity * cost) per category.
SELECT
    cat.category_name,
    ROUND(SUM(p.stock_quantity * p.cost), 2) AS stock_value
FROM
    inventory.categories AS cat
    INNER JOIN inventory.products AS p ON cat.category_id = p.category_id
GROUP BY
    cat.category_name;

-- ================================================================
-- SOURCE FILE CHECK
-- The following numbered solutions were not present in the supplied SQL files.
-- They are intentionally left as TODOs rather than invented.
-- ================================================================
-- TODO Question 105: Count orders per year.
