/*
===============================================================================
Project      : ShopSphere Analytics Warehouse
Layer        : Raw Layer
Script Name  : 06_raw_payments_profiling.sql
Source Table : raw.payments

Description
-----------
Performs data profiling on the raw.payments table before loading data into the
Staging Layer. The objective is to evaluate data quality, identify duplicate
payment records, validate payment values, analyze payment methods, and detect
missing or invalid data.

Profiling Checks
----------------
1. Total Record Count
2. Duplicate Payment Records
3. NULL Value Analysis
4. Payment Type Distribution
5. Payment Installments Analysis
6. Invalid Payment Values
7. Payment Value Statistics
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
FROM raw.payments;
GO

/*=============================================================================
CHECK 2 : DUPLICATE PAYMENT RECORDS
Business Key = (order_id, payment_sequential)
=============================================================================*/

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

/*=============================================================================
CHECK 3 : NULL VALUE ANALYSIS
=============================================================================*/

SELECT

SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,

SUM(CASE WHEN payment_sequential IS NULL THEN 1 ELSE 0 END) AS null_payment_sequential,

SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS null_payment_type,

SUM(CASE WHEN payment_installments IS NULL THEN 1 ELSE 0 END) AS null_payment_installments,

SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS null_payment_value

FROM raw.payments;
GO

/*=============================================================================
CHECK 4 : PAYMENT TYPE DISTRIBUTION
=============================================================================*/

SELECT

payment_type,

COUNT(*) AS total_transactions

FROM raw.payments

GROUP BY payment_type

ORDER BY total_transactions DESC;
GO

/*=============================================================================
CHECK 5 : PAYMENT INSTALLMENTS ANALYSIS
=============================================================================*/

SELECT

payment_installments,

COUNT(*) AS total_transactions

FROM raw.payments

GROUP BY payment_installments

ORDER BY payment_installments;
GO

/*=============================================================================
CHECK 6 : INVALID PAYMENT VALUES
=============================================================================*/

SELECT *

FROM raw.payments

WHERE payment_value < 0
   OR payment_installments < 0;
GO

/*=============================================================================
CHECK 7 : PAYMENT VALUE STATISTICS
=============================================================================*/

SELECT

MIN(payment_value) AS minimum_payment,

MAX(payment_value) AS maximum_payment,

AVG(payment_value) AS average_payment,

SUM(payment_value) AS total_payment_value

FROM raw.payments;
GO

/*=============================================================================
CHECK 8 : SAMPLE DATA
=============================================================================*/

SELECT TOP (20) *

FROM raw.payments;
GO

/*=============================================================================
END OF SCRIPT
=============================================================================*/
