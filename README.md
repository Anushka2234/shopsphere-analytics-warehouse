# shopsphere-analytics-warehouse
Enterprise E-Commerce Analytics Data Warehouse built with MySQL, ETL pipelines, Star Schema modeling, Advanced SQL analytics, and Power BI dashboards.

## Project Status


### Completed

Phase 1:

Requirement Analysis and Warehouse Design


Deliverables:

- Business Requirement Documentation
- Architecture Design
- Source System Analysis
- Star Schema Model
- Data Dictionary


### Current Phase

Phase 2:

SQL Server Warehouse Development
---

# Phase 2 – Raw Data Profiling & Staging ETL

## Overview

Phase 2 focuses on improving data quality and preparing source data for analytical processing.

This phase introduces a layered ETL architecture consisting of a Raw Layer for data profiling and a Staging Layer for data cleansing and standardization.

---

## Raw Layer

The Raw Layer stores source data without modification and performs comprehensive data profiling.

### Profiling Activities

- Record count validation
- Duplicate detection
- NULL value analysis
- Blank value analysis
- Business rule validation
- Data distribution analysis

### Raw Tables

- Customers
- Sellers
- Products
- Orders
- Order Items
- Payments
- Reviews
- Geolocation

---

## Staging Layer

The Staging Layer prepares data for the warehouse by applying data quality improvements.

### Transformations

- Data cleansing
- Duplicate removal
- Standardization
- Metadata generation
- Business validation
- ETL validation queries

### Staging Tables

- stg_customers
- stg_sellers
- stg_products
- stg_orders
- stg_order_items
- stg_payments
- stg_reviews
- stg_geolocation

---

## Skills Demonstrated

- SQL Server
- ETL Pipeline Development
- Data Profiling
- Data Cleansing
- Data Validation
- Data Quality Management
- SQL Query Optimization
- Layered Data Warehouse Architecture

---

## Project Progress

- ✅ Phase 1 – Database Setup
- ✅ Phase 2 – Raw Layer & Staging Layer
- ⏳ Phase 3 – Warehouse Layer
- ⏳ Phase 4 – Power BI Dashboard
