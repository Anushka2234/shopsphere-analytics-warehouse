/*
====================================================================

Project Name : ShopSphere Analytics Warehouse

Layer        : STAGING

Script       : 03_staging_orders.sql

Source       : raw.orders

Target       : staging.orders

Purpose
-------
Clean and prepare order transaction data before loading into
the Data Warehouse.

Cleaning Rules
--------------
1. Remove leading/trailing spaces
2. Standardize order status
3. Convert timestamps to DATETIME
4. Preserve NULL business dates
5. Calculate Approval Time
6. Calculate Delivery Time
7. Add ETL metadata

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
    WHERE name='staging'
)
BEGIN
    EXEC('CREATE SCHEMA staging');
END;
GO

/*==============================================================
STEP 2 : DROP TABLE
==============================================================*/

DROP TABLE IF EXISTS staging.orders;
GO

/*==============================================================
STEP 3 : CREATE TABLE
==============================================================*/

CREATE TABLE staging.orders
(

    order_id VARCHAR(50) NOT NULL,

    customer_id VARCHAR(50) NOT NULL,

    order_status VARCHAR(30),

    order_purchase_timestamp DATETIME,

    order_approved_at DATETIME,

    order_delivered_carrier_date DATETIME,

    order_delivered_customer_date DATETIME,

    order_estimated_delivery_date DATETIME,

    approval_minutes INT,

    delivery_days INT,

    etl_created_date DATETIME,

    source_system VARCHAR(50)

);

GO

/*==============================================================
STEP 4 : LOAD CLEAN DATA
==============================================================*/

INSERT INTO staging.orders
(

order_id,

customer_id,

order_status,

order_purchase_timestamp,

order_approved_at,

order_delivered_carrier_date,

order_delivered_customer_date,

order_estimated_delivery_date,

approval_minutes,

delivery_days,

etl_created_date,

source_system

)

SELECT


---------------------------------------------------------
-- Order ID
---------------------------------------------------------

TRIM(order_id),

---------------------------------------------------------
-- Customer ID
---------------------------------------------------------

TRIM(customer_id),

---------------------------------------------------------
-- Order Status
---------------------------------------------------------

UPPER(TRIM(order_status)),

---------------------------------------------------------
-- Purchase Date
---------------------------------------------------------

TRY_CAST(order_purchase_timestamp AS DATETIME),

---------------------------------------------------------
-- Approved Date
---------------------------------------------------------

TRY_CAST(order_approved_at AS DATETIME),

---------------------------------------------------------
-- Carrier Date
---------------------------------------------------------

TRY_CAST(order_delivered_carrier_date AS DATETIME),

---------------------------------------------------------
-- Customer Delivery Date
---------------------------------------------------------

TRY_CAST(order_delivered_customer_date AS DATETIME),

---------------------------------------------------------
-- Estimated Delivery Date
---------------------------------------------------------

TRY_CAST(order_estimated_delivery_date AS DATETIME),

---------------------------------------------------------
-- Approval Minutes
---------------------------------------------------------

CASE

WHEN order_approved_at IS NULL

THEN NULL

ELSE

DATEDIFF
(
MINUTE,

TRY_CAST(order_purchase_timestamp AS DATETIME),

TRY_CAST(order_approved_at AS DATETIME)

)

END,

---------------------------------------------------------
-- Delivery Days
---------------------------------------------------------

CASE

WHEN order_delivered_customer_date IS NULL

THEN NULL

ELSE

DATEDIFF
(
DAY,

TRY_CAST(order_purchase_timestamp AS DATETIME),

TRY_CAST(order_delivered_customer_date AS DATETIME)

)

END,

---------------------------------------------------------
-- ETL Date
---------------------------------------------------------

GETDATE(),

---------------------------------------------------------
-- Source System
---------------------------------------------------------

'OLIST_ECOMMERCE'

FROM raw.orders;

GO

/*==============================================================
STEP 5 : VALIDATION
==============================================================*/

---------------------------------------------------------
-- Raw vs Staging Count
---------------------------------------------------------

SELECT

'RAW_ORDERS' AS table_name,

COUNT(*) AS total_records

FROM raw.orders

UNION ALL

SELECT

'STAGING_ORDERS',

COUNT(*)

FROM staging.orders;

---------------------------------------------------------
-- Duplicate Orders
---------------------------------------------------------

SELECT

order_id,

COUNT(*) AS duplicate_count

FROM staging.orders

GROUP BY order_id

HAVING COUNT(*) > 1;

---------------------------------------------------------
-- NULL Customer Check
---------------------------------------------------------

SELECT

COUNT(*) AS null_customer_count

FROM staging.orders

WHERE customer_id IS NULL;

---------------------------------------------------------
-- Invalid Delivery Days
---------------------------------------------------------

SELECT *

FROM staging.orders

WHERE delivery_days < 0;

---------------------------------------------------------
-- Order Status Distribution
---------------------------------------------------------

SELECT

order_status,

COUNT(*) AS total_orders

FROM staging.orders

GROUP BY order_status

ORDER BY total_orders DESC;

---------------------------------------------------------
-- Delivery Performance
---------------------------------------------------------

SELECT

AVG(delivery_days) AS avg_delivery_days,

MIN(delivery_days) AS minimum_days,

MAX(delivery_days) AS maximum_days

FROM staging.orders;

---------------------------------------------------------
-- Approval Performance
---------------------------------------------------------

SELECT

AVG(approval_minutes) AS avg_approval_minutes,

MIN(approval_minutes) AS minimum_minutes,

MAX(approval_minutes) AS maximum_minutes

FROM staging.orders;

GO
