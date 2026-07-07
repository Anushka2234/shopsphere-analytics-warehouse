
# Data Warehouse Model Design


Project:

ShopSphere Enterprise Analytics Warehouse


Modeling Approach:

Dimensional Modeling


Schema Type:

Star Schema


Purpose:

Design analytics optimized tables for reporting and business intelligence.


# Business Process


Selected Business Process:

E-Commerce Sales


Reason:


Sales is the core activity of the company.

Every order creates measurable business events.


Analysis Supported:


- Revenue Analysis

- Customer Analysis

- Product Performance

- Seller Performance

- Delivery Analytics


                         dim_data


                            |


dim_customer --------- fact_sales -------- dim_product


                            |


                      dim_seller


                            |


                     dim_location 

# Fact Table


Table Name:

fact_sales


Description:

Stores measurable sales transaction events.



Grain:

One row represents one product sold in an order.



Columns:


sales_key: Primary Key

Surrogate Key: order_id, Original transaction ID
customer_key: Foreign Key
product_key: Foreign Key
seller_key: Foreign Key
date_key: Foreign Key



Measures:


quantity


price


freight_value


total_amount


payment_value


review_score


# Dimension Table


Table:

dim_customer


Purpose:

Stores customer descriptive information.


Columns:


customer_key PK


customer_id


customer_unique_id


customer_city


customer_state


# dim_product


Purpose:

Product analysis


Columns:


product_key PK


product_id


product_category


product_weight


product_length


product_height


product_width


# dim_seller


Purpose:

Seller performance analysis


Columns:


seller_key PK


seller_id


seller_city


seller_state


# dim_date


Purpose:

Time-based reporting


Columns:


date_key PK


date


day


month


quarter


year


month_name



# dim_location


Purpose:

Geographical analytics


Columns:


location_key PK


zip_code


city


state


latitude


longitude


