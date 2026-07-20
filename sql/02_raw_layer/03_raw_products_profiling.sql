/*
===============================================================================
Project      : ShopSphere Analytics Warehouse
Layer        : Raw Layer
Script Name  : 03_raw_products_profiling.sql
Source Table : raw.products

Description
-----------
Performs data profiling on the raw.products table before loading data into the
Staging Layer. The objective is to identify missing values, duplicate products,
invalid measurements, and understand product category distribution.

Profiling Checks
----------------
1. Total Record Count
2. Duplicate Product IDs
3. NULL Value Analysis
4. Product Category Distribution
5. Invalid Numeric Values
6. Missing Product Categories
7. Sample Data Inspection

===============================================================================
*/

USE ShopSphereDW;
GO

/*=============================================================================
CHECK 1 : TOTAL RECORD COUNT
=============================================================================*/

SELECT
    COUNT(*) AS total_records
FROM raw.products;
GO

/*=============================================================================
CHECK 2 : DUPLICATE PRODUCT IDs
=============================================================================*/

SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM raw.products
GROUP BY product_id
HAVING COUNT(*) > 1;
GO

/*=============================================================================
CHECK 3 : NULL VALUE ANALYSIS
=============================================================================*/

SELECT

SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,

SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS null_category,

SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END) AS null_name_length,

SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END) AS null_description_length,

SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END) AS null_photos,

SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) AS null_weight,

SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) AS null_length,

SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END) AS null_height,

SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) AS null_width

FROM raw.products;
GO

/*=============================================================================
CHECK 4 : PRODUCT CATEGORY DISTRIBUTION
=============================================================================*/

SELECT

product_category_name,

COUNT(*) AS total_products

FROM raw.products

GROUP BY product_category_name

ORDER BY total_products DESC;
GO

/*=============================================================================
CHECK 5 : INVALID NUMERIC VALUES
=============================================================================*/

SELECT *

FROM raw.products

WHERE

product_weight_g < 0

OR product_length_cm < 0

OR product_height_cm < 0

OR product_width_cm < 0

OR product_photos_qty < 0;
GO

/*=============================================================================
CHECK 6 : PRODUCTS WITH MISSING CATEGORY
=============================================================================*/

SELECT *

FROM raw.products

WHERE product_category_name IS NULL;
GO

/*=============================================================================
CHECK 7 : SAMPLE DATA
=============================================================================*/

SELECT TOP (20) *

FROM raw.products;
GO

/*=============================================================================
END OF SCRIPT
=============================================================================*/
