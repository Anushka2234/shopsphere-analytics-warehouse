/*
===============================================================================
Project      : ShopSphere Analytics Warehouse
Layer        : Raw Layer
Script Name  : 01_raw_customers_profiling.sql
Source Table : raw.customers

Description
-----------
Performs data profiling on the raw.customers table before the ETL process.
The objective is to assess data quality and identify issues that need to be
addressed in the Staging Layer.

Profiling Checks
----------------
1. Total Record Count
2. Duplicate Customer IDs
3. Duplicate Customer Unique IDs
4. NULL Value Analysis
5. Blank Value Analysis
6. Customer State Distribution
7. Top Customer Cities
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
FROM raw.customers;
GO

/*=============================================================================
CHECK 2 : DUPLICATE CUSTOMER IDs
=============================================================================*/

SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM raw.customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
GO

/*=============================================================================
CHECK 3 : DUPLICATE CUSTOMER UNIQUE IDs
=============================================================================*/

SELECT
    customer_unique_id,
    COUNT(*) AS duplicate_count
FROM raw.customers
GROUP BY customer_unique_id
HAVING COUNT(*) > 1;
GO

/*=============================================================================
CHECK 4 : NULL VALUE ANALYSIS
=============================================================================*/

SELECT

SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,

SUM(CASE WHEN customer_unique_id IS NULL THEN 1 ELSE 0 END) AS null_customer_unique_id,

SUM(CASE WHEN customer_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS null_zip_code,

SUM(CASE WHEN customer_city IS NULL THEN 1 ELSE 0 END) AS null_city,

SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END) AS null_state

FROM raw.customers;
GO

/*=============================================================================
CHECK 5 : BLANK VALUE ANALYSIS
=============================================================================*/

SELECT

SUM(CASE WHEN TRIM(ISNULL(customer_city,''))='' THEN 1 ELSE 0 END) AS blank_city,

SUM(CASE WHEN TRIM(ISNULL(customer_state,''))='' THEN 1 ELSE 0 END) AS blank_state

FROM raw.customers;
GO

/*=============================================================================
CHECK 6 : CUSTOMER STATE DISTRIBUTION
=============================================================================*/

SELECT

customer_state,

COUNT(*) AS total_customers

FROM raw.customers

GROUP BY customer_state

ORDER BY total_customers DESC;
GO

/*=============================================================================
CHECK 7 : TOP 20 CUSTOMER CITIES
=============================================================================*/

SELECT TOP (20)

customer_city,

COUNT(*) AS total_customers

FROM raw.customers

GROUP BY customer_city

ORDER BY total_customers DESC;
GO

/*=============================================================================
CHECK 8 : SAMPLE DATA
=============================================================================*/

SELECT TOP (20) *

FROM raw.customers;
GO

/*=============================================================================
END OF SCRIPT
=============================================================================*/
