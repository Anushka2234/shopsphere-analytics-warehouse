# Dataset Reference Document


Project:

ShopSphere Enterprise Analytics Warehouse



# Dataset Name


Olist Brazilian E-Commerce Dataset



# Dataset Description


This dataset contains real-world e-commerce marketplace transactions.

It represents customers purchasing products from sellers through an online platform.



# Reason For Selection


This dataset supports enterprise analytics scenarios including:


- Sales Analytics

- Customer Analytics

- Product Performance

- Seller Performance

- Delivery Analysis

- Revenue Reporting



# Dataset Files


| File | Purpose |
|-|-|
| customers.csv | Customer details |
| orders.csv | Order transactions |
| order_items.csv | Sales information |
| products.csv | Product catalog |
| sellers.csv | Seller details |
| payments.csv | Payment information |
| reviews.csv | Customer feedback |
| geolocation.csv | Location data |



# Data Usage


Raw CSV Files

↓

SQL Server Raw Layer

↓

Staging Layer

↓

Data Warehouse

↓

Power BI Dashboards



# Storage Approach


CSV files are not stored in GitHub.


Reason:


Large datasets should not be stored in source control.


Enterprise equivalent storage:


- Data Lake

- Cloud Storage

- Database Storage
