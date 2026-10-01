
# Messy Retail Analytics — MySQL Portfolio Project

## Dataset
Synthetic, intentionally messy multi-table retail/e-commerce dataset.

Tables:
- customers.csv
- products.csv
- orders.csv
- order_items.csv
- payments.csv

The dataset contains roughly 58K+ records across the five tables (exact row counts are listed below).

## Why it is messy
This dataset intentionally contains real-world style problems:
- NULL / blank values
- inconsistent capitalization and whitespace
- multiple date formats
- inconsistent Yes/No/1/0 flags
- malformed emails and phone numbers
- duplicate customer records
- negative / suspicious stock values
- negative payment amounts
- inconsistent payment/order totals
- cancelled, returned, failed and pending transactions
- imperfect geographic spelling/casing
- discount anomalies
- incomplete transaction references

## Suggested project workflow

1. **Business understanding**
   - Define revenue, customer, product and payment KPIs.
   - Identify business questions before cleaning.

2. **Raw/Bronze layer**
   - Load CSVs without modifying source data.
   - Preserve original values.

3. **Data profiling**
   - Row counts
   - NULL percentages
   - duplicate checks
   - distinct values
   - invalid formats
   - outlier detection

4. **Data cleaning / Silver layer**
   - Standardize dates
   - Normalize text/case/whitespace
   - Validate emails/phones
   - Resolve duplicates
   - Standardize status/channel/payment fields
   - Handle missing values
   - Flag suspicious financial records
   - Validate relationships between tables

5. **Data modeling**
   - Build a star schema or reporting layer.
   - Fact: order_items / orders
   - Dimensions: customer, product, date, channel

6. **SQL analysis / Gold layer**
   Example questions:
   - Monthly revenue and order growth
   - Top 20 products by revenue
   - Repeat vs new customers
   - Customer lifetime value
   - Average order value
   - Revenue by city/state/channel
   - Cancellation and return rate
   - Payment success rate
   - Discount impact
   - Product margin
   - Customer cohort retention
   - RFM segmentation

7. **Power BI**
   Build:
   - Executive sales dashboard
   - Customer analytics page
   - Product performance page
   - Operations/payment quality page

## Row counts
- customers: 5,035 rows
- products: 1,000 rows
- orders: 14,000 rows
- order_items: 23,000 rows
- payments: 15,000 rows

## Important
This is synthetic data. It is designed for learning, SQL practice, data cleaning, ETL, dimensional modeling, EDA and dashboard work. It does not represent real people or real transactions.
