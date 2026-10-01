-- ================================================================
-- 06 — Data Inspection & Cleaning
-- Questions 186–210
-- PostgreSQL practice solutions from the Company DB project.
-- ================================================================
-- Question 186: Count how many employees have NULL phone.
SELECT
    COUNT(*)
FROM
    hr.employees
WHERE
    phone IS NULL;

-- Question 187: Count how many employees have NULL manager_id.
SELECT
    COUNT(*)
FROM
    hr.employees
WHERE
    manager_id IS NULL;

-- Question 188: Count how many customers have NULL email.
SELECT
    COUNT(*)
FROM
    sales.customers
WHERE
    email IS NULL;

-- Question 189: Count how many orders have NULL ship_date.
SELECT
    COUNT(*)
FROM
    sales.orders
WHERE
    ship_date IS NULL;

-- Question 190: Find all rows with any NULL values in employees.
SELECT
    *
FROM
    hr.employees
WHERE
    first_name IS NULL
    OR last_name IS NULL
    OR email IS NULL
    OR hire_date IS NULL
    OR job_title IS NULL
    OR department_id IS NULL
    OR manager_id IS NULL
    OR salary IS NULL
    OR status IS NULL;

-- Question 191: Check for duplicate emails in customers.
SELECT
    email,
    COUNT(*) AS email_count
FROM
    hr.employees
WHERE
    email IS NOT NULL
GROUP BY
    email
HAVING
    COUNT(*) > 1;

-- Question 192: Check for duplicate first_name + last_name combinations in employees.
SELECT
    CONCAT_WS(' ', first_name, last_name),
    COUNT(*)
FROM
    hr.employees
GROUP BY
    CONCAT_WS(' ', first_name, last_name)
HAVING
    COUNT(*) > 1;

-- Question 193: Find possible outlier salaries (very high or very low).
SELECT
    salary
FROM
    hr.employees
ORDER BY
    salary DESC
FETCH FIRST
    5 ROWS
WITH
    ties;

-- OR
SELECT
    salary
FROM
    hr.employees
ORDER BY
    salary ASC
FETCH FIRST
    5 ROWS
WITH
    ties;

-- Question 194: Find products where cost >= unit_price (data quality issue).
SELECT
    *
FROM
    inventory.products
WHERE
    cost >= unit_price;

-- Question 195: Find orders where ship_date < order_date (impossible).
SELECT
    *
FROM
    sales.orders
WHERE
    order_date > ship_date;

-- Question 196: Find order items with quantity = 0 or negative (if any).
SELECT
    *
FROM
    sales.order_items
WHERE
    quantity <= 0;

-- Question 197: Find customers with invalid-looking phone numbers.
SELECT
    customer_id,
    first_name,
    last_name,
    phone,
    LENGTH(TRANSLATE(phone, '-', '')) AS phone_length
FROM
    sales.customers
WHERE
    LENGTH(TRANSLATE(phone, '-', '')) > 10;

-- Question 198: List all distinct status values in employees and orders to check consistency.
SELECT DISTINCT
    status
FROM
    hr.employees;

-- 
SELECT DISTINCT
    status
FROM
    sales.orders;

-- Question 199: Find employees whose department_id does not exist in departments (orphans).
SELECT
    *
FROM
    hr.employees AS e
WHERE
    NOT EXISTS (
        SELECT
            1
        FROM
            hr.departments AS d
        WHERE
            d.department_id = e.department_id
    );

-- Question 200: Find order_items whose product_id does not exist in products.
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

-- Question 201: Find order_items whose order_id does not exist in orders.
SELECT
    *
FROM
    sales.order_items
WHERE
    order_id NOT IN (
        SELECT
            order_id
        FROM
            sales.orders
    );

-- Question 202: Check if any manager_id points to a non-existent employee.
SELECT
    *
FROM
    hr.employees
WHERE
    employee_id NOT IN (
        SELECT
            manager_id
        FROM
            hr.employees
    );

-- Question 203: Find customers with the same email as an employee.
SELECT
    *
FROM
    hr.employees
WHERE
    email IN (
        SELECT
            email
        FROM
            sales.customers
    );

-- Question 204: Summarize missing data percentage for key columns.
SELECT
    COUNT(*)
FROM
    sales.customers
WHERE
    email IS NULL;

-- Question 205: Find the most common city and state combinations.
SELECT
    city,
    state,
    COUNT(*) AS total
FROM
    sales.customers
GROUP BY
    city,
    state
ORDER BY
    total DESC;

-- Question 206: Detect possible inconsistent city/state pairs.
-- Question 207: Find products with stock_quantity = 0 that are not discontinued.
SELECT
    *
FROM
    inventory.products
WHERE
    stock_quantity = 0
    AND is_discontinued = FALSE;

-- Question 208: Find employees with salary = 0 or NULL.
SELECT
    *
FROM
    hr.employees
WHERE
    salary = 0
    OR salary IS NULL;

-- Question 209: List the top 5 most frequent last names.
SELECT
    last_name,
    COUNT(*) AS freq
FROM
    hr.employees
GROUP BY
    last_name
ORDER BY
    freq DESC
FETCH FIRST
    5 ROWS
WITH
    ties;

-- Question 210: Create a data quality report showing null counts per column for a table.
SELECT
    'customer_id' AS feature_name,
    COUNT(*) AS total_nulls
FROM
    sales.customers
WHERE
    customer_id IS NULL
UNION ALL
SELECT
    'first_name' AS feature_name,
    COUNT(*) AS total_nulls
FROM
    sales.customers
WHERE
    first_name IS NULL
UNION ALL
SELECT
    'last_name' AS feature_name,
    COUNT(*) AS total_nulls
FROM
    sales.customers
WHERE
    last_name IS NULL
UNION ALL
SELECT
    'email' AS feature_name,
    COUNT(*) AS total_nulls
FROM
    sales.customers
WHERE
    email IS NULL
UNION ALL
SELECT
    'phone' AS feature_name,
    COUNT(*) AS total_nulls
FROM
    sales.customers
WHERE
    phone IS NULL
UNION ALL
SELECT
    'city' AS feature_name,
    COUNT(*) AS total_nulls
FROM
    sales.customers
WHERE
    city IS NULL
UNION ALL
SELECT
    'state' AS feature_name,
    COUNT(*) AS total_nulls
FROM
    sales.customers
WHERE
    state IS NULL
UNION ALL
SELECT
    'signup_date' AS feature_name,
    COUNT(*) AS total_nulls
FROM
    sales.customers
WHERE
    signup_date IS NULL
UNION ALL
SELECT
    'customer_segment' AS feature_name,
    COUNT(*) AS total_nulls
FROM
    sales.customers
WHERE
    customer_segment IS NULL
UNION ALL
SELECT
    'is_active' AS feature_name,
    COUNT(*) AS total_nulls
FROM
    sales.customers
WHERE
    is_active IS NULL;