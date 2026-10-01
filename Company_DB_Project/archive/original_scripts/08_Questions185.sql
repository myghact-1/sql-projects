-- 166
SELECT
    *,
    'Customers' AS table_name
FROM
    sales.customers
UNION ALL
SELECT
    *,
    'Archived'
FROM
    sales.archived_customers;

-- 167
-- 168
SELECT
    *
FROM
    sales.customers
INTERSECT
SELECT
    *
FROM
    sales.archived_customers;

-- 169
SELECT
    *
FROM
    sales.customers
EXCEPT
SELECT
    *
FROM
    sales.archived_customers;

-- 170
SELECT
    *
FROM
    sales.archived_customers
EXCEPT
SELECT
    *
FROM
    sales.customers;

-- 171
SELECT
    CONCAT_WS(' ', first_name, last_name) AS people
FROM
    sales.customers
UNION ALL
SELECT
    CONCAT_WS(' ', first_name, last_name) AS people
FROM
    hr.employees;

-- 172
SELECT
    CONCAT_WS(' ', first_name, last_name) AS people
FROM
    sales.customers
INTERSECT
SELECT
    CONCAT_WS(' ', first_name, last_name) AS people
FROM
    hr.employees;

-- 173
SELECT
    job_title
FROM
    hr.employees
INTERSECT
SELECT
    role AS job_title
FROM
    hr.employee_projects;

-- 174