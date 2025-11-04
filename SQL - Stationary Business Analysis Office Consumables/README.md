# Office Consumables Business Analytics Portfolio

## Overview
This project showcases my ability to design, query, and analyze real-world retail datasets using Microsoft SQL Server (T-SQL).
It’s built around operational data from a stationery and office supplies business, featuring product, order, employee, and customer information modeled into a clean relational schema for advanced business analytics.

## The goal is to demonstrate:
- Strong data modeling and SQL normalization techniques.
- Advanced query writing for performance and insight generation.
- Use of window functions, CASE logic, and dynamic pivots for analytics.
- Real-world reporting automation and KPI generation inside SQL Server.

## Data Source:
- Product Data: Product catalog with category, name, price, and discount information.
- Orders Data: Transactional sales data with sales, profit, discount, and date fields.
- Customer Data: Customer profiles including segment and state.
- Employees Data: Employee list for linking orders to sales representatives.

## Key SQL Features Demonstrated
- Dynamic date parsing and creation of a reusable clean view (`v_orders_clean`).  
- Aggregations by category, segment, geography, and employee.  
- Margin analysis and performance ranking using window functions.  
- Basket pairing and trend analytics using CTEs.  
- Profit leakage detection and recency/churn analysis for customer retention.  
- Data-driven filtering based on actual dataset timelines.

## Highlighted Analytical Queries
| # | Query | Purpose |
| - | ------ | -------- |
| 1 | Monthly Sales Overview | Monitor revenue, units, and profit over time |
| 2 | Top 20 Products (Last 90 Days) | Identify fast-moving products by revenue |
| 3 | Category + Subcategory Performance | Evaluate mix and margin contribution |
| 4 | Customer Segment Performance | Compare profitability across customer groups |
| 5 | Geographic Heatmap | Analyze revenue distribution by state and city |
| 6 | Discount Bands | Evaluate margin impact of discount levels |
| 7 | Employee Performance | Rank employees by sales, profit, and margin |
| 8 | Average Order Value | Measure basket size by segment and ship mode |
| 9 | Order-to-Ship Lead Time | Track delivery efficiency by region and ship mode |
| 10 | Negative / Low Margin Flags | Detect unprofitable products or areas |
| 11 | Repeat Rate & Recency | Measure customer retention and activity gaps |
| 12 | Basket Pairings by Subcategory | Discover commonly co-purchased product types |
| 13 | Price per Unit Insight | Assess pricing consistency across products |
| 14 | Quarterly Category Trend | Identify seasonal category growth patterns |

## Business Insights Generated
- **Sales & Seasonal Trends**  
  - Showcased by: [Monthly Sales Overview](./MONTHLY%20SALES%20OVERVIEW.csv), [Quarterly Category Trend](./QUARTERLY%20CATEGORY%20TREND.csv)  
  - Recommendation:

| Focus Area | Evidence | Recommendation | Expected Impact |
| ----------- | -------- | -------------- | ---------------- |
| **Quarterly Category Trend** | Stationery peaked in Q3 ($58K) before 9 % decline in Q4 | Increase stock by July–August; scale down post-September | +6 % inventory efficiency |
| **Seasonality Awareness** | Q2–Q3 peak aligns with school supply cycle | Launch promotions early Q2 | +8 % sales lift during back-to-school |

- **Product & Pricing Insight**  
  - Showcased by: [Top 20 Products by Revenue (Last 90 Days)](./TOP%2020%20PRODUCTS%20BY%20REVENUE%20(LAST%2090%20DAYS).csv), [Price per Unit Insight](./PRICE%20PER%20UNIT%20INSIGHT.csv)  
  - Recommendation:

| Focus Area | Evidence | Recommendation | Expected Impact |
| ----------- | -------- | -------------- | ---------------- |
| **High-Performing SKUs** | “Executive Pen Set” and “Premium Notebook” = 25 % of total revenue | Keep steady supply; expand similar premium line | +5 % total revenue |
| **Price Ladder** | Average unit price consistent across size tiers | Maintain pricing strategy | Stable margin, low cannibalization |

- **Customer Behavior & Retention**  
  - Showcased by: [Repeat Rate & Recency](./REPEAT%20RATE%20&%20RECENCY.csv), [Customer Segment Performance](./CUSTOMER%20SEGMENT%20PERFORMANCE.csv)  
  - Recommendation:

| Focus Area | Evidence | Recommendation | Expected Impact |
| ----------- | -------- | -------------- | ---------------- |
| **Churn Risk** | 35 % customers inactive > 90 days | Run win-back email campaign | +10 % customer reactivation |
| **Segment Profitability** | Corporate segment 40 % of revenue, 32 % profit margin | Offer bulk order incentives | Strengthen B2B loyalty |

- **Operational & Fulfillment Metrics**  
  - Showcased by: [Order-to-Ship Lead Time](./ORDER%E2%80%91TO%E2%80%91SHIP%20LEAD%20TIME.csv), [Average Order Value](./AVERAGE%20ORDER%20VALUE.csv)  
  - Recommendation:

| Focus Area | Evidence | Recommendation | Expected Impact |
| ----------- | -------- | -------------- | ---------------- |
| **Shipping Speed** | Standard mode avg = 6.4 days | Optimize dispatch process | +3 days faster delivery |
| **Order Size** | Corporate orders avg $420 vs Consumer $280 | Bundle office essentials for larger orders | +12 % average order value |

- **Employee & Profitability Analysis**  
  - Showcased by: [Employee Performance](./EMPLOYEE%20PERFORMANCE.csv), [Discount Bands](./DISCOUNT%20BANDS.csv), [Negative and Low Margin Flags](./NEGATIVE%20AND%20LOW%20MARGIN%20FLAGS.csv)  
  - Recommendation:

| Focus Area | Evidence | Recommendation | Expected Impact |
| ----------- | -------- | -------------- | ---------------- |
| **Top Performers** | Employee 102 generates 1.8× avg revenue | Use as benchmark for coaching others | +7 % team sales uplift |
| **Margin Control** | Discounts > 20 % reduce profit < 10 % | Cap discounts ≤ 15 %; switch to bundle promos | +4 ppt overall margin |
| **Low Margin Alerts** | 8 % of SKUs < 10 % margin | Renegotiate supplier cost or drop lines | +$25K annual recovery |

- **Cross-Selling & Basket Insights**  
  - Showcased by: [Basket Pairings by Subcategory](./BASKET%20PAIRINGS%20BY%20SUBCATEGORY.csv), [Category + Subcategory Performance](./CATEGORY%20+%20SUBCATEGORY%20PERFORMANCE.csv)  
  - Recommendation:

| Focus Area | Evidence | Recommendation | Expected Impact |
| ----------- | -------- | -------------- | ---------------- |
| **Common Combos** | “Printer Paper” + “Pens” frequent co-purchases | Create bundle packs or auto-suggest in POS | +9 % attachment rate |
| **Category Mix** | Office Supplies > Stationery in units but lower margin | Promote high-margin stationery add-ons | +2 ppt profit margin |

- **Geographic Opportunity**  
  - Showcased by: [Geographic Heatmap](./GEOGRAPHIC%20HEATMAP.csv)  
  - Recommendation:

| Focus Area | Evidence | Recommendation | Expected Impact |
| ----------- | -------- | -------------- | ---------------- |
| **Growth States** | NSW + 12 % revenue YoY | Expand distribution in top states | +8 % sales |
| **Low-Performing Cities** | Regional VIC underperforming | Focus B2B partnerships | +5 % local uplift |

## Tech Stack
- Database: Microsoft SQL Server 2022
- Language: T-SQL
- Tools: SQL Server Management Studio (SSMS), Excel
- Data Volume: ~100 K transactions, 4 tables (Orders, Products, Customers, Employees)

## Author
- Frank Dinh
- Data Analyst | Retail & Operations Analytics
- Focused on SQL-based analytics, process automation, and Power BI dashboarding.




























