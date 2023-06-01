--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Case Study Questions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Runner and Customer Experience
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT strftime('%W', registration_date) AS week_of_registration, COUNT(runner_id) AS number_of_runners
FROM Runners
GROUP BY week_of_registration
ORDER BY week_of_registration;

--What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT runner_id, 
CAST ((AVG((JulianDay(pickup_time) - JulianDay(order_time)))) * 24 * 60 AS INTEGER) AS avg_time_in_minutes
FROM cleaned_runner_orders cr
INNER JOIN cleaned_cust_orders cc
ON cr.order_id = cc.order_id
WHERE cancellation IS NULL
GROUP BY runner_id
ORDER BY avg_time_in_minutes;

--Is there any relationship between the number of pizzas and how long the order takes to prepare?

WITH set_up AS (

SELECT cc.order_id, COUNT(cc.order_id) AS pizza_count, 
CAST (((JulianDay(pickup_time) - JulianDay(order_time))) * 24 * 60 AS INTEGER) AS minutes_to_prepare
FROM cleaned_runner_orders cr
INNER JOIN cleaned_cust_orders cc
ON cr.order_id = cc.order_id
WHERE cancellation IS NULL
GROUP BY cc.order_id
)

SELECT pizza_count, AVG(minutes_to_prepare)
FROM set_up
GROUP BY pizza_count;

--What was the average distance travelled for each customer?

SELECT customer_id, ROUND(AVG(distance_km),1)
FROM cleaned_runner_orders cr
INNER JOIN cleaned_cust_orders cc
ON cr.order_id = cc.order_id
WHERE cancellation IS NULL
GROUP BY customer_id;

--What was the difference between the longest and shortest delivery times for all orders?

SELECT MAX(duration_mins) - MIN(duration_mins)
FROM cleaned_runner_orders
WHERE cancellation IS NULL;

--What was the average speed for each runner for each delivery and do you notice any trend for these values?

SELECT runner_id, order_id, (distance_km * 60 / duration_mins) AS 'Km/H'
FROM cleaned_runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id, order_id
ORDER BY order_id;

--What is the successful delivery percentage for each runner?

SELECT runner_id,
CAST (100.0 * count(pickup_time) / count(order_id) AS numeric(5,2)) as percentage
FROM cleaned_runner_orders
GROUP BY runner_id;
