/*
===============================================================================
01_DATABASE_SETUP.SQL
Project : Divvy 2025 Bike-Share Operations Analytics
Purpose : Create the PostgreSQL database objects used by the project.

Run this file while connected to the target database.
NOTE: PostgreSQL does not allow CREATE DATABASE inside a transaction in pgAdmin.
Create the database separately, then connect to it before running this file.
===============================================================================
*/
-- Optional: create the database from pgAdmin's database interface:
-- CREATE DATABASE bike_share_2025;
-- Raw table: mirrors the source CSV structure.
DROP TABLE IF EXISTS trips_raw CASCADE;

CREATE TABLE trips_raw (
    ride_id VARCHAR(50),
    rideable_type VARCHAR(30),
    started_at TIMESTAMP,
    ended_at TIMESTAMP,
    start_station_name VARCHAR(255),
    start_station_id VARCHAR(50),
    end_station_name VARCHAR(255),
    end_station_id VARCHAR(50),
    start_lat NUMERIC(10, 7),
    start_lng NUMERIC(10, 7),
    end_lat NUMERIC(10, 7),
    end_lng NUMERIC(10, 7),
    member_casual VARCHAR(20)
);

COMMENT ON TABLE trips_raw IS 'Raw 2025 Divvy trip data imported from the 12 monthly source CSV files.';
