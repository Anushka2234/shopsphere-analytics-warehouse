# ShopSphere Data Warehouse Data Dictionary


Project:

Enterprise E-Commerce Analytics Warehouse


Purpose:

Define warehouse tables, columns, business meaning, and usage.

# Table: fact_sales


Description:

Stores measurable sales transaction events.


Grain:

One row represents one product purchased within an order.


Source Tables:

- orders
- order_items
- payments
- reviews

| Column | Type | Description |
|-|-|-|
| sales_key | INT | Unique warehouse sales key |
| order_id | VARCHAR | Source order identifier |
| customer_key | INT | Links customer dimension |
| product_key | INT | Links product dimension |
| seller_key | INT | Links seller dimension |
| date_key | INT | Links date dimension |
| quantity | INT | Number of items sold |
| price | DECIMAL | Product selling price |
| freight_value | DECIMAL | Shipping cost |
| total_amount | DECIMAL | Total sales value |


# Table: dim_customer


Purpose:

Stores customer descriptive information.


Source:

customers.csv


Usage:

Customer analytics and segmentation
Business Usage:

Revenue and sales performance analytics

| Column | Description |
|-|-|
| customer_key | Surrogate primary key |
| customer_id | Source customer ID |
| customer_city | Customer city |
| customer_state | Customer state |


# Table: dim_product


Purpose:

Stores product information.


Usage:

Product performance analysis

| Column | Description |
|-|-|
| product_key | Surrogate key |
| product_id | Product identifier |
| category | Product category |
| weight | Product weight |

# Table: dim_seller


Purpose:

Seller performance reporting

| Column | Description |
|-|-|
| seller_key | Surrogate key |
| seller_id | Seller identifier |
| seller_city | Seller city |
| seller_state | Seller state |

# Table: dim_date


Purpose:

Supports time-based reporting

| Column | Description |
|-|-|
| date_key | Date identifier |
| date | Calendar date |
| month | Month |
| quarter | Quarter |
| year | Year |
