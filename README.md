# 🛍️ Retail Sales Analysis Using SQL

This project explores a retail sales dataset to uncover key business insights using structured query language (SQL). The dataset consists of three core tables: `Customers`, `Products`, and `Sales`.

## 🎯 Objective

To analyze customer behavior, product performance, and sales trends in order to support business decision-making through data-driven insights.

## 📊 Key Analyses Performed

- ✅ **Data Cleaning**  
  - Removed duplicate records and handled null values with caution to preserve data integrity.

- ✅ **Revenue per Product Analysis**  
  - Calculated **monthly revenue** for each product to monitor financial performance over time.  
  - Identified the top product by **average monthly revenue**.  
  - Identified the top product by **total revenue**.

- ✅ **Quantity Sold per Product Analysis**  
  - Determined the **best-selling products per month** based on quantity sold.

- ✅ **Product Sales Drop Analysis**  
  - Detected products that experienced a **≥45% decline** in revenue on a **month-over-month** basis.

- ✅ **Customer Behavior Analysis**  
  - Identified **repeat customers** who made purchases in **two or more consecutive months**.  
  - Detected customers who **repeatedly purchased the same product**.

## 🧰 Tools & Technologies

- SQL (MySQL)
- MySQL workbench

## 📁 Dataset Structure

- **Customers**: customer_id, name, age, gender, region, etc.
- **Products**: product_id, product_name, category, price, etc.
- **Sales**: sale_id, customer_id, product_id, sale_date, quantity, channel, etc.

## 🏁 Key Findings


### 📈 Monthly Revenue per Product  
![Monthly Revenue per Product](Outputs/avg%20monthly%20revenue.png)  
The *Dumbbell Set* had the highest total revenue at **$135**, even though the *Notebook* had the highest quantity sold in a month (**8 units**). The *Pen Set* had the lowest monthly revenue at just **$3.75**.

### 🛒 Best-Selling Products by Month  
![Best-Selling Products by Month](Outputs/Best-Selling%20Products%20by%20Month.png)  
**January**: *Notebook* led with **8 units** sold.  
**February**: Tie between *Wireless Mouse*, *Pen Set*, and *Dumbbell Set* (**3 units** each).  
**March**: Tie between *USB Cable* and *Notebook* (**4 units** each).

### Top Product by Average Monthly Revenue
  ![Best Monthly Revenue](Outputs/Monthly%20Revenue%20by%20Product.png)  
  The *Dumbbell Set* had the highest **average monthly revenue** at **$112.50**, although it was only sold in **2 months** with a total of **5 items**.

### 💰 Top Product by Total Revenue  
![Top Product by Total Revenue](Outputs/Top%20Product%20by%20Total%20Revenue.png)  
  While the *Dumbbell Set* led in average revenue, the *Wireless Mouse* had the **highest total revenue** overall at **$233.91**, from **9 items** sold across **4 different months**.

### 🔁 Repeat Customers (Multi-Month Buyers)  
![Repeat Customers](Outputs/Repeat%20Customers.png) 
  Identified **8 out of 8 customers** who made purchases in **more than 2 distinct months**, indicating strong customer retention and engagement. Also showing their most purchased product

### 📉 Products with Major Drop in Sales (>45%)  
 ![Products with Major Drop in Sales](Outputs/Products%20with%20Major%20Drop%20in%20Sales.png)  
  - *Notebook*: **−87%**  
  - *Pen Set*: **−66%**  
  - *Headphones*, *Wireless Mouse*, *Yoga Mat*: each dropped by **−50%**

- **Consistently Performing Products**  
  **None** of the products showed consistent performance — all experienced a **drop in sales** at some point during the analysis period.

### 🔁 Repeat Purchases Detected 
 ![Repeat Purchases Detected](Outputs/Repeat%20Purchases%20Detected.png) 
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

This project sharpened my ability to translate raw data into actionable insights using SQL — an essential skill for data analysis and business intelligence roles. I also got to hone my skills in terms of advanced sql functions such as window functions, logical case statements, and creating multiple CTEs to attain the desirable analysis.


