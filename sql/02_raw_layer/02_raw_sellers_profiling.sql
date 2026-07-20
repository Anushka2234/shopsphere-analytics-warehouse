/*
===============================================================================
Project      : ShopSphere Analytics Warehouse
Layer        : Raw Layer
Script Name  : 02_raw_sellers_profiling.sql
Source Table : raw.sellers

Description
-----------
Performs data profiling on the raw.sellers table before loading data into the
Staging Layer. The objective is to identify data quality issues such as missing
values, duplicates, blank fields, and inconsistent seller locations.

Profiling Checks
----------------
1. Total Record Count
2. Duplicate Seller IDs
3. NULL Value Analysis
4. Blank Value Analysis
5. Seller State Distribution
6. Top Seller Cities
7. Invalid City Values
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
FROM raw.sellers;
GO

/*=============================================================================
CHECK 2 : DUPLICATE SELLER IDs
=============================================================================*/

SELECT
    seller_id,
    COUNT(*) AS duplicate_count
FROM raw.sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;
GO

/*=============================================================================
CHECK 3 : NULL VALUE ANALYSIS
=============================================================================*/

SELECT

SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS null_seller_id,

SUM(CASE WHEN seller_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS null_zip_code,

SUM(CASE WHEN seller_city IS NULL THEN 1 ELSE 0 END) AS null_city,

SUM(CASE WHEN seller_state IS NULL THEN 1 ELSE 0 END) AS null_state

FROM raw.sellers;
GO

/*=============================================================================
CHECK 4 : BLANK VALUE ANALYSIS
=============================================================================*/

SELECT

SUM(CASE WHEN TRIM(ISNULL(seller_city,''))='' THEN 1 ELSE 0 END) AS blank_city,

SUM(CASE WHEN TRIM(ISNULL(seller_state,''))='' THEN 1 ELSE 0 END) AS blank_state

FROM raw.sellers;
GO

/*=============================================================================
CHECK 5 : SELLER STATE DISTRIBUTION
=============================================================================*/

SELECT

seller_state,

COUNT(*) AS total_sellers

FROM raw.sellers

GROUP BY seller_state

ORDER BY total_sellers DESC;
GO

/*=============================================================================
CHECK 6 : TOP 20 SELLER CITIES
=============================================================================*/

SELECT TOP (20)

seller_city,

COUNT(*) AS total_sellers

FROM raw.sellers

GROUP BY seller_city

ORDER BY total_sellers DESC;
GO

/*=============================================================================
CHECK 7 : POTENTIAL INVALID CITY VALUES
Checks for blank cities, numeric values, or values containing '@'.
=============================================================================*/

SELECT *

FROM raw.sellers

WHERE seller_city IS NULL
   OR TRIM(seller_city) = ''
   OR seller_city LIKE '%@%'
   OR seller_city LIKE '%[0-9]%';
GO

/*=============================================================================
CHECK 8 : SAMPLE DATA
=============================================================================*/

SELECT TOP (20) *

FROM raw.sellers;
GO

/*=============================================================================
END OF SCRIPT
=============================================================================*/
