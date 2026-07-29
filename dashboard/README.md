# Ikota Eats: Power BI Dashboard

This dashboard visualizes the findings from the [SQL analysis](../README.md) as an 
interactive Power BI report. Built in Power BI Desktop, connected directly to the 
PostgreSQL database via Import mode.

## Page 1: Overview

![Page 1: Overview](screenshots/page1_overview.jpg)

**What it shows:**
- KPI summary: 5,000 total orders, ₦162.65M total revenue, ₦32.53K average order value, 
  5.50% overall cancellation rate
- **Orders & Revenue by Day of Week** — reveals that Friday drives both the highest order 
  volume and the highest total revenue, despite having the lowest average order value of 
  any day. This visual captures the Friday pattern that recurs throughout the analysis: 
  high volume, smaller typical orders, and (as shown elsewhere) the highest cancellation rate
- **Most/Least Sold Products** — the top 5 and bottom 3 products by units sold, confirming 
  that sales volume is concentrated in Sides & Extras and Drinks & Beverage categories at 
  both ends of the ranking
- **Orders by Axis (Most/Least)** — the top 10 and bottom 10 delivery zones by order volume, 
  showing Ikota's clear dominance (over double the next-highest zone) and the sharp drop-off 
  toward low-coverage zones like General Paint and LBS

Full interactive file: [Ikota_eats_dashboard.pbix](Ikota_eats_dashboard.pbix)

## Page 2: Product & Revenue Deep Dive

![Page 2: Product & Revenue](screenshots/page2_product_revenue.jpg)

**What it shows:**
- **Most/Least Profitable Products** — top 5 and bottom 5 products by total margin, 
  confirming that Grills & Suya items dominate the most profitable end, while Sides & 
  Extras and Drinks & Beverage cluster at the low end — the opposite pattern from units 
  sold, where those same categories lead in volume
- **Top 10 Margin by Delivery Axis** — Ikota leads on profit as well as volume, confirming 
  its dominance isn't just about order count
- **Units Sold vs. Margin by Product** (scatter) — visually demonstrates that sales volume 
  and profitability are not correlated in this dataset. High-volume products cluster at 
  moderate-to-low margin, while the highest-margin product sits at a mid-range volume, 
  not the top seller
- **Flagged Orders card** — 110 of 5,000 orders (2.2%) flagged for a subtotal-vs-line-items 
  mismatch, consistent with the Q7 discrepancy check

Full interactive file: [Ikota_eats_dashboard.pbix](Ikota_eats_dashboard.pbix)

## Page 3: Staff & Rider Performance

![Page 3: Staff & Rider Performance](screenshots/page3_staff_rider_performance.jpg)

**What it shows:**
- **Staff Performance Table** — order volume, cancellation rate, and complaint rate per 
  CSR. CSR Peace stands out with a 16.75% cancellation rate versus 3.64%–5.33% for the 
  other three staff, despite processing far fewer total orders
- **Rider Completion Rate** (bar chart) — Rider Paul is flagged in red, visually isolating 
  the most extreme outlier in the entire dataset: a 61% completion rate versus 91%+ for 
  every other rider
- **Rider Detail Table** — full breakdown per rider including late-delivery rate. Paul is 
  the only rider with any late deliveries at all (33.40%), while every other rider shows 0%

Full interactive file: [Ikota_eats_dashboard.pbix](Ikota_eats_dashboard.pbix)

## Page 4: Customers & Suppliers

![Page 4: Customers & Suppliers](screenshots/page4_customers_suppliers.jpg)

**What it shows:**
- **Top 20 Most Frequent Customers** (orders above ₦15k) — confirms the sharp segmentation 
  found in Q4: all 20 customers fall within 81–113 qualifying orders, distinctly separated 
  from the rest of the customer base
- **Average Margin by Supplier** — average per-product margin, matching the Q10 analysis. 
  Supplier F (Fresh Produce) leads at ~₦2,930 average margin, while Supplier C (Beverages & 
  Drinks) trails at ~₦1,725, despite having the highest average unit cost — its higher input 
  cost isn't being fully passed through to margin. As noted in Q10, each supplier maps to 
  exactly one product category with no overlap, so this reflects category-level differences 
  as much as supplier effectiveness

Full interactive file: [Ikota_eats_dashboard.pbix](Ikota_eats_dashboard.pbix)