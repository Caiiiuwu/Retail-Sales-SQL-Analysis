# 🛍️ Retail Sales Analysis Using SQL

This project explores a retail sales dataset to uncover key business insights using structured query language (SQL). The dataset consists of three core tables: `Customers`, `Products`, and `Sales`.

## 🎯 Objective

To analyze customer behavior, product performance, and sales trends in order to support business decision-making through data-driven insights.

## 📊 Key Analyses Performed

- ✅ **Data Cleaning**  
  - Removed duplicate records and handled null values with caution to preserve data integrity.

- ✅ **Revenue Analysis**  
  - Calculated **monthly revenue** for each product to monitor financial performance over time.

- ✅ **Sales Trend Analysis**  
  - Identified product sales trends across different **sales channels** (e.g., in-store, online).
  - Detected products with **consistent sales** and those showing a **decline in quantity sold**.

- ✅ **Customer Behavior**  
  - Analyzed **customer buying patterns**, such as purchase frequency and preferred product categories.
  - Measured **customer churn and retention** to assess engagement and loyalty over time.

## 🧰 Tools & Technologies

- SQL (MySQL)
- MySQL workbench

## 📁 Dataset Structure

- **Customers**: customer_id, name, age, gender, region, etc.
- **Products**: product_id, product_name, category, price, etc.
- **Sales**: sale_id, customer_id, product_id, sale_date, quantity, channel, etc.

## 📈 Sample Insights

> ✨ *"Product A maintained a steady monthly revenue growth of 12%, while Product C showed a consistent drop in quantity sold starting from Q2."*  
> ✨ *"70% of customers who made two or more purchases returned within 30 days, suggesting strong brand loyalty."*

## 💡 Key Skills Demonstrated

- Advanced SQL querying (joins, grouping, filtering, window functions, ranks, CASE statements, Date functions)
- Time-based aggregations and trend analysis
- Multiple CTE creations
- Customer behavior analysis
- Data wrangling and integrity management

## 📌 Outcome

This project sharpened my ability to translate raw data into actionable insights using SQL — an essential skill for data analysis and business intelligence roles. 

---

📂 Feel free to check out the [SQL queries](./retail_sales_queries.sql) and [sample output screenshots](./sample_outputs/) for a deeper dive.
