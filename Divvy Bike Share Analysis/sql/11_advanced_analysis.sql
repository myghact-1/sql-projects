/*
===============================================================================
11_ADVANCED_ANALYSIS.SQL
Business goal: demonstrate PostgreSQL analytical SQL for a portfolio.
===============================================================================
*/

-- Q1. Rank stations within each month.
WITH monthly_station AS (
    SELECT
        ride_month,
        start_station_name,
        COUNT(*) AS rides
    FROM trips_clean
    WHERE start_station_name IS NOT NULL
    GROUP BY ride_month, start_station_name
)
SELECT
    ride_month,
    start_station_name,
    rides,
    RANK() OVER (
        PARTITION BY ride_month
        ORDER BY rides DESC
    ) AS monthly_station_rank
FROM monthly_station
ORDER BY ride_month, monthly_station_rank;

-- Q2. January-to-December station change.
WITH station_month AS (
    SELECT
        start_station_name,
        ride_month,
        COUNT(*) AS rides
    FROM trips_clean
    WHERE start_station_name IS NOT NULL
      AND ride_month IN (1, 12)
    GROUP BY start_station_name, ride_month
),
pivoted AS (
    SELECT
        start_station_name,
        MAX(rides) FILTER (WHERE ride_month = 1) AS january_rides,
        MAX(rides) FILTER (WHERE ride_month = 12) AS december_rides
    FROM station_month
    GROUP BY start_station_name
)
SELECT
    start_station_name,
    january_rides,
    december_rides,
    december_rides - january_rides AS absolute_change
FROM pivoted
WHERE january_rides IS NOT NULL
  AND december_rides IS NOT NULL
ORDER BY absolute_change DESC
LIMIT 20;

-- Q3. Top hours for each rider type.
WITH hourly AS (
    SELECT
        member_casual,
        ride_hour,
        COUNT(*) AS rides
    FROM trips_clean
    GROUP BY member_casual, ride_hour
)
SELECT
    member_casual,
    ride_hour,
    rides,
    RANK() OVER (
        PARTITION BY member_casual
        ORDER BY rides DESC
    ) AS hour_rank
FROM hourly
ORDER BY member_casual, hour_rank;

-- Q4. Monthly rider-type share using a window function.
WITH monthly AS (
    SELECT
        ride_month,
        member_casual,
        COUNT(*) AS rides
    FROM trips_clean
    GROUP BY ride_month, member_casual
)
SELECT
    ride_month,
    member_casual,
    rides,
    ROUND(
        100.0 * rides /
        SUM(rides) OVER (PARTITION BY ride_month),
        2
    ) AS monthly_share_pct
FROM monthly
ORDER BY ride_month, member_casual;

-- Q5. Top five stations for each rider type.
WITH station_rides AS (
    SELECT
        member_casual,
        start_station_name,
        COUNT(*) AS rides
    FROM trips_clean
    WHERE start_station_name IS NOT NULL
    GROUP BY member_casual, start_station_name
),
ranked AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            PARTITION BY member_casual
            ORDER BY rides DESC
        ) AS station_rank
    FROM station_rides
)
SELECT
    member_casual,
    station_rank,
    start_station_name,
    rides
FROM ranked
WHERE station_rank <= 5
ORDER BY member_casual, station_rank;

-- Q6. Identify daily demand outliers.
WITH daily AS (
    SELECT ride_date, COUNT(*) AS rides
    FROM trips_clean
    GROUP BY ride_date
),
stats AS (
    SELECT
        AVG(rides) AS avg_daily_rides,
        STDDEV_POP(rides) AS sd_daily_rides
    FROM daily
)
SELECT
    d.ride_date,
    d.rides,
    ROUND(s.avg_daily_rides, 2) AS avg_daily_rides,
    ROUND(
        (d.rides - s.avg_daily_rides)
        / NULLIF(s.sd_daily_rides, 0),
        2
    ) AS z_score
FROM daily d
CROSS JOIN stats s
WHERE ABS(
    (d.rides - s.avg_daily_rides)
    / NULLIF(s.sd_daily_rides, 0)
) >= 2
ORDER BY ABS(
    (d.rides - s.avg_daily_rides)
    / NULLIF(s.sd_daily_rides, 0)
) DESC;
