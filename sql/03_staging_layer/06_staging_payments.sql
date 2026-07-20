/*
====================================================================

Project Name : ShopSphere Analytics Warehouse

Layer        : STAGING

Script       : 05_staging_payments.sql

Source       : raw.payments

Target       : staging.payments

Purpose
-------
Clean payment transaction data before loading into
the Data Warehouse.

Cleaning Rules
--------------
1. Remove leading/trailing spaces
2. Standardize payment type
3. Validate installments
4. Validate payment value
5. Add ETL metadata

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

DROP TABLE IF EXISTS staging.payments;
GO

/*==============================================================
STEP 3 : CREATE TABLE
==============================================================*/

CREATE TABLE staging.payments
(
    order_id VARCHAR(50) NOT NULL,

    payment_sequential INT NOT NULL,

    payment_type VARCHAR(50),

    payment_installments INT,

    payment_value DECIMAL(10,2),

    etl_created_date DATETIME,

    source_system VARCHAR(50)
);

GO

/*==============================================================
STEP 4 : LOAD CLEAN DATA
==============================================================*/

INSERT INTO staging.payments
(
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value,
    etl_created_date,
    source_system
)

SELECT

---------------------------------------------------------
-- Order ID
---------------------------------------------------------

TRIM(order_id),

---------------------------------------------------------
-- Payment Sequence
---------------------------------------------------------

payment_sequential,

---------------------------------------------------------
-- Payment Type
---------------------------------------------------------

UPPER(TRIM(payment_type)),

---------------------------------------------------------
-- Installments
---------------------------------------------------------

CASE

WHEN payment_installments < 0

THEN 0

ELSE payment_installments

END,

---------------------------------------------------------
-- Payment Value
---------------------------------------------------------

CASE

WHEN payment_value < 0

THEN 0

ELSE payment_value

END,

---------------------------------------------------------
-- ETL Date
---------------------------------------------------------

GETDATE(),

---------------------------------------------------------
-- Source System
---------------------------------------------------------

'OLIST_ECOMMERCE'

FROM raw.payments;

GO

/*==============================================================
STEP 5 : VALIDATION
==============================================================*/

---------------------------------------------------------
-- Raw vs Staging Count
---------------------------------------------------------

SELECT

'RAW_PAYMENTS' AS table_name,

COUNT(*) AS total_records

FROM raw.payments

UNION ALL

SELECT

'STAGING_PAYMENTS',

COUNT(*)

FROM staging.payments;

---------------------------------------------------------
-- Duplicate Composite Key
---------------------------------------------------------

SELECT

order_id,

payment_sequential,

COUNT(*) AS duplicate_count

FROM staging.payments

GROUP BY

order_id,

payment_sequential

HAVING COUNT(*) > 1;

---------------------------------------------------------
-- Invalid Payment Values
---------------------------------------------------------

SELECT *

FROM staging.payments

WHERE payment_value < 0;

---------------------------------------------------------
-- Invalid Installments
---------------------------------------------------------

SELECT *

FROM staging.payments

WHERE payment_installments < 0;

---------------------------------------------------------
-- Payment Type Distribution
---------------------------------------------------------

SELECT

payment_type,

COUNT(*) AS total_payments

FROM staging.payments

GROUP BY payment_type

ORDER BY total_payments DESC;

---------------------------------------------------------
-- Payment Statistics
---------------------------------------------------------

SELECT

AVG(payment_value) AS average_payment,

MIN(payment_value) AS minimum_payment,

MAX(payment_value) AS maximum_payment

FROM staging.payments;

---------------------------------------------------------
-- Installment Statistics
---------------------------------------------------------

SELECT

AVG(payment_installments) AS average_installments,

MIN(payment_installments) AS minimum_installments,

MAX(payment_installments) AS maximum_installments

FROM staging.payments;

GO
