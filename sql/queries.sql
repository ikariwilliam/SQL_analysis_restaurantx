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

-- Q7 Discount/pricing discrepancy check — orders where the recorded amount doesn't match the sum of item totals, or where discount % looks abnormally high
WITH order_calc AS (
    SELECT 
        o.order_id,
        o.subtotal_amount,
        o.discount_amount,
        o.final_amount_charged,
        COALESCE(SUM(oi.quantity * oi.unit_price_at_sale), 0) AS calculated_subtotal
    FROM orders o
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id, o.subtotal_amount, o.discount_amount, o.final_amount_charged
)
SELECT *
FROM order_calc
WHERE subtotal_amount <> calculated_subtotal
   OR (subtotal_amount - COALESCE(discount_amount, 0)) <> final_amount_charged
   OR (COALESCE(discount_amount, 0) / NULLIF(subtotal_amount, 0)) > 0.5;

-- Q8. Staff performance — which customer service staff processes the most orders, and is there a difference in order accuracy/cancellation rate by staff member
SELECT 
    s.staff_name,
    s.role,
    COUNT(DISTINCT o.order_id) AS total_orders_processed,
    COUNT(DISTINCT o.order_id) FILTER (WHERE o.order_status = 'Cancelled') AS cancelled_orders,
    ROUND(100.0 * COUNT(DISTINCT o.order_id) FILTER (WHERE o.order_status = 'Cancelled') 
        / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS cancellation_rate_pct,
    COUNT(DISTINCT c.complaint_id) AS total_complaints,
    ROUND(100.0 * COUNT(DISTINCT c.complaint_id) 
        / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS complaint_rate_pct
FROM staff s
LEFT JOIN orders o ON s.staff_id = o.staff_id
LEFT JOIN complaints c ON o.order_id = c.order_id
GROUP BY s.staff_id, s.staff_name, s.role
ORDER BY total_orders_processed DESC

-- Follow-up: CSR Peace had far fewer total orders than the other 3 staff — 
-- checking whether this is a tenure/activity issue or a throughput issue
SELECT 
    s.staff_name,
    COUNT(o.order_id) AS total_orders,
    COUNT(DISTINCT DATE(o.order_timestamp)) AS active_days,
    ROUND(COUNT(o.order_id)::numeric / NULLIF(COUNT(DISTINCT DATE(o.order_timestamp)), 0), 2) AS avg_orders_per_active_day
FROM staff s
LEFT JOIN orders o ON s.staff_id = o.staff_id
GROUP BY s.staff_id, s.staff_name
ORDER BY avg_orders_per_active_day DESC

-- Q9 Rider performance — order completion rate per rider, quick vs. late delivery rate, and customer complaint rate per rider
SELECT 
    r.rider_name,
    COUNT(DISTINCT o.order_id) AS total_orders_assigned,
    COUNT(DISTINCT o.order_id) FILTER (WHERE o.order_status = 'Completed') AS completed_orders,
    ROUND(100.0 * COUNT(DISTINCT o.order_id) FILTER (WHERE o.order_status = 'Completed') 
        / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS completion_rate_pct,
    COUNT(DISTINCT o.order_id) FILTER (WHERE o.order_status = 'Delivered Late') AS late_orders,
    ROUND(100.0 * COUNT(DISTINCT o.order_id) FILTER (WHERE o.order_status = 'Delivered Late') 
        / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS late_rate_pct,
    COUNT(DISTINCT c.complaint_id) AS total_complaints,
    ROUND(100.0 * COUNT(DISTINCT c.complaint_id) 
        / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS complaint_rate_pct
FROM riders r
LEFT JOIN orders o ON r.rider_id = o.rider_id
LEFT JOIN complaints c ON o.order_id = c.order_id
GROUP BY r.rider_id, r.rider_name
ORDER BY total_orders_assigned DESC

-- Q10 Supplier cost analysis — most cost-effective suppliers, and whether supplier choice correlates with product margin
SELECT 
    sup.supplier_name,
    sup.supply_category,
    COUNT(p.product_id) AS products_supplied,
    ROUND(AVG(p.unit_cost), 2) AS avg_unit_cost,
    ROUND(AVG(p.unit_price - p.unit_cost), 2) AS avg_product_margin
FROM suppliers sup
JOIN products p ON sup.supplier_id = p.supplier_id
GROUP BY sup.supplier_id, sup.supplier_name, sup.supply_category
ORDER BY avg_product_margin DESC