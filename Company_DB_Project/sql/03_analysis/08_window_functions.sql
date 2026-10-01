-- ================================================================
-- 08 — Window Functions
-- Questions 246–275
-- PostgreSQL practice solutions from the Company DB project.
-- ================================================================
-- Question 246: Rank employees by salary within the whole company.
SELECT
    employee_id,
    first_name,
    last_name,
    salary,
    RANK() OVER (
        ORDER BY
            salary DESC
    ) AS salary_rank
FROM
    hr.employees;

-- Question 247: Rank employees by salary within each department (PARTITION BY).
SELECT
    employee_id,
    first_name,
    last_name,
    salary,
    RANK() OVER (
        PARTITION BY
            department_id
        ORDER BY
            salary DESC
    ) AS salary_rank
FROM
    hr.employees;

-- Question 248: Give a dense rank of employees by salary per department.
SELECT
    employee_id,
    first_name,
    last_name,
    salary,
    DENSE_RANK() OVER (
        PARTITION BY
            department_id
        ORDER BY
            salary DESC
    ) AS salary_rank
FROM
    hr.employees;

-- Question 249: Assign row numbers to employees ordered by hire_date.
SELECT
    employee_id,
    first_name,
    last_name,
    salary,
    hire_date,
    ROW_NUMBER() OVER (
        ORDER BY
            hire_date
    ) AS index_rnk
FROM
    hr.employees;

-- Question 250: Calculate the running total of salaries ordered by employee_id.
SELECT
    employee_id,
    first_name,
    last_name,
    salary,
    SUM(salary) OVER (
        ORDER BY
            employee_id
    ) AS cumulative_salary_sum
FROM
    hr.employees;

-- Question 251: Calculate the cumulative revenue by order_date.
WITH
    cte_line_total AS (
        SELECT
            o.order_date,
            SUM(
                ROUND(
                    oi.quantity * oi.unit_price * (1 - oi.discount),
                    2
                )
            ) AS line_total
        FROM
            sales.orders AS o
            LEFT JOIN sales.order_items AS oi ON o.order_id = oi.order_id
        GROUP BY
            o.order_date
    )
SELECT
    order_date,
    line_total,
    SUM(line_total) OVER (
        ORDER BY
            order_date
    ) AS cumulative_sum
FROM
    cte_line_total;

-- Question 252: Show each employee’s salary and the average salary of their department (using AVG() OVER).
SELECT
    employee_id,
    CONCAT_WS(' ', first_name, last_name) AS employee_name,
    salary,
    department_id,
    ROUND(
        AVG(salary) OVER (
            PARTITION BY
                department_id
        ),
        2
    ) AS dept_avg
FROM
    hr.employees;

-- Question 253: Show each employee’s salary and the difference from the department average.
WITH
    cte_dept_avg AS (
        SELECT
            employee_id,
            CONCAT_WS(' ', first_name, last_name) AS employee_name,
            salary,
            department_id,
            ROUND(
                AVG(salary) OVER (
                    PARTITION BY
                        department_id
                ),
                2
            ) AS dept_avg
        FROM
            hr.employees
    )
SELECT
    employee_id,
    employee_name,
    salary,
    dept_avg,
    salary - dept_avg AS deviation
FROM
    cte_dept_avg;

-- Question 254: Find the top 3 highest paid employees in each department (using RANK or ROW_NUMBER).
WITH
    cte_emp_rank AS (
        SELECT
            department_id,
            employee_id,
            first_name,
            last_name,
            salary,
            DENSE_RANK() OVER (
                PARTITION BY
                    department_id
                ORDER BY
                    salary DESC
            ) AS emp_rank
        FROM
            hr.employees
    )
SELECT
    *
FROM
    cte_emp_rank
WHERE
    emp_rank <= 3;

-- Question 255: Calculate the moving average of monthly revenue (3-month).
WITH
    cte_line_total AS (
        SELECT
            order_id,
            SUM(quantity * unit_price * (1 - discount)) AS line_total
        FROM
            sales.order_items
        GROUP BY
            order_id
    ),
    cte_order_total AS (
        SELECT
            TO_CHAR(o.order_date, 'yyyy-MM') AS order_month,
            SUM(lt.line_total) AS total
        FROM
            sales.orders AS o
            INNER JOIN cte_line_total AS lt ON o.order_id = lt.order_id
        GROUP BY
            TO_CHAR(o.order_date, 'yyyy-MM')
    )
SELECT
    order_month,
    total,
    ROUND(
        AVG(total) OVER (
            ORDER BY
                order_month ROWS BETWEEN 2 PRECEDING
                AND CURRENT ROW
        ),
        2
    ) AS moving_3_mth_avg
FROM
    cte_order_total;

-- Question 256: Show lag and lead salary for employees ordered by salary.
SELECT
    employee_id,
    first_name,
    last_name,
    salary,
    LEAD(salary) OVER (
        ORDER BY
            salary
    ),
    LAG(salary) OVER (
        ORDER BY
            salary
    )
FROM
    hr.employees;

-- Question 257: For each order, show the previous order date of the same customer (LAG).
SELECT
    order_id,
    customer_id,
    order_date,
    LAG(order_date) OVER (
        PARTITION BY
            customer_id
        ORDER BY
            order_date
    ) AS previous_order
FROM
    sales.orders;

-- Question 258: Calculate the time between consecutive orders for each customer.
SELECT
    order_id,
    customer_id,
    order_date,
    LAG(order_date) OVER (
        PARTITION BY
            customer_id
        ORDER BY
            order_date
    ) AS previous_order,
    order_date - LAG(order_date) OVER (
        PARTITION BY
            customer_id
        ORDER BY
            order_date
    ) AS time_between
FROM
    sales.orders;

-- Question 259: Rank products by revenue within each category.
WITH
    product_revenue AS (
        SELECT
            p.category_id,
            p.product_name,
            SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) total
        FROM
            sales.order_items AS oi
            INNER JOIN inventory.products AS p ON p.product_id = oi.product_id
        GROUP BY
            p.category_id,
            p.product_name
    )
SELECT
    cat.category_id,
    cat.category_name,
    pr.product_name,
    pr.total,
    RANK() OVER (
        PARTITION BY
            cat.category_id
        ORDER BY
            pr.total DESC
    ) AS rank
FROM
    inventory.categories AS cat
    LEFT JOIN product_revenue AS pr ON cat.category_id = pr.category_id;

-- Question 260: Show the percentage of total revenue that each product contributes.
WITH
    product_revenue AS (
        SELECT
            p.category_id,
            p.product_name,
            SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) total
        FROM
            sales.order_items AS oi
            INNER JOIN inventory.products AS p ON p.product_id = oi.product_id
        GROUP BY
            p.category_id,
            p.product_name
    )
SELECT
    cat.category_id,
    cat.category_name,
    pr.product_name,
    pr.total,
    SUM(total) OVER () AS total_revenue,
    ROUND(pr.total / SUM(total) OVER () * 100, 2) AS pct
FROM
    inventory.categories AS cat
    LEFT JOIN product_revenue AS pr ON cat.category_id = pr.category_id;

-- Question 261: Show the percentage of department salary expense that each employee represents.
SELECT
    department_id,
    employee_id,
    first_name,
    last_name,
    salary,
    SUM(salary) OVER (
        PARTITION BY
            department_id
    ) AS total_dept_salary,
    ROUND(
        salary / SUM(salary) OVER (
            PARTITION BY
                department_id
        ),
        2
    ) * 100 AS pct_dept_salary
FROM
    hr.employees;

-- Question 262: Divide employees into 4 salary quartiles (NTILE).
SELECT
    department_id,
    employee_id,
    first_name,
    last_name,
    salary,
    NTILE(4) OVER (
        ORDER BY
            salary DESC
    ) AS GROUP
FROM
    hr.employees;

-- Question 263: Divide customers into 5 groups by total spend.
WITH
    total_spend AS (
        SELECT
            order_id,
            SUM(quantity * unit_price * (1 - discount)) AS total
        FROM
            sales.order_items
        GROUP BY
            order_id
    ),
    cte_customer_spend AS (
        SELECT
            o.customer_id,
            SUM(ts.total) AS customer_spend
        FROM
            sales.orders AS o
            LEFT JOIN total_spend AS ts ON o.order_id = ts.order_id
        GROUP BY
            o.customer_id
    )
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ccs.customer_spend,
    NTILE(5) OVER (
        ORDER BY
            ccs.customer_spend DESC
    ) AS cust_grp
FROM
    sales.customers AS c
    INNER JOIN cte_customer_spend AS ccs ON c.customer_id = ccs.customer_id;

-- Question 264: For each employee, show the highest salary in their department (MAX OVER).
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    salary,
    department_id,
    MAX(salary) OVER (
        PARTITION BY
            department_id
    ) AS max_salary_in_dept
FROM
    hr.employees AS e;

-- Question 265: For each product, show the most expensive product in its category.
SELECT
    product_id,
    product_name,
    unit_price,
    category_id,
    MAX(unit_price) OVER (
        PARTITION BY
            category_id
    ) AS max_in_cat
FROM
    inventory.products;

-- Question 266: Calculate first_value and last_value of salary within department ordered by hire_date.
SELECT
    employee_id,
    first_name,
    last_name,
    salary,
    hire_date,
    department_id,
    FIRST_VALUE(salary) OVER (
        PARTITION BY
            department_id
        ORDER BY
            hire_date
    ),
    LAST_VALUE(salary) OVER (
        PARTITION BY
            department_id
        ORDER BY
            hire_date
    )
FROM
    hr.employees;

-- Question 267: Show the rank of each project by total hours_worked.
WITH
    cte_hours AS (
        SELECT
            p.project_id,
            p.project_name,
            SUM(ep.hours_worked) AS total_worked_hours
        FROM
            hr.projects AS p
            LEFT JOIN hr.employee_projects AS ep ON p.project_id = ep.project_id
        GROUP BY
            p.project_id,
            p.project_name
    )
SELECT
    project_id,
    project_name,
    total_worked_hours,
    RANK() OVER (
        ORDER BY
            total_worked_hours DESC
    )
FROM
    cte_hours;

-- Question 268: Calculate a running count of orders per customer ordered by order_date.
SELECT
    *,
    SUM(num_orders) OVER (
        PARTITION BY
            customer_id
        ORDER BY
            order_date
    )
FROM
    (
        SELECT
            order_date,
            customer_id,
            COUNT(*) AS num_orders
        FROM
            sales.orders
        GROUP BY
            order_date,
            customer_id
    );

-- Question 269: Find employees whose salary is in the top 10% of the company.
WITH
    cte_salary_group AS (
        SELECT
            employee_id,
            first_name,
            last_name,
            salary,
            NTILE(10) OVER (
                ORDER BY
                    salary DESC
            ) AS salary_group
        FROM
            hr.employees
    )
SELECT
    *
FROM
    cte_salary_group
WHERE
    salary_group = 1;

-- Question 270: Compare each month’s revenue to the previous month using LAG.
WITH
    cte_monthly_revenue AS (
        SELECT
            TO_CHAR(o.order_date, 'YYYY-MM') AS MONTH,
            SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS monthly_revenue
        FROM
            sales.orders AS o
            INNER JOIN sales.order_items AS oi ON oi.order_id = o.order_id
        GROUP BY
            TO_CHAR(o.order_date, 'YYYY-MM')
    )
SELECT
    MONTH,
    monthly_revenue,
    LAG(monthly_revenue) OVER (
        ORDER BY
            MONTH
    ) AS previous_month_revenue,
    ROUND(
        (
            monthly_revenue - LAG(monthly_revenue) OVER (
                ORDER BY
                    MONTH
            )
        ) / LAG(monthly_revenue) OVER (
            ORDER BY
                MONTH
        ) * 100,
        2
    ) AS pct_change_month
FROM
    cte_monthly_revenue;

-- Question 271: Show the difference in hours_worked vs hours_allocated for every assignment and rank them.
SELECT
    *,
    RANK() OVER (
        ORDER BY
            diff_allocated_worked DESC
    ) AS rank
FROM
    (
        SELECT
            project_id,
            SUM(hours_allocated) AS total_hours_allocated,
            SUM(hours_worked) AS total_hours_worked,
            SUM(hours_worked) - SUM(hours_allocated) AS diff_allocated_worked
        FROM
            hr.employee_projects
        GROUP BY
            project_id
    );

-- Question 272: Create a dense ranking of customers by number of orders and by total spend.
WITH
    cte_total_spend AS (
        SELECT
            order_id,
            SUM(quantity * unit_price * (1 - discount)) AS order_total
        FROM
            sales.order_items
        GROUP BY
            order_id
    ),
    cte_customer_spend AS (
        SELECT
            o.customer_id,
            SUM(ts.order_total) AS customer_spend,
            COUNT(o.order_id) AS num_orders
        FROM
            sales.orders AS o
            INNER JOIN cte_total_spend AS ts ON o.order_id = ts.order_id
        GROUP BY
            o.customer_id
    )
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    cs.customer_spend,
    cs.num_orders,
    DENSE_RANK() OVER (
        ORDER BY
            cs.customer_spend DESC
    ) AS customer_rank,
    DENSE_RANK() OVER (
        ORDER BY
            cs.num_orders DESC
    ) AS orders_rank
FROM
    cte_customer_spend AS cs
    INNER JOIN sales.customers AS c ON c.customer_id = cs.customer_id;

-- Question 273: For each order item, show the average unit_price of products in the same category.
SELECT
    oi.order_item_id,
    oi.unit_price,
    ROUND(
        AVG(oi.unit_price) OVER (
            PARTITION BY
                p.category_id
        ),
        2
    ) AS avg_price_in_cat
FROM
    sales.order_items AS oi
    LEFT JOIN inventory.products AS p ON oi.product_id = p.product_id;

-- Question 274: Calculate the cumulative distribution of salaries (CUME_DIST).
SELECT
    employee_id,
    first_name,
    last_name,
    salary,
    CUME_DIST() OVER (
        ORDER BY
            salary
    ) AS cume_dist
FROM
    hr.employees;

-- Question 275: Use WINDOW clause to define a reusable window for salary rankings.
SELECT
    employee_id,
    first_name,
    last_name,
    department_id,
    salary,
    RANK() OVER salary_window AS salary_rank,
    DENSE_RANK() OVER salary_window AS dense_salary_rank,
    ROW_NUMBER() OVER salary_window AS row_num
FROM
    hr.employees
WINDOW
    salary_window AS (
        PARTITION BY
            department_id
        ORDER BY
            salary DESC
    )
ORDER BY
    department_id,
    salary_rank;