-- Q1 Top 5 and bottom 3 products by units sold
-- Top 5 products by quantity sold
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

-- Q4 5. Margin analysis — which products/areas are actually profitable vs. just high-volume
-- Product margin
SELECT 
    p.product_name,
    p.category,
    SUM(oi.quantity) AS total_qty_sold,
    SUM(oi.quantity * oi.unit_price_at_sale) AS total_revenue,
    SUM(oi.quantity * p.unit_cost) AS total_cost,
    SUM(oi.quantity * (oi.unit_price_at_sale - p.unit_cost)) AS total_margin
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY total_margin DESC
-- Axis margin
SELECT 
    o.axis,
    SUM(oi.quantity * oi.unit_price_at_sale) AS total_revenue,
    SUM(oi.quantity * (oi.unit_price_at_sale - p.unit_cost)) AS total_margin
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
GROUP BY o.axis
ORDER BY total_margin DESC