-- 131
SELECT
    hire_date,
    EXTRACT(
        YEAR
        FROM
            hire_date
    )
FROM
    hr.employees;

-- 132
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

-- 133
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

-- 134
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

-- 135
SELECT
    order_id,
    order_date,
    ship_date,
    ship_date - order_date AS num_days
FROM
    sales.orders;

-- 136
SELECT
    order_id,
    order_date,
    ship_date,
    ship_date - order_date AS num_days
FROM
    sales.orders
WHERE
    (ship_date - order_date) > 5;

-- 137
SELECT
    order_id,
    order_date,
    TO_CHAR(order_date, 'Dy') AS DAY
FROM
    sales.orders
WHERE
    TO_CHAR(order_date, 'Dy') IN ('Sun', 'Sat');

-- 138
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

-- 139
SELECT
    customer_id,
    first_name,
    last_name,
    TO_CHAR(signup_date, 'YYYY-MM') AS year_month
FROM
    sales.customers;

-- 140
SELECT
    hire_date,
    TO_CHAR(hire_date, 'DD-Mon-YYYY') AS new_format
FROM
    hr.employees;

-- 141
SELECT
    first_name,
    last_name,
    first_name || ' ' || last_name AS full_name
FROM
    hr.employees;

-- 142
SELECT
    first_name,
    last_name,
    LOWER(first_name) || '.' || LOWER(last_name) AS full_name
FROM
    hr.employees;

-- 143
SELECT
    UPPER(product_name)
FROM
    inventory.products;

-- 144
SELECT
    LOWER(city)
FROM
    sales.customers;

-- 145
SELECT
    product_name
FROM
    inventory.products
WHERE
    product_name ILIKE '%set%';

-- 146
SELECT
    product_name
FROM
    inventory.products
WHERE
    product_name ILIKE ANY (ARRAY['wireless%', 'smart%']);

-- 147
SELECT
    first_name,
    last_name
FROM
    sales.customers
WHERE
    LENGTH(last_name) > 8;

-- 148
-- 149
SELECT
    first_name,
    last_name,
    email,
    SPLIT_PART(email, '@', 2) AS domain_name
FROM
    sales.customers;

-- 150
SELECT
    first_name,
    last_name,
    phone
FROM
    hr.employees
WHERE
    phone ILIKE '555%';

-- 151
SELECT
    email,
    REPLACE(email, 'emp', 'staff') AS new_email
FROM
    hr.employees;

-- 152
SELECT
    product_name,
    LENGTH(product_name)
FROM
    inventory.products;

-- 153
SELECT
    employee_id,
    LPAD(employee_id::TEXT, 6, '0')
FROM
    hr.employees;

-- 154
-- 155
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

-- 156
SELECT
    project_name,
    age (end_date, start_date) AS project_age
FROM
    hr.projects;

-- 157
SELECT
    project_name,
    end_date - start_date AS project_age
FROM
    hr.projects
WHERE
    (end_date - start_date) > 200;

-- 158
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

-- 159
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

-- 160
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

-- 161
SELECT
    customer_id,
    first_name,
    last_name,
    CONCAT_WS(', ', city, state) AS address
FROM
    sales.customers;

-- 162
SELECT
    customer_id,
    first_name,
    last_name,
    email
FROM
    sales.customers
WHERE
    email ILIKE '%.com';

-- 163
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

-- 164
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

-- 165
SELECT
    *
FROM
    sales.orders;