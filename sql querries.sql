create database zomato;
USE zomato; 

-- 1. Create menu table
CREATE TABLE IF NOT EXISTS menu (
    sr_no INT,
    menu_id VARCHAR(50),
    r_id INT,
    f_id VARCHAR(50),
    cuisine VARCHAR(255),
    price DECIMAL(10, 2)
);

-- 2. Create food table
CREATE TABLE IF NOT EXISTS food (
    sr_no INT,
    f_id VARCHAR(50),
    item VARCHAR(255),
    veg_or_non_veg VARCHAR(50)
);

-- 3. Create orders table
CREATE TABLE IF NOT EXISTS orders (
    sr_no INT,
    order_date DATE,
    sales_qty INT,
    sales_amount DECIMAL(10, 2),
    currency VARCHAR(10),
    user_id INT,
    r_id INT
);

-- 4. Create restaurant table
CREATE TABLE IF NOT EXISTS restaurant (
    sr_no INT,
    id INT,
    name VARCHAR(255),
    city VARCHAR(100),
    rating VARCHAR(50),
    rating_count VARCHAR(100),
    cost VARCHAR(50),
    cuisine VARCHAR(255),
    lic_no VARCHAR(100),
    link TEXT,
    address TEXT,
    menu TEXT
);
USE zomato;

USE zomato;

-- Purani table drop karke naye structure ke saath create karein
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    sr_no INT,
    user_id INT,
    name VARCHAR(255),
    email VARCHAR(255),
    password VARCHAR(255),
    age INT,
    gender VARCHAR(50),
    marital_status VARCHAR(50),
    occupation VARCHAR(100),
    monthly_income VARCHAR(100),
    educational_qualification VARCHAR(100),
    family_size INT
);
USE zomato;

LOAD DATA LOCAL INFILE 'C:/Users/tejas/Downloads/Zomato Orders Analysis/users_cleaned.csv'
INTO TABLE users
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
SELECT * FROM users;

-- 1. Menu Table
SELECT count(*) FROM menu ;

-- 2. Food Table
SELECT count(*) FROM food ;

-- 3. Orders Table
SELECT distinct(order_date) FROM orders ;

-- 4. Restaurant Table
SELECT * FROM restaurant;
truncate table restaurant;

DESCRIBE restaurant;


truncate table restaurant;

TRUNCATE TABLE restaurant;

LOAD DATA LOCAL INFILE 'C:/Users/tejas/Downloads/Zomato Orders Analysis/restaurant.csv'
INTO TABLE restaurant
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(sr_no, id, name, city, rating, rating_count, cost, cuisine,
 lic_no, link, address, menu);
-- Question 1. Top 10 restaurants by total sales amount
-- Concepts: JOIN, GROUP BY, SUM(), ORDER BY, LIMIT
SELECT
    r.id AS restaurant_id,
    r.name AS restaurant_name,
    SUM(o.sales_amount) AS total_sales
FROM orders o
JOIN restaurant r
    ON o.r_id = r.id
WHERE o.sales_amount > 0
GROUP BY r.id, r.name
ORDER BY total_sales DESC
LIMIT 10;

 -- -- Q1 Top 10 restaurants by total sales amount
-- Concepts: JOIN, GROUP BY, SUM(), ORDER BY, LIMIT
SELECT
    r.id AS restaurant_id,
    r.name AS restaurant_name,
    SUM(o.sales_amount) AS total_sales
FROM orders o
JOIN restaurant r
    ON o.r_id = r.id
WHERE o.sales_amount > 0
GROUP BY r.id, r.name
ORDER BY total_sales DESC
LIMIT 10;
-- Explanation: Combine orders with restaurant names, calculate total sales for each restaurant, and return the top 10

select * from orders;
truncate orders;
DESCRIBE orders;

TRUNCATE TABLE orders;

LOAD DATA LOCAL INFILE 'C:/Users/tejas/Downloads/Zomato Orders Analysis/orders _cleaned.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
    sr_no,
    @order_date,
    sales_qty,
    sales_amount,
    currency,
    user_id,
    r_id
)
SET order_date = STR_TO_DATE(@order_date, '%Y-%m-%d');

LOAD DATA LOCAL INFILE 'C:/Users/tejas/Downloads/Zomato Orders Analysis/menu_cleaned.csv'
INTO TABLE menu
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
LOAD DATA LOCAL INFILE 'C:/Users/tejas/Downloads/Zomato Orders Analysis/food_clened.csv'
INTO TABLE food
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
USE zomato;

LOAD DATA LOCAL INFILE 'C:/Users/tejas/Downloads/Zomato Orders Analysis/users_clened.csv'
INTO TABLE users
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;
-- Q2. Average rating and total rating count for restaurants in the top 20 cities
SELECT
    r.city,
    COUNT(DISTINCT r.id) AS total_restaurants,
    ROUND(AVG(CAST(NULLIF(r.rating, '--') AS DECIMAL(3,1))), 2)
        AS average_rating,
    SUM(
        CAST(
            NULLIF(REGEXP_REPLACE(r.rating_count, '[^0-9]', ''), '')
            AS UNSIGNED
        )
    ) AS total_rating_count
FROM restaurant AS r
JOIN (
    SELECT city
    FROM restaurant
    WHERE city IS NOT NULL
      AND city <> ''
    GROUP BY city
    ORDER BY COUNT(DISTINCT id) DESC
    LIMIT 20
) AS top_cities
    ON r.city = top_cities.city
GROUP BY r.city
ORDER BY total_restaurants DESC;

-- How it works
-- 1. Subquery: Finds the 20 cities with the most restaurants.
-- 2. WHERE city IN: Filters the restaurant data to those cities.
-- 3. AVG(rating): Calculates the average restaurant rating per city.
-- 4. SUM(rating_count): Calculates the combined rating count per city after removing commas.
-- Question 3. Monthly order trends based on order volume
-- Concepts: DATE_FORMAT(), COUNT(), GROUP BY
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    COUNT(*) AS total_orders,
    SUM(sales_qty) AS total_sales_quantity,
    SUM(
        CASE WHEN sales_amount > 0
             THEN sales_amount ELSE 0 END
    ) AS total_sales_amount
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month;
-- 5. GROUP BY city: Produces one row per city.
TRUNCATE TABLE users;
SELECT * FROM users;

LOAD DATA LOCAL INFILE 'C:/Users/tejas/Downloads/Zomato Orders Analysis/users_cleaned.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
    sr_no,
    @order_date,
    sales_qty,
    sales_amount,
    currency,
    user_id,
    r_id
)
SET order_date = STR_TO_DATE(@order_date, '%c/%e/%Y');

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    COUNT(*) AS total_orders,
    SUM(sales_qty) AS total_sales_quantity,
    SUM(
        CASE
            WHEN sales_amount > 0 THEN sales_amount
            ELSE 0
        END
    ) AS total_sales_amount
FROM orders
WHERE order_date IS NOT NULL
GROUP BY order_month
ORDER BY order_month;


-- Q4 Top 5 Cauine by total volume

select * from users;
select * from restaurant;

select 
      r.cuisine,
      sum(o.sales_qty) as Total_Quantity
From orders as o 
join restaurant as r 
on r.id=o.r_id
group by r.cuisine
order by Total_Quantity desc
limit 5;   

-- Q5 What is the distribution of vegetarian vs non-vegetarian items ordered?

select 
      f.veg_or_non_veg,
      sum(o.sales_qty) as Total_Quantity
From orders as o 
join menu as m 
on m.r_id=o.r_id
join food as f 
on f.f_id=m.f_id
group by f.veg_or_non_veg
order by Total_Quantity;

select * from orders;
select * from menu;
select * from food;
show tables;


-- Q6.What are the top 20 cities by the number of restaurants?
select * from restaurant;
select 
      city,
      count(distinct id) as Total_restaurants
From restaurant
group by city
order by Total_restaurants desc
limit 20;      

-- Q7.How do different user demographics correlate with average order value?
select * from orders;
select * from users;
select * from food;
select * from restaurant;
select * from menu;
show tables;

select * from users;

select 
	  r.city,
      (sum(o.sales_amount)/count(o.sr_no)) as AOV
from orders as o 
join restaurant as r 
on r.sr_no=o.sr_no
group by r.city
;  
select 
city  from restaurant; 
-- Question 8. Top 15 highest-spending users
SELECT
    u.user_id,
    u.name,
    SUM(o.sales_amount) AS total_spending,
    COUNT(*) AS total_orders,
    ROUND(AVG(o.sales_amount), 2) AS average_order_value
FROM users u
JOIN orders o
    ON u.user_id = o.user_id
WHERE o.sales_amount > 0
GROUP BY u.user_id, u.name
ORDER BY total_spending DESC
LIMIT 15;
select * from menu;
-- Explanation: Ranks customers according to their cumulative positive sales amount.
-- Question 9. Top 15 cuisines with the highest average menu prices
SELECT
    cuisine,
    ROUND(AVG(price), 2) AS average_menu_price,
    COUNT(*) AS menu_entries
FROM menu
WHERE cuisine IS NOT NULL
  AND price IS NOT NULL
  AND price > 0
GROUP BY cuisine
HAVING COUNT(*) >= 10
ORDER BY average_menu_price DESC
LIMIT 15;
-- Question 10. Restaurants with the most diverse menus
  -- The following query measures diversity using the number of distinct cuisine labels and distinct food items available.
SELECT
    r.id AS restaurant_id,
    r.name AS restaurant_name,
    COUNT(DISTINCT m.cuisine) AS unique_cuisine_labels,
    COUNT(DISTINCT m.f_id) AS unique_dishes,
    COUNT(DISTINCT m.cuisine)
        + COUNT(DISTINCT m.f_id) AS diversity_score
FROM restaurant r
JOIN menu m
    ON r.id = m.r_id
GROUP BY r.id, r.name
ORDER BY diversity_score DESC,
         unique_dishes DESC
LIMIT 10;
-- Question 11. Most ordered food items across all restaurants
-- The CSVs do not link order records to individual food IDs, so actual item-level order counts are unavailable. As a useful alternative, find the most widely listed dishes across restaurant menus:
SELECT
    f.f_id,
    f.item AS food_item,
    COUNT(DISTINCT m.r_id) AS restaurants_offering_item,
    COUNT(*) AS menu_entries
FROM food f
JOIN menu m
    ON f.f_id = m.f_id
GROUP BY f.f_id, f.item
ORDER BY restaurants_offering_item DESC,
         menu_entries DESC
LIMIT 15;
USE zomato;

-- Question 12. How does spending behavior differ between genders?
SELECT
    u.Gender,
    COUNT(DISTINCT u.user_id) AS total_users,
    COUNT(o.sr_no) AS total_orders,
    ROUND(SUM(o.sales_amount), 2) AS total_spending,
    ROUND(AVG(o.sales_amount), 2) AS average_order_value,
    ROUND(SUM(o.sales_amount) / NULLIF(COUNT(DISTINCT u.user_id), 0), 2) AS avg_spending_per_user
FROM users u
JOIN orders o 
    ON u.user_id = o.user_id
GROUP BY u.Gender;


-- Question 13. Which days of the week have peak order volumes?
SELECT 
    DAYNAME(order_date) AS day_of_week,
    DAYOFWEEK(order_date) AS day_number,
    COUNT(*) AS total_orders,
    SUM(
        CASE WHEN sales_amount > 0 
             THEN sales_amount ELSE 0 END
    ) AS total_sales
FROM orders
GROUP BY 
    DAYNAME(order_date),
    DAYOFWEEK(order_date)
ORDER BY total_orders DESC;  
        -- Question 13. Which days of the week have peak order volumes?
-- Question 13. Which days of the week have peak order volumes?
SELECT 
    DAYNAME(order_date) AS day_of_week,
    DAYOFWEEK(order_date) AS day_number,
    COUNT(*) AS total_orders,
    SUM(
        CASE WHEN sales_amount > 0 
             THEN sales_amount ELSE 0 END
    ) AS total_sales
FROM orders
GROUP BY 
    DAYNAME(order_date),
    DAYOFWEEK(order_date)
ORDER BY total_orders DESC;        

-- Explanation: Finds the busiest days using order-record volume. DAYOFWEEK() sorts days numerically from Sunday to Saturday, though this query ranks them by order count.
-- Question 14. How does order frequency vary across income groups?
-- Question 14. How does order frequency vary across income groups?
SELECT 
    u.monthly_income AS income_group,
    COUNT(DISTINCT u.user_id) AS total_users,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) / NULLIF(COUNT(DISTINCT u.user_id), 0),
        2
    ) AS orders_per_user,
    ROUND(AVG(o.sales_amount), 2) AS average_order_value
FROM users u
JOIN orders o 
    ON u.user_id = o.user_id
WHERE o.sales_amount > 0
GROUP BY u.monthly_income
ORDER BY orders_per_user DESC;

-- Q1. Customer retention insight
  -- Business question: How many customers order repeatedly?
SELECT
  CASE WHEN cnt > 1 THEN 'Repeat'
       ELSE 'One-Time' END AS customer_type,
  COUNT(*) AS customers
FROM (
  SELECT user_id, COUNT(*) AS cnt
  FROM orders
  GROUP BY user_id
) t
GROUP BY customer_type;

-- THIS IS UPDATED QUERY

select 
      repeat_customers/count(*) as Repeat_customers_pct,
	  Onetime_customers/count(*) as Onetime_customers_pct
from  count_customer_type;
select * from users; 
select * from users; 

show tables;
      


-- Q2  High-revenue, low-rated restaurants
-- Business question: Which restaurants earn well but have low ratings?
SELECT r.name, r.city, r.rating,
       SUM(o.sales_amount) AS revenue
FROM orders o
JOIN restaurant r ON o.r_id = r.id
WHERE o.sales_amount > 0
  AND r.rating REGEXP '^[0-9]+(\\.[0-9]+)?$'
GROUP BY r.id, r.name, r.city, r.rating
HAVING CAST(r.rating AS DECIMAL(3,1)) < 3.5
ORDER BY revenue DESC
LIMIT 10;

-- q3 Which cuisines generate the highest sales 
-- compared with other cuisines?
WITH cuisine_sales AS (
    SELECT
        r.cuisine,
        SUM(o.sales_amount) AS total_sales
    FROM restaurant r
    JOIN orders o ON r.id = o.r_id
    WHERE o.sales_amount > 0
    GROUP BY r.cuisine
),
ranked_cuisines AS (
    SELECT *,
        DENSE_RANK() OVER (
            ORDER BY total_sales DESC
        ) AS sales_rank
    FROM cuisine_sales
)
SELECT *
FROM ranked_cuisines
WHERE sales_rank <= 5
ORDER BY sales_rank;



        
	
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        





  

