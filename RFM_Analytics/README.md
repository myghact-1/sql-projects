# 📊 E-Commerce Customer Analytics --- PostgreSQL

## 📌 Project Overview

This project is an end-to-end **PostgreSQL customer analytics project**
built around an online retail dataset.

The project takes raw transactional data and turns it into
analysis-ready information through a practical workflow:

**Raw Data → Data Cleaning → Customer Metrics → RFM Segmentation →
Cohort Analysis → Retention Insights**

The main objective is to understand **customer purchasing behavior,
customer value, and retention** using SQL.

------------------------------------------------------------------------

## 🎯 Business Objectives

This project focuses on answering practical business questions such as:

-   Which customers are most valuable?
-   How recently have customers purchased?
-   How frequently do customers purchase?
-   How much revenue does each customer generate?
-   Which customers are Champions, Loyal Customers, New Customers, At
    Risk, or Lost?
-   How well are different customer cohorts retained?
-   How does customer activity change after the first purchase?
-   Which customer segments contribute the most revenue?

------------------------------------------------------------------------

## 🗂️ Dataset

The project uses an **Online Retail II** style transactional dataset.

The raw table contains:

  Column           Description
  ---------------- ------------------------------
  `invoice_no`     Invoice / transaction number
  `stock_code`     Product / stock identifier
  `description`    Product description
  `quantity`       Quantity purchased
  `invoice_date`   Transaction date and time
  `unit_price`     Price per unit
  `customer_id`    Customer identifier
  `country`        Customer country

The database schema stores these fields in a PostgreSQL `raw_retail`
table. fileciteturn0file0L5-L13

------------------------------------------------------------------------

# 🏗️ Project Architecture

``` text
                    RAW CSV DATA
                         │
                         ▼
                 ┌──────────────┐
                 │ raw_retail   │
                 │ Bronze/Raw   │
                 └──────┬───────┘
                        │
                        ▼
                DATA CLEANING
                        │
                        ▼
              ┌─────────────────┐
              │ v_clean_retail  │
              │ Cleaned View    │
              └────────┬────────┘
                       │
             ┌─────────┴──────────┐
             ▼                    ▼
       RFM ANALYSIS          COHORT ANALYSIS
             │                    │
             ▼                    ▼
     Customer Segments       Retention Matrix
             │                    │
             └─────────┬──────────┘
                       ▼
                BUSINESS INSIGHTS
```

------------------------------------------------------------------------

# 🛠️ Technology

-   **PostgreSQL**
-   SQL
-   CTEs
-   Window Functions
-   Views
-   Aggregations
-   Date/Time Functions
-   Customer Segmentation
-   Cohort Analysis

------------------------------------------------------------------------

# 📁 Project Files

``` text
├── 01_Schema.sql
├── 02_Data_Cleaning.sql
├── 03_RFM_Segmentation.sql
├── 04_Cohort_Retention.sql
└── README.md
```

### `01_Schema.sql`

Creates the database and `raw_retail` table and prepares the CSV loading
process. It also creates indexes on `customer_id` and `invoice_date` for
query optimization. fileciteturn0file0L1-L4
fileciteturn0file0L16-L35

### `02_Data_Cleaning.sql`

Creates the `v_clean_retail` view.

The cleaning logic:

-   Trims product descriptions
-   Removes records without a customer ID
-   Removes blank customer IDs
-   Keeps only positive quantities
-   Keeps only positive unit prices
-   Calculates `total_amount = quantity × unit_price`

This produces a cleaner analytical dataset from the raw table.
fileciteturn0file1L1-L18

### `03_RFM_Segmentation.sql`

Calculates customer-level:

-   **Recency**
-   **Frequency**
-   **Monetary value**

The script uses `NTILE(5)` to create RFM scores and then assigns
customers to business segments. fileciteturn0file2L2-L15
fileciteturn0file2L17-L35

The segmentation includes:

  -----------------------------------------------------------------------
  Segment                             Meaning
  ----------------------------------- -----------------------------------
  `Champions`                         High recency score, frequency, and
                                      monetary value

  `Loyal Customers`                   Strong frequency and monetary value

  `New Customers`                     Recent customers with lower
                                      frequency

  `At Risk / Churning`                Less recent customers with
                                      relatively strong frequency

  `Lost Customers`                    Low recency and frequency scores

  `Potential Loyalists`               Customers who do not fit the
                                      previous categories
  -----------------------------------------------------------------------

These segment rules are implemented directly in the SQL CASE expression.
fileciteturn0file2L38-L60

The final output provides:

-   Customer count
-   Customer share %
-   Total revenue
-   Revenue share %
-   Average monetary value per customer
-   Average days since last order fileciteturn0file2L64-L84

### `04_Cohort_Retention.sql`

Builds a customer cohort-retention analysis.

The process:

1.  Finds each customer's first purchase month.
2.  Assigns that month as the customer's cohort.
3.  Calculates the number of months since the cohort's first purchase.
4.  Counts active customers in each cohort/month.
5.  Calculates the retention rate.

The cohort is based on the month of the customer's minimum invoice date.
fileciteturn0file3L2-L9

The final retention analysis reports:

-   Cohort month
-   Initial cohort size
-   Month number
-   Active customers
-   Retention rate %

and currently limits the output to the first six months.
fileciteturn0file3L44-L57

------------------------------------------------------------------------

# 🧹 Data Cleaning

Data cleaning is performed before customer analytics.

The cleaned view removes:

``` text
Customer ID is NULL
        OR
Customer ID is blank
        OR
Quantity <= 0
        OR
Unit Price <= 0
```

It also standardizes the product description with `TRIM()` and creates a
calculated sales measure:

``` sql
quantity * unit_price
```

The result is stored as `total_amount`. fileciteturn0file1L1-L18

This step demonstrates an important analytical principle:

> **Good analysis starts with reliable data.**

------------------------------------------------------------------------

# 👥 RFM Customer Segmentation

RFM stands for:

### Recency

**How recently did the customer purchase?**

Lower days since the last purchase indicates a more recent customer.

### Frequency

**How often does the customer purchase?**

Measured as the number of distinct invoices.

### Monetary

**How much revenue did the customer generate?**

Measured as the sum of `total_amount`.

The project calculates all three measures at customer level.
fileciteturn0file2L2-L15

------------------------------------------------------------------------

## 📈 RFM Scoring

Each RFM dimension is divided into five groups using `NTILE(5)`.

The SQL intentionally orders recency in descending order because fewer
days since purchase should receive a better score, while frequency and
monetary value are ordered ascending before the NTILE scoring is
assigned. fileciteturn0file2L17-L35

``` text
RFM
 │
 ├── Recency
 │      └── R Score
 │
 ├── Frequency
 │      └── F Score
 │
 └── Monetary
        └── M Score
```

------------------------------------------------------------------------

# 🎯 Customer Segmentation

The project translates numerical RFM scores into business-friendly
customer groups.

``` text
                    CUSTOMERS
                        │
                        ▼
                    RFM SCORE
                        │
        ┌───────────────┼───────────────┐
        ▼               ▼               ▼
     Champions     Loyal Customers   New Customers
        │
        ├──────────────► Potential Loyalists
        │
        ├──────────────► At Risk / Churning
        │
        └──────────────► Lost Customers
```

The final executive summary ranks segments by total revenue.
fileciteturn0file2L64-L84

------------------------------------------------------------------------

# 🔄 Cohort & Retention Analysis

Cohort analysis groups customers according to the month in which they
made their **first purchase**.

For example:

``` text
Customer A → First Purchase: January
Customer B → First Purchase: January
Customer C → First Purchase: February
Customer D → First Purchase: February
```

This creates:

``` text
January Cohort
February Cohort
March Cohort
...
```

Customer activity is then measured relative to the customer's cohort
month. fileciteturn0file3L2-L22

------------------------------------------------------------------------

## 📊 Retention Calculation

For every cohort and month number, the project calculates active
customers and compares them with the original cohort size.

``` text
Retention Rate =
Active Customers / Initial Cohort Customers × 100
```

The SQL returns retention percentages and currently examines month `0`
through month `6`. fileciteturn0file3L24-L42
fileciteturn0file3L44-L57

------------------------------------------------------------------------

# 💡 Key Analytical Concepts Demonstrated

This project provides hands-on practice with:

### SQL Fundamentals

-   Database creation
-   Table creation
-   Data loading
-   Filtering
-   Aggregations
-   `GROUP BY`
-   `CASE`
-   `JOIN`

### Intermediate / Advanced SQL

-   CTEs
-   Window functions
-   `NTILE()`
-   `DATE_PART()`
-   `DATE_TRUNC()`
-   `TO_CHAR()`
-   Calculated metrics
-   Customer segmentation

### Performance

Indexes are created for:

``` text
customer_id
invoice_date
```

to support query optimization. fileciteturn0file0L32-L35

### Analytics

-   Customer value analysis
-   RFM segmentation
-   Cohort analysis
-   Retention analysis
-   Revenue contribution
-   Customer-share analysis

------------------------------------------------------------------------

# 🚀 Project Workflow

``` text
STEP 1
Create Database
      ↓
STEP 2
Create Raw Table
      ↓
STEP 3
Load CSV
      ↓
STEP 4
Create Indexes
      ↓
STEP 5
Clean Transaction Data
      ↓
STEP 6
Calculate Customer Metrics
      ↓
STEP 7
Perform RFM Segmentation
      ↓
STEP 8
Build Customer Cohorts
      ↓
STEP 9
Calculate Retention
      ↓
STEP 10
Generate Business Insights
```

------------------------------------------------------------------------

# 🧠 What I Learned

This project helped me move beyond basic SQL querying and practice
thinking about SQL as an **analytics tool**.

The most important learning areas were:

-   Designing a raw transactional table
-   Loading external CSV data into PostgreSQL
-   Cleaning transactional data
-   Creating reusable SQL views
-   Building customer-level metrics
-   Using window functions for segmentation
-   Turning quantitative scores into business segments
-   Understanding customer lifecycle behavior
-   Measuring retention through cohorts
-   Translating SQL results into business questions

------------------------------------------------------------------------

# 👤 About the Author

I am building my skills in **SQL, Data Analytics, Data Warehousing, Data
Modeling, Power BI, Python, and related data technologies** through
practical, project-based learning.

My approach is:

``` text
Learn
  ↓
Build
  ↓
Break
  ↓
Debug
  ↓
Understand
  ↓
Improve
```

Rather than stopping at syntax, I am focusing on understanding **why a
query is written, what business problem it solves, and how the result
can support decision-making**.

This project is part of my portfolio and represents my continued
development in practical data analysis.

------------------------------------------------------------------------

# 📚 Future Improvements

Potential next steps for expanding this project include:

-   Add a dedicated calendar/date dimension
-   Create additional customer KPIs
-   Analyze revenue by country
-   Analyze product performance
-   Investigate cancelled/returned transactions
-   Add customer lifetime value analysis
-   Create churn-risk analysis
-   Build RFM visualizations
-   Build cohort heatmaps
-   Connect the PostgreSQL results to Power BI
-   Create an executive customer analytics dashboard
-   Add automated data-quality tests
-   Improve the ETL pipeline

------------------------------------------------------------------------

# ⭐ Final Takeaway

This project demonstrates a complete analytical workflow:

> **Raw transactional data → Clean data → Customer metrics → RFM
> segmentation → Cohort analysis → Retention insights**

The key lesson is that effective data analysis is not just about writing
SQL.

It is about:

**understanding the data → cleaning the data → modeling the problem →
asking the right business questions → analyzing the results →
communicating insights.**

------------------------------------------------------------------------

## 📌 Project Status

**Status:** Completed core SQL analysis

**Primary focus:** Customer Analytics

**Database:** PostgreSQL

**Core techniques:** Data Cleaning · RFM Segmentation · Cohort Analysis
· Retention Analysis · Window Functions · CTEs
