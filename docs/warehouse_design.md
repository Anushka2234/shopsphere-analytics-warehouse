# Warehouse Design

## Objective

The objective of this project is to design an enterprise-grade data warehouse for an e-commerce platform that supports business intelligence and analytical reporting.

The warehouse integrates data from multiple operational datasets and transforms them into an analytics-ready star schema.

---

# Business Process

The business process being analyzed is:

**Sales**

Every order placed by a customer generates sales transactions that will be stored inside the warehouse.

---

# Grain

The grain defines what one record represents inside the fact table.

Fact Table Grain:

> One row represents one product purchased within one order.

Example

Order 1001

Product A

Product B

↓

Fact Table

Row 1 → Product A

Row 2 → Product B

---

# Fact Table

fact_sales

Stores measurable business events.

Measures include

- Sales Amount
- Freight Amount
- Payment Amount
- Quantity

---

# Dimension Tables

- dim_customers
- dim_products
- dim_sellers
- dim_date

---

# Warehouse Architecture

CSV Files

↓

Raw Layer

↓

Staging Layer

↓

Warehouse Layer

↓

Power BI
