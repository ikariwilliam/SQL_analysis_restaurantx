# SQL_analysis_restaurantx
End-to-end restaurant operations &amp; financial analysis project using PostgreSQL for data extraction and Power BI for interactive dashboards.
# Ikota Eats: SQL Analytics Project

## Overview
This project analyzes operational and financial data for a synthetic Lekki/Ikota-corridor 
food delivery business. Using a relational PostgreSQL database of 5,000 orders, 400 customers, 
and 40 products, I answer 10 real-world business questions covering sales performance, 
delivery zone patterns, customer purchasing patterns, staff and rider performance and supplier cost 
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
7. Discount/pricing discrepancy check
8. Staff performance — order volume and cancellation/complaint rate by staff member
9. Rider performance — completion rate, late-delivery rate, complaint rate
10. Supplier cost analysis — cost-effectiveness and margin correlation

---

## Key Takeaways

Pulling together the patterns that showed up across multiple questions:

**1. Friday is operationally distinct — and it compounds.**
Friday drives the highest order volume (1,279 orders, nearly double the next-highest day) 
but also has the lowest average order value AND the highest cancellation rate (8.84%, 
over 3x the lowest day). Despite the smaller average order size, Friday still generates 
the most total revenue by a wide margin — but the elevated cancellation rate suggests 
something operationally strained about Fridays specifically (staffing, order backlog, or 
rider availability), not just a naturally busier day.

**2. Two clear outliers surfaced in staff and rider performance — both worth real operational follow-up.**
- **CSR Peace** processes far fewer orders than the other three staff, is active on roughly 
  half as many days, and has a cancellation rate 3–4x higher than her peers even accounting 
  for reduced activity.
- **Rider Paul** is the most extreme outlier in the entire dataset: a 61% completion rate 
  and 33.4% late-delivery rate, versus 91%+ completion and 0% late-delivery for every other 
  rider. His complaint rate (12%) is up to 30x higher than any other rider.

Both patterns are isolated to a single individual rather than reflecting a team-wide issue — 
exactly the kind of signal that's easy to miss in aggregate reporting but obvious once you 
break performance out by person.

**3. Sales volume and profitability are not the same thing.**
The best-selling product by units (Sides & Extra Item #2) ranks only 18th of 40 products by 
margin. The actual most profitable product (Grills & Suya Item #5) was only the second 
best-seller by volume. Grills & Suya as a category dominates the top of the margin ranking, 
while Sides & Extras and Drinks & Beverage — despite strong unit sales — fill most of the 
bottom. A volume-only view of "top products" would have pointed the business toward the 
wrong items to prioritize.

**4. Ikota is the business's core hub, and its dominance holds up under scrutiny.**
Ikota accounts for roughly 20% of all orders — more than double the next-closest zone — and 
that dominance carries through to margin, not just order count, making it the highest-profit 
zone as well as the highest-volume one. On the other end, General Paint and LBS are 
consistent bottom performers across both order volume and margin, suggesting they may be 
edge-of-coverage zones rather than core delivery areas.

**Limitations.**
One question surfaced a real limitation in the dataset rather than a clean insight: 
supplier cost-effectiveness couldn't be cleanly separated from product category, since each 
supplier in this dataset supplies exactly one category with no overlap — so "supplier choice" 
and "category" are confounded variables here.

---

*A companion interactive Power BI dashboard visualizing these findings across 4 pages is 
available here: [dashboard/README.md](dashboard/README.md)*

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

## Q7: Discount / Pricing Discrepancy Check
See [sql/queries.sql](sql/queries.sql) for the full query.

**Findings:**

This query flags any order where:
1. The recorded subtotal doesn't match the sum of its line items
2. `subtotal − discount` doesn't equal the final amount charged
3. The discount exceeds 50% of the subtotal

Results: **110 of 5,000 orders (2.2%)** were flagged — all for reason #1 (subtotal ≠ sum of 
line items). Zero orders failed the final-amount check, and zero orders had an abnormally 
high discount ratio.

- The discount and final-amount logic is fully consistent across the entire dataset — every 
  order correctly applies `subtotal − discount = final_amount_charged`, and no order carries 
  a suspiciously large discount
- The 110 flagged orders all stem from a mismatch between the recorded subtotal and the actual 
  sum of order-item totals — these represent genuine pricing/recording discrepancies worth a 
  closer audit, similar in nature to a pricing diagnostic issue previously identified and 
  resolved in a prior operations role

## Q8: Staff Performance — Order Volume, Cancellation Rate, and Complaint Rate
See [sql/queries.sql](sql/queries.sql) for both queries.

**Initial findings (order volume, cancellation rate, complaint rate):**

| Staff Name  | Orders Processed | Cancelled | Cancellation Rate | Complaints | Complaint Rate |
|-------------|------------------:|----------:|--------------------:|-----------:|----------------:|
| CSR Joseph  | 1,593             | 58        | 3.64%                | 36         | 2.26%            |
| CSR Patience| 1,531             | 70        | 4.57%                | 26         | 1.70%            |
| CSR Ruth    | 1,464             | 78        | 5.33%                | 27         | 1.84%            |
| CSR Peace   | 412               | 69        | 16.75%               | 11         | 2.67%            |

CSR Peace immediately stood out — far lower total orders than the other three, alongside 
the highest cancellation and complaint rates. This raised a question the first query 
couldn't answer on its own: is Peace just newer/less active, or is throughput itself lower 
even when working?

**Follow-up: average orders processed per active day**

| Staff Name  | Active Days | Avg Orders/Active Day |
|-------------|------------:|-------------------------:|
| CSR Joseph  | 501         | 3.18                     |
| CSR Patience| 498         | 3.07                     |
| CSR Ruth    | 489         | 2.99                     |
| CSR Peace   | 282         | 1.46                     |

**Combined conclusion:**
- CSR Peace was active on only 282 of 545 possible days (~52%), compared to 489–501 days 
  for the other three staff — suggesting either a shorter tenure or an intermittent 
  work pattern
- Even accounting for fewer active days, Peace's throughput per active day (1.46) is 
  roughly half the rate of the other three (~3.0–3.2) — so reduced activity alone doesn't 
  fully explain the gap. Lower daily throughput combined with the highest cancellation 
  and complaint rates suggests a genuine performance difference, not just fewer shifts worked
- This is a good example of why a single aggregate metric (total orders) can be misleading — 
  digging into the rate (orders per active day) revealed the total-orders gap wasn't just 
  about frequency of work, but also about consistency of output while working

  ## Q9: Rider Performance — Completion Rate, Late Delivery Rate, Complaint Rate
See [sql/queries.sql](sql/queries.sql) for the full query.

**Findings:**

| Rider          | Orders | Completed | Completion Rate | Late | Late Rate | Complaints | Complaint Rate |
|----------------|-------:|----------:|------------------:|-----:|-----------:|-----------:|-----------------:|
| Rider Agnes    | 519    | 497       | 95.76%             | 0    | 0.00%      | 4          | 0.77%            |
| Rider John     | 516    | 488       | 94.57%             | 0    | 0.00%      | 3          | 0.58%            |
| Rider Grace    | 509    | 478       | 93.91%             | 0    | 0.00%      | 5          | 0.98%            |
| Rider Sarah    | 507    | 482       | 95.07%             | 0    | 0.00%      | 3          | 0.59%            |
| Rider Patience | 507    | 483       | 95.27%             | 0    | 0.00%      | 5          | 0.99%            |
| **Rider Paul** | 500    | 305       | **61.00%**         | 167  | **33.40%** | 60         | **12.00%**       |
| Rider Hope     | 495    | 472       | 95.35%             | 0    | 0.00%      | 2          | 0.40%            |
| Rider Simon    | 492    | 452       | 91.87%             | 0    | 0.00%      | 5          | 2.03%            |
| Rider Joy      | 492    | 460       | 93.50%             | 0    | 0.00%      | 5          | 1.02%            |
| Rider James    | 463    | 441       | 95.25%             | 0    | 0.00%      | 3          | 0.65%            |

- **Rider Paul is an extreme outlier across every metric measured.** Every other rider has a 
  0% late-delivery rate and a completion rate above 91%. Paul's completion rate is 61%, his 
  late-delivery rate is 33.4%, and his complaint rate (12%) is 6–30x higher than any other 
  rider
- This isn't a marginal underperformance — it's a distinct, isolated pattern affecting one 
  rider out of ten, while the other nine are tightly clustered and consistent with each other
- Given how sharply Paul's numbers diverge from every other rider, this looks like a rider 
  worth immediate operational review — vehicle issues, route assignment problems, or a 
  performance/attendance issue are all plausible explanations the data alone can't distinguish, 
  but the pattern is clear enough that it wouldn't need statistical testing to justify action

  ## Q10: Supplier Cost Analysis — Cost-Effectiveness and Margin Correlation
See [sql/queries.sql](sql/queries.sql) for the full query.

**Findings:**

| Supplier   | Category               | Products Supplied | Avg Unit Cost (₦) | Avg Product Margin (₦) |
|------------|-------------------------|--------------------:|---------------------:|--------------------------:|
| Supplier F | Fresh Produce            | 5                    | 2,850.00              | 2,930.00                  |
| Supplier A | Poultry & Meat           | 9                    | 2,427.78              | 2,594.44                  |
| Supplier B | Grains & Foodstuffs      | 6                    | 2,175.00              | 2,091.67                  |
| Supplier E | Spices & Condiments      | 4                    | 1,450.00              | 1,900.00                  |
| Supplier D | Packaging & Disposables  | 6                    | 1,933.33              | 1,800.00                  |
| Supplier C | Beverages & Drinks       | 10                   | 4,315.00              | 1,725.00                  |

- **Supplier F (Fresh Produce) has the highest average product margin** (₦2,930.00), while 
  **Supplier C (Beverages & Drinks) has the lowest** (₦1,725.00) despite having the highest 
  average unit cost (₦4,315.00) — high input cost isn't being fully passed through to margin 
  for this supplier's products
- **Important limitation:** each supplier in this dataset supplies exactly one product category, 
  with no overlap between suppliers. This means margin differences here cannot be cleanly 
  attributed to "supplier choice" as a variable — they're equally explainable by inherent 
  differences between food categories (e.g. beverages naturally pricing differently than 
  produce). A true supplier-effectiveness comparison would require multiple suppliers 
  competing within the same category, which this dataset doesn't include

 ## Dashboard

An interactive Power BI dashboard visualizing these findings is available here: 
[dashboard/README.md](dashboard/README.md)