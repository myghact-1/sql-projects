-- ================================================================
-- 01 — Basic SELECT & Filtering
-- Questions 1–40
-- PostgreSQL practice solutions from the Company DB project.
-- ================================================================
-- Question 1: Select all columns from the employees table.
SELECT
    *
FROM
    hr.employees;

-- Question 2: Select only first_name, last_name and salary from employees.
SELECT
    first_name,
    last_name,
    salary
FROM
    hr.employees;

-- Question 3: List all unique job titles.
SELECT DISTINCT
    job_title
FROM
    hr.employees;

-- Question 4: Find all employees with salary greater than 100000.
SELECT
    *
FROM
    hr.employees
WHERE
    salary > 100000;

-- Question 5: Find employees with salary between 60000 and 90000.
SELECT
    first_name,
    last_name,
    salary
FROM
    hr.employees
WHERE
    salary > 60000
    AND salary < 90000;

-- Question 6: Find employees whose status is 'Active'.
SELECT
    first_name,
    last_name,
    status
FROM
    hr.employees
WHERE
    status = 'Active';

-- Question 7: Find employees whose status is not 'Terminated'.
SELECT
    first_name,
    last_name,
    status
FROM
    hr.employees
WHERE
    status != 'Terminated';

-- Question 8: Find employees hired after '2020-01-01'.
SELECT
    *
FROM
    hr.employees
WHERE
    hire_date > '2020-01-01';

-- Question 9: Find employees hired in the year 2019.
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

-- Question 10: Find employees whose first name starts with 'J'.
SELECT
    first_name
FROM
    hr.employees
WHERE
    first_name ILIKE 'J%';

-- Question 11: Find employees whose last name ends with 'son'.
SELECT
    last_name
FROM
    hr.employees
WHERE
    last_name ILIKE '%son';

-- Question 12: Find employees whose email contains 'emp10'.
SELECT
    first_name,
    email
FROM
    hr.employees
WHERE
    email ILIKE '%emp10%';

-- Question 13: Find employees with NULL phone numbers.
SELECT
    first_name,
    phone
FROM
    hr.employees
WHERE
    phone IS NULL;

-- Question 14: Find employees who have no manager (manager_id IS NULL).
SELECT
    first_name,
    last_name,
    job_title,
    manager_id
FROM
    hr.employees
WHERE
    manager_id IS NULL;

-- Question 15: Find employees in department_id 1 or 2.
SELECT
    first_name,
    last_name,
    department_id
FROM
    hr.employees
WHERE
    department_id IN (1, 2);

-- Question 16: Find employees in departments 1, 3 and 5 using IN.
SELECT
    first_name,
    last_name
FROM
    hr.employees
WHERE
    department_id IN (1, 3, 5);

-- Question 17: Find employees not in departments 4 and 6.
SELECT
    first_name,
    last_name
FROM
    hr.employees
WHERE
    department_id NOT IN (4, 6);

-- Question 18: List the 10 highest paid employees.
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

-- Question 19: List the 5 lowest paid active employees.
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

-- Question 20: Find employees whose salary is higher than the average salary (use subquery later if needed).
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

-- Question 21: Select distinct cities from customers.
SELECT DISTINCT
    city
FROM
    sales.customers;

-- Question 22: Find customers from the state 'CA'.
SELECT
    first_name,
    last_name
FROM
    sales.customers
WHERE
    state = 'CA';

-- Question 23: Find customers with customer_segment = 'Platinum'.
SELECT
    *
FROM
    sales.customers
WHERE
    customer_segment = 'Platinum';

-- Question 24: Find inactive customers (is_active = false).
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

-- Question 25: Find customers who signed up after '2022-01-01'.
SELECT
    *
FROM
    sales.customers
WHERE
    signup_date > '2022-01-01';

-- Question 26: Find products with stock_quantity less than 20.
SELECT
    *
FROM
    inventory.products
WHERE
    stock_quantity < 20;

-- Question 27: Find discontinued products.
SELECT
    *
FROM
    inventory.products
WHERE
    is_discontinued;

-- Question 28: Find products with unit_price > 100.
SELECT
    *
FROM
    inventory.products
WHERE
    unit_price > 100;

-- Question 29: Find products supplied by 'SupplierA'.
SELECT
    *
FROM
    inventory.products
WHERE
    supplier = 'SupplierA';

-- Question 30: Find orders with status 'Delivered'.
SELECT
    *
FROM
    sales.orders
WHERE
    status = 'Delivered';

-- Question 31: Find orders with status 'Pending' or 'Cancelled'.
SELECT
    *
FROM
    sales.orders
WHERE
    status = 'Pending'
    OR status = 'Cancelled';

-- Question 32: Find orders placed in 2023.
SELECT
    *
FROM
    sales.orders
WHERE
    order_date BETWEEN '2023-01-01' AND '2023-12-31';

-- Question 33: Find orders with shipping_cost = 0.
SELECT
    *
FROM
    sales.orders
WHERE
    shipping_cost = 0;

-- Question 34: Find orders paid by 'PayPal'.
SELECT
    *
FROM
    sales.orders
WHERE
    payment_method = 'PayPal';

-- Question 35: Find order items with discount greater than 0.1.
SELECT
    *
FROM
    sales.order_items
WHERE
    discount > 0.1;

-- Question 36: Find order items with quantity >= 3.
SELECT
    *
FROM
    sales.order_items
WHERE
    quantity >= 3;

-- Question 37: List all project names and their status.
SELECT
    project_name,
    status
FROM
    hr.projects;

-- Question 38: Find projects with budget over 150000.
SELECT
    project_name,
    budget
FROM
    hr.projects
WHERE
    budget > 150000;

-- Question 39: Find projects that are 'In Progress'.
SELECT
    project_name,
    budget,
    status
FROM
    hr.projects
WHERE
    status = 'In Progress';

-- Question 40: Find employees with job_title containing 'Engineer' or 'Analyst'.
SELECT
    first_name,
    last_name,
    job_title
FROM
    hr.employees
WHERE
    job_title ILIKE '%Engineer%'
    OR job_title ILIKE '%Analyst%';

-- ================================================================
-- SOURCE FILE CHECK
-- The following numbered solutions were not present in the supplied SQL files.
-- They are intentionally left as TODOs rather than invented.
-- ================================================================
-- TODO Question 1: Select all columns from the employees table.
