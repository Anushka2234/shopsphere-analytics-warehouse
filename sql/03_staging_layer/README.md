# Staging Layer

## Overview

The Staging Layer transforms raw source data into standardized datasets that are ready for loading into the Data Warehouse.

This layer applies data cleansing, formatting, and business validation while preserving the original business meaning.

---

## Objectives

- Clean raw data
- Standardize formats
- Remove duplicates
- Handle missing values
- Apply business rules
- Prepare data for dimensional modeling

---

## ETL Scripts

| Script | Description |
|---------|-------------|
| stg_customers.sql | Customer staging ETL |
| stg_sellers.sql | Seller staging ETL |
| stg_products.sql | Product staging ETL |
| stg_orders.sql | Order staging ETL |
| stg_order_items.sql | Order item staging ETL |
| stg_payments.sql | Payment staging ETL |
| stg_reviews.sql | Review staging ETL |
| stg_geolocation.sql | Geolocation staging ETL |

---

## Transformations

Typical transformations include:

- Trimming whitespace
- Standardizing text values
- Removing duplicate records
- Handling NULL values
- Data type conversions
- Metadata generation
- Validation queries

---

## Output

The cleaned staging tables serve as the source for the Warehouse Layer.
