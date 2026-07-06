# Raw Data Layer


## Description

This folder represents the raw ingestion layer of the ShopSphere Data Warehouse project.


The original source files are not uploaded to GitHub because production projects do not store large datasets inside source control.


## Dataset Source

Olist Brazilian E-Commerce Dataset


## Source Files Used


1. olist_customers_dataset.csv

Purpose:

Stores customer information.


2. olist_orders_dataset.csv

Purpose:

Stores customer order transactions.


3. olist_order_items_dataset.csv

Purpose:

Stores products purchased in orders.


4. olist_products_dataset.csv

Purpose:

Stores product catalog information.


5. olist_sellers_dataset.csv

Purpose:

Stores seller information.


6. olist_order_payments_dataset.csv

Purpose:

Stores payment transactions.


7. olist_order_reviews_dataset.csv

Purpose:

Stores customer review information.


8. olist_geolocation_dataset.csv

Purpose:

Stores customer and seller location data.


9. product_category_name_translation.csv

Purpose:

Stores product category translations.



## Production Equivalent


In a real enterprise environment:

Raw files are stored in:

- Azure Data Lake Storage
- Amazon S3
- Enterprise File Storage


ETL pipelines extract files from storage and load them into the warehouse.


## Data Flow


CSV Source Files

        ↓

SQL Server Raw Layer

        ↓

Staging Layer

        ↓

Data Warehouse

        ↓

Power BI

