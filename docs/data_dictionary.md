# Data Dictionary

## fact_sales

| Column | Description |
|----------|-------------|
| sales_key | Primary Key |
| customer_key | Customer FK |
| product_key | Product FK |
| seller_key | Seller FK |
| date_key | Date FK |
| sales_amount | Product Price |
| freight_amount | Shipping Cost |
| payment_amount | Total Payment |

---

## dim_customers

| Column | Description |
|---------|-------------|
| customer_key | Primary Key |
| customer_id | Business Key |
| city | Customer City |
| state | Customer State |

---

Continue similarly for

- dim_products
- dim_sellers
- dim_date
