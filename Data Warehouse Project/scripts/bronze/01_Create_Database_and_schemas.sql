/*
==============================================================
Create Database and Schemas
==============================================================

In this Script--
    1. A database is created named 'DataWarehouse', if it not exists. Otherwise, it drops the database and creates a new one.
    2. Then script creates three schemas named 'Bronze', 'Silver', and 'Gold'.

    IMPORTANT NOTE: Don't run this script if you don't have backup of the DataWarehouse database;
*/


-- Drop an existing database 'DataWarehouse'
DROP DATABASE IF EXISTS DataWarehouse;

-- Creating a new Database 'DataWarehouse'
CREATE DATABASE DataWarehouse;

-- use database datawarehouse
\c DataWarehouse;

-- Creating Schemas

CREATE SCHEMA bronze;

CREATE SCHEMA silver;

CREATE SCHEMA gold;