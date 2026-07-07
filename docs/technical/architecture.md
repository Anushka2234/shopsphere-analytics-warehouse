# ShopSphere Data Warehouse Architecture



# Objective


Design an enterprise analytics architecture to transform operational e-commerce data into business insights.



# Architecture Flow


Source Data

↓

Raw Layer

↓

Staging Layer

↓

Transformation Layer

↓

Data Warehouse

↓

Analytics Layer

↓

Power BI



# 1. Source Layer


Technology: CSV Files


Contains:

Customer

Orders

Products

Payments



# 2. Raw Layer


Technology: SQL Server


Schema: raw


Purpose: Store original unchanged data.


Example:

raw.orders

raw.customers



Rules:

No cleaning

No transformation



# 3. Staging Layer


Schema: staging


Purpose: Prepare data for warehouse loading.


Activities:


Remove duplicates

Handle missing values

Convert data types

Validate data



# 4. Transformation Layer


Purpose: Apply business logic.


Activities:


Create surrogate keys

Create calculations

Prepare dimensions

Prepare facts



# 5. Warehouse Layer


Model: Star Schema


Schema: dw



Dimension Tables:


dim_customer

dim_product

dim_seller

dim_date



Fact Tables:


fact_sales



# 6. Analytics Layer


Contains:


SQL Views

Aggregations

KPI Queries



# 7. Reporting Layer


Tool:

Power BI


Dashboards:


Executive Dashboard

Sales Dashboard

Customer Dashboard

Product Dashboard

Operations Dashboard



# Technology Stack


| Component | Technology |
|-|-|
| Database | SQL Server |
| Development | SSMS |
| Modeling | Star Schema |
| Reporting | Power BI |
| Documentation | GitHub |
