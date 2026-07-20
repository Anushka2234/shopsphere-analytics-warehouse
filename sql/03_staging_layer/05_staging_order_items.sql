/*
====================================================================

Project Name : ShopSphere Analytics Warehouse

Layer        : STAGING

Script       : 04_staging_order_items.sql

Source       : raw.order_items

Target       : staging.order_items

Purpose
-------
Clean order item transaction data before loading into
the Data Warehouse.

Cleaning Rules
--------------
1. Remove leading/trailing spaces
2. Convert shipping date to DATETIME
3. Validate price
4. Validate freight value
5. Calculate total_amount
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

DROP TABLE IF EXISTS staging.order_items;
GO

/*==============================================================
STEP 3 : CREATE TABLE
==============================================================*/

CREATE TABLE staging.order_items
(
    order_id VARCHAR(50) NOT NULL,

    order_item_id INT NOT NULL,

    product_id VARCHAR(50) NOT NULL,

    seller_id VARCHAR(50) NOT NULL,

    shipping_limit_date DATETIME,

    price DECIMAL(10,2),

    freight_value DECIMAL(10,2),

    total_amount DECIMAL(10,2),

    etl_created_date DATETIME,

    source_system VARCHAR(50)
);

GO

/*==============================================================
STEP 4 : LOAD CLEAN DATA
==============================================================*/

INSERT INTO staging.order_items
(
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value,
    total_amount,
    etl_created_date,
    source_system
)

SELECT

---------------------------------------------------------
-- Order ID
---------------------------------------------------------

TRIM(order_id),

---------------------------------------------------------
-- Order Item Number
---------------------------------------------------------

order_item_id,

---------------------------------------------------------
-- Product ID
---------------------------------------------------------

TRIM(product_id),

---------------------------------------------------------
-- Seller ID
---------------------------------------------------------

TRIM(seller_id),

---------------------------------------------------------
-- Shipping Limit Date
---------------------------------------------------------

TRY_CAST(shipping_limit_date AS DATETIME),

---------------------------------------------------------
-- Price
---------------------------------------------------------

CASE
    WHEN price < 0 THEN 0
    ELSE price
END,

---------------------------------------------------------
-- Freight Value
---------------------------------------------------------

CASE
    WHEN freight_value < 0 THEN 0
    ELSE freight_value
END,

---------------------------------------------------------
-- Total Amount
---------------------------------------------------------

CASE
    WHEN price < 0 THEN 0 ELSE price
END
+
CASE
    WHEN freight_value < 0 THEN 0 ELSE freight_value
END,

---------------------------------------------------------
-- ETL Date
---------------------------------------------------------

GETDATE(),

---------------------------------------------------------
-- Source System
---------------------------------------------------------

'OLIST_ECOMMERCE'

FROM raw.order_items;

GO

/*==============================================================
STEP 5 : VALIDATION
==============================================================*/

---------------------------------------------------------
-- Raw vs Staging Count
---------------------------------------------------------

SELECT

'RAW_ORDER_ITEMS' AS table_name,

COUNT(*) AS total_records

FROM raw.order_items

UNION ALL

SELECT

'STAGING_ORDER_ITEMS',

COUNT(*)

FROM staging.order_items;

---------------------------------------------------------
-- Duplicate Composite Key
---------------------------------------------------------

SELECT

order_id,

order_item_id,

COUNT(*) AS duplicate_count

FROM staging.order_items

GROUP BY

order_id,

order_item_id

HAVING COUNT(*) > 1;

---------------------------------------------------------
-- Invalid Prices
---------------------------------------------------------

SELECT *

FROM staging.order_items

WHERE price < 0;

---------------------------------------------------------
-- Invalid Freight
---------------------------------------------------------

SELECT *

FROM staging.order_items

WHERE freight_value < 0;

---------------------------------------------------------
-- Total Amount Validation
---------------------------------------------------------

SELECT TOP 20

price,

freight_value,

total_amount

FROM staging.order_items;

---------------------------------------------------------
-- Shipping Date Check
---------------------------------------------------------

SELECT TOP 20

shipping_limit_date

FROM staging.order_items

ORDER BY shipping_limit_date;

GO
