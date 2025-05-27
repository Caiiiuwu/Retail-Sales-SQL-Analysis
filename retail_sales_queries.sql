    -- Monthly revenue of per product
    SELECT p.product_id, p.product_name, date_format(sale_date, '%Y-%m') as month, SUM(price*quantity) as monthly_revenue,
    COUNT(sale_id) as number_of_trans, SUM(quantity) as total_items
	FROM products p
	INNER JOIN sales s on p.product_id= s.product_id
	group by p.product_id, p.product_name, date_format(sale_date, '%Y-%m')
	Order by month, product_name;
    
    --  Best-Selling Products by Month (Using ROW_NUMBER)
    WITH quantity_table as(
    SELECT p.product_name, date_format(sale_date, '%Y-%m') as month, SUM(quantity) as total_quantity_sold
    FROM products p
    INNER JOIN sales s on p.product_id = s.product_id
    GROUP BY  p.product_name, date_format(sale_date, '%Y-%m')),
    
    rank_table as(
    SELECT *, rank() OVER(partition by month order by total_quantity_sold) as product_rank
    FROM quantity_table)
    
    SELECT *
    FROM rank_table
    WHERE product_rank = 1
    order by product_name, month;
    
   -- Identify Product Sales Trends Across Channels
   -- CTE tables are created for online and store channel, and this was joined using product name and month to make sure that they are joined in the same month
   WITH online_table as(
   SELECT p.product_name, date_format(s.sale_date, '%Y-%m') as month, s.channel, sum(s.quantity) as online_quantity
   FROM products p
   INNER JOIN sales s on p.product_id = s.product_id    
   WHERE s.channel = 'online'
   GROUP BY p.product_name, s.channel, date_format(s.sale_date, '%Y-%m')),
   
   store_table as(
   SELECT p.product_name, date_format(s.sale_date, '%Y-%m') as month, s.channel, sum(s.quantity) as store_quantity
   FROM products p
   INNER JOIN sales s on p.product_id = s.product_id    
   WHERE s.channel = 'store'
   GROUP BY p.product_name, s.channel, date_format(s.sale_date, '%Y-%m'))
   
   SELECT ot.product_name, ot.month, ot.online_quantity, st.store_quantity, ot.online_quantity - st.store_quantity as difference
   FROM online_table ot
   INNER JOIN store_table st ON ot.product_name = st.product_name AND ot.month = st.month;
   
   -- Identify Repeat Customers by looking if they have purchased more than 2 months, and identifying their most purchase product
   -- the code executes a customer_table for the month count and total item purchase
   -- the other CTES are for identfying the customer's most purchase product using row_number() and filtering rn = 1
   WITH customer_table as(
   SELECT c.customer_id, c.customer_name, 
   COUNT(DISTINCT date_format(s.sale_date, '%Y-%m')) as month_count, SUM(quantity) as total_item_purchased
   FROM customers c
   INNER JOIN sales s on c.customer_id = s.customer_id
   GROUP BY c.customer_id, c.customer_name
   HAVING COUNT(DISTINCT date_format(s.sale_date, '%Y-%m')) >= 2
   ),
   
   total_per_product as(
   SELECT c.customer_id, c.customer_name, p.product_name, sum(s.quantity) as product_total
   FROM customers c
   INNER JOIN sales s on c.customer_id = s.customer_id
   INNER JOIN products p on s.product_id = p.product_id  
   GROUP BY c.customer_id, c.customer_name, p.product_name
   ),
   
   product_ranking as(   SELECT *, row_number() OVER(partition by customer_id order by product_total DESC) as product_rank
   FROM total_per_product),
   
   product_filter as(
   SELECT *
   FROM product_ranking
   WHERE product_rank = 1
   )
   SELECT ct.customer_id, ct.customer_name, ct.month_count, ct.total_item_purchased, pf.product_name as most_purchased_product
   FROM customer_table ct
   INNER JOIN product_filter pf on ct.customer_id = pf.customer_id;
   
-- Most purchased product per month per customer
-- The partition by is paritionied by customer_name and month, this allows us to group per customer per month, and allows us to get the
-- most purchased product per month per customer
WITH monthly_product_totals as(
SELECT c.customer_name, p.product_name, date_format(s.sale_date, '%Y-%m') as month, sum(s.quantity) as total_purchased
FROM customers c
INNER JOIN sales s on c.customer_id = s.customer_id
INNER JOIN products p on s.product_id = p.product_id
GROUP BY c.customer_name, p.product_name, date_format(s.sale_date, '%Y-%m')),

ranked_products as(
SELECT *, row_number () OVER(partition by customer_name, month order by total_purchased DESC) as rn
FROM monthly_product_totals
)

SELECT customer_name, month, product_name, total_purchased
FROM ranked_products
WHERE rn = 1
ORDER BY customer_name, month;


-- Identify Price-Sensitive Products where products drop more than 45% in the next month based on quantity sold
WITH monthly_sold as(
SELECT p.product_name, date_format(s.sale_date, '%Y-%m') as month, SUM(quantity) total_monthly_sold
FROM products p 
INNER JOIN sales s on p.product_id = s.product_id
GROUP by p.product_name, date_format(s.sale_date, '%Y-%m')),

next_month as(
 SELECT *, LEAD(total_monthly_sold) OVER(partition by product_name order by month) as next_month_quantity_sold
 FROM monthly_sold),
 
 pct_diff_table as(
 Select *, 
 CASE WHEN total_monthly_sold > 0 AND next_month_quantity_sold is not null then 
 ROUND(((total_monthly_sold - next_month_quantity_sold)/total_monthly_sold) * 100.0,2)
 ELSE NULL END AS pct_drop
 FROM next_month)
 
 SELECT *
 FROM pct_diff_table
 WHERE pct_drop >= 45.00
 order by pct_drop DESC;
 
 -- Identifying products that never had a quantity drop per month. we used case function to flag the months dropped per product
 -- when the product had droped a month, it will have a 1 on months_drop column and 0 if not. So in the final select, we sum that column
 -- and if its still equal to 0 it means that i did not have a drop. Take note that we group by again since we only want to output
 -- the products not the month. HAVING is used since we are using the conditions of SUM(months_drop)
 WITH monthly_quantity as(
 SELECT p.product_id, p.product_name, date_format(sale_date, '%Y-%m') as month, SUM(s.quantity) as monthly_sold
 FROM products p
 INNER JOIN sales s on p.product_id = s.product_id
 GROUP BY  p.product_id, p.product_name, date_format(sale_date, '%Y-%m')),
 
 previous_quantity as(
 SELECT *, LAG(monthly_sold) OVER(partition by product_name order by month) as previous_sold
 FROM monthly_quantity),
 
 is_drop as (
 SELECT *, CASE WHEN previous_sold is not null AND monthly_sold > previous_sold then 1
 ELSE 0 END AS months_drop
 FROM previous_quantity)
 
 SELECT product_name,product_id, SUM(months_drop) as is_drop
 FROM is_drop
GROUP BY product_name, product_id
HAVING SUM(months_drop) = 0;

--  Identify Top 2 Customers by Spending per Month
with customer_table as(
SELECT c.customer_name,date_format(s.sale_date, '%Y-%m') as month, SUM(p.price * s.quantity) as total_spent
FROM customers c
INNER JOIN sales s on c.customer_id = s.customer_id
INNER JOIN products p on s.product_id = p.product_id
GROUP BY date_format(s.sale_date, '%Y-%m'), c.customer_name),

ranking as (
SELECT *, dense_rank() over (partition by month order by total_spent DESC) as rn
FROM customer_table)

SELECT *
FROM ranking
WHERE rn <= 2
order by month;

 -- Identify the Most Improved Product Month-over-Month
 WITH product_table as(
 SELECT p.product_name, date_format(sale_date, '%Y-%m') as month, sum(s.quantity) as monthly_sold
 FROM sales s
 INNER JOIN products p on s.product_id = p.product_id
 GROUP BY p.product_name, date_format(sale_date, '%Y-%m')),
 
prev_sold as(
SELECT *, LAG(monthly_sold) OVER (partition by product_name order by month) as previous_sold
FROM product_table),

calc_table as (
SELECT *, CASE WHEN monthly_sold > 0 AND  previous_sold IS NOT NULL THEN monthly_sold - previous_sold
ELSE NULL END AS quantity_diff
FROM prev_sold),

ranking as (
SELECT *, rank() OVER (partition by product_name order by quantity_diff DESC) as rn
FROM calc_table)

SELECT *
FROM ranking
WHERE rn = 1
order by quantity_diff desc;

--  Identify Customers with Decreasing Purchases
with customer_table as(
SELECT c.customer_name, date_format(sale_date, '%Y-%m') as month, SUM(s.quantity) as current_month_quantity
FROM customers c
INNER JOIN sales s on c.customer_id = s.customer_id
GROUP BY  c.customer_name, date_format(sale_date, '%Y-%m')),

prev_month as (
SELECT *, LAG (current_month_quantity) OVER(partition by customer_name order by month) as	previous_month_quantity
FROM customer_table)

SELECT *, current_month_quantity - previous_month_quantity as diff
FROM prev_month
WHERE current_month_quantity < previous_month_quantity
Order by diff;

-- Detect Product Comebacks
with current_month as(
SELECT p.product_name, date_format(sale_date,'%Y-%m') as month, SUM(s.quantity) as current_month_quantity
FROM products p
INNER JOIN sales s on p.product_id = s.product_id
GROUP BY p.product_name, date_format(sale_date,'%Y-%m')),

prev_month as(
SELECT *, LAG(current_month_quantity) OVER(partition by product_name order by month) as previous_month_quantity
FROM current_month),

filtering as(
SELECT *, CASE WHEN previous_month_quantity <= 1 AND current_month_quantity > 2 THEN 'Comeback'
ELSE NULL end as product_state
FROM prev_month)

SELECT *
FROM filtering 
WHERE product_state = 'Comeback';

-- Detecting repeat product purchase by customer, so we partitioned by customer name and product so that we are looking at each product
-- seperately, then we had a case in which we ensured that the monthly quantity and prev quantity is > 0 so we can detect if they bought
-- again
with customer_table as(
SELECT c.customer_name, date_format(sale_date, '%Y-%m') as month, p.product_name, SUM(quantity) as monthly_quantity
FROM customers c
INNER JOIN sales s on c.customer_id = s.customer_id
INNER JOIN products p on s.product_id = p.product_id
GROUP BY c.customer_name, date_format(sale_date, '%Y-%m'), p.product_name),

prev_month as(
SELECT *, LAG(monthly_quantity) OVER(partition by customer_name, product_name order by month) as prev_quantity
FROM customer_table),

flag_table as(
SELECT *,  CASE WHEN prev_quantity > 0 AND prev_quantity is not null AND monthly_quantity > 0 THEN 'YES'
ELSE 'NO' end as purchased_last_month
FROM prev_month 
)
SELECT *
FROM flag_table
WHERE purchased_last_month = 'YES'
ORDER BY customer_name, month;


-- Detect Customer Churn if they bought a product on previous month and not on the next month

-- step 1: create a CTE for all distinct customers and months combination using cross join, regardless if they did not buy in that month
-- this allows us to have all possible combination. We use a subqeury to make sure we only get distinct months for cleaner combinations
-- although we can just use 'cross join sale' it will produce extra rows and duplicates, which is not efficient.
with customer_table as(
SELECT DISTINCT c.customer_name, months.month
FROM customers c
CROSS JOIN(
SELECT DISTINCT date_format(sale_date, '%Y-%m') as month
from sales s)   as months),

-- Step 2: basically creating a CTE for customers that have a monthly_quantiy, this will be used for a left join later
-- to define what month did the customer did not buy using the customer_table cte
sale_summary as(
SELECT c.customer_name, date_format(s.sale_date, '%Y-%m') as month, SUM(s.quantity) as monthly_quantity
FROM customers c
INNER JOIN sales s on c.customer_id = s.customer_id
GROUP BY c.customer_name, date_format(s.sale_date, '%Y-%m')),

-- step 3: most crucial step, now we join both tables using LEFT JOIN, using coalesce, since the sale_summary has the table
-- for customers who had bought monthly, it will be join in the customer_table with all possible combinations, so if they did not satisfy
-- a combination that will be defined monthly_quanaity as 0 and if it has, then simply shows ss.monthly_quantity
join_summary as(
SELECT ct.customer_name, ct.month, coalesce(ss.monthly_quantity, 0) as monthly_quantity
FROM customer_table ct
LEFT JOIN sale_summary ss on ct.customer_name = ss.customer_name and ct.month = ss.month),

-- step 4: use lag window function to look back at the previous month's monthly_quantity
prev_month as (
SELECT *, LAG(monthly_quantity) OVER( partition by customer_name order by month) as prev_quantity
FROM join_summary),

-- step 5: now filter with CASE to define a churn by picking a row with a monthly_quantity and the prev_quantity should be more than 0
filtering as (
SELECT *, CASE WHEN prev_quantity > 0 AND prev_quantity is not null AND monthly_quantity = 0 THEN 'churned'
ELSE 'retain' end as customer_status
FROM prev_month)

-- step 6: filter to select rows with a status of churned from the case statement
SELECT *
FROM filtering 
WHERE customer_status = 'churned'
ORDER BY customer_name;
