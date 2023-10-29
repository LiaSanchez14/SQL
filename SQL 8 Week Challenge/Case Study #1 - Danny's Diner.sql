--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Introduction
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Case study URL: https://8weeksqlchallenge.com/case-study-1/

--Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.
--Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data 
--to help them run the business.

--Problem Statement

--Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. 
--Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers. He plans on using these insights to help him decide whether he 
--should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL. Danny has provided you 
--with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!
--Danny has shared with you 3 key datasets for this case study:
--sales, menu, and members
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Set Up
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Case Study Questions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--What is the total amount each customer spent at the restaurant?

SELECT customer_id, SUM(price)
FROM sales
INNER JOIN menu
ON sales.product_id = menu.product_id
GROUP BY customer_id;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--How many days has each customer visited the restaurant?

SELECT customer_id, COUNT(DISTINCT(order_date))
FROM sales
GROUP BY customer_id;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--What was the first item from the menu purchased by each customer?

WITH Rank AS (

SELECT customer_id, order_date, product_name, DENSE_RANK() OVER (PARTITION BY Sales.Customer_ID Order by Sales.order_date) as rank
FROM sales
INNER JOIN menu
ON sales.product_id = menu.product_id 
GROUP BY customer_id, product_name, order_date
)

SELECT customer_id, product_name
FROM Rank
WHERE rank= 1;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT product_name, COUNT(sales.product_id)
FROM sales
INNER JOIN menu
ON sales.product_id = menu.product_id
GROUP BY product_name
ORDER BY COUNT(sales.product_id) DESC;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Which item was the most popular for each customer?

WITH Rank as (
  
SELECT customer_id, product_name, COUNT(menu.product_id) AS count, DENSE_RANK() OVER (PARTITION BY sales.customer_id Order by COUNT(menu.product_id) DESC) as rank
FROM sales
INNER JOIN menu
ON sales.product_id = menu.product_id
GROUP BY customer_id, Product_name
)

SELECT customer_id, product_name, count
FROM Rank
WHERE rank = 1;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Which item was purchased first by the customer after they became a member?

WITH Rank AS (

Select sales.customer_id, product_name, Dense_rank() OVER (Partition by sales.Customer_id Order by sales.Order_date) as Rank
FROM sales
INNER JOIN menu
ON sales.product_id = menu.product_id
INNER JOIN members
ON sales.customer_id = members.customer_id
WHERE order_date >= join_date
)

SELECT *
FROM Rank
WHERE rank = 1;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Which item was purchased just before the customer became a member?

WITH Rank AS (

Select sales.customer_id, product_name, Dense_rank() OVER (Partition by sales.Customer_id Order by sales.Order_date) as Rank
FROM sales
INNER JOIN menu
ON sales.product_id = menu.product_id
INNER JOIN members
ON sales.customer_id = members.customer_id
WHERE order_date < join_date
)

SELECT *
FROM Rank
WHERE rank = 1;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--What is the total items and amount spent for each member before they became a member?

SELECT sales.customer_id, COUNT(menu.product_id) AS quantity, SUM(price) AS total_spent
FROM sales
INNER JOIN menu
ON sales.product_id = menu.product_id
INNER JOIN members
ON sales.customer_id = members.customer_id
WHERE order_date < join_date
GROUP BY sales.customer_id;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

WITH Points AS (
SELECT *, 
CASE
WHEN product_name = 'sushi' THEN price*20
ELSE price*10
END AS Points
FROM menu
)

SELECT customer_id, SUM(Points.points)
AS Points
FROM sales
INNER JOIN Points
ON sales.product_id = Points.product_id
GROUP by customer_id;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi
--how many points do customer A and B have at the end of January?

WITH dates AS 
(
    SELECT *, DATE(join_date,'+6 days') AS valid_date, 
      '2021-01-31' AS last_date
   FROM members  
)

SELECT sales.Customer_id, SUM(CASE
WHEN product_name = 'sushi' THEN menu.price*20
WHEN sales.order_date BETWEEN dates.join_date AND dates.valid_date THEN menu.price*20
ELSE menu.price*10
END) as Points
FROM Dates
INNER JOIN Sales 
ON dates.customer_id = sales.customer_id
INNER JOIN menu 
ON menu.product_id = sales.product_id
WHERE sales.order_date < dates.last_date
GROUP BY sales.customer_id;
