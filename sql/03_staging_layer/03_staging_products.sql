DROP TABLE IF EXISTS staging.products;
GO

CREATE TABLE staging.products
(
    product_id VARCHAR(50) NOT NULL,

    product_category_name VARCHAR(100),

    product_name_lenght INT,

    product_description_lenght INT,

    product_photos_qty INT,

    product_weight_g INT,

    product_length_cm INT,

    product_height_cm INT,

    product_width_cm INT,

    etl_created_date DATETIME,

    source_system VARCHAR(50)
);

GO

INSERT INTO staging.products
(
    product_id,
    product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    etl_created_date,
    source_system
)

SELECT

TRIM(product_id),

CASE
    WHEN product_category_name IS NULL
         OR TRIM(product_category_name) = ''
    THEN 'UNKNOWN'
    ELSE UPPER(TRIM(product_category_name))
END,

ISNULL(product_name_lenght,0),

ISNULL(product_description_lenght,0),

ISNULL(product_photos_qty,0),

ISNULL(product_weight_g,0),

ISNULL(product_length_cm,0),

ISNULL(product_height_cm,0),

ISNULL(product_width_cm,0),

GETDATE(),

'OLIST_ECOMMERCE'

FROM raw.products;

GO

SELECT
'RAW_PRODUCTS' AS table_name,
COUNT(*) AS total_records
FROM raw.products

UNION ALL

SELECT
'STAGING_PRODUCTS',
COUNT(*)
FROM staging.products;

SELECT
product_id,
COUNT(*) AS duplicate_count
FROM staging.products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT
COUNT(*) AS unknown_category_count
FROM staging.products
WHERE product_category_name='UNKNOWN';

SELECT TOP 20 *
FROM staging.products;


