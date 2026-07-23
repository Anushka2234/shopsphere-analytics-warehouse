# Dimensional Model

The warehouse follows Kimball's Star Schema methodology.

## Fact Table

fact_sales

## Dimension Tables

dim_customers

dim_products

dim_sellers

dim_date

---

## Relationships

dim_customers

↓

fact_sales

↑

dim_products

↑

dim_sellers

↑

dim_date

---

## Surrogate Keys

Every dimension contains an integer surrogate key.

Example

customer_key

product_key

seller_key

date_key

These keys are used inside the fact table instead of business IDs.
