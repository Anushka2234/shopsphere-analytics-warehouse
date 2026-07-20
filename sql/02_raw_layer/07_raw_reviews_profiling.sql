/*
===============================================================================
Project      : ShopSphere Analytics Warehouse
Layer        : Raw Layer
Script Name  : 07_raw_reviews_profiling.sql
Source Table : raw.reviews

Description
-----------
Performs data profiling on the raw.reviews table before loading data into the
Staging Layer. This script evaluates data completeness, duplicate reviews,
review score distribution, missing values, timestamp consistency, and overall
review quality.

Profiling Checks
----------------
1. Total Record Count
2. Duplicate Review IDs
3. NULL Value Analysis
4. Review Score Distribution
5. Invalid Review Scores
6. Review Timeline Validation
7. Missing Review Comments
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
FROM raw.reviews;
GO

/*=============================================================================
CHECK 2 : DUPLICATE REVIEW IDs
=============================================================================*/

SELECT
    review_id,
    COUNT(*) AS duplicate_count
FROM raw.reviews
GROUP BY review_id
HAVING COUNT(*) > 1;
GO

/*=============================================================================
CHECK 3 : NULL VALUE ANALYSIS
=============================================================================*/

SELECT

SUM(CASE WHEN review_id IS NULL THEN 1 ELSE 0 END) AS null_review_id,

SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,

SUM(CASE WHEN review_score IS NULL THEN 1 ELSE 0 END) AS null_review_score,

SUM(CASE WHEN review_comment_title IS NULL THEN 1 ELSE 0 END) AS null_review_title,

SUM(CASE WHEN review_comment_message IS NULL THEN 1 ELSE 0 END) AS null_review_message,

SUM(CASE WHEN review_creation_date IS NULL THEN 1 ELSE 0 END) AS null_creation_date,

SUM(CASE WHEN review_answer_timestamp IS NULL THEN 1 ELSE 0 END) AS null_answer_timestamp

FROM raw.reviews;
GO

/*=============================================================================
CHECK 4 : REVIEW SCORE DISTRIBUTION
=============================================================================*/

SELECT

review_score,

COUNT(*) AS total_reviews

FROM raw.reviews

GROUP BY review_score

ORDER BY review_score;
GO

/*=============================================================================
CHECK 5 : INVALID REVIEW SCORES
Valid review scores should be between 1 and 5.
=============================================================================*/

SELECT *

FROM raw.reviews

WHERE review_score NOT BETWEEN 1 AND 5;
GO

/*=============================================================================
CHECK 6 : REVIEW TIMELINE VALIDATION
Checks if the review response occurred before the review was created.
=============================================================================*/

SELECT *

FROM raw.reviews

WHERE review_creation_date IS NOT NULL
  AND review_answer_timestamp IS NOT NULL
  AND review_answer_timestamp < review_creation_date;
GO

/*=============================================================================
CHECK 7 : REVIEWS WITHOUT COMMENTS
Useful to understand how many reviews contain only ratings.
=============================================================================*/

SELECT *

FROM raw.reviews

WHERE
    TRIM(ISNULL(review_comment_title, '')) = ''
AND TRIM(ISNULL(review_comment_message, '')) = '';
GO

/*=============================================================================
CHECK 8 : SAMPLE DATA
=============================================================================*/

SELECT TOP (20) *

FROM raw.reviews;
GO

/*=============================================================================
END OF SCRIPT
=============================================================================*/
