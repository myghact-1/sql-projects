/*
===============================================================================
02_DATA_IMPORT.SQL
Purpose : Load the 12 monthly 2025 CSV files into trips_raw.
===============================================================================
*/
-- January
COPY trips_raw
FROM
   'S:\sql-projects\Divvy Bike Share Analysis\datasets\raw\202501-divvy-tripdata.csv'
WITH
   (FORMAT CSV, HEADER TRUE, DELIMITER ',');

-- February
COPY trips_raw
FROM
   'S:\sql-projects\Divvy Bike Share Analysis\datasets\raw\202502-divvy-tripdata.csv'
WITH
   (FORMAT CSV, HEADER TRUE, DELIMITER ',');

-- March
COPY trips_raw
FROM
   'S:\sql-projects\Divvy Bike Share Analysis\datasets\raw\202503-divvy-tripdata.csv'
WITH
   (FORMAT CSV, HEADER TRUE, DELIMITER ',');

-- April
COPY trips_raw
FROM
   'S:\sql-projects\Divvy Bike Share Analysis\datasets\raw\202504-divvy-tripdata.csv'
WITH
   (FORMAT CSV, HEADER TRUE, DELIMITER ',');

-- May
COPY trips_raw
FROM
   'S:\sql-projects\Divvy Bike Share Analysis\datasets\raw\202505-divvy-tripdata.csv'
WITH
   (FORMAT CSV, HEADER TRUE, DELIMITER ',');

-- June
COPY trips_raw
FROM
   'S:\sql-projects\Divvy Bike Share Analysis\datasets\raw\202506-divvy-tripdata.csv'
WITH
   (FORMAT CSV, HEADER TRUE, DELIMITER ',');

-- July
COPY trips_raw
FROM
   'S:\sql-projects\Divvy Bike Share Analysis\datasets\raw\202507-divvy-tripdata.csv'
WITH
   (FORMAT CSV, HEADER TRUE, DELIMITER ',');

-- August
COPY trips_raw
FROM
   'S:\sql-projects\Divvy Bike Share Analysis\datasets\raw\202508-divvy-tripdata.csv'
WITH
   (FORMAT CSV, HEADER TRUE, DELIMITER ',');

-- September
COPY trips_raw
FROM
   'S:\sql-projects\Divvy Bike Share Analysis\datasets\raw\202509-divvy-tripdata.csv'
WITH
   (FORMAT CSV, HEADER TRUE, DELIMITER ',');

-- October
COPY trips_raw
FROM
   'S:\sql-projects\Divvy Bike Share Analysis\datasets\raw\202510-divvy-tripdata.csv'
WITH
   (FORMAT CSV, HEADER TRUE, DELIMITER ',');

-- November
COPY trips_raw
FROM
   'S:\sql-projects\Divvy Bike Share Analysis\datasets\raw\202511-divvy-tripdata.csv'
WITH
   (FORMAT CSV, HEADER TRUE, DELIMITER ',');

-- December
COPY trips_raw
FROM
   'S:\sql-projects\Divvy Bike Share Analysis\datasets\raw\202512-divvy-tripdata.csv'
WITH
   (FORMAT CSV, HEADER TRUE, DELIMITER ',');

-- Validation
SELECT
   COUNT(*) AS raw_ride_count
FROM
   trips_raw;

-- Expected :
-- 5,552,994 rows
