/*
===============================================================================
08_TIME_ANALYSIS.SQL
Business goal: identify demand peaks and seasonality.
===============================================================================
*/

-- Q1. Busiest hours.
SELECT
    ride_hour,
    COUNT(*) AS total_rides
FROM trips_clean
GROUP BY ride_hour
ORDER BY total_rides DESC;

-- Q2. Hourly demand by rider type.
SELECT
    ride_hour,
    COUNT(*) FILTER (WHERE member_casual = 'member') AS member_rides,
    COUNT(*) FILTER (WHERE member_casual = 'casual') AS casual_rides,
    COUNT(*) AS total_rides
FROM trips_clean
GROUP BY ride_hour
ORDER BY ride_hour;

-- Q3. Busiest days of the week.
SELECT
    day_of_week,
    MIN(day_name) AS day_name,
    COUNT(*) AS total_rides
FROM trips_clean
GROUP BY day_of_week
ORDER BY total_rides DESC;

-- Q4. Weekday vs weekend demand by month.
SELECT
    ride_month,
    day_type,
    COUNT(*) AS rides
FROM trips_clean
GROUP BY ride_month, day_type
ORDER BY ride_month, day_type;

-- Q5. Average ride duration by hour.
SELECT
    ride_hour,
    COUNT(*) AS rides,
    ROUND(AVG(ride_duration_minutes), 2) AS avg_duration_minutes
FROM trips_clean
GROUP BY ride_hour
ORDER BY ride_hour;

-- Q6. Month-over-month growth.
WITH monthly AS (
    SELECT ride_month, COUNT(*) AS rides
    FROM trips_clean
    GROUP BY ride_month
)
SELECT
    ride_month,
    rides,
    LAG(rides) OVER (ORDER BY ride_month) AS previous_month,
    ROUND(
        100.0 * (rides - LAG(rides) OVER (ORDER BY ride_month))
        / NULLIF(LAG(rides) OVER (ORDER BY ride_month), 0),
        2
    ) AS mom_growth_pct
FROM monthly
ORDER BY ride_month;

-- Q7. Seven-day rolling average.
WITH daily AS (
    SELECT ride_date, COUNT(*) AS rides
    FROM trips_clean
    GROUP BY ride_date
)
SELECT
    ride_date,
    rides,
    ROUND(
        AVG(rides) OVER (
            ORDER BY ride_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS rolling_7_day_avg
FROM daily
ORDER BY ride_date;
