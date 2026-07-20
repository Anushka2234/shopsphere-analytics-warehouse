use [ShopSphereDW]

/* ==========================================================
   CREATE STAGING SCHEMA
   ========================================================== */

IF NOT EXISTS 
(
	SELECT 1 
	FROM sys.schemas 
	WHERE name = 'staging'
)
BEGIN
	EXEC('CREATE SCHEMA staging')
END

GO


/* ==========================================================
   STAGING LAYER : OLIST CUSTOMERS
   ========================================================== */


DROP TABLE IF EXISTS staging.customers;
GO


CREATE TABLE staging.customers
(
	customer_id VARCHAR(50),

	customer_unique_id VARCHAR(50),

	customer_zip_code_prefix VARCHAR(50),

	customer_city VARCHAR(100),

	customer_state CHAR(2),

	etl_created_date DATETIME,

	source_system VARCHAR(50)
);

GO



/* ==========================================================
   LOAD CLEAN DATA INTO STAGING
   ========================================================== */


INSERT INTO staging.customers
(
	customer_id,
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state,
	etl_created_date,
	source_system
)


SELECT


/* Customer ID */

TRIM(customer_id)
AS customer_id,



/* Customer Unique ID */

TRIM(customer_unique_id)
AS customer_unique_id,



/* ZIP Code */

TRIM(
CAST(customer_zip_code_prefix AS VARCHAR(50))
)
AS customer_zip_code_prefix,



/* Customer City */

CASE

WHEN customer_city IS NULL
OR TRIM(customer_city) = ''

THEN 'UNKNOWN'


ELSE

UPPER
(
	TRIM
	(
		REPLACE
		(
			REPLACE
			(
				customer_city,
				CHAR(13),
				''
			),
			CHAR(10),
			''
		)
	)
)

END
AS customer_city,



/* Customer State */

CASE

WHEN customer_state IS NULL
OR TRIM(customer_state) = ''

THEN 'UN'


ELSE

UPPER(TRIM(customer_state))

END
AS customer_state,



/* ETL Date */

GETDATE()
AS etl_created_date,



/* Source */

'OLIST_ECOMMERCE'
AS source_system



FROM raw.customers;

GO



/* ==========================================================
   VALIDATE STAGING LOAD
   ========================================================== */


SELECT COUNT(*) AS total_records
FROM staging.customers;


SELECT TOP 100 *
FROM staging.customers;

Select distinct customer_city from staging.customers;
