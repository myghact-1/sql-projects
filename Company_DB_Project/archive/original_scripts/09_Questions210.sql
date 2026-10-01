-- 186
SELECT
    COUNT(*)
FROM
    hr.employees
WHERE
    phone IS NULL;

-- 187
SELECT
    COUNT(*)
FROM
    hr.employees
WHERE
    manager_id IS NULL;

-- 188
SELECT
    COUNT(*)
FROM
    sales.customers
WHERE
    email IS NULL;

-- 189
SELECT
    COUNT(*)
FROM
    sales.orders
WHERE
    ship_date IS NULL;

-- 190
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

-- 191
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

-- 192
SELECT
    CONCAT_WS(' ', first_name, last_name),
    COUNT(*)
FROM
    hr.employees
GROUP BY
    CONCAT_WS(' ', first_name, last_name)
HAVING
    COUNT(*) > 1;

-- 193
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

-- 194
SELECT
    *
FROM
    inventory.products
WHERE
    cost >= unit_price;

-- 195
SELECT
    *
FROM
    sales.orders
WHERE
    order_date > ship_date;

-- 196
SELECT
    *
FROM
    sales.order_items
WHERE
    quantity <= 0;

-- 197
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

-- 198
SELECT DISTINCT
    status
FROM
    hr.employees;

-- 
SELECT DISTINCT
    status
FROM
    sales.orders;

-- 199
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

-- 200
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

-- 201
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

-- 202
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

-- 203
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

-- 204
SELECT
    COUNT(*)
FROM
    sales.customers
WHERE
    email IS NULL;

-- 205
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

-- 206
-- 207
SELECT
    *
FROM
    inventory.products
WHERE
    stock_quantity = 0
    AND is_discontinued = FALSE;

-- 208
SELECT
    *
FROM
    hr.employees
WHERE
    salary = 0
    OR salary IS NULL;

-- 209
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

-- 210
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