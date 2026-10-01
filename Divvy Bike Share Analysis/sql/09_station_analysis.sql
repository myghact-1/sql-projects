/*
===============================================================================
09_STATION_ANALYSIS.SQL
Business goal: understand station-level demand.
===============================================================================
*/

-- Q1. Top start stations.
SELECT
    start_station_name,
    COUNT(*) AS rides
FROM trips_clean
WHERE start_station_name IS NOT NULL
GROUP BY start_station_name
ORDER BY rides DESC
LIMIT 20;

-- Q2. Top end stations.
SELECT
    end_station_name,
    COUNT(*) AS rides
FROM trips_clean
WHERE end_station_name IS NOT NULL
GROUP BY end_station_name
ORDER BY rides DESC
LIMIT 20;

-- Q3. Combined start/end activity.
WITH station_activity AS (
    SELECT start_station_name AS station_name
    FROM trips_clean
    WHERE start_station_name IS NOT NULL

    UNION ALL

    SELECT end_station_name AS station_name
    FROM trips_clean
    WHERE end_station_name IS NOT NULL
)
SELECT
    station_name,
    COUNT(*) AS total_station_activity
FROM station_activity
GROUP BY station_name
ORDER BY total_station_activity DESC
LIMIT 20;

-- Q4. Top casual start stations.
SELECT
    start_station_name,
    COUNT(*) AS casual_rides
FROM trips_clean
WHERE member_casual = 'casual'
  AND start_station_name IS NOT NULL
GROUP BY start_station_name
ORDER BY casual_rides DESC
LIMIT 20;

-- Q5. Top member start stations.
SELECT
    start_station_name,
    COUNT(*) AS member_rides
FROM trips_clean
WHERE member_casual = 'member'
  AND start_station_name IS NOT NULL
GROUP BY start_station_name
ORDER BY member_rides DESC
LIMIT 20;

-- Q6. Stations with the largest member/casual difference.
WITH station_rides AS (
    SELECT
        start_station_name AS station_name,
        COUNT(*) FILTER (WHERE member_casual = 'member') AS member_rides,
        COUNT(*) FILTER (WHERE member_casual = 'casual') AS casual_rides
    FROM trips_clean
    WHERE start_station_name IS NOT NULL
    GROUP BY start_station_name
)
SELECT
    station_name,
    member_rides,
    casual_rides,
    member_rides - casual_rides AS member_minus_casual
FROM station_rides
ORDER BY ABS(member_rides - casual_rides) DESC
LIMIT 20;

-- Q7. Missing station-name rate.
SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE start_station_name IS NULL)
        / NULLIF(COUNT(*), 0), 2
    ) AS missing_start_station_pct,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE end_station_name IS NULL)
        / NULLIF(COUNT(*), 0), 2
    ) AS missing_end_station_pct
FROM trips_clean;
