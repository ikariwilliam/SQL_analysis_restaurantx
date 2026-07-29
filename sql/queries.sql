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

-- Q5 5. Margin analysis — which products/areas are actually profitable vs. just high-volume
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

-- Q6 6. Order cancellation rate — overall, and whether it's higher on certain days
SELECT 
    TO_CHAR(order_timestamp, 'Day') AS day_of_week,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND(100.0 * SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancellation_rate_pct
FROM orders
GROUP BY TO_CHAR(order_timestamp, 'Day')
ORDER BY cancellation_rate_pct DESC;

-- Repeat vs. one-time customers — what % of customers only ordered once vs. came back
SELECT
    COUNT(*) FILTER (WHERE order_count = 1) AS one_time_customers,
    COUNT(*) FILTER (WHERE order_count > 1) AS repeat_customers,
    ROUND(100.0 * COUNT(*) FILTER (WHERE order_count = 1) / COUNT(*), 2) AS one_time_pct,
    ROUND(100.0 * COUNT(*) FILTER (WHERE order_count > 1) / COUNT(*), 2) AS repeat_pct
FROM (
    SELECT customer_id, COUNT(order_id) AS order_count
    FROM orders
    GROUP BY customer_id
) customer_orders