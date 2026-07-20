--Total Records
SELECT COUNT(*) AS total_orders
FROM raw.orders;

--Duplicate Orders
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM raw.orders
GROUP BY order_id
HAVING COUNT(*) > 1;

--NULL Analysis

SELECT

SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS null_order_id,

SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,

SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS null_status,

SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS null_purchase,

SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS null_approved,

SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS null_carrier,

SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS null_customer_delivery,

SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS null_estimated

  
--Order Status Check
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM raw.orders
GROUP BY order_status
ORDER BY total_orders DESC;


--Date Validation
SELECT *
FROM raw.orders
WHERE order_purchase_timestamp >
      order_estimated_delivery_date;
FROM raw.orders;
