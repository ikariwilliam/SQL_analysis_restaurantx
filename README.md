# SQL_analysis_restaurantx
End-to-end restaurant operations &amp; financial analysis project using PostgreSQL for data extraction and Power BI for interactive dashboards.
# Ikota Eats: SQL Analytics Project

## Overview
This project analyzes operational and financial data for a synthetic Lekki/Ikota-corridor 
food delivery business. Using a relational PostgreSQL database of 5,000 orders, 400 customers, 
and 40 products, I answer 10 real-world business questions covering sales performance, 
delivery zone patterns, customer retention, staff and rider performance, and supplier cost 
efficiency. Findings are visualized in an interactive Power BI dashboard.

## Tools
- **PostgreSQL** (via pgAdmin 4) — database hosting and query execution
- **SQL** — data extraction, aggregation, and analysis
- **Power BI** — dashboard visualization of key findings

## Database Schema
9 tables: `customers`, `orders`, `order_items`, `products`, `payments`, `complaints`, 
`staff`, `riders`, `suppliers` — full structure in [sql/schema.sql](sql/schema.sql).


## Business Questions
1. Top 5 and bottom 3 products by units sold
2. Which axis (delivery zone) customers order from the most and least
3. Busiest and lowest average order day (by day of week)
4. Top 20 most frequent customers, counting only orders above ₦15k
5. Margin analysis — which products/areas are profitable vs. just high-volume
6. Order cancellation rate — overall and by day
7. Repeat vs. one-time customers
8. Discount/pricing discrepancy check
9. Staff performance — order volume and cancellation/complaint rate by staff member
10. Rider performance — completion rate, late-delivery rate, complaint rate
11. Supplier cost analysis — cost-effectiveness and margin correlation

---


## Q1: Top 5 and Bottom 3 Products by Units Sold
See [sql/queries.sql](sql/queries.sql) for the full query.

**Findings:**

Top 5 by units sold:
1. Sides & Extra Item #2 — 1,574 units
2. Grills & Suya Item #5 — 1,547 units
3. Drinks & Beverage Item #4 — 1,488 units
4. Drinks & Beverage Item #1 — 1,466 units
5. Drinks & Beverage Item #3 — 1,461 units

Bottom 3 by units sold:
1. Sides & Extra Item #38 — 271 units
2. Grills & Suya Item #39 — 230 units
3. Drinks & Beverage Item #40 — 190 units

- Top 5 sellers are tightly clustered (1,461–1,574 units), suggesting broad, even demand across the best performers rather than one runaway favorite
- The weakest product sells roughly 8x fewer units than the top seller (190 vs. 1,574) — worth checking in a later question whether this is a pricing, availability, or genuine low-demand issue
- Both Sides & Extras and Drinks & Beverage categories appear at *both* ends of the ranking — so it's not that a whole category underperforms, it's specific items within otherwise strong categories

## Q2: Which Axis (Delivery Zone) Customers Order From Most and Least
See [sql/queries.sql](sql/queries.sql) for the full query.

**Findings:**

Highest order volume:
1. Ikota — 1,005 orders
2. Ajah — 476 orders
3. VGC — 455 orders

Lowest order volume:
1. General Paint — 17 orders
2. LBS — 33 orders
3. Sangotedo — 102 orders

- Ikota accounts for roughly 20% of all orders on its own — more than double the next-closest zone (Ajah) — suggesting either a dense customer base or strong brand presence concentrated in that axis
- General Paint and LBS are outliers at the low end, each under 35 orders — over 25x smaller than Ikota. Given the gap is this large, these may be smaller/newer delivery zones or edge-of-coverage areas rather than typical zones performing poorly
- The remaining 14 zones fall in a much more gradual range (100–350 orders), suggesting the business has one dominant hub (Ikota) surrounded by a fairly even spread of secondary zones, plus two clear long-tail outliers

## Q3: Busiest Day and Lowest Average Order Day (by Day of Week)
See [sql/queries.sql](sql/queries.sql) for the full query.

**Findings:**

| Day       | Total Orders | Avg Order Value (₦) |
|-----------|-------------:|---------------------:|
| Friday    | 1,279        | 31,694.50            |
| Tuesday   | 708          | 32,091.70            |
| Saturday  | 674          | 32,283.07            |
| Thursday  | 665          | 33,141.39            |
| Monday    | 663          | 33,526.59            |
| Wednesday | 637          | 33,378.38            |
| Sunday    | 374          | 32,351.45            |

- **Busiest day by order count: Friday** (1,279 orders) — nearly double the next-highest day (Tuesday, 708)
- **Lowest order count: Sunday** (374 orders) — the quietest day of the week by volume
- **Lowest average order value: Friday** (₦31,694.50) — notably, this is the *same* day that has the highest order count. This suggests Friday's volume is driven by a higher number of smaller-value orders rather than proportionally higher revenue per order — worth investigating whether this reflects different customer behavior (e.g. quick weekday lunch orders) or a promotional pattern specific to Fridays
- Despite having the fewest orders, Sunday's average order value (₦32,351.45) is actually mid-pack — not the lowest, meaning low volume on Sunday isn't accompanied by low-value orders