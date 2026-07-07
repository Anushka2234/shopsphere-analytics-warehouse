# Source System Analysis Document

Project:
ShopSphere Enterprise Analytics Warehouse


## Purpose

This document analyzes the source systems used for building the data warehouse.

It explains:

- Source datasets
- Business purpose
- Table relationships
- Important columns
- Target warehouse usage


# Source System Overview

The source data represents an e-commerce marketplace platform.

The operational systems include:

1. Customer Management System

2. Order Management System

3. Product Management System

4. Payment System

5. Seller Management System

6. Review System

7. Location Management System


# Source Tables


## 1. Customers


Source File:

olist_customers_dataset.csv


Business Purpose:

Stores customer profile and location information.


Primary Key:

customer_id


Important Columns:

customer_id

customer_unique_id

customer_city

customer_state


Used For:

Customer analytics

Customer segmentation


Warehouse Target:

dim_customer



---


## 2. Orders


Source File:

olist_orders_dataset.csv


Business Purpose:

Stores customer purchase transactions.


Primary Key:

order_id


Foreign Key:

customer_id


Important Columns:

order_status

order_purchase_timestamp

order_delivered_customer_date


Used For:

Sales analysis

Delivery performance


Warehouse Usage:

fact_sales



---


## 3. Order Items


Source:

olist_order_items_dataset.csv


Purpose:

Stores product level order details.


Keys:

order_id

product_id

seller_id


Measures:

price

freight_value


Used For:

Revenue calculations


Warehouse Target:

fact_sales



---


## 4. Products


Source:

olist_products_dataset.csv


Purpose:

Stores product information.


Primary Key:

product_id


Important Columns:

product_category_name

product_weight_g


Warehouse Target:

dim_product



---


## 5. Sellers


Source:

olist_sellers_dataset.csv


Purpose:

Stores seller information.


Primary Key:

seller_id


Warehouse Target:

dim_seller



---


## 6. Payments


Source:

olist_order_payments_dataset.csv


Purpose:

Stores payment transactions.


Metrics:

payment_value


Used For:

Financial KPIs



---


## 7. Reviews


Source:

olist_order_reviews_dataset.csv


Purpose:

Stores customer feedback.


Metrics:

review_score


Used For:

Customer satisfaction analytics



# Source Relationships


customers

↓

orders

↓

order_items

↓

products


order_items

↓

sellers


orders

↓

payments


orders

↓

reviews



# Data Quality Checks Required


- Duplicate validation

- NULL checks

- Invalid dates

- Missing relationships

- Invalid payment values
