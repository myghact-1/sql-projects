/*
===============================================================================
12_FINAL_BUSINESS_REPORT.SQL
Purpose : Final portfolio-ready KPI queries.

===============================================================================
*/
-- KPI 1: Total rides and rider mix.
SELECT
    COUNT(*) AS total_rides,
    COUNT(*) FILTER (
        WHERE
            member_casual = 'member'
    ) AS member_rides,
    COUNT(*) FILTER (
        WHERE
            member_casual = 'casual'
    ) AS casual_rides,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE
                member_casual = 'member'
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS member_share_pct,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE
                member_casual = 'casual'
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS casual_share_pct
FROM
    trips_clean;

-- KPI 2: Monthly demand and rider mix.
SELECT
    ride_month,
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
ORDER BY
    ride_month;

-- KPI 3: Average duration by rider type.
SELECT
    member_casual,
    ROUND(AVG(ride_duration_minutes), 2) AS avg_duration_minutes
FROM
    trips_clean
GROUP BY
    member_casual;

-- KPI 4: Busiest hours.
SELECT
    ride_hour,
    COUNT(*) AS rides
FROM
    trips_clean
GROUP BY
    ride_hour
ORDER BY
    rides DESC
LIMIT
    10;

-- KPI 5: Busiest start stations.
SELECT
    start_station_name,
    COUNT(*) AS rides
FROM
    trips_clean
WHERE
    start_station_name IS NOT NULL
GROUP BY
    start_station_name
ORDER BY
    rides DESC
LIMIT
    10;

-- KPI 6: Most popular routes.
SELECT
    start_station_name,
    end_station_name,
    COUNT(*) AS rides
FROM
    trips_clean
WHERE
    start_station_name IS NOT NULL
    AND end_station_name IS NOT NULL
GROUP BY
    start_station_name,
    end_station_name
ORDER BY
    rides DESC
LIMIT
    10;

-- KPI 7: Weekend behavior.
SELECT
    member_casual,
    COUNT(*) AS total_rides,
    COUNT(*) FILTER (
        WHERE
            day_type = 'Weekend'
    ) AS weekend_rides,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE
                day_type = 'Weekend'
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS weekend_share_pct
FROM
    trips_clean
GROUP BY
    member_casual;

-- KPI 8: Data-quality summary for the final report.
SELECT
    (
        SELECT
            COUNT(*)
        FROM
            trips_raw
    ) AS raw_rides,
    (
        SELECT
            COUNT(*)
        FROM
            trips_clean
    ) AS clean_rides,
    (
        SELECT
            COUNT(*)
        FROM
            trips_raw
    ) - (
        SELECT
            COUNT(*)
        FROM
            trips_clean
    ) AS excluded_rides,
    (
        SELECT
            COUNT(DISTINCT ride_id)
        FROM
            trips_raw
    ) AS unique_ride_ids;

-- KPI 9: Missing station information.
SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE
                start_station_name IS NULL
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS missing_start_station_pct,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE
                end_station_name IS NULL
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS missing_end_station_pct
FROM
    trips_clean;
