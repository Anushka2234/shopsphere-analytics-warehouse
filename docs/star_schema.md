# Star Schema

The warehouse is designed using a Star Schema.

Advantages

- Fast reporting
- Simple joins
- Better Power BI performance
- Easy maintenance
- Enterprise standard architecture

---

## Schema

                 dim_date
                    |
                    |
dim_customers --- fact_sales --- dim_products
                    |
                    |
              dim_sellers
