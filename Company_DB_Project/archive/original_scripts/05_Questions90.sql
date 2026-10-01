-- 41
SELECT
    e.first_name || ' ' || e.last_name AS full_name,
    d.department_name
FROM
    hr.employees AS e
    LEFT JOIN hr.departments AS d ON e.department_id = d.department_id;

-- 42
SELECT
    e.first_name,
    e.last_name,
    d.department_name,
    d.location
FROM
    hr.employees AS e
    LEFT JOIN hr.departments AS d ON e.department_id = d.department_id;

-- 43
SELECT
    d.department_name,
    e.first_name || ' ' || e.last_name AS full_name
FROM
    hr.departments AS d
    LEFT JOIN hr.employees AS e ON d.department_id = e.department_id;

-- 44
SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM
    hr.employees AS e
    LEFT JOIN hr.departments AS d ON e.department_id = d.department_id;

-- 45
SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM
    hr.employees AS e
    LEFT JOIN hr.departments AS d ON e.department_id = d.department_id
WHERE
    d.department_name ILIKE '%Engineering';

-- 46
SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM
    hr.employees AS e
    LEFT JOIN hr.departments AS d ON e.department_id = d.department_id
WHERE
    d.department_name IN ('Sales', 'Marketing');

-- 47
SELECT
    e.first_name,
    e.last_name,
    m.first_name || ' ' || m.last_name AS manager_name
FROM
    hr.employees AS e
    JOIN hr.employees AS m ON e.manager_id = m.employee_id;

-- 48
SELECT
    first_name,
    last_name
FROM
    hr.employees AS e
WHERE
    e.manager_id IS NULL;

-- 49
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

-- 50
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    m.first_name || ' ' || m.last_name AS manager_name
FROM
    hr.employees AS e
    INNER JOIN hr.employees AS m ON e.manager_id = m.employee_id
WHERE
    e.employee_id = 1010;

-- 51
SELECT
    c.first_name,
    c.last_name,
    o.order_id
FROM
    sales.orders AS o
    LEFT JOIN sales.customers AS c ON o.customer_id = c.customer_id;

-- 52
SELECT
    c.first_name,
    c.last_name,
    c.city,
    o.order_id
FROM
    sales.orders AS o
    LEFT JOIN sales.customers AS c ON o.customer_id = c.customer_id;

-- 53
SELECT
    c.first_name,
    c.last_name,
    o.order_id
FROM
    sales.customers AS c
    LEFT JOIN sales.orders AS o ON c.customer_id = o.customer_id;

-- 54
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

-- 55
SELECT
    o.order_id,
    p.product_name,
    oi.quantity,
    oi.unit_price
FROM
    sales.orders AS o
    LEFT JOIN sales.order_items AS oi ON o.order_id = oi.order_id
    LEFT JOIN inventory.products AS p ON oi.product_id = p.product_id;

-- 56
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

-- 57
SELECT
    oi.order_id,
    oi.unit_price * oi.quantity * (1 - oi.discount) AS line_total
FROM
    sales.order_items AS oi;

-- 58
SELECT
    p.product_name,
    cat.category_name
FROM
    inventory.products AS p
    LEFT JOIN inventory.categories AS cat ON p.category_id = cat.category_id;

-- 59
SELECT
    p.product_name,
    cat.category_name
FROM
    inventory.products AS p
    LEFT JOIN inventory.categories AS cat ON p.category_id = cat.category_id
WHERE
    cat.category_name = 'Electronics';

-- 60
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

-- 61
SELECT
    e.first_name,
    e.last_name,
    hp.project_name
FROM
    hr.employees AS e
    INNER JOIN hr.employee_projects AS ep ON e.employee_id = ep.employee_id
    INNER JOIN hr.projects AS hp ON ep.project_id = hp.project_id;

-- 62
SELECT
    hp.project_name,
    e.first_name || ' ' || e.last_name AS employee_name
FROM
    hr.projects AS hp
    INNER JOIN hr.employee_projects AS ep ON hp.project_id = ep.project_id
    INNER JOIN hr.employees AS e ON ep.employee_id = e.employee_id;

-- 63
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

-- 64
SELECT
    hp.project_name,
    ep.employee_id
FROM
    hr.projects AS hp
    LEFT JOIN hr.employee_projects AS ep ON hp.project_id = ep.project_id
WHERE
    ep.employee_id IS NULL;

-- 65
SELECT
    e.first_name || ' ' || e.last_name AS full_name,
    hp.project_name,
    ep.role,
    ep.hours_worked
FROM
    hr.employees AS e
    INNER JOIN hr.employee_projects AS ep ON e.employee_id = ep.employee_id
    INNER JOIN hr.projects AS hp ON ep.project_id = hp.project_id;

-- 66
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

-- 67
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name,
    d.budget
FROM
    hr.employees AS e
    INNER JOIN hr.departments AS d ON e.department_id = d.department_id;

-- 68
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

-- 69
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

-- 70
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

-- 71
SELECT
    o.order_id,
    o.order_date,
    c.city
FROM
    sales.orders AS o
    INNER JOIN sales.customers AS c ON o.customer_id = c.customer_id
WHERE
    c.city IN ('New York', 'Los Angeles');

-- 72
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

-- 73
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

-- 74
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

-- 75
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

-- 76
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

-- 77
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

-- 78
SELECT
    o.order_id,
    o.order_date,
    c.customer_segment
FROM
    sales.orders AS o
    INNER JOIN sales.customers AS c ON o.customer_id = c.customer_id
WHERE
    c.customer_segment IN ('Gold', 'Platinum');

-- 79
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

-- 80
SELECT
    d.department_name,
    e.first_name || ' ' || e.last_name AS employee_name,
    p.project_name
FROM
    hr.departments AS d
    LEFT JOIN hr.employees AS e ON e.department_id = d.department_id
    LEFT JOIN hr.employee_projects AS ep ON ep.employee_id = e.employee_id
    LEFT JOIN hr.projects AS p ON ep.project_id = p.project_id;

-- 81
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

-- 82
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

-- 83
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

-- 84
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    ep.hours_worked
FROM
    hr.employees AS e
    INNER JOIN hr.employee_projects AS ep ON e.employee_id = ep.employee_id;

-- 85
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

-- 86
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

-- 87
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

-- 88
SELECT
    p.product_name,
    COUNT(DISTINCT oi.order_id) AS times_ordered
FROM
    inventory.products AS p
    LEFT JOIN sales.order_items AS oi ON p.product_id = oi.product_id
GROUP BY
    p.product_name;

-- 89
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

-- 90
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