# Company DB — PostgreSQL SQL Analytics Project

A practical PostgreSQL project built around a realistic company database and a **300-question SQL practice set**. The project covers SQL fundamentals through advanced analytical SQL, including joins, aggregations, CTEs, subqueries, window functions, data-quality checks, and statistical analysis.

This project is designed as a **portfolio-ready SQL practice project** rather than a collection of disconnected queries.

---

## Project Overview

The database represents three connected business areas:

- **HR** — employees, departments, projects, and employee project assignments
- **Sales** — customers, orders, and order items
- **Inventory** — products and product categories

The SQL work answers progressively harder business and analytical questions, moving from basic filtering to advanced PostgreSQL techniques.

### Main goals

1. Build a relational PostgreSQL database from CSV files.
2. Practice database design, schemas, primary keys, and foreign keys.
3. Explore and validate the data before analysis.
4. Solve 300 SQL practice questions.
5. Practice both technical SQL and business-oriented analysis.
6. Build a strong foundation for later **Power BI and DAX** projects.

---

## Database Architecture

```text
                         COMPANY_DB
                             |
          +------------------+------------------+
          |                  |                  |
         HR                SALES            INVENTORY
          |                  |                  |
   +------+------+     +-----+------+      +----+------+
   |      |      |     |     |      |      |           |
Departments Employees Projects Customers Orders    Categories
              |         |        |       |            |
              +---- Employee     |       +------      Products
                   Projects       |              
                                  +---- Order Items
```

### Schemas

| Schema | Purpose | Tables |
|---|---|---|
| `hr` | Workforce and projects | `departments`, `employees`, `projects`, `employee_projects` |
| `sales` | Customers and transactions | `customers`, `archived_customers`, `orders`, `order_items` |
| `inventory` | Product catalog | `categories`, `products` |

---

## Repository Structure

```text
Company_DB_Project/
│
├── README.md
│
├── data/
│   └── raw/
│       ├── archived_customers.csv
│       ├── categories.csv
│       ├── customers.csv
│       ├── departments.csv
│       ├── employee_projects.csv
│       ├── employees.csv
│       ├── order_items.csv
│       ├── orders.csv
│       ├── products.csv
│       └── projects.csv
│
├── docs/
│   ├── 300_SQL_Practice_Questions.md
│   └── data_dictionary.md
│
├── sql/
│   ├── 00_setup/
│   │   ├── 01_create_database.sql
│   │   └── 02_create_schemas_and_tables.sql
│   │
│   ├── 01_data_loading/
│   │   └── 01_load_csv_data.sql
│   │
│   ├── 02_data_validation/
│   │   └── 01_inspect_tables.sql
│   │
│   ├── 03_analysis/
│   │   ├── 01_basic_select_filtering.sql
│   │   ├── 02_joins.sql
│   │   ├── 03_group_by_aggregations.sql
│   │   ├── 04_date_text_functions.sql
│   │   ├── 05_set_operators.sql
│   │   ├── 06_data_inspection_cleaning.sql
│   │   ├── 07_subqueries_ctes.sql
│   │   ├── 08_window_functions.sql
│   │   └── 09_statistical_analysis.sql
│   │
│   └── 04_dml_practice/
│       └── 01_data_modification_practice.sql
│
└── archive/
    └── original_scripts/
        └── Original SQL files supplied before restructuring
```

---

# SQL Learning Sections

## 1. Basic SELECT & Filtering — Questions 1–40

Practice includes:

- `SELECT`
- `DISTINCT`
- `WHERE`
- comparison operators
- `BETWEEN`
- `IN` / `NOT IN`
- `LIKE`
- `NULL` handling
- `ORDER BY`
- `LIMIT` / `FETCH`
- basic subquery concepts

---

## 2. JOINs — Questions 41–90

Practice includes:

- `INNER JOIN`
- `LEFT JOIN`
- self joins
- multi-table joins
- customers and orders
- products and categories
- employees and departments
- employees and projects
- finding unmatched records
- hierarchical relationships

---

## 3. GROUP BY & Aggregations — Questions 91–130

Practice includes:

- `COUNT`
- `SUM`
- `AVG`
- `MIN` / `MAX`
- `GROUP BY`
- `HAVING`
- revenue calculations
- customer metrics
- employee metrics
- project metrics
- inventory metrics

---

## 4. Date & Text Functions — Questions 131–165

Practice includes:

- `EXTRACT`
- `DATE` arithmetic
- `TO_CHAR`
- tenure calculations
- shipping delays
- year/month/quarter analysis
- `CONCAT`
- `CONCAT_WS`
- `LOWER` / `UPPER`
- `TRIM`
- `LENGTH`
- `REPLACE`
- `CASE`

---

## 5. Set Operators — Questions 166–185

Practice includes:

- `UNION`
- `UNION ALL`
- `INTERSECT`
- `EXCEPT`
- comparing current and archived customers
- comparing people across tables

---

## 6. Data Inspection & Cleaning — Questions 186–210

Practice includes:

- duplicate detection
- `NULL` analysis
- invalid relationships
- orphan records
- zero/negative values
- data consistency checks
- basic data-quality reporting

---

## 7. Subqueries & CTEs — Questions 211–245

Practice includes:

- scalar subqueries
- correlated subqueries
- `EXISTS`
- `NOT EXISTS`
- CTEs
- multiple CTEs
- recursive CTE concepts
- above-average analysis
- multi-step business analysis

---

## 8. Window Functions — Questions 246–275

Practice includes:

- `ROW_NUMBER`
- `RANK`
- `DENSE_RANK`
- `LAG`
- `LEAD`
- `AVG() OVER`
- `SUM() OVER`
- running totals
- moving averages
- percentage contribution
- `NTILE`
- `CUME_DIST`
- reusable `WINDOW` clauses

---

## 9. Statistical Analysis — Questions 276–295

This section moves beyond ordinary SQL querying into analytical SQL.

Topics include:

- mean
- median
- minimum / maximum
- standard deviation
- variance
- percentiles
- IQR
- outlier detection
- distribution analysis
- year-over-year growth
- revenue contribution
- statistical summaries

PostgreSQL functions such as `STDDEV`, `VAR_SAMP`, and `PERCENTILE_CONT` are used where appropriate.

---

## 10. DML Practice — Questions 296–300

The final questions cover:

- `INSERT`
- `UPDATE`
- `DELETE`
- salary updates
- status changes
- filling missing values
- archiving old records

**Important:** Practice DML inside a transaction and use `ROLLBACK` while learning.

Example:

```sql
BEGIN;

-- Your UPDATE / INSERT / DELETE here

ROLLBACK;
```

Use `COMMIT` only after you have verified the result and intentionally want to keep the changes.

---

# How to Run the Project

## Prerequisites

- PostgreSQL
- `psql` or another PostgreSQL client such as pgAdmin
- Basic knowledge of SQL

---

## Step 1 — Create the database

Run:

```sql
CREATE DATABASE company_db;
```

Then connect to `company_db`.

---

## Step 2 — Create schemas and tables

Run:

```text
sql/00_setup/02_create_schemas_and_tables.sql
```

This creates:

```text
hr
sales
inventory
```

and all 10 project tables.

---

## Step 3 — Load the CSV files

The project uses PostgreSQL `\copy` so the CSV files are read from the local project folder rather than requiring the PostgreSQL server to have access to the folder.

Run:

```text
sql/01_data_loading/01_load_csv_data.sql
```

Run the command from the **project root** when using `psql`, so paths such as `data/raw/employees.csv` resolve correctly.

If you use pgAdmin's Query Tool, you can instead import the CSV files through pgAdmin or adapt the script to use server-side `COPY` with an absolute path.

---

## Step 4 — Validate the data

Run:

```text
sql/02_data_validation/01_inspect_tables.sql
```

This includes table previews and row-count checks.

---

## Step 5 — Start the SQL analysis

Work through the files in this order:

```text
01_basic_select_filtering.sql
02_joins.sql
03_group_by_aggregations.sql
04_date_text_functions.sql
05_set_operators.sql
06_data_inspection_cleaning.sql
07_subqueries_ctes.sql
08_window_functions.sql
09_statistical_analysis.sql
```

The questions are numbered so you can compare each query with the corresponding question in:

```text
docs/300_SQL_Practice_Questions.md
```

---

# Example Business Metrics

The project allows analysis such as:

- Employee headcount by department
- Average and total salary expense
- Highest-paid employees
- Manager reporting structures
- Employee project allocation
- Project hours worked
- Customer order frequency
- Customer revenue
- Average order value
- Product revenue
- Category revenue
- Shipping cost trends
- Order-status distribution
- Product stock levels
- Revenue growth
- Customer segment contribution
- Salary distribution and outliers

These questions make the project useful as preparation for real **Data Analyst SQL interviews and business analysis**.

---

# PostgreSQL Features Practiced

```text
SELECT / WHERE / ORDER BY
        ↓
JOINs
        ↓
GROUP BY / HAVING
        ↓
Date & Text Functions
        ↓
Set Operators
        ↓
Data Quality
        ↓
Subqueries / CTEs
        ↓
Window Functions
        ↓
Statistical SQL
        ↓
DML
```

---

# Portfolio Value

This project demonstrates more than the ability to write isolated SQL statements. It shows a progression from:

**database setup → data loading → validation → exploration → analysis → advanced SQL → statistical analysis**

For a Data Analyst portfolio, the most useful next step is to connect this project to a BI layer such as **Power BI** and build a small dashboard from the same database.

A possible next workflow is:

```text
PostgreSQL
    ↓
SQL Data Validation
    ↓
Analytical Queries
    ↓
Power BI Data Model
    ↓
DAX Measures
    ↓
Dashboard
    ↓
Business Insights
```

---

# Notes About the Supplied Practice Files

The original archive contains the full **300-question practice bank**. The supplied SQL solution files contain most of the analytical solutions, but a few numbered items were not present in the SQL files supplied for restructuring.

The restructured project deliberately **does not invent those missing solutions**. They are marked as `TODO` where applicable so the repository remains faithful to the original work.

The source files also contain a few numbering/labeling inconsistencies. For example, some queries are labeled with the previous question number even though the SQL matches the following question. I preserved the original SQL rather than silently changing its logic.

The explicitly absent solution items include:

- Question 105
- Questions 174–185
- Questions 290 and 293
- Questions 296–300 (DML practice)

The original files are preserved under:

```text
archive/original_scripts/
```

This makes it possible to compare the cleaned project structure with the original work.

---

# Learning Outcome

After completing this project, you should be comfortable with:

- relational database structure
- PostgreSQL schemas
- primary and foreign keys
- SQL filtering
- joins
- aggregations
- date and text functions
- set operations
- data-quality analysis
- subqueries
- CTEs
- window functions
- statistical SQL
- safe DML practices
- translating business questions into SQL

---

## Author

**SQL Practice & Analytics Project**

Built as a hands-on PostgreSQL learning and portfolio project.

---

## License

This project is intended for learning, practice, and portfolio use. The included sample data is synthetic/practice data.
