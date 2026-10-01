# SQL Practice Datasets

Realistic sample data for practicing SQL joins, set operators, GROUP BY, filtering, date/text functions, data inspection/modification, advanced queries, and statistical analysis.

## Files & Schema

### 1. departments.csv
- department_id (PK)
- department_name
- location
- budget

### 2. employees.csv (120 rows)
- employee_id (PK)
- first_name, last_name, email, phone
- hire_date (YYYY-MM-DD)
- job_title
- department_id (FK → departments)
- manager_id (FK → employees.employee_id, self-join)
- salary
- status (Active / On Leave / Terminated)

### 3. customers.csv (200 rows)
- customer_id (PK)
- first_name, last_name, email, phone
- city, state
- signup_date
- customer_segment (Bronze/Silver/Gold/Platinum)
- is_active

### 4. archived_customers.csv (40 rows)
- Same structure as customers (for UNION / EXCEPT / INTERSECT practice)

### 5. categories.csv
- category_id (PK)
- category_name
- parent_category_id

### 6. products.csv (70 rows)
- product_id (PK)
- product_name
- category_id (FK → categories)
- unit_price, cost
- stock_quantity
- supplier
- is_discontinued

### 7. orders.csv (500 rows)
- order_id (PK)
- customer_id (FK → customers)
- order_date, ship_date
- status (Pending/Shipped/Delivered/Cancelled/Returned)
- shipping_cost
- payment_method

### 8. order_items.csv (~1490 rows)
- order_item_id (PK)
- order_id (FK → orders)
- product_id (FK → products)
- quantity
- unit_price
- discount (0 to 0.15)

### 9. projects.csv
- project_id (PK)
- project_name
- start_date, end_date
- budget
- status

### 10. employee_projects.csv
- employee_id (FK → employees)
- project_id (FK → projects)
- role
- hours_allocated, hours_worked

