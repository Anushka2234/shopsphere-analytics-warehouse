/*
====================================================================

Project Name : ShopSphere Analytics Warehouse

Layer        : STAGING

Script       : 07_staging_reviews.sql

Source       : raw.reviews

Target       : staging.reviews

Purpose
-------
Clean customer review data before loading into
the Data Warehouse.

Cleaning Rules
--------------
1. Trim spaces
2. Validate review score
3. Keep NULL review title/message (business meaning)
4. Convert dates to DATETIME
5. Add ETL metadata

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

DROP TABLE IF EXISTS staging.reviews;
GO

/*==============================================================
STEP 3 : CREATE TABLE
==============================================================*/

CREATE TABLE staging.reviews
(
review_id VARCHAR(50) NOT NULL,

order_id VARCHAR(50) NOT NULL,

review_score INT,

review_comment_title NVARCHAR(500),

review_comment_message NVARCHAR(MAX),

review_creation_date DATETIME,

review_answer_timestamp DATETIME,

etl_created_date DATETIME,

source_system VARCHAR(50)
);

GO

/*==============================================================
STEP 4 : LOAD DATA
==============================================================*/

INSERT INTO staging.reviews
(
review_id,
order_id,
review_score,
review_comment_title,
review_comment_message,
review_creation_date,
review_answer_timestamp,
etl_created_date,
source_system
)

SELECT

TRIM(review_id),

TRIM(order_id),

CASE
WHEN review_score < 1 THEN 1
WHEN review_score > 5 THEN 5
ELSE review_score
END,

CASE
WHEN review_comment_title IS NULL THEN NULL
ELSE TRIM(review_comment_title)
END,

CASE
WHEN review_comment_message IS NULL THEN NULL
ELSE TRIM(review_comment_message)
END,

TRY_CAST(review_creation_date AS DATETIME),

TRY_CAST(review_answer_timestamp AS DATETIME),

GETDATE(),

'OLIST_ECOMMERCE'

FROM raw.reviews;

GO

/*==============================================================
STEP 5 : VALIDATION
==============================================================*/

-- Row Count

SELECT

'RAW_REVIEWS' AS table_name,

COUNT(*) AS total_records

FROM raw.reviews

UNION ALL

SELECT

'STAGING_REVIEWS',

COUNT(*)

FROM staging.reviews;

GO

-- Duplicate Review IDs

SELECT

review_id,

COUNT(*) AS duplicate_count

FROM staging.reviews

GROUP BY review_id

HAVING COUNT(*) > 1;

GO

-- Invalid Scores

SELECT *

FROM staging.reviews

WHERE review_score NOT BETWEEN 1 AND 5;

GO

-- Review Score Distribution

SELECT

review_score,

COUNT(*) AS total_reviews

FROM staging.reviews

GROUP BY review_score

ORDER BY review_score;

GO

-- NULL Review Titles

SELECT

COUNT(*) AS null_review_titles

FROM staging.reviews

WHERE review_comment_title IS NULL;

GO

-- NULL Review Messages

SELECT

COUNT(*) AS null_review_messages

FROM staging.reviews

WHERE review_comment_message IS NULL;

GO

-- Sample Data

SELECT TOP 20 *

FROM staging.reviews;

GO
