/*
===============================================================================
04_DATA_CLEANING.SQL
Purpose : Build the clean analytical table from trips_raw.

Cleaning decisions:
1. Exclude only records where ended_at <= started_at (29 records in this
   project). These records cannot represent a valid positive-duration trip.
2. Keep long rides rather than arbitrarily deleting them.
3. Flag rides over 24 hours for later sensitivity analysis.
4. Keep missing station names. Missing station metadata is a data-quality issue,
   but deleting those rides would remove valid trip observations.
5. Add reusable date/time dimensions for analysis.
===============================================================================
*/

DROP TABLE IF EXISTS trips_clean;

CREATE TABLE trips_clean AS
SELECT
    ride_id,
    rideable_type,
    started_at,
    ended_at,

    -- Derived duration in minutes.
    ROUND(
        EXTRACT(EPOCH FROM (ended_at - started_at)) / 60.0,
        2
    ) AS ride_duration_minutes,

    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,

    start_lat,
    start_lng,
    end_lat,
    end_lng,

    member_casual,

    -- Calendar dimensions.
    started_at::DATE AS ride_date,
    EXTRACT(YEAR FROM started_at)::INT AS ride_year,
    EXTRACT(MONTH FROM started_at)::INT AS ride_month,

    TO_CHAR(started_at, 'Month') AS ride_month_name,

    EXTRACT(DOW FROM started_at)::INT AS day_of_week,
    TO_CHAR(started_at, 'Day') AS day_name,

    EXTRACT(HOUR FROM started_at)::INT AS ride_hour,

    -- Weekday vs weekend classification.
    CASE
        WHEN EXTRACT(DOW FROM started_at) IN (0, 6)
            THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,

    -- Flag rather than automatically remove very long rides.
    CASE
        WHEN ended_at - started_at > INTERVAL '24 hours'
            THEN TRUE
        ELSE FALSE
    END AS is_over_24_hours

FROM trips_raw
WHERE ended_at > started_at;

-- Add an index on the most common analytical dimensions.
CREATE INDEX idx_trips_clean_started_at
    ON trips_clean (started_at);

CREATE INDEX idx_trips_clean_ride_date
    ON trips_clean (ride_date);

CREATE INDEX idx_trips_clean_member_casual
    ON trips_clean (member_casual);

CREATE INDEX idx_trips_clean_start_station
    ON trips_clean (start_station_id);

CREATE INDEX idx_trips_clean_end_station
    ON trips_clean (end_station_id);

-- Validation: expected clean row count.
SELECT COUNT(*) AS clean_rides
FROM trips_clean;

-- Expected:
-- 5,552,965
