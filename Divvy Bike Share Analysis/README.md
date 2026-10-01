# 🚲 Divvy 2025 Bike-Share Operations Analytics

> **A PostgreSQL project analyzing 5.5M+ bike-share trips across all 12 months of 2025.**

---

## 📌 Project Overview

This project analyzes 2025 Divvy bike-share trip data to understand:

- How demand changes throughout the year
- How **members** and **casual riders** use the system differently
- When demand peaks during the day and week
- Which stations generate the most activity
- Which routes are most frequently used
- How demand changes month-over-month
- Where data-quality issues exist
- What operational patterns can be identified from trip behavior


---

## 🎯 Business Problem

A bike-share operator needs to understand how customers use its network so that it can better understand demand patterns, station activity, and rider behavior.

### Core business question

> **How can 2025 bike-share trip data be used to understand rider behavior, demand patterns, station activity, and operational trends?**

---

## 📊 Dataset

**Source:** Divvy System Data  
**Period:** January–December 2025  
**Geography:** Chicago, Illinois  
**Technology:** PostgreSQL

The dataset contains trip-level records including:

- Ride ID
- Bike type
- Start/end timestamps
- Start/end stations
- Start/end coordinates
- Rider type

---

## 📈 Dataset Summary

| Metric | Value |
|---|---:|
| Raw rides | 5,552,994 |
| Clean rides | 5,552,965 |
| Excluded records | 29 |
| Months | 12 |
| Rider types | Member / Casual |

### Data-quality findings

The raw data contains missing station information. These records were **not automatically deleted** because the trips themselves remain useful for time, rider, duration, and other analyses.

There were also **29 records where `ended_at <= started_at`**. These were excluded from the analytical table because they represent impossible/non-positive trip durations.

Long rides were retained and flagged with `is_over_24_hours` rather than automatically treating them as errors.

---

# 🗂️ Project Structure

```text
Divvy Bike Sharing Analysis/
│
├── README.md
│
├── data/
│   ├── raw/
│       └── 2025 monthly CSV files
│   
│   
│
├── sql/
│   ├── 01_database_setup.sql
│   ├── 02_data_import.sql
│   ├── 03_data_quality.sql
│   ├── 04_data_cleaning.sql
│   ├── 05_clean_table_validation.sql
│   ├── 06_exploratory_analysis.sql
│   ├── 07_rider_analysis.sql
│   ├── 08_time_analysis.sql
│   ├── 09_station_analysis.sql
│   ├── 10_route_analysis.sql
│   ├── 11_advanced_analysis.sql
│   └── 12_final_business_report.sql
│
└── analysis/
    └── findings.md
```

---

# 🧱 Database Architecture

The project follows a simple analytical pipeline:

```text
12 Monthly CSV Files
        │
        ▼
   trips_raw
        │
        │ Data Quality Checks
        ▼
   Data Cleaning
        │
        ▼
  trips_clean
        │
        ├───────────────┐
        ▼               ▼
 Exploratory       Advanced SQL
 Analysis               │
        │               │
        └───────┬───────┘
                ▼
       Final Business Report
```

### `trips_raw`

The untouched source table.

### `trips_clean`

The analytical table containing cleaned records plus reusable calculated dimensions.

---

# 🧹 Data Cleaning

The cleaning process intentionally separates **data validation** from **data transformation**.

### Excluded

Records where:

```text
ended_at <= started_at
```

These represent impossible/non-positive durations.

### Retained

- Records with missing station names
- Records with missing end coordinates
- Long rides

### Added analytical columns

```text
ride_duration_minutes
ride_date
ride_year
ride_month
ride_month_name
day_of_week
day_name
ride_hour
day_type
is_over_24_hours
```

This allows later analysis without repeatedly recalculating the same time dimensions.

---

# 🔍 Analysis Areas

## 1. Exploratory Analysis

Questions include:

- How many rides occurred each month?
- How does member/casual composition change?
- Which month had the highest demand?
- Which month had the lowest demand?
- What is the month-over-month growth?

---

## 2. Rider Behavior

Questions include:

- How do members and casual riders differ?
- Which rider type has longer rides?
- How does weekday/weekend behavior differ?
- Which bike types are used by each rider segment?

---

## 3. Time Analysis

Questions include:

- What are the busiest hours?
- Which days are busiest?
- How does demand differ between weekdays and weekends?
- What are the seasonal patterns?
- What does the 7-day rolling average look like?

---

## 4. Station Analysis

Questions include:

- Which stations have the highest start demand?
- Which stations have the highest destination demand?
- Which stations have the most overall activity?
- Which stations are more heavily used by members?
- Which stations are more heavily used by casual riders?

---

## 5. Route Analysis

Questions include:

- What are the most popular routes?
- Which routes are popular with casual riders?
- Which routes are popular with members?
- Which routes have the longest average duration?
- How frequently do riders return to the same station?


---

# 📋 Final Business Report


### Demand

- Total annual rides
- Monthly demand
- Peak months
- Peak hours
- Weekday/weekend patterns

### Customers

- Member vs casual share
- Average duration by rider type
- Weekend behavior
- Bike-type preferences

### Network

- Highest-demand stations
- Highest-demand routes
- Rider-type station differences

### Data Quality

- Raw record count
- Clean record count
- Excluded records
- Missing station information
- Long-ride observations




> **Bike-Share Operations Analytics — PostgreSQL**

### Problem

Understand customer behavior and network demand across 5.5M+ 2025 trips.

### Approach

1. Loaded 12 monthly files into PostgreSQL
2. Performed data-quality profiling
3. Created a clean analytical table
4. Analyzed rider behavior
5. Analyzed temporal demand
6. Analyzed station activity
7. Analyzed routes
8. Applied window functions and advanced SQL
9. Produced business-facing KPIs

### Deliverables

- PostgreSQL database
- SQL analysis scripts
- Data-quality documentation
- Final business report
- Optional dashboard

---

# 📌 Key Takeaway

This project demonstrates more than SQL syntax.

It demonstrates the complete analyst workflow:

```text
Raw Data
   ↓
Data Quality
   ↓
Cleaning
   ↓
Data Transformation
   ↓
Exploration
   ↓
Advanced Analysis
   ↓
Business Questions
   ↓
Insights
```
