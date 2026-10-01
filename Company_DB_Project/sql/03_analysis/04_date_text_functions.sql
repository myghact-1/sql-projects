-- ================================================================
-- 04 — Date & Text Functions
-- Questions 131–165
-- PostgreSQL practice solutions from the Company DB project.
-- ================================================================
-- Question 131: Extract the year from hire_date for all employees.
SELECT
    hire_date,
    EXTRACT(
        YEAR
        FROM
            hire_date
    )
FROM
    hr.employees;

-- Question 132: Extract month and year from order_date.
SELECT
    hire_date,
    EXTRACT(
        YEAR
        FROM
            hire_date
    ) AS YEAR,
    EXTRACT(
        MONTH
        FROM
            hire_date
    ) AS MONTH
FROM
    hr.employees;

-- Question 133: Calculate the number of years each employee has been with the company (tenure).
SELECT
    employee_id,
    first_name || ' ' || last_name AS employee_name,
    hire_date,
    age (CURRENT_DATE, hire_date),
    EXTRACT(
        YEAR
        FROM
            age (CURRENT_DATE, hire_date)
    ) AS tenure
FROM
    hr.employees;

-- Question 134: Find employees with tenure greater than 5 years.
SELECT
    employee_id,
    first_name || ' ' || last_name AS employee_name,
    hire_date,
    EXTRACT(
        YEAR
        FROM
            age (CURRENT_DATE, hire_date)
    ) AS tenure
FROM
    hr.employees
WHERE
    EXTRACT(
        YEAR
        FROM
            age (CURRENT_DATE, hire_date)
    ) > 5;

-- Question 135: Calculate the number of days between order_date and ship_date (shipping delay).
SELECT
    order_id,
    order_date,
    ship_date,
    ship_date - order_date AS num_days
FROM
    sales.orders;

-- Question 136: Find orders that took more than 5 days to ship.
SELECT
    order_id,
    order_date,
    ship_date,
    ship_date - order_date AS num_days
FROM
    sales.orders
WHERE
    (ship_date - order_date) > 5;

-- Question 137: Find orders placed on a weekend (if your SQL supports it).
SELECT
    order_id,
    order_date,
    TO_CHAR(order_date, 'Dy') AS DAY
FROM
    sales.orders
WHERE
    TO_CHAR(order_date, 'Dy') IN ('Sun', 'Sat');

-- Question 138: Find employees hired in the last 3 years from today.
SELECT
    employee_id,
    first_name,
    last_name,
    hire_date,
    age (current_date, hire_date) AS duration
FROM
    hr.employees
WHERE
    EXTRACT(
        YEAR
        FROM
            age (current_date, hire_date)
    ) < 3;

-- OR
SELECT
    employee_id,
    first_name,
    last_name,
    hire_date,
    ROUND((current_date - hire_date) / 365.25, 1) AS duration
FROM
    hr.employees
WHERE
    ROUND((current_date - hire_date) / 365.25, 1) <= 3;

-- Question 139: Find customers who signed up in the same month and year.
SELECT
    customer_id,
    first_name,
    last_name,
    TO_CHAR(signup_date, 'YYYY-MM') AS year_month
FROM
    sales.customers;

-- Question 140: Format hire_date as 'DD-Mon-YYYY'.
SELECT
    hire_date,
    TO_CHAR(hire_date, 'DD-Mon-YYYY') AS new_format
FROM
    hr.employees;

-- Question 141: Concatenate first_name and last_name as full_name.
SELECT
    first_name,
    last_name,
    first_name || ' ' || last_name AS full_name
FROM
    hr.employees;

-- Question 142: Create email-style name: lower(first_name) || '.' || lower(last_name).
SELECT
    first_name,
    last_name,
    LOWER(first_name) || '.' || LOWER(last_name) AS full_name
FROM
    hr.employees;

-- Question 143: Convert all product names to uppercase.
SELECT
    UPPER(product_name)
FROM
    inventory.products;

-- Question 144: Convert all customer cities to lowercase.
SELECT
    LOWER(city)
FROM
    sales.customers;

-- Question 145: Find product names that contain the word 'Set'.
SELECT
    product_name
FROM
    inventory.products
WHERE
    product_name ILIKE '%set%';

-- Question 146: Find product names that start with 'Wireless' or 'Smart'.
SELECT
    product_name
FROM
    inventory.products
WHERE
    product_name ILIKE ANY (ARRAY['wireless%', 'smart%']);

-- Question 147: Find customers whose last name is longer than 8 characters.
SELECT
    first_name,
    last_name
FROM
    sales.customers
WHERE
    LENGTH(last_name) > 8;

-- Question 148: Trim any possible spaces from names (practice with TRIM).
-- Question 149: Extract the domain from email addresses (everything after @).
SELECT
    first_name,
    last_name,
    email,
    SPLIT_PART(email, '@', 2) AS domain_name
FROM
    sales.customers;

-- Question 150: Find employees whose phone number starts with '555'.
SELECT
    first_name,
    last_name,
    phone
FROM
    hr.employees
WHERE
    phone ILIKE '555%';

-- Question 151: Replace 'emp' with 'staff' in the email column (for display only).
SELECT
    email,
    REPLACE(email, 'emp', 'staff') AS new_email
FROM
    hr.employees;

-- Question 152: Find the length of every product_name.
SELECT
    product_name,
    LENGTH(product_name)
FROM
    inventory.products;

-- Question 153: Pad employee_id with leading zeros to 6 digits.
SELECT
    employee_id,
    LPAD(employee_id::TEXT, 6, '0')
FROM
    hr.employees;

-- Question 154: Find orders placed between two specific dates.
-- Question 155: Find the first and last order date for each customer.
SELECT
    c.customer_id,
    CONCAT_WS(' ', c.first_name, c.last_name) AS cust_name,
    MIN(o.order_date) AS first_order,
    MAX(o.order_date) AS recent_order
FROM
    sales.orders AS o
    LEFT JOIN sales.customers AS c ON o.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name;

-- Question 156: Calculate the age of each project in days (end_date - start_date).
SELECT
    project_name,
    age (end_date, start_date) AS project_age
FROM
    hr.projects;

-- Question 157: Find projects that lasted more than 200 days.
SELECT
    project_name,
    end_date - start_date AS project_age
FROM
    hr.projects
WHERE
    (end_date - start_date) > 200;

-- Question 158: Extract the quarter from order_date.
SELECT
    order_id,
    order_date,
    EXTRACT(
        quarter
        FROM
            order_date
    ) AS quarter
FROM
    sales.orders;

-- Question 159: Count orders per quarter.
SELECT
    TO_CHAR(order_date, 'YYYY') AS YEAR,
    TO_CHAR(order_date, 'Q') AS quarter,
    COUNT(*) AS total_orders
FROM
    sales.orders
GROUP BY
    TO_CHAR(order_date, 'YYYY'),
    TO_CHAR(order_date, 'Q')
ORDER BY
    YEAR,
    quarter;

-- Question 160: Find employees hired on the same day of the year (any year).
SELECT
    hire_date,
    STRING_AGG(CONCAT_WS(' ', first_name, last_name), ', '),
    COUNT(DISTINCT employee_id) AS total_employees
FROM
    hr.employees
GROUP BY
    hire_date
HAVING
    COUNT(DISTINCT employee_id) >= 2;

-- Question 161: Create a full address-like string from city and state.
SELECT
    customer_id,
    first_name,
    last_name,
    CONCAT_WS(', ', city, state) AS address
FROM
    sales.customers;

-- Question 162: Find customers with email ending in '.com'.
SELECT
    customer_id,
    first_name,
    last_name,
    email
FROM
    sales.customers
WHERE
    email ILIKE '%.com';

-- Question 163: Use CASE to classify salary into 'Low', 'Medium', 'High'.
SELECT
    employee_id,
    first_name,
    last_name,
    salary,
    CASE
        WHEN salary > 90000 THEN 'High'
        WHEN salary > 50000 THEN 'Medium'
        ELSE 'Low'
    END AS segment
FROM
    hr.employees;

-- Question 164: Use CASE to classify shipping delay into 'Fast', 'Normal', 'Slow'.
SELECT
    order_id,
    order_date,
    ship_date,
    ship_date - order_date AS delay_days,
    CASE
        WHEN (ship_date - order_date) > 5 THEN 'Slow'
        WHEN (ship_date - order_date) >= 3 THEN 'Normal'
        WHEN (ship_date - order_date) < 3 THEN 'Fast'
        ELSE NULL
    END AS shipping_segment
FROM
    sales.orders;

-- Question 165: Create a descriptive label for each order status using CASE.
SELECT
    *
FROM
    sales.orders;