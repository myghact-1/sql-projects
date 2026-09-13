# 🏗️ End-to-End SQL Data Warehouse & Analytics Project

> A hands-on data warehousing project built as part of my journey toward
> becoming a strong Data Analyst / Analytics professional.

## 🙏 About This Project

This project is my hands-on implementation and learning journey based on
the excellent **SQL Data Warehouse Project by Baraa Khatib Salkini (Data
With Baraa)**.

Baraa's project provided the original educational framework, business
scenario, datasets, architecture, and step-by-step methodology. I
followed that guidance to understand not only **how to write SQL**, but
also **how a data professional thinks about raw data, data quality, ETL,
data modeling, and business analytics**.

**Full credit and appreciation go to Baraa / Data With Baraa for the
original project, teaching approach, datasets, and methodology.**

> This repository is a learning implementation based on Baraa's
> educational project. I do not claim ownership of the original project,
> datasets, or educational materials.

------------------------------------------------------------------------

## 🎯 Project Objectives

The goal of this project is to build an end-to-end data warehouse and
understand the complete journey from source data to business-ready
analytics.

-   Build a modern SQL data warehouse
-   Work with multiple source systems
-   Understand ETL processes
-   Load raw data into a Bronze layer
-   Clean and standardize data in the Silver layer
-   Build business-ready models in the Gold layer
-   Design fact and dimension tables
-   Implement a Star Schema
-   Perform data-quality checks
-   Write analytical SQL queries
-   Generate meaningful business insights

------------------------------------------------------------------------

## 🏛️ Data Architecture

The project follows the **Medallion Architecture**:

``` text
                 SOURCE SYSTEMS
                      │
             ┌────────┴────────┐
             │                 │
            CRM               ERP
             │                 │
             └────────┬────────┘
                      ▼
               🥉 BRONZE
              Raw Data Layer
                      │
                      ▼
               🥈 SILVER
          Cleaned & Standardized
                      │
                      ▼
                🥇 GOLD
          Business-Ready Data
                      │
                      ▼
              📊 ANALYTICS
```

### 🥉 Bronze Layer

Stores source data as close to the original format as possible.

Focus:

-   Data ingestion
-   Raw data preservation
-   Source-system traceability
-   Minimal transformation

### 🥈 Silver Layer

Transforms raw data into reliable, standardized data.

Focus:

-   Cleaning
-   Standardization
-   NULL handling
-   Data-type conversion
-   Date transformation
-   Duplicate detection
-   Data validation
-   Business rules

### 🥇 Gold Layer

Contains business-ready analytical models.

Focus:

-   Fact tables
-   Dimension tables
-   Star Schema
-   Business logic
-   Analytical views
-   Reporting-ready data

------------------------------------------------------------------------

## 🔄 ETL Workflow

``` text
Extract
   ↓
Load Raw Data
   ↓
Bronze Layer
   ↓
Profile & Validate
   ↓
Clean & Transform
   ↓
Silver Layer
   ↓
Integrate Sources
   ↓
Gold Layer
   ↓
Business Analytics
```

One of my biggest takeaways from this project is that SQL development in
real projects is much more than writing SELECT statements. The difficult
part is understanding the data, identifying problems, designing reliable
transformations, and making the final dataset useful.

------------------------------------------------------------------------

## 🧹 Data Quality

The project gave me practical experience with common real-world data
problems:

-   Missing values
-   Duplicate records
-   Invalid values
-   Inconsistent formats
-   Incorrect data types
-   Inconsistent naming
-   Unclean customer information
-   Product-data inconsistencies
-   Date-format problems
-   Referential integrity issues

The goal is not simply to make the data look clean. The goal is to make
the data **trustworthy enough for analysis and decision-making**.

------------------------------------------------------------------------

## ⭐ Data Modeling

The Gold layer uses dimensional modeling concepts.

### Dimension Tables

Examples:

-   `dim_customer`
-   `dim_product`

These tables provide descriptive information used to analyze business
activity.

### Fact Table

Example:

-   `fact_sales`

The fact table contains measurable business events such as sales,
quantity, price, and revenue.

Conceptually:

``` text
                  dim_customer
                       │
                       ▼
dim_product ─────► fact_sales ◄───── dim_date
                       │
                       ▼
                 Business Analysis
```

------------------------------------------------------------------------

## 📊 Business Analytics

After building the warehouse, the data can answer questions such as:

### Customer Analysis

-   Who are the most valuable customers?
-   Which customers generate the most revenue?
-   What are customer purchasing patterns?
-   How does customer behavior change over time?

### Product Analysis

-   Which products generate the most revenue?
-   Which categories perform best?
-   Which products are declining?
-   What are the top-selling products?

### Sales Analysis

-   What is total revenue?
-   How does revenue change over time?
-   What are monthly and yearly trends?
-   Which products contribute most to revenue?
-   Which customer segments contribute most to sales?

### Advanced SQL Analysis

-   Ranking
-   Running totals
-   Moving averages
-   Year-over-year comparison
-   Cumulative analysis
-   Customer segmentation
-   Product segmentation
-   Performance analysis

------------------------------------------------------------------------

## 🧠 What I Learned

### SQL

I practiced:

-   SELECT statements
-   JOINs
-   CASE expressions
-   Aggregations
-   GROUP BY
-   Subqueries
-   CTEs
-   Window functions
-   Date functions
-   String manipulation
-   Data-type conversions
-   Views
-   Stored procedures
-   Temporary tables
-   Data validation

### Data Engineering

I developed practical understanding of:

-   ETL
-   Data pipelines
-   Data warehouses
-   Medallion Architecture
-   Data integration
-   Data cleaning
-   Data quality
-   Dimensional modeling
-   Star Schemas
-   Fact and dimension tables

### Analytics

The project helped me understand the complete transformation:

``` text
Raw Data
   ↓
Business Questions
   ↓
Data Cleaning
   ↓
Transformation
   ↓
Metrics
   ↓
Analysis
   ↓
Business Insights
```

------------------------------------------------------------------------

## 💪 My Learning & Contribution

Although this project follows Baraa's original educational framework, I
treated it as a serious hands-on learning exercise.

I focused on understanding:

-   Why each architecture layer exists
-   Why specific transformations are required
-   How source systems are integrated
-   How data-quality issues affect analysis
-   Why dimensional modeling is useful
-   How analytical queries should be designed
-   How raw data eventually becomes a business insight

I also spent time experimenting, troubleshooting errors, improving SQL
scripts, documenting concepts, and understanding alternative approaches.

This project represents an important step in my transition from
**learning SQL syntax to thinking like a data professional**.

------------------------------------------------------------------------

## 🚀 Skills Demonstrated

  Area                Skills
  ------------------- ----------------------------------------------------------------
  SQL                 Joins, CTEs, window functions, aggregations, advanced querying
  Data Cleaning       Standardization, validation, transformation
  ETL                 Extract, Transform, Load
  Data Warehousing    Bronze, Silver, Gold architecture
  Data Modeling       Star Schema, facts and dimensions
  Data Quality        Validation and anomaly detection
  Analytics           Customer, product and sales analysis
  Documentation       Data catalog, architecture and project documentation
  Problem Solving     Debugging, troubleshooting and query improvement
  Business Thinking   Translating data into useful business questions

------------------------------------------------------------------------

## 🛠️ Technologies & Tools

-   SQL
-   SQL Server concepts
-   PostgreSQL adaptations / SQL concepts
-   Git & GitHub
-   Draw.io
-   Data modeling
-   ETL workflows

------------------------------------------------------------------------

## 📁 Project Structure

``` text
sql-data-warehouse-project/
│
├── datasets/
│   ├── crm/
│   └── erp/
│
├── docs/
│   ├── data_catalog.md
│   ├── data_architecture.drawio
│   ├── data_flow.drawio
│   ├── data_models.drawio
│   ├── etl.drawio
│   └── naming-conventions.md
│
├── scripts/
│   ├── bronze/
│   ├── silver/
│   └── gold/
│
├── tests/
│
├── README.md
└── LICENSE
```

------------------------------------------------------------------------

## 📌 Complete Project Workflow

``` text
1. Understand the Business Problem
          ↓
2. Understand the Source Data
          ↓
3. Design Data Architecture
          ↓
4. Create Bronze Layer
          ↓
5. Load Raw Data
          ↓
6. Perform Data Profiling
          ↓
7. Clean & Transform Data
          ↓
8. Build Silver Layer
          ↓
9. Integrate CRM + ERP
          ↓
10. Build Gold Layer
          ↓
11. Design Star Schema
          ↓
12. Validate Data
          ↓
13. Perform Exploratory Analysis
          ↓
14. Generate Business Insights
          ↓
15. Prepare for BI / Reporting
```

------------------------------------------------------------------------

# 🙏 Special Thanks --- Data With Baraa

A huge thank you to **Baraa Khatib Salkini, Data With Baraa**, for
creating such a practical and accessible project.

What I particularly value about Baraa's approach is that it teaches more
than isolated SQL commands. The project demonstrates how to think
through an entire data problem---from understanding raw source data and
dealing with data-quality issues to building a warehouse and producing
analytical insights.

The project gave me a strong practical foundation for understanding:

**SQL → ETL → Data Quality → Data Warehousing → Data Modeling →
Analytics**

I am genuinely grateful for the time, effort, and knowledge Baraa has
put into making practical data education accessible to learners.

**Original creator:** Baraa Khatib Salkini / Data With Baraa

------------------------------------------------------------------------

## 🔗 Original Resources

-   **Original GitHub Project:**\
    https://github.com/DataWithBaraa/sql-data-warehouse-project

-   **Data With Baraa:**\
    https://www.datawithbaraa.com/

-   **SQL Learning Resources:**\
    https://www.datawithbaraa.com/wiki/sql

------------------------------------------------------------------------

# 📚 What This Project Means to Me

This project is more than a collection of SQL scripts.

It represents a stage in my learning journey where I started connecting:

**SQL + Data Cleaning + ETL + Data Warehousing + Data Modeling +
Analytics + Business Thinking**

My goal is to become a data professional who can do more than write
queries.

I want to be able to:

> **Understand a business problem → investigate the data → build a
> reliable analytical foundation → analyze it → communicate meaningful
> insights.**

This project is one important step toward that goal.

------------------------------------------------------------------------

## 👤 About Me

I am building my skills in **SQL, Data Analytics, Data Warehousing, Data
Modeling, Power BI, Python, and related data technologies** through
hands-on projects.

My learning philosophy is:

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

Instead of learning only through theory, I am using real project-style
problems to develop practical problem-solving skills and build a
portfolio that demonstrates how I work with data from beginning to end.

I am particularly focused on developing the ability to connect
**technical skills with business thinking**---because good analytics is
not only about getting the correct SQL result; it is about understanding
what that result means and why the business should care.

------------------------------------------------------------------------

## ⭐ Final Note

If you are learning SQL or data analytics, I highly recommend studying
Baraa's original project and then attempting to rebuild it yourself.

One of the biggest lessons I took from this project is:

> **Don't just learn SQL. Learn how data moves, how data breaks, how
> data is cleaned, how data is modeled, and how data becomes useful to a
> business.**

**Built with curiosity, persistence, experimentation, and a lot of SQL.
🚀**
