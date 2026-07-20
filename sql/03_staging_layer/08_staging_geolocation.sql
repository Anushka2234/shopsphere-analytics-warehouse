/*
====================================================================

Project Name : ShopSphere Analytics Warehouse

Layer        : STAGING

Script       : 08_staging_geolocation.sql

Source       : raw.geolocation

Target       : staging.geolocation

Purpose
-------
Clean geolocation data before loading into
the Data Warehouse.

Cleaning Rules
--------------
1. Remove leading/trailing spaces
2. Standardize city names
3. Standardize state codes
4. Handle NULL values
5. Validate latitude and longitude
6. Add ETL metadata

Author : Your Name

====================================================================
*/

USE ShopSphereDW;
GO

/*==============================================================
STEP 1 : CREATE STAGING SCHEMA
==============================================================*/

IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name='staging'
)
BEGIN
    EXEC('CREATE SCHEMA staging');
END;
GO

/*==============================================================
STEP 2 : DROP TABLE
==============================================================*/

DROP TABLE IF EXISTS staging.geolocation;
GO

/*==============================================================
STEP 3 : CREATE TABLE
==============================================================*/

CREATE TABLE staging.geolocation
(
    geolocation_zip_code_prefix INT,

    geolocation_lat DECIMAL(12,8),

    geolocation_lng DECIMAL(12,8),

    geolocation_city VARCHAR(150),

    geolocation_state VARCHAR(10),

    etl_created_date DATETIME,

    source_system VARCHAR(50)
);

GO

/*==============================================================
STEP 4 : LOAD CLEAN DATA
==============================================================*/

INSERT INTO staging.geolocation
(
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state,
    etl_created_date,
    source_system
)

SELECT

---------------------------------------------------------
-- ZIP Code
---------------------------------------------------------

geolocation_zip_code_prefix,

---------------------------------------------------------
-- Latitude
---------------------------------------------------------

ISNULL(geolocation_lat,0),

---------------------------------------------------------
-- Longitude
---------------------------------------------------------

ISNULL(geolocation_lng,0),

---------------------------------------------------------
-- City
---------------------------------------------------------

CASE

WHEN geolocation_city IS NULL
     OR TRIM(geolocation_city)=''

THEN 'UNKNOWN'

ELSE

UPPER
(
TRIM
(
REPLACE
(
REPLACE
(
geolocation_city,
CHAR(13),
''
),
CHAR(10),
''
)
)
)

END,

---------------------------------------------------------
-- State
---------------------------------------------------------

CASE

WHEN geolocation_state IS NULL
     OR TRIM(geolocation_state)=''

THEN 'UNKNOWN'

ELSE

UPPER(TRIM(geolocation_state))

END,

---------------------------------------------------------
-- ETL Date
---------------------------------------------------------

GETDATE(),

---------------------------------------------------------
-- Source System
---------------------------------------------------------

'OLIST_ECOMMERCE'

FROM raw.geolocation;

GO

/*==============================================================
STEP 5 : VALIDATION
==============================================================*/

---------------------------------------------------------
-- Validation 1 : Raw vs Staging Count
---------------------------------------------------------

SELECT

'RAW_GEOLOCATION' AS table_name,

COUNT(*) AS total_records

FROM raw.geolocation

UNION ALL

SELECT

'STAGING_GEOLOCATION',

COUNT(*)

FROM staging.geolocation;

GO

---------------------------------------------------------
-- Validation 2 : Unknown Cities
---------------------------------------------------------

SELECT

COUNT(*) AS unknown_city_count

FROM staging.geolocation

WHERE geolocation_city='UNKNOWN';

GO

---------------------------------------------------------
-- Validation 3 : Unknown States
---------------------------------------------------------

SELECT

COUNT(*) AS unknown_state_count

FROM staging.geolocation

WHERE geolocation_state='UNKNOWN';

GO

---------------------------------------------------------
-- Validation 4 : Invalid Latitude
---------------------------------------------------------

SELECT *

FROM staging.geolocation

WHERE geolocation_lat NOT BETWEEN -90 AND 90;

GO

---------------------------------------------------------
-- Validation 5 : Invalid Longitude
---------------------------------------------------------

SELECT *

FROM staging.geolocation

WHERE geolocation_lng NOT BETWEEN -180 AND 180;

GO

---------------------------------------------------------
-- Validation 6 : State Distribution
---------------------------------------------------------

SELECT

geolocation_state,

COUNT(*) AS total_records

FROM staging.geolocation

GROUP BY geolocation_state

ORDER BY total_records DESC;

GO

---------------------------------------------------------
-- Validation 7 : Top Cities
---------------------------------------------------------

SELECT TOP 20

geolocation_city,

COUNT(*) AS total_records

FROM staging.geolocation

GROUP BY geolocation_city

ORDER BY total_records DESC;

GO

---------------------------------------------------------
-- Validation 8 : Sample Data
---------------------------------------------------------

SELECT TOP 20 *

FROM staging.geolocation;

GO
