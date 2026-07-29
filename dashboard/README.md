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

---