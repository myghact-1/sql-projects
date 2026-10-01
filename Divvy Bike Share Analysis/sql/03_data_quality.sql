/*
===============================================================================
03_DATA_QUALITY.SQL
Purpose : Profile the raw dataset before making cleaning decisions.
===============================================================================
*/
-- Q1. Total raw records.
SELECT
    COUNT(*) AS total_rides
FROM
    trips_raw;

-- Q2. Duplicate ride IDs.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT ride_id) AS unique_ride_ids,
    COUNT(*) - COUNT(DISTINCT ride_id) AS duplicate_ids
FROM
    trips_raw;

-- Q3. Rider-type values and volumes.
SELECT
    member_casual,
    COUNT(*) AS rides
FROM
    trips_raw
GROUP BY
    member_casual
ORDER BY
    rides DESC;

-- Q4. Missing values.
SELECT
    COUNT(*) FILTER (
        WHERE
            ride_id IS NULL
    ) AS missing_ride_id,
    COUNT(*) FILTER (
        WHERE
            started_at IS NULL
    ) AS missing_started_at,
    COUNT(*) FILTER (
        WHERE
            ended_at IS NULL
    ) AS missing_ended_at,
    COUNT(*) FILTER (
        WHERE
            start_station_name IS NULL
    ) AS missing_start_station,
    COUNT(*) FILTER (
        WHERE
            end_station_name IS NULL
    ) AS missing_end_station,
    COUNT(*) FILTER (
        WHERE
            start_lat IS NULL
    ) AS missing_start_lat,
    COUNT(*) FILTER (
        WHERE
            start_lng IS NULL
    ) AS missing_start_lng,
    COUNT(*) FILTER (
        WHERE
            end_lat IS NULL
    ) AS missing_end_lat,
    COUNT(*) FILTER (
        WHERE
            end_lng IS NULL
    ) AS missing_end_lng
FROM
    trips_raw;

-- Q5. Raw ride-duration range.
SELECT
    MIN(ended_at - started_at) AS shortest_ride,
    MAX(ended_at - started_at) AS longest_ride,
    AVG(ended_at - started_at) AS average_ride
FROM
    trips_raw
WHERE
    started_at IS NOT NULL
    AND ended_at IS NOT NULL;

-- Q6. Impossible timestamps.
SELECT
    COUNT(*) AS invalid_rides
FROM
    trips_raw
WHERE
    ended_at <= started_at;

-- Q7. Inspect invalid records before excluding them.
SELECT
    ride_id,
    rideable_type,
    started_at,
    ended_at,
    ended_at - started_at AS duration,
    start_station_name,
    end_station_name,
    member_casual
FROM
    trips_raw
WHERE
    ended_at <= started_at
ORDER BY
    duration;

-- Q8. Extremely long rides.
SELECT
    ride_id,
    started_at,
    ended_at,
    ended_at - started_at AS duration,
    member_casual
FROM
    trips_raw
WHERE
    ended_at - started_at > INTERVAL '24 hours'
ORDER BY
    duration DESC;

-- Q9. Check distinct categorical values.
SELECT DISTINCT
    rideable_type
FROM
    trips_raw
ORDER BY
    rideable_type;

SELECT DISTINCT
    member_casual
FROM
    trips_raw
ORDER BY
    member_casual;
