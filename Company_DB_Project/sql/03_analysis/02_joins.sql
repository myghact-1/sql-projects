-- ================================================================
-- 02 — JOINs
-- Questions 41–90
-- PostgreSQL practice solutions from the Company DB project.
-- ================================================================
-- Question 41: List employee full name and their department name.
SELECT
    e.first_name || ' ' || e.last_name AS full_name,
    d.department_name
FROM
    hr.employees AS e
    LEFT JOIN hr.departments AS d ON e.department_id = d.department_id;

-- Question 42: List employee name, department name and location.
SELECT
    e.first_name,
    e.last_name,
    d.department_name,
    d.location
FROM
    hr.employees AS e
    LEFT JOIN hr.departments AS d ON e.department_id = d.department_id;

-- Question 43: List all departments and the employees in them (include departments with no employees).
SELECT
    d.department_name,
    e.first_name || ' ' || e.last_name AS full_name
FROM
    hr.departments AS d
    LEFT JOIN hr.employees AS e ON d.department_id = e.department_id;

-- Question 44: List all employees and their department (include employees with no department if any).
SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM
    hr.employees AS e
    LEFT JOIN hr.departments AS d ON e.department_id = d.department_id;

-- Question 45: Find employees who work in 'Engineering'.
SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM
    hr.employees AS e
    LEFT JOIN hr.departments AS d ON e.department_id = d.department_id
WHERE
    d.department_name ILIKE '%Engineering';

-- Question 46: Find employees who work in 'Sales' or 'Marketing'.
SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM
    hr.employees AS e
    LEFT JOIN hr.departments AS d ON e.department_id = d.department_id
WHERE
    d.department_name IN ('Sales', 'Marketing');

-- Question 47: List each employee with their manager’s full name (self-join).
SELECT
    e.first_name,
    e.last_name,
    m.first_name || ' ' || m.last_name AS manager_name
FROM
    hr.employees AS e
    JOIN hr.employees AS m ON e.manager_id = m.employee_id;

-- Question 48: List employees who have no manager.
SELECT
    first_name,
    last_name
FROM
    hr.employees AS e
WHERE
    e.manager_id IS NULL;

-- Question 49: List managers and how many people report directly to them.
SELECT
    m.employee_id AS manager_id,
    m.first_name || ' ' || m.last_name AS manager_name,
    COUNT(*) AS total_employees
FROM
    hr.employees AS e
    INNER JOIN hr.employees AS m ON e.manager_id = m.employee_id
GROUP BY
    m.employee_id,
    m.first_name,
    m.last_name
ORDER BY
    total_employees DESC;

-- Question 50: Find the manager of employee_id 1010.
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    m.first_name || ' ' || m.last_name AS manager_name
FROM
    hr.employees AS e
    INNER JOIN hr.employees AS m ON e.manager_id = m.employee_id
WHERE
    e.employee_id = 1010;

-- Question 51: List orders with customer first_name and last_name.
SELECT
    c.first_name,
    c.last_name,
    o.order_id
FROM
    sales.orders AS o
    LEFT JOIN sales.customers AS c ON o.customer_id = c.customer_id;

-- Question 52: List orders with customer name and city.
SELECT
    c.first_name,
    c.last_name,
    c.city,
    o.order_id
FROM
    sales.orders AS o
    LEFT JOIN sales.customers AS c ON o.customer_id = c.customer_id;

-- Question 53: List all customers and their orders (include customers with no orders).
SELECT
    c.first_name,
    c.last_name,
    o.order_id
FROM
    sales.customers AS c
    LEFT JOIN sales.orders AS o ON c.customer_id = o.customer_id;

-- Question 54: Find customers who have never placed an order.
SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM
    sales.customers AS c
    LEFT JOIN sales.orders AS o ON c.customer_id = o.customer_id
WHERE
    o.customer_id IS NULL;

-- or
SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    customer_id NOT IN (
        SELECT
            customer_id
        FROM
            sales.orders
    );

-- or
SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM
    sales.customers AS c
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            sales.orders AS o
        WHERE
            o.customer_id = c.customer_id
    );

-- or
SELECT
    c.customer_id,
    c.first_name,
    c.last_name
FROM
    sales.customers AS c
    LEFT JOIN sales.orders AS o ON c.customer_id = o.customer_id
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            sales.orders
        WHERE
            o.customer_id = c.customer_id
    );

-- Question 55: List order_id, product_name, quantity and unit_price.
SELECT
    o.order_id,
    p.product_name,
    oi.quantity,
    oi.unit_price
FROM
    sales.orders AS o
    LEFT JOIN sales.order_items AS oi ON o.order_id = oi.order_id
    LEFT JOIN inventory.products AS p ON oi.product_id = p.product_id;

-- Question 56: List complete order details: customer name, order_date, product_name, quantity, line total.
SELECT
    c.first_name || ' ' || c.last_name AS customer_name,
    o.order_date,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price * (1 - oi.discount) AS total_price
FROM
    sales.orders AS o
    INNER JOIN sales.customers AS c ON o.customer_id = c.customer_id
    INNER JOIN sales.order_items AS oi ON o.order_id = oi.order_id
    INNER JOIN inventory.products AS p ON oi.product_id = p.product_id;

-- Question 57: Calculate line total (quantity * unit_price * (1 - discount)) for every order item.
SELECT
    oi.order_id,
    oi.unit_price * oi.quantity * (1 - oi.discount) AS line_total
FROM
    sales.order_items AS oi;

-- Question 58: List products with their category name.
SELECT
    p.product_name,
    cat.category_name
FROM
    inventory.products AS p
    LEFT JOIN inventory.categories AS cat ON p.category_id = cat.category_id;

-- Question 59: Find all products in the 'Electronics' category.
SELECT
    p.product_name,
    cat.category_name
FROM
    inventory.products AS p
    LEFT JOIN inventory.categories AS cat ON p.category_id = cat.category_id
WHERE
    cat.category_name = 'Electronics';

-- Question 60: List orders that contain at least one product from 'Clothing'.
SELECT DISTINCT
    o.order_id,
    o.order_date,
    p.product_name
FROM
    sales.orders AS o
    INNER JOIN sales.order_items AS oi ON oi.order_id = o.order_id
    INNER JOIN inventory.products AS p ON p.product_id = oi.product_id
    INNER JOIN inventory.categories AS cat ON p.category_id = cat.category_id
WHERE
    cat.category_name = 'Clothing';

-- Question 61: List employees and the projects they are assigned to.
SELECT
    e.first_name,
    e.last_name,
    hp.project_name
FROM
    hr.employees AS e
    INNER JOIN hr.employee_projects AS ep ON e.employee_id = ep.employee_id
    INNER JOIN hr.projects AS hp ON ep.project_id = hp.project_id;

-- Question 62: List project name and the names of employees working on it.
SELECT
    hp.project_name,
    e.first_name || ' ' || e.last_name AS employee_name
FROM
    hr.projects AS hp
    INNER JOIN hr.employee_projects AS ep ON hp.project_id = ep.project_id
    INNER JOIN hr.employees AS e ON ep.employee_id = e.employee_id;

-- Question 63: Find employees who are not assigned to any project.
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.hire_date
FROM
    hr.employees AS e
WHERE
    e.employee_id NOT IN (
        SELECT
            employee_id
        FROM
            hr.employee_projects
    );

-- Question 64: Find projects that have no employees assigned.
SELECT
    hp.project_name,
    ep.employee_id
FROM
    hr.projects AS hp
    LEFT JOIN hr.employee_projects AS ep ON hp.project_id = ep.project_id
WHERE
    ep.employee_id IS NULL;

-- Question 65: List employee name, project name, role and hours_worked.
SELECT
    e.first_name || ' ' || e.last_name AS full_name,
    hp.project_name,
    ep.role,
    ep.hours_worked
FROM
    hr.employees AS e
    INNER JOIN hr.employee_projects AS ep ON e.employee_id = ep.employee_id
    INNER JOIN hr.projects AS hp ON ep.project_id = hp.project_id;

-- Question 66: Find employees who work as 'Lead' on any project.
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    hp.project_name
FROM
    hr.employees AS e
    INNER JOIN hr.employee_projects AS ep ON e.employee_id = ep.employee_id
    INNER JOIN hr.projects AS hp ON hp.project_id = ep.project_id
WHERE
    ep.role = 'Lead';

-- Question 67: Join employees → departments → and show department budget.
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name,
    d.budget
FROM
    hr.employees AS e
    INNER JOIN hr.departments AS d ON e.department_id = d.department_id;

-- Question 68: List customers, their total number of orders and total amount spent (join + later aggregate).
SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM((oi.unit_price * oi.quantity * (1 - oi.discount))) AS total_spent
FROM
    sales.customers AS c
    INNER JOIN sales.orders AS o ON c.customer_id = o.customer_id
    INNER JOIN sales.order_items AS oi ON o.order_id = oi.order_id
GROUP BY
    c.customer_id
ORDER BY
    total_spent DESC;

-- Question 69: Find the top 10 customers by number of orders.
SELECT
    c.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM
    sales.customers AS c
    INNER JOIN sales.orders AS o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id
ORDER BY
    total_orders DESC
FETCH FIRST
    10 ROWS
WITH
    ties;

-- Question 70: List every order item with product name, category name and customer name.
SELECT
    o.order_id,
    p.product_name,
    cat.category_name,
    c.first_name || ' ' || c.last_name AS customer_name
FROM
    sales.customers AS c
    RIGHT JOIN sales.orders AS o ON c.customer_id = o.customer_id
    INNER JOIN sales.order_items AS oi ON o.order_id = oi.order_id
    INNER JOIN inventory.products AS p ON oi.product_id = p.product_id
    INNER JOIN inventory.categories AS cat ON p.category_id = cat.category_id;

-- Question 71: Find orders shipped to customers in 'New York' or 'Los Angeles'.
SELECT
    o.order_id,
    o.order_date,
    c.city
FROM
    sales.orders AS o
    INNER JOIN sales.customers AS c ON o.customer_id = c.customer_id
WHERE
    c.city IN ('New York', 'Los Angeles');

-- Question 72: List employees in the same department as employee_id 1005.
SELECT
    e.employee_id,
    e.first_name,
    e.last_name
FROM
    hr.employees AS e
WHERE
    e.department_id IN (
        SELECT
            department_id
        FROM
            hr.employees
        WHERE
            employee_id = 1005
    );

-- Question 73: Find pairs of employees who share the same manager.
SELECT
    e.manager_id,
    STRING_AGG(e.first_name || ' ' || e.last_name, ', ') AS employee_list,
    COUNT(*) AS total
FROM
    hr.employees AS e
WHERE
    e.manager_id IS NOT NULL
GROUP BY
    e.manager_id;

-- Question 74: List products that have never been ordered.
SELECT
    hp.product_id,
    hp.product_name
FROM
    inventory.products AS hp
    LEFT JOIN sales.order_items AS oi ON hp.product_id = oi.product_id
WHERE
    oi.order_id IS NULL;

-- or
SELECT
    hp.product_id,
    hp.product_name
FROM
    inventory.products AS hp
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            sales.order_items AS oi
        WHERE
            oi.product_id = hp.product_id
    );

-- Question 75: List categories that have no products.
SELECT
    cat.category_id,
    cat.category_name
FROM
    inventory.categories AS cat
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            inventory.products AS p
        WHERE
            p.category_id = cat.category_id
    );

-- Question 76: Show employee name, manager name and department name in one result.
SELECT
    e.first_name || ' ' || e.last_name AS employee_name,
    m.first_name || ' ' || m.last_name AS manager_name,
    d.department_name
FROM
    hr.employees AS e
    INNER JOIN hr.employees AS m ON e.manager_id = m.employee_id
    INNER JOIN hr.departments AS d ON e.department_id = d.department_id
ORDER BY
    manager_name ASC;

-- Question 77: Find all 'Senior Engineer' employees and their department location.
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name
FROM
    hr.employees AS e
    INNER JOIN hr.departments AS d ON e.department_id = d.department_id
WHERE
    e.job_title = 'Senior Engineer';

-- Question 78: List orders placed by 'Gold' or 'Platinum' customers.
SELECT
    o.order_id,
    o.order_date,
    c.customer_segment
FROM
    sales.orders AS o
    INNER JOIN sales.customers AS c ON o.customer_id = c.customer_id
WHERE
    c.customer_segment IN ('Gold', 'Platinum');

-- Question 79: Find the products ordered by customer_id 5010.
SELECT
    o.order_id,
    p.product_name
FROM
    sales.customers AS c
    INNER JOIN sales.orders AS o ON c.customer_id = o.customer_id
    INNER JOIN sales.order_items AS oi ON o.order_id = oi.order_id
    INNER JOIN inventory.products AS p ON oi.product_id = p.product_id
WHERE
    c.customer_id = 5010;

-- Question 80: List the full hierarchy: department → employee → project.
SELECT
    d.department_name,
    e.first_name || ' ' || e.last_name AS employee_name,
    p.project_name
FROM
    hr.departments AS d
    LEFT JOIN hr.employees AS e ON e.department_id = d.department_id
    LEFT JOIN hr.employee_projects AS ep ON ep.employee_id = e.employee_id
    LEFT JOIN hr.projects AS p ON ep.project_id = p.project_id;

-- Question 81: Find employees who work on projects with budget > 200000.
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    p.project_name,
    p.budget
FROM
    hr.employees AS e
    INNER JOIN hr.employee_projects AS ep ON e.employee_id = ep.employee_id
    INNER JOIN hr.projects AS p ON ep.project_id = p.project_id
WHERE
    p.budget > 200000;

-- Question 82: List customers who ordered products from more than one category.
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT cat.category_id) AS num_category
FROM
    sales.customers AS c
    INNER JOIN sales.orders AS o ON c.customer_id = o.customer_id
    INNER JOIN sales.order_items AS oi ON o.order_id = oi.order_id
    INNER JOIN inventory.products AS p ON oi.product_id = p.product_id
    INNER JOIN inventory.categories AS cat ON p.category_id = cat.category_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING
    COUNT(DISTINCT cat.category_id) > 1;

-- Question 83: Find orders that include both an Electronics and a Clothing product.
SELECT
    o.order_id
FROM
    sales.orders AS o
    JOIN sales.order_items AS oi ON o.order_id = oi.order_id
    JOIN inventory.products AS p ON oi.product_id = p.product_id
    JOIN inventory.categories AS cat ON p.category_id = cat.category_id
WHERE
    cat.category_name IN ('Electronics', 'Clothing')
GROUP BY
    o.order_id
HAVING
    COUNT(DISTINCT cat.category_name) = 2;

-- Question 84: List employees and the total hours they have worked across all projects.
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    ep.hours_worked
FROM
    hr.employees AS e
    INNER JOIN hr.employee_projects AS ep ON e.employee_id = ep.employee_id;

-- Question 85: Find the project with the most employees assigned.
SELECT
    p.project_name,
    STRING_AGG(e.first_name || ' ' || e.last_name, ', ') AS employee_list,
    COUNT(*) AS total_employees
FROM
    hr.projects AS p
    LEFT JOIN hr.employee_projects AS ep ON p.project_id = ep.project_id
    LEFT JOIN hr.employees AS e ON ep.employee_id = e.employee_id
GROUP BY
    p.project_name
ORDER BY
    total_employees DESC
FETCH FIRST
    1 ROWS
WITH
    ties;

-- Question 86: List each department and the highest paid employee in it.
WITH
    cte_salary_rank AS (
        SELECT
            department_id,
            first_name,
            last_name,
            salary,
            RANK() OVER (
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
    csr.first_name,
    csr.last_name,
    csr.salary,
    csr.rnk
FROM
    hr.departments AS d
    LEFT JOIN cte_salary_rank AS csr ON d.department_id = csr.department_id
WHERE
    csr.rnk = 1;

-- Question 87: Find customers whose first order was in 2022.
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    MIN(o.order_date) AS first_order
FROM
    sales.customers AS c
    INNER JOIN sales.orders AS o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING
    EXTRACT(
        YEAR
        FROM
            MIN(o.order_date)::DATE
    ) = 2022;

-- Question 88: List products and how many times they have been ordered.
SELECT
    p.product_name,
    COUNT(DISTINCT oi.order_id) AS times_ordered
FROM
    inventory.products AS p
    LEFT JOIN sales.order_items AS oi ON p.product_id = oi.product_id
GROUP BY
    p.product_name;

-- Question 89: Find employees who manage other employees and also work on projects.
SELECT DISTINCT
    m.employee_id,
    m.first_name,
    m.last_name
FROM
    hr.employees AS e
    JOIN hr.employees AS m ON e.manager_id = m.employee_id
WHERE
    EXISTS (
        SELECT
            1
        FROM
            hr.employee_projects AS ep
        WHERE
            ep.employee_id = m.employee_id
    );

-- Question 90: Write a query that joins all major tables and returns a sales report row.
SELECT
    oi.order_item_id,
    o.order_date,
    o.ship_date,
    o.shipping_cost,
    oi.quantity,
    oi.unit_price,
    oi.discount,
    ROUND(
        oi.quantity * oi.unit_price * (1 - oi.discount),
        2
    ) AS sales_amount
FROM
    sales.orders AS o
    LEFT JOIN sales.order_items AS oi ON o.order_id = oi.order_id
    LEFT JOIN inventory.products AS p ON oi.product_id = p.product_id;