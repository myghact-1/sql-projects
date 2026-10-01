-- 1.
SELECT
    *
FROM
    hr.employees;

-- 2
SELECT
    first_name,
    last_name,
    salary
FROM
    hr.employees;

-- 3
SELECT DISTINCT
    job_title
FROM
    hr.employees;

-- 4
SELECT
    *
FROM
    hr.employees
WHERE
    salary > 100000;

-- 5
SELECT
    first_name,
    last_name,
    salary
FROM
    hr.employees
WHERE
    salary > 60000
    AND salary < 90000;

-- 6
SELECT
    first_name,
    last_name,
    status
FROM
    hr.employees
WHERE
    status = 'Active';

-- 7
SELECT
    first_name,
    last_name,
    status
FROM
    hr.employees
WHERE
    status != 'Terminated';

-- 8
SELECT
    *
FROM
    hr.employees
WHERE
    hire_date > '2020-01-01';

-- 9
SELECT
    first_name,
    last_name,
    hire_date,
    EXTRACT(
        YEAR
        FROM
            hire_date
    ) AS YEAR
FROM
    hr.employees
WHERE
    EXTRACT(
        YEAR
        FROM
            hire_date
    ) = 2019;

-- 10
SELECT
    first_name
FROM
    hr.employees
WHERE
    first_name ILIKE 'J%';

-- 11
SELECT
    last_name
FROM
    hr.employees
WHERE
    last_name ILIKE '%son';

-- 12
SELECT
    first_name,
    email
FROM
    hr.employees
WHERE
    email ILIKE '%emp10%';

-- 13
SELECT
    first_name,
    phone
FROM
    hr.employees
WHERE
    phone IS NULL;

-- 14
SELECT
    first_name,
    last_name,
    job_title,
    manager_id
FROM
    hr.employees
WHERE
    manager_id IS NULL;

-- 15
SELECT
    first_name,
    last_name,
    department_id
FROM
    hr.employees
WHERE
    department_id IN (1, 2);

-- 16
SELECT
    first_name,
    last_name
FROM
    hr.employees
WHERE
    department_id IN (1, 3, 5);

-- 17
SELECT
    first_name,
    last_name
FROM
    hr.employees
WHERE
    department_id NOT IN (4, 6);

-- 18
SELECT
    first_name,
    last_name,
    job_title,
    salary
FROM
    hr.employees
ORDER BY
    salary DESC
FETCH FIRST
    10 ROWS
WITH
    ties;

-- 19
SELECT
    first_name,
    last_name,
    salary,
    status
FROM
    hr.employees
WHERE
    status = 'Active'
ORDER BY
    salary ASC
LIMIT
    5;

-- 20
SELECT
    first_name,
    last_name,
    salary
FROM
    hr.employees
WHERE
    salary > (
        SELECT
            AVG(salary)
        FROM
            hr.employees
    );

-- 21
SELECT DISTINCT
    city
FROM
    sales.customers;

-- 22
SELECT
    first_name,
    last_name
FROM
    sales.customers
WHERE
    state = 'CA';

-- 23
SELECT
    *
FROM
    sales.customers
WHERE
    customer_segment = 'Platinum';

-- 24
SELECT
    *
FROM
    sales.customers
WHERE
    is_active = FALSE;

-- OR
SELECT
    *
FROM
    sales.customers
WHERE
    NOT is_active;

-- 25
SELECT
    *
FROM
    sales.customers
WHERE
    signup_date > '2022-01-01';

-- 26
SELECT
    *
FROM
    inventory.products
WHERE
    stock_quantity < 20;

-- 27
SELECT
    *
FROM
    inventory.products
WHERE
    is_discontinued;

-- 28
SELECT
    *
FROM
    inventory.products
WHERE
    unit_price > 100;

-- 29
SELECT
    *
FROM
    inventory.products
WHERE
    supplier = 'SupplierA';

-- 30
SELECT
    *
FROM
    sales.orders
WHERE
    status = 'Delivered';

-- 31
SELECT
    *
FROM
    sales.orders
WHERE
    status = 'Pending'
    OR status = 'Cancelled';

-- 32
SELECT
    *
FROM
    sales.orders
WHERE
    order_date BETWEEN '2023-01-01' AND '2023-12-31';

-- 33
SELECT
    *
FROM
    sales.orders
WHERE
    shipping_cost = 0;

-- 34
SELECT
    *
FROM
    sales.orders
WHERE
    payment_method = 'PayPal';

-- 35
SELECT
    *
FROM
    sales.order_items
WHERE
    discount > 0.1;

-- 36
SELECT
    *
FROM
    sales.order_items
WHERE
    quantity >= 3;

-- 37
SELECT
    project_name,
    status
FROM
    hr.projects;

-- 38
SELECT
    project_name,
    budget
FROM
    hr.projects
WHERE
    budget > 150000;

-- 39
SELECT
    project_name,
    budget,
    status
FROM
    hr.projects
WHERE
    status = 'In Progress';

-- 40
SELECT
    first_name,
    last_name,
    job_title
FROM
    hr.employees
WHERE
    job_title ILIKE '%Engineer%'
    OR job_title ILIKE '%Analyst%';
