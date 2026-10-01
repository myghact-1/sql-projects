/*
===============================================================================
07_RIDER_ANALYSIS.SQL
Business goal: understand member vs casual rider behavior.
===============================================================================
*/
-- Q1. Member and casual volume by month.
SELECT
    ride_month,
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

-- Q2. Average duration by rider type.
SELECT
    member_casual,
    ROUND(AVG(ride_duration_minutes), 2) AS avg_duration_minutes
FROM
    trips_clean
GROUP BY
    member_casual
ORDER BY
    avg_duration_minutes DESC;

-- Q3. Weekday vs weekend behavior.
SELECT
    member_casual,
    day_type,
    COUNT(*) AS rides,
    ROUND(AVG(ride_duration_minutes), 2) AS avg_duration_minutes
FROM
    trips_clean
GROUP BY
    member_casual,
    day_type
ORDER BY
    member_casual,
    day_type;

-- Q4. Weekend share by rider type.
WITH
    cte_daywise_rides AS (
        SELECT
            member_casual,
            day_type,
            COUNT(*) AS daywise_total_rides
        FROM
            trips_clean
        GROUP BY
            member_casual,
            day_type
    ),
    cte_member_casual AS (
        SELECT
            member_casual,
            COUNT(*) AS total_rides
        FROM
            trips_clean
        GROUP BY
            member_casual
    )
SELECT
    cm.member_casual,
    cd.day_type,
    cm.total_rides,
    cd.daywise_total_rides,
    ROUND(
        (
            cd.daywise_total_rides::NUMERIC * 100 / cm.total_rides::NUMERIC
        ),
        2
    ) AS weekend_share_pct
FROM
    cte_member_casual AS cm
    LEFT JOIN cte_daywise_rides AS cd ON cm.member_casual = cd.member_casual
WHERE
    cd.day_type = 'Weekend';

-- OR
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

-- Q5. Rideable-type mix within each rider type.
SELECT
    member_casual,
    rideable_type,
    COUNT(*) AS rides,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (
            PARTITION BY
                member_casual
        ),
        2
    ) AS rider_type_share_pct
FROM
    trips_clean
GROUP BY
    member_casual,
    rideable_type
ORDER BY
    member_casual,
    rides DESC;

-- Q6. Long rides by rider type.
SELECT
    member_casual,
    COUNT(*) AS total_rides,
    COUNT(*) FILTER (
        WHERE
            is_over_24_hours
    ) AS over_24h_rides,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE
                is_over_24_hours
        ) / NULLIF(COUNT(*), 0),
        4
    ) AS over_24h_share_pct
FROM
    trips_clean
GROUP BY
    member_casual;
