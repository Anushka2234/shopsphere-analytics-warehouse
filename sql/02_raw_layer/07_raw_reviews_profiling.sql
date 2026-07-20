/*
====================================================================

Project Name : ShopSphere Analytics Warehouse

Layer        : RAW

Script       : 07_raw_reviews_profiling.sql

Table        : raw.reviews

Purpose
-------
Perform data profiling before loading into staging layer.

Checks Included
---------------
1. Record Count
2. Duplicate Review IDs
3. NULL Analysis
4. Blank Value Analysis
5. Review Score Distribution
6. Invalid Review Scores
7. Review Date Analysis
8. Sample Data

====================================================================
*/

USE ShopSphereDW;
GO

/*==============================================================
CHECK 1 : TOTAL RECORDS
==============================================================*/

SELECT
COUNT(*) AS total_records
FROM raw.reviews;

GO

/*==============================================================
CHECK 2 : DUPLICATE REVIEW IDS
==============================================================*/

SELECT

review_id,

COUNT(*) AS duplicate_count

FROM raw.reviews

GROUP BY review_id

HAVING COUNT(*) > 1;

GO

/*==============================================================
CHECK 3 : NULL VALUE ANALYSIS
==============================================================*/

SELECT

SUM(CASE WHEN review_id IS NULL THEN 1 ELSE 0 END) AS null_review_id,

SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,

SUM(CASE WHEN review_score IS NULL THEN 1 ELSE 0 END) AS null_review_score,

SUM(CASE WHEN review_comment_title IS NULL THEN 1 ELSE 0 END) AS null_review_title,

SUM(CASE WHEN review_comment_message IS NULL THEN 1 ELSE 0 END) AS null_review_message,

SUM(CASE WHEN review_creation_date IS NULL THEN 1 ELSE 0 END) AS null_review_creation_date,

SUM(CASE WHEN review_answer_timestamp IS NULL THEN 1 ELSE 0 END) AS null_review_answer_timestamp

FROM raw.reviews;

GO

/*==============================================================
CHECK 4 : BLANK VALUE ANALYSIS
==============================================================*/

SELECT

SUM(CASE WHEN TRIM(review_id)='' THEN 1 ELSE 0 END) AS blank_review_id,

SUM(CASE WHEN TRIM(order_id)='' THEN 1 ELSE 0 END) AS blank_order_id,

SUM(CASE WHEN TRIM(ISNULL(review_comment_title,''))='' THEN 1 ELSE 0 END) AS blank_review_title,

SUM(CASE WHEN TRIM(ISNULL(review_comment_message,''))='' THEN 1 ELSE 0 END) AS blank_review_message

FROM raw.reviews;

GO

/*==============================================================
CHECK 5 : REVIEW SCORE DISTRIBUTION
==============================================================*/

SELECT

review_score,

COUNT(*) AS total_reviews

FROM raw.reviews

GROUP BY review_score

ORDER BY review_score;

GO

/*==============================================================
CHECK 6 : INVALID REVIEW SCORES
==============================================================*/

SELECT *

FROM raw.reviews

WHERE review_score NOT BETWEEN 1 AND 5;

GO

/*==============================================================
CHECK 7 : DATE RANGE
==============================================================*/

SELECT

MIN(review_creation_date) AS first_review,

MAX(review_creation_date) AS last_review,

MIN(review_answer_timestamp) AS first_answer,

MAX(review_answer_timestamp) AS last_answer

FROM raw.reviews;

GO

/*==============================================================
CHECK 8 : SAMPLE DATA
==============================================================*/

SELECT TOP 20 *

FROM raw.reviews;

GO
