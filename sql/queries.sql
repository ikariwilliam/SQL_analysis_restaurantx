-- Top 5 products by quantity sold
SELECT p.product_id, p.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_sold DESC
LIMIT 5;

-- Bottom 3 products by quantity sold
SELECT p.product_id,p.product_name, SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_sold ASC
LIMIT 3;

-- order volume by delivery axis
SELECT axis, COUNT(order_id) AS total_orders
FROM orders
GROUP BY axis
ORDER BY total_orders DESC

