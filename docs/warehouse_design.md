# Warehouse Design

## Business Process

Sales Analysis

## Fact Table Grain

One row represents one product purchased in one order.

## Dimensions

- Customer
- Product
- Seller
- Date

## Measures

- Sales Amount
- Freight Amount
- Payment Amount
- Quantity

## Star Schema

(dim_customers)
        \
(dim_products) ---- fact_sales ---- (dim_sellers)
        /
   (dim_date)
