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

| Day       | Total Orders | Avg Amount Charged (₦) | Total Revenue (₦) |
|-----------|-------------:|-------------------------:|--------------------:|
| Friday    | 1,279        | 31,694.50                | 40,537,267.44        |
| Tuesday   | 708          | 32,091.70                | 22,720,922.37        |
| Monday    | 663          | 33,526.59                | 22,228,128.18        |
| Thursday  | 665          | 33,141.39                | 22,039,021.83        |
| Saturday  | 674          | 32,283.07                | 21,758,787.22        |
| Wednesday | 637          | 33,378.38                | 21,262,028.41        |
| Sunday    | 374          | 32,351.45                | 12,099,441.16        |

*Note: "Avg Amount Charged" is the post-discount amount per order. "Total Revenue" is the 
sum of all orders for that day — these tell different stories.*

- **Busiest day by order count and revenue: Friday** — 1,279 orders generating ₦40.5M, nearly double the next-highest day (Tuesday, ₦22.7M)
- **Friday also has the lowest average order value** (₦31,694.50) — but this does NOT mean it's a weak sales day. High order volume more than compensates for smaller average order size, making Friday the strongest revenue day of the week by a wide margin
- **Sunday is the genuinely weak day** — lowest order count (374) AND lowest total revenue (₦12.1M), despite a mid-pack average order value. Low volume, not low order value, is what drives Sunday's underperformance

## Q4: Top 20 Most Frequent Customers (Orders Above ₦15k Only)
See [sql/queries.sql](sql/queries.sql) for the full query.

**Findings:**

Top 5 of the 20 most frequent customers (counting only orders over ₦15,000):
1. Gabriel Ojo — 113 qualifying orders
2. Sarah Abiola — 104 qualifying orders
3. Faith Olawale — 103 qualifying orders
4. Paul Abiola — 102 qualifying orders
5. Samuel Ibrahim — 101 qualifying orders

- The top 20 customers all fall within a tight range of 81–113 qualifying orders each
- There's a sharp drop-off right after rank 20 — the 21st most frequent customer has only 12 qualifying orders, less than a sixth of the 20th-ranked customer's total (81). This isn't a gradual decline; it's a clear break, suggesting these top 20 form a distinct high-frequency customer segment rather than simply being the natural tail end of a smooth distribution
- This kind of sharp segmentation would be a strong candidate for a loyalty/VIP program targeting analysis, since these customers behave meaningfully differently from the rest of the customer base

## Q5: Margin Analysis — Profitable vs. Just High-Volume
See [sql/queries.sql](sql/queries.sql) for the full queries.

**Findings:**

Top 5 products by total margin:
1. Grills & Suya Item #5 — ₦9,127,300 margin
2. Grills & Suya Item #7 — ₦7,048,800 margin
3. Grills & Suya Item #14 — ₦5,548,400 margin
4. Rice & Swallow Item #8 — ₦3,823,950 margin
5. Grills & Suya Item #26 — ₦3,578,400 margin

Bottom 5 products by total margin:
36. Drinks & Beverage Item #36 — ₦172,000 margin
37. Sides & Extra Item #37 — ₦231,600 margin
38. Sides & Extra Item #38 — ₦243,900 margin
39. Drinks & Beverage Item #40 — ₦247,000 margin
40. Sides & Extra Item #20 — ₦381,000 margin

- **Volume doesn't equal profitability.** Sides & Extra Item #2 was the #1 best-selling product by units (Q1), but ranks only #18 of 40 by margin. Grills & Suya Item #5 — the #2 best seller by volume — is the #1 product by margin, generating over 23x more profit than the lowest-margin product
- **Grills & Suya dominates the top of the margin ranking**, taking 4 of the top 5 spots — this category likely carries a higher price-to-cost ratio than Sides & Extras or Drinks & Beverage, which fill most of the bottom of the list

Axis (delivery zone) margin ranking (top and bottom 3 of 19):
1. Ikota — ₦14,527,400 margin
2. Ajah — ₦7,270,850 margin
3. Ikate — ₦5,745,000 margin
...
17. LBS — ₦331,350 margin
18. General Paint — ₦144,050 margin

- **Ikota is both the highest-volume zone (Q2) and the highest-margin zone** — nearly double the next-best zone (Ajah), confirming its dominance isn't just about order count but translates directly into profit
- General Paint and LBS remain the weakest zones on margin too, consistent with their low order volume from Q2 — no surprising reversal here, unlike the product-level findings.

## Q6: Order Cancellation Rate — Overall and by Day
See [sql/queries.sql](sql/queries.sql) for the full query.

**Findings:**

| Day       | Total Orders | Cancelled | Cancellation Rate |
|-----------|-------------:|----------:|-------------------:|
| Friday    | 1,279        | 113       | 8.84%               |
| Thursday  | 665          | 38        | 5.71%               |
| Monday    | 663          | 32        | 4.83%               |
| Tuesday   | 708          | 31        | 4.38%               |
| Wednesday | 637          | 27        | 4.24%               |
| Sunday    | 374          | 14        | 3.74%               |
| Saturday  | 674          | 20        | 2.97%               |

**Overall cancellation rate: 5.5%** (275 of 5,000 orders)

- **Friday has both the highest order volume AND the highest cancellation rate** (8.84%) — over 3x higher than Saturday, the lowest (2.97%). This compounds the Q3 finding that Friday drives high volume with lower average order value; now it's also shedding the highest share of that volume to cancellations
- Every other day sits in a fairly tight band (2.97%–5.71%), meaning Friday is a genuine outlier rather than part of a gradual trend — worth investigating what's operationally different about Fridays (staffing, order backlog, rider availability) that might be driving both the volume spike and the cancellation spike together