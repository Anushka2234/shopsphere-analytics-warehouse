/*
===============================================================================
Project      : ShopSphere Analytics Warehouse
Layer        : Raw Layer
Script Name  : 08_raw_geolocation_profiling.sql
Source Table : raw.geolocation

Description
-----------
Performs data profiling on the raw.geolocation table before loading data into
the Staging Layer. This script evaluates data completeness, duplicate
geolocations, missing values, coordinate validity, and geographic distribution.

Profiling Checks
----------------
1. Total Record Count
2. Duplicate Geolocation Records
3. NULL Value Analysis
4. Blank Value Analysis
5. Invalid Latitude and Longitude
6. State Distribution
7. Top Cities
8. Sample Data Inspection

===============================================================================
*/

USE ShopSphereDW;
GO

/*=============================================================================
CHECK 1 : TOTAL RECORD COUNT
=============================================================================*/

SELECT
    COUNT(*) AS total_records
FROM raw.geolocation;
GO

/*=============================================================================
CHECK 2 : DUPLICATE GEOLOCATION RECORDS
Business Key = (geolocation_zip_code_prefix, geolocation_lat, geolocation_lng)
=============================================================================*/

SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    COUNT(*) AS duplicate_count
FROM raw.geolocation
GROUP BY
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng
HAVING COUNT(*) > 1;
GO

/*=============================================================================
CHECK 3 : NULL VALUE ANALYSIS
=============================================================================*/

SELECT

SUM(CASE WHEN geolocation_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS null_zip_code,

SUM(CASE WHEN geolocation_lat IS NULL THEN 1 ELSE 0 END) AS null_latitude,

SUM(CASE WHEN geolocation_lng IS NULL THEN 1 ELSE 0 END) AS null_longitude,

SUM(CASE WHEN geolocation_city IS NULL THEN 1 ELSE 0 END) AS null_city,

SUM(CASE WHEN geolocation_state IS NULL THEN 1 ELSE 0 END) AS null_state

FROM raw.geolocation;
GO

/*=============================================================================
CHECK 4 : BLANK VALUE ANALYSIS
=============================================================================*/

SELECT

SUM(CASE WHEN TRIM(ISNULL(geolocation_city,''))='' THEN 1 ELSE 0 END) AS blank_city,

SUM(CASE WHEN TRIM(ISNULL(geolocation_state,''))='' THEN 1 ELSE 0 END) AS blank_state

FROM raw.geolocation;
GO

/*=============================================================================
CHECK 5 : INVALID LATITUDE OR LONGITUDE
Latitude must be between -90 and 90.
Longitude must be between -180 and 180.
=============================================================================*/

SELECT *

FROM raw.geolocation

WHERE

geolocation_lat NOT BETWEEN -90 AND 90

OR

geolocation_lng NOT BETWEEN -180 AND 180;
GO

/*=============================================================================
CHECK 6 : STATE DISTRIBUTION
=============================================================================*/

SELECT

geolocation_state,

COUNT(*) AS total_locations

FROM raw.geolocation

GROUP BY geolocation_state

ORDER BY total_locations DESC;
GO

/*=============================================================================
CHECK 7 : TOP 20 CITIES
=============================================================================*/

SELECT TOP (20)

geolocation_city,

COUNT(*) AS total_locations

FROM raw.geolocation

GROUP BY geolocation_city

ORDER BY total_locations DESC;
GO

/*=============================================================================
CHECK 8 : SAMPLE DATA
=============================================================================*/

SELECT TOP (20) *

FROM raw.geolocation;
GO

/*=============================================================================
END OF SCRIPT
=============================================================================*/
