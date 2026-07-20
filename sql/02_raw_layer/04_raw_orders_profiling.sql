/*
===============================================================================
Project      : ShopSphere Analytics Warehouse
Layer        : Raw Layer
Script Name  : 04_raw_orders_profiling.sql
Source Table : raw.orders

Description
-----------
Performs data profiling on the raw.orders table before loading data into the
Staging Layer. This script validates record completeness, detects duplicates,
checks order status values, validates timestamps, and identifies potential
business data quality issues.

Profiling Checks
----------------
1. Total Record Count
2. Duplicate Order IDs
3. NULL Value Analysis
4. Order Status Distribution
5. Invalid Order Status
6. Date Validation
7. Order Year Distribution
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
FROM raw.orders;
GO

/*=============================================================================
CHECK 2 : DUPLICATE ORDER IDs
=============================================================================*/

SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM raw.orders
GROUP BY order_id
HAVING COUNT(*) > 1;
GO

/*=============================================================================
CHECK 3 : NULL VALUE ANALYSIS
=============================================================================*/

SELECT

SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,

SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,

SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS null_order_status,

SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS null_purchase_timestamp,

SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS null_approved_at,

SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS null_carrier_date,

SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS null_customer_delivery_date,

SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS null_estimated_delivery_date

FROM raw.orders;
GO

/*=============================================================================
CHECK 4 : ORDER STATUS DISTRIBUTION
=============================================================================*/

SELECT

order_status,

COUNT(*) AS total_orders

FROM raw.orders

GROUP BY order_status

ORDER BY total_orders DESC;
GO

/*=============================================================================
CHECK 5 : INVALID ORDER STATUS
=============================================================================*/

SELECT *

FROM raw.orders

WHERE order_status NOT IN
(
'created',
'approved',
'invoiced',
'processing',
'shipped',
'delivered',
'canceled',
'unavailable'
);
GO

/*=============================================================================
CHECK 6 : DATE VALIDATION
Identify orders where the delivery date occurs before the purchase date.
=============================================================================*/

SELECT *

FROM raw.orders

WHERE order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date < order_purchase_timestamp;
GO

/*=============================================================================
CHECK 7 : ORDER YEAR DISTRIBUTION
=============================================================================*/

SELECT

YEAR(order_purchase_timestamp) AS order_year,

COUNT(*) AS total_orders

FROM raw.orders

GROUP BY YEAR(order_purchase_timestamp)

ORDER BY order_year;
GO

/*=============================================================================
CHECK 8 : SAMPLE DATA
=============================================================================*/

SELECT TOP (20) *

FROM raw.orders;
GO

/*=============================================================================
END OF SCRIPT
=============================================================================*/
