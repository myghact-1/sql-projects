/*
===============================================================================
10_ROUTE_ANALYSIS.SQL
Business goal: identify common origin-destination patterns.
===============================================================================
*/

-- Q1. Most popular routes.
SELECT
    start_station_name,
    end_station_name,
    COUNT(*) AS rides
FROM trips_clean
WHERE start_station_name IS NOT NULL
  AND end_station_name IS NOT NULL
GROUP BY start_station_name, end_station_name
ORDER BY rides DESC
LIMIT 20;

-- Q2. Most popular casual routes.
SELECT
    start_station_name,
    end_station_name,
    COUNT(*) AS casual_rides
FROM trips_clean
WHERE member_casual = 'casual'
  AND start_station_name IS NOT NULL
  AND end_station_name IS NOT NULL
GROUP BY start_station_name, end_station_name
ORDER BY casual_rides DESC
LIMIT 20;

-- Q3. Most popular member routes.
SELECT
    start_station_name,
    end_station_name,
    COUNT(*) AS member_rides
FROM trips_clean
WHERE member_casual = 'member'
  AND start_station_name IS NOT NULL
  AND end_station_name IS NOT NULL
GROUP BY start_station_name, end_station_name
ORDER BY member_rides DESC
LIMIT 20;

-- Q4. Longest average routes, with a minimum volume threshold.
SELECT
    start_station_name,
    end_station_name,
    COUNT(*) AS rides,
    ROUND(AVG(ride_duration_minutes), 2) AS avg_duration_minutes
FROM trips_clean
WHERE start_station_name IS NOT NULL
  AND end_station_name IS NOT NULL
GROUP BY start_station_name, end_station_name
HAVING COUNT(*) >= 100
ORDER BY avg_duration_minutes DESC
LIMIT 20;

-- Q5. Same-station returns.
SELECT
    COUNT(*) AS rides_with_station_ids,
    COUNT(*) FILTER (
        WHERE start_station_id = end_station_id
    ) AS same_station_rides,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE start_station_id = end_station_id
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS same_station_pct
FROM trips_clean
WHERE start_station_id IS NOT NULL
  AND end_station_id IS NOT NULL;
