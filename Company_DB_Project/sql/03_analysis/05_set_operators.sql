-- ================================================================
-- 05 — Set Operators
-- Questions 166–185
-- PostgreSQL practice solutions from the Company DB project.
-- ================================================================
-- Question 166: Use UNION to combine current customers and archived customers (all columns).
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

-- Question 167: Use UNION ALL and observe the difference in row count.
-- Question 168: Find customer_ids that exist in both customers and archived_customers (INTERSECT).
SELECT
    *
FROM
    sales.customers
INTERSECT
SELECT
    *
FROM
    sales.archived_customers;

-- Question 169: Find customer_ids that exist only in customers (EXCEPT / MINUS).
SELECT
    *
FROM
    sales.customers
EXCEPT
SELECT
    *
FROM
    sales.archived_customers;

-- Question 170: Find customer_ids that exist only in archived_customers.
SELECT
    *
FROM
    sales.archived_customers
EXCEPT
SELECT
    *
FROM
    sales.customers;

-- Question 171: Combine first_name + last_name from employees and customers into one list of people.
SELECT
    CONCAT_WS(' ', first_name, last_name) AS people
FROM
    sales.customers
UNION ALL
SELECT
    CONCAT_WS(' ', first_name, last_name) AS people
FROM
    hr.employees;

-- Question 172: Find names that appear in both employees and customers.
SELECT
    CONCAT_WS(' ', first_name, last_name) AS people
FROM
    sales.customers
INTERSECT
SELECT
    CONCAT_WS(' ', first_name, last_name) AS people
FROM
    hr.employees;

-- Question 173: Find job titles that are also used as project roles (if any overlap).
SELECT
    job_title
FROM
    hr.employees
INTERSECT
SELECT
    role AS job_title
FROM
    hr.employee_projects;

-- Question 174: List all unique cities from customers and locations from departments.
-- ================================================================
-- SOURCE FILE CHECK
-- The following numbered solutions were not present in the supplied SQL files.
-- They are intentionally left as TODOs rather than invented.
-- ================================================================
-- TODO Question 174: List all unique cities from customers and locations from departments.
-- TODO Question 175: Find department locations that are also customer cities.
-- TODO Question 176: Use UNION to create a single list of all “people” (employees + customers) with a type column.
-- TODO Question 177: Find products that have the same name pattern as project names (creative).
-- TODO Question 178: Combine active employees and active customers into one result set with a source label.
-- TODO Question 179: Find states that have both customers and a department location.
-- TODO Question 180: Create a set of all email addresses from employees and customers (UNION).
-- TODO Question 181: Find emails that appear in both tables (INTERSECT).
-- TODO Question 182: List all project statuses and order statuses in one column (UNION).
-- TODO Question 183: Find employees who are not in any project and customers who have no orders (combine with UNION).
-- TODO Question 184: Use EXCEPT to find departments that currently have zero employees.
-- TODO Question 185: Create a comprehensive “all parties” list: employees, customers, and archived customers.
