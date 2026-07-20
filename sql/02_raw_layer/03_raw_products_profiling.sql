SELECT COUNT(*) AS total_products
FROM raw.products;

SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM raw.products
GROUP BY product_id
HAVING COUNT(*) > 1;

--NULL Check
SELECT

SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS null_category,

SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END) AS null_name_length,

SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END) AS null_description_length,

SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END) AS null_photos,

SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) AS null_weight,

SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) AS null_length,

SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END) AS null_height,

SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) AS null_width

FROM raw.products;

