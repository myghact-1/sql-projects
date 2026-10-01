/*
===============================================================================
05_CLEAN_TABLE_VALIDATION.SQL
Purpose : Confirm that trips_clean was created correctly.
===============================================================================
*/
-- Q1. Raw vs clean row counts.
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
    ) AS excluded_rides;

-- Q2. Check for invalid timestamps in the clean table.
SELECT
    COUNT(*) AS invalid_clean_rides
FROM
    trips_clean
WHERE
    ended_at <= started_at;

-- Expected: 0
-- Q3. Check duration statistics.
SELECT
    MIN(ride_duration_minutes) AS min_duration_minutes,
    ROUND(AVG(ride_duration_minutes), 2) AS avg_duration_minutes,
    MAX(ride_duration_minutes) AS max_duration_minutes
FROM
    trips_clean;

-- Q4. Verify the year.
SELECT
    ride_year,
    COUNT(*) AS rides
FROM
    trips_clean
GROUP BY
    ride_year
ORDER BY
    ride_year;

-- Expected: only 2025.
-- Q5. Rider mix.
SELECT
    member_casual,
    COUNT(*) AS rides
FROM
    trips_clean
GROUP BY
    member_casual
ORDER BY
    rides DESC;

-- Q6. Long-ride flag.
SELECT
    is_over_24_hours,
    COUNT(*) AS rides
FROM
    trips_clean
GROUP BY
    is_over_24_hours
ORDER BY
    is_over_24_hours;

-- Q7. Check station-name missingness after cleaning.
SELECT
    COUNT(*) FILTER (
        WHERE
            start_station_name IS NULL
    ) AS missing_start_station,
    COUNT(*) FILTER (
        WHERE
            end_station_name IS NULL
    ) AS missing_end_station
FROM
    trips_clean;
