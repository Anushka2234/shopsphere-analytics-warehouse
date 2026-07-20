/*
====================================================================

Project Name : ShopSphere Analytics Warehouse

Layer        : RAW

Script       : 08_raw_geolocation_profiling.sql

Table        : raw.geolocation

Purpose
-------
Perform data profiling before loading data into staging layer.

Checks Included
---------------
1. Record Count
2. Duplicate Records
3. NULL Analysis
4. Blank Value Analysis
5. Latitude Validation
6. Longitude Validation
7. State Distribution
8. Top Cities
9. Sample Data

====================================================================
*/

USE ShopSphereDW;
GO

/*==============================================================
CHECK 1 : TOTAL RECORDS
==============================================================*/

SELECT
COUNT(*) AS total_records
FROM raw.geolocation;

GO

/*==============================================================
CHECK 2 : DUPLICATE RECORDS
==============================================================*/

SELECT

geolocation_zip_code_prefix,

geolocation_lat,

geolocation_lng,

geolocation_city,

geolocation_state,

COUNT(*) AS duplicate_count

FROM raw.geolocation

GROUP BY

geolocation_zip_code_prefix,

geolocation_lat,

geolocation_lng,

geolocation_city,

geolocation_state

HAVING COUNT(*) > 1;

GO

/*==============================================================
CHECK 3 : NULL VALUE ANALYSIS
==============================================================*/

SELECT

SUM(CASE WHEN geolocation_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS null_zip,

SUM(CASE WHEN geolocation_lat IS NULL THEN 1 ELSE 0 END) AS null_lat,

SUM(CASE WHEN geolocation_lng IS NULL THEN 1 ELSE 0 END) AS null_lng,

SUM(CASE WHEN geolocation_city IS NULL THEN 1 ELSE 0 END) AS null_city,

SUM(CASE WHEN geolocation_state IS NULL THEN 1 ELSE 0 END) AS null_state

FROM raw.geolocation;

GO

/*==============================================================
CHECK 4 : BLANK VALUES
==============================================================*/

SELECT

SUM(CASE WHEN TRIM(ISNULL(geolocation_city,''))='' THEN 1 ELSE 0 END) AS blank_city,

SUM(CASE WHEN TRIM(ISNULL(geolocation_state,''))='' THEN 1 ELSE 0 END) AS blank_state

FROM raw.geolocation;

GO

/*==============================================================
CHECK 5 : INVALID LATITUDE
==============================================================*/

SELECT *

FROM raw.geolocation

WHERE geolocation_lat NOT BETWEEN -90 AND 90;

GO

/*==============================================================
CHECK 6 : INVALID LONGITUDE
==============================================================*/

SELECT *

FROM raw.geolocation

WHERE geolocation_lng NOT BETWEEN -180 AND 180;

GO

/*==============================================================
CHECK 7 : STATE DISTRIBUTION
==============================================================*/

SELECT

geolocation_state,

COUNT(*) AS total_records

FROM raw.geolocation

GROUP BY geolocation_state

ORDER BY total_records DESC;

GO

/*==============================================================
CHECK 8 : TOP CITIES
==============================================================*/

SELECT TOP 20

geolocation_city,

COUNT(*) AS total_records

FROM raw.geolocation

GROUP BY geolocation_city

ORDER BY total_records DESC;

GO

/*==============================================================
CHECK 9 : SAMPLE DATA
==============================================================*/

SELECT TOP 20 *

FROM raw.geolocation;

GO
