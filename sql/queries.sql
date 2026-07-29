-- Q1 Top 5 products by quantity sold
SELECT p.product_id, p.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_sold DESC
LIMIT 5

-- Bottom 3 products by quantity sold
SELECT p.product_id,p.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_sold ASC
LIMIT 3

-- Q2 order volume by delivery axis
SELECT axis, COUNT(order_id) AS total_orders
FROM orders
GROUP BY axis
ORDER BY total_orders DESC

-- Q3 Busiest day and lowest average order value by day of week
SELECT 
    TO_CHAR(order_timestamp, 'Day') AS day_of_week,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(final_amount_charged), 2) AS avg_amount_charged,
    SUM(final_amount_charged) AS total_revenue
FROM orders
GROUP BY TO_CHAR(order_timestamp, 'Day')
ORDER BY total_orders DESC

-- Q4 Top 20 most frequent customers on orders above 15k
SELECT c.customer_id, c.name, c.axis, COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.final_amount_charged > 15000
GROUP BY c.customer_id, c.name, c.axis
ORDER BY order_count DESC
LIMIT 20