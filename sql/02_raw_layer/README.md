
# Raw Layer

## Overview

The Raw Layer is the landing zone for all source data imported from the Olist Brazilian E-Commerce Dataset.

Data in this layer is stored in its original form without any transformations.

The purpose of this layer is to preserve the source data and perform data profiling before loading records into the Staging Layer.

---

## Objectives

- Store original source data
- Preserve data integrity
- Perform data quality assessment
- Detect duplicates
- Identify NULL values
- Validate business rules

---

## SQL Scripts

| Script | Description |
|---------|-------------|
| create_raw_tables.sql | Creates all raw tables |
| 01_raw_customers_profiling.sql | Profiles customer data |
| 02_raw_sellers_profiling.sql | Profiles seller data |
| 03_raw_products_profiling.sql | Profiles product data |
| 04_raw_orders_profiling.sql | Profiles order data |
| 05_raw_order_items_profiling.sql | Profiles order item data |
| 06_raw_payments_profiling.sql | Profiles payment data |
| 07_raw_reviews_profiling.sql | Profiles review data |
| 08_raw_geolocation_profiling.sql | Profiles geolocation data |

---

## Profiling Checks

Each profiling script performs one or more of the following:

- Record count validation
- Duplicate detection
- NULL value analysis
- Blank value analysis
- Business rule validation
- Distribution analysis
- Sample data inspection

---

## Next Step

The output of the Raw Layer is used as the source for the Staging Layer, where data is cleaned, standardized, and prepared for dimensional modeling.
