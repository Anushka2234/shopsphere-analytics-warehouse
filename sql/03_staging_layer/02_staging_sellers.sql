/*
====================================================================

Project Name : ShopSphere Analytics Warehouse

Layer        : STAGING

Script       : 02_staging_sellers.sql

Source       : raw.sellers

Target       : staging.sellers

Purpose
-------
Clean seller master data before loading into Data Warehouse.

Cleaning Rules
--------------
1. Remove leading/trailing spaces
2. Convert city and state to uppercase
3. Handle NULL and blank values
4. Replace numeric city values with 'UNKNOWN'
5. Replace email addresses with 'UNKNOWN'
6. Remove hidden CR/LF characters
7. Remove duplicate spaces
8. Add ETL metadata columns

Author       : Your Name

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
    WHERE name = 'staging'
)
BEGIN
    EXEC('CREATE SCHEMA staging');
END;
GO

/*==============================================================
STEP 2 : DROP EXISTING TABLE
==============================================================*/

DROP TABLE IF EXISTS staging.sellers;
GO

/*==============================================================
STEP 3 : CREATE STAGING TABLE
==============================================================*/

CREATE TABLE staging.sellers
(
    seller_id VARCHAR(50) NOT NULL,

    seller_zip_code_prefix INT,

    seller_city VARCHAR(150),

    seller_state VARCHAR(10),

    etl_created_date DATETIME,

    source_system VARCHAR(50)
);
GO

/*==============================================================
STEP 4 : LOAD CLEAN DATA
==============================================================*/

INSERT INTO staging.sellers
(
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state,
    etl_created_date,
    source_system
)

SELECT

/*------------------------------------------------------------
Seller ID
------------------------------------------------------------*/

TRIM(seller_id) AS seller_id,

/*------------------------------------------------------------
Zip Code
------------------------------------------------------------*/

seller_zip_code_prefix,

/*------------------------------------------------------------
Seller City Cleaning
------------------------------------------------------------*/

CASE

    -- NULL City
    WHEN seller_city IS NULL THEN 'UNKNOWN'

    -- Blank City
    WHEN TRIM(seller_city) = '' THEN 'UNKNOWN'

    -- Numeric Value
    WHEN TRY_CAST(TRIM(seller_city) AS BIGINT) IS NOT NULL THEN 'UNKNOWN'

    -- Email Address
    WHEN seller_city LIKE '%@%' THEN 'UNKNOWN'

    ELSE

        UPPER
        (
            TRIM
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            seller_city,
                            CHAR(13),
                            ''
                        ),
                        CHAR(10),
                        ''
                    ),
                    '  ',
                    ' '
                )
            )
        )

END AS seller_city,

/*------------------------------------------------------------
Seller State Cleaning
------------------------------------------------------------*/

CASE

    WHEN seller_state IS NULL
         OR TRIM(seller_state) = ''

    THEN 'UNKNOWN'

    ELSE UPPER(TRIM(seller_state))

END AS seller_state,

/*------------------------------------------------------------
ETL Metadata
------------------------------------------------------------*/

GETDATE() AS etl_created_date,

'OLIST_ECOMMERCE' AS source_system

FROM raw.sellers;

GO

/*==============================================================
STEP 5 : VALIDATION
==============================================================*/

---------------------------------------------------------------
-- Validation 1 : Raw vs Staging Count
---------------------------------------------------------------

SELECT
'RAW_SELLERS' AS table_name,
COUNT(*) AS total_records
FROM raw.sellers

UNION ALL

SELECT
'STAGING_SELLERS',
COUNT(*)
FROM staging.sellers;

---------------------------------------------------------------
-- Validation 2 : Duplicate Seller IDs
---------------------------------------------------------------

SELECT
seller_id,
COUNT(*) AS duplicate_count
FROM staging.sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

---------------------------------------------------------------
-- Validation 3 : Unknown Cities
---------------------------------------------------------------

SELECT
COUNT(*) AS unknown_city_count
FROM staging.sellers
WHERE seller_city = 'UNKNOWN';

---------------------------------------------------------------
-- Validation 4 : Unknown States
---------------------------------------------------------------

SELECT
COUNT(*) AS unknown_state_count
FROM staging.sellers
WHERE seller_state = 'UNKNOWN';

---------------------------------------------------------------
-- Validation 5 : Distinct Cities
---------------------------------------------------------------

SELECT DISTINCT
seller_city
FROM staging.sellers
ORDER BY seller_city;

---------------------------------------------------------------
-- Validation 6 : Top Seller Cities
---------------------------------------------------------------

SELECT TOP 20
seller_city,
seller_state,
COUNT(*) AS total_sellers
FROM staging.sellers
GROUP BY
seller_city,
seller_state
ORDER BY total_sellers DESC;

GO
