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
  - Identified product comebacks

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

## 🏁 Key Findings

> ✨ *"Product A maintained a steady monthly revenue growth of 12%, while Product C showed a consistent drop in quantity sold starting from Q2."*

> ✨ *Below are additional findings based on my analysis of the dataset:*

- **Monthly Revenue by Product**  
  The *Dumbbell Set* had the highest total revenue at **$135**, even though the *Notebook* had the highest quantity sold in a month (**8 units**). The *Pen Set* had the lowest monthly revenue at just **$3.75**.

- **Best-Selling Products per Month**  
  - **January**: *Notebook* was the top-seller with **6 units** sold.  
  - **February**: Tie between *Wireless Mouse*, *Pen Set*, and *Dumbbell Set* (**3 units** each).  
  - **March**: Tie between *USB Cable* and *Notebook* (**4 units** each).

- **Repeat Customers (Multi-Month Buyers)**  
  Found **8 customers** who made purchases in **more than 2 different months**, showing signs of customer retention.

- **Products with Major Drop in Sales (>45%)**  
  Products that experienced significant month-over-month drop in quantity sold:  
  - *Notebook*: **−87%**  
  - *Pen Set*: **−66%**  
  - *Headphones*, *Wireless Mouse*, *Yoga Mat*: each dropped by **−50%**

- **Consistently Performing Products**  
  No products showed consistent month-over-month sales growth — **all experienced a drop** at some point.

- **Repeat Purchases Detected via LAG()**  
  Customers who bought the **same product in consecutive months**:  
  - *Alice Chen*: Water Bottle  
  - *Bob Gomez*: Yoga Mat  
  - *Cathy Li*: Wireless Mouse  
  - *David Kim*: Notebook



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
