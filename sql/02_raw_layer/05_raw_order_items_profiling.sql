/*
===============================================================================
Project      : ShopSphere Analytics Warehouse
Layer        : Raw Layer
Script Name  : 05_raw_order_items_profiling.sql
Source Table : raw.order_items

Description
-----------
Performs data profiling on the raw.order_items table before loading data into
the Staging Layer. This script evaluates data completeness, duplicate records,
missing values, pricing anomalies, freight charges, and shipping dates.

Profiling Checks
----------------
1. Total Record Count
2. Duplicate Order Item Records
3. NULL Value Analysis
4. Price Validation
5. Freight Value Validation
6. Top Selling Products
7. Top Sellers
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
FROM raw.order_items;
GO

/*=============================================================================
CHECK 2 : DUPLICATE ORDER ITEMS
Business Key = (order_id, order_item_id)
=============================================================================*/

SELECT
    order_id,
    order_item_id,
    COUNT(*) AS duplicate_count
FROM raw.order_items
GROUP BY
    order_id,
    order_item_id
HAVING COUNT(*) > 1;
GO

/*=============================================================================
CHECK 3 : NULL VALUE ANALYSIS
=============================================================================*/

SELECT

SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,

SUM(CASE WHEN order_item_id IS NULL THEN 1 ELSE 0 END) AS null_order_item_id,

SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,

SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS null_seller_id,

SUM(CASE WHEN shipping_limit_date IS NULL THEN 1 ELSE 0 END) AS null_shipping_limit_date,

SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS null_price,

SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS null_freight_value

FROM raw.order_items;
GO

/*=============================================================================
CHECK 4 : INVALID PRICE VALUES
=============================================================================*/

SELECT *

FROM raw.order_items

WHERE price < 0;
GO

/*=============================================================================
CHECK 5 : INVALID FREIGHT VALUES
=============================================================================*/

SELECT *

FROM raw.order_items

WHERE freight_value < 0;
GO

/*=============================================================================
CHECK 6 : TOP 20 PRODUCTS BY NUMBER OF ORDER ITEMS
=============================================================================*/

SELECT TOP (20)

product_id,

COUNT(*) AS total_order_items

FROM raw.order_items

GROUP BY product_id

ORDER BY total_order_items DESC;
GO

/*=============================================================================
CHECK 7 : TOP 20 SELLERS BY NUMBER OF ORDER ITEMS
=============================================================================*/

SELECT TOP (20)

seller_id,

COUNT(*) AS total_order_items

FROM raw.order_items

GROUP BY seller_id

ORDER BY total_order_items DESC;
GO

/*=============================================================================
CHECK 8 : SAMPLE DATA
=============================================================================*/

SELECT TOP (20) *

FROM raw.order_items;
GO

/*=============================================================================
END OF SCRIPT
=============================================================================*/
