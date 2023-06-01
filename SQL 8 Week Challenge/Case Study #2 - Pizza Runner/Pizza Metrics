--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Case Study Questions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Pizza Metrics
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--How many pizzas were ordered?

SELECT COUNT(order_id) AS number_of_orders
FROM cleaned_cust_orders;

--How many unique customer orders were made?

SELECT COUNT(DISTINCT order_id) AS Unique_orders
FROM cleaned_cust_orders;

--How many successful orders were delivered by each runner?

SELECT runner_id, COUNT(DISTINCT order_id) AS pizza_deliveries
FROM cleaned_runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;

--How many of each type of pizza was delivered?

SELECT pizza_name, COUNT(cc.pizza_id) AS pizza_orders
FROM cleaned_cust_orders cc
INNER JOIN cleaned_runner_orders cr
ON cc.order_id = cr.order_id
INNER JOIN pizza_names pn
ON pn.pizza_id = cc.pizza_id
WHERE cancellation IS NULL
GROUP BY cc.pizza_id;

--How many Vegetarian and Meatlovers were ordered by each customer?

SELECT customer_id, pizza_name, COUNT(cc.pizza_id) AS pizza_orders
FROM cleaned_cust_orders cc
INNER JOIN pizza_names pn
ON pn.pizza_id = cc.pizza_id
GROUP BY customer_id, pizza_name;

--What was the maximum number of pizzas delivered in a single order?

SELECT COUNT(pizza_id) AS max_pizza_orders_per_single_delivery
FROM cleaned_cust_orders cc
INNER JOIN cleaned_runner_orders cr
ON cc.order_id = cr.order_id
WHERE cancellation IS NULL
GROUP BY cc.order_id
ORDER BY max_pizza_orders_per_single_delivery desc
LIMIT 1;

--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT customer_id,
SUM(CASE
	WHEN exclusions NOT NULL OR extras NOT NULL THEN 1
    ELSE 0
END) AS at_least_one_change,
SUM(CASE
	WHEN exclusions IS NULL AND extras IS NULL THEN 1
    ELSE 0
END) AS no_changes
FROM cleaned_cust_orders cc
INNER JOIN cleaned_runner_orders cr
ON cc.order_id = cr.order_id
WHERE cancellation IS NULL
GROUP BY customer_id;

--How many pizzas were delivered that had both exclusions and extras?

SELECT COUNT(cc.order_id) AS both_exclusions_and_extras
FROM cleaned_cust_orders cc
INNER JOIN cleaned_runner_orders cr
ON cc.order_id = cr.order_id
WHERE cancellation IS NULL AND exclusions NOT NULL AND extras NOT NULL;

--What was the total volume of pizzas ordered for each hour of the day?

SELECT strftime('%H', order_time) AS hour, COUNT(order_id) AS pizzas_ordered
FROM cleaned_cust_orders
GROUP BY hour
ORDER BY hour;

--What was the volume of orders for each day of the week?

SELECT 
CASE
CAST (strftime('%w', order_time) as integer)
  WHEN 0 THEN 'Sunday'
  WHEN 1 THEN 'Monday'
  WHEN 2 THEN 'Tuesday'
  WHEN 3 THEN 'Wednesday'
  WHEN 4 THEN 'Thursday'
  WHEN 5 THEN 'Friday'
  ELSE 'Saturday' 
END as weekday, 
COUNT(order_id) AS pizzas_ordered
FROM cleaned_cust_orders
GROUP BY weekday
ORDER BY pizzas_ordered desc;

