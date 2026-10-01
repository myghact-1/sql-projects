/*
===============================================================================
06_EXPLORATORY_ANALYSIS.SQL
Business goal: establish the overall 2025 demand picture.
===============================================================================
*/
-- Q1. How did ride volume change month by month?
WITH
    monthly AS (
        SELECT
            ride_month,
            MIN(ride_month_name) AS ride_month_name,
            COUNT(*) AS total_rides,
            COUNT(*) FILTER (
                WHERE
                    member_casual = 'member'
            ) AS member_rides,
            COUNT(*) FILTER (
                WHERE
                    member_casual = 'casual'
            ) AS casual_rides
        FROM
            trips_clean
        GROUP BY
            ride_month
    )
SELECT
    ride_month,
    ride_month_name,
    total_rides,
    member_rides,
    casual_rides,
    ROUND(100.0 * member_rides / NULLIF(total_rides, 0), 2) AS member_share_pct,
    ROUND(100.0 * casual_rides / NULLIF(total_rides, 0), 2) AS casual_share_pct,
    LAG(total_rides) OVER (
        ORDER BY
            ride_month
    ) AS previous_month_rides,
    ROUND(
        100.0 * (
            total_rides - LAG(total_rides) OVER (
                ORDER BY
                    ride_month
            )
        ) / NULLIF(
            LAG(total_rides) OVER (
                ORDER BY
                    ride_month
            ),
            0
        ),
        2
    ) AS mom_growth_pct
FROM
    monthly
ORDER BY
    ride_month;

-- Q2. Highest and lowest volume months.
WITH
    monthly AS (
        SELECT
            ride_month,
            ride_month_name,
            COUNT(*) AS total_rides,
            COUNT(*) FILTER (
                WHERE
                    member_casual = 'member'
            ) AS member_rides,
            COUNT(*) FILTER (
                WHERE
                    member_casual = 'casual'
            ) AS casual_rides
        FROM
            trips_clean
        GROUP BY
            ride_month,
            ride_month_name
    ),
    ranked AS (
        SELECT
            *,
            RANK() OVER (
                ORDER BY
                    total_rides DESC
            ) AS high_rank,
            RANK() OVER (
                ORDER BY
                    total_rides ASC
            ) AS low_rank
        FROM
            monthly
    )
SELECT
    *
FROM
    ranked
WHERE
    high_rank = 1
    OR low_rank = 1;

-- Q3. Overall annual rider mix.
SELECT
    member_casual,
    COUNT(*) AS rides,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS share_pct
FROM
    trips_clean
GROUP BY
    member_casual
ORDER BY
    rides DESC;

-- Q4. Average duration by rider type.
SELECT
    member_casual,
    COUNT(*) AS rides,
    ROUND(AVG(ride_duration_minutes), 2) AS avg_duration_minutes,
    ROUND(MIN(ride_duration_minutes), 2) AS min_duration_minutes,
    ROUND(MAX(ride_duration_minutes), 2) AS max_duration_minutes
FROM
    trips_clean
GROUP BY
    member_casual
ORDER BY
    member_casual;
