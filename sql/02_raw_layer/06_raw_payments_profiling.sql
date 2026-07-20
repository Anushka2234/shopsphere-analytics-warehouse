/*
====================================================================

Project Name : ShopSphere Analytics Warehouse

Layer        : RAW

Script       : 05_raw_payments_profiling.sql

Table        : raw.payments

Purpose
-------
Perform data profiling before loading data into staging layer.

Checks Included
---------------
1. Record Count
2. Duplicate Records
3. NULL Analysis
4. Blank Value Analysis
5. Payment Type Distribution
6. Installment Statistics
7. Payment Value Statistics
8. Invalid Values
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
FROM raw.payments;

GO

/*==============================================================
CHECK 2 : DUPLICATE COMPOSITE KEY
(order_id + payment_sequential)
==============================================================*/

SELECT

order_id,

payment_sequential,

COUNT(*) AS duplicate_count

FROM raw.payments

GROUP BY

order_id,

payment_sequential

HAVING COUNT(*) > 1;

GO

/*==============================================================
CHECK 3 : NULL VALUE ANALYSIS
==============================================================*/

SELECT

SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,

SUM(CASE WHEN payment_sequential IS NULL THEN 1 ELSE 0 END) AS null_payment_sequence,

SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS null_payment_type,

SUM(CASE WHEN payment_installments IS NULL THEN 1 ELSE 0 END) AS null_installments,

SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS null_payment_value

FROM raw.payments;

GO

/*==============================================================
CHECK 4 : BLANK VALUES
==============================================================*/

SELECT

SUM(CASE WHEN TRIM(order_id)='' THEN 1 ELSE 0 END) AS blank_order_id,

SUM(CASE WHEN TRIM(payment_type)='' THEN 1 ELSE 0 END) AS blank_payment_type

FROM raw.payments;

GO

/*==============================================================
CHECK 5 : PAYMENT TYPE DISTRIBUTION
==============================================================*/

SELECT

payment_type,

COUNT(*) AS total_payments

FROM raw.payments

GROUP BY payment_type

ORDER BY total_payments DESC;

GO

/*==============================================================
CHECK 6 : INSTALLMENT STATISTICS
==============================================================*/

SELECT

MIN(payment_installments) AS minimum_installments,

MAX(payment_installments) AS maximum_installments,

AVG(payment_installments) AS average_installments

FROM raw.payments;

GO

/*==============================================================
CHECK 7 : PAYMENT VALUE STATISTICS
==============================================================*/

SELECT

MIN(payment_value) AS minimum_payment,

MAX(payment_value) AS maximum_payment,

AVG(payment_value) AS average_payment

FROM raw.payments;

GO

/*==============================================================
CHECK 8 : INVALID VALUES
==============================================================*/

-- Negative Installments

SELECT *

FROM raw.payments

WHERE payment_installments < 0;

GO

-- Negative Payment Value

SELECT *

FROM raw.payments

WHERE payment_value < 0;

GO

/*==============================================================
CHECK 9 : SAMPLE DATA
==============================================================*/

SELECT TOP 20 *

FROM raw.payments;

GO
