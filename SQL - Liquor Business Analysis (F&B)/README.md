# Liquor Business Analytics Portfolio

## Overview
This project showcases my ability to design, query, and analyze real-world retail and wholesale datasets using Microsoft SQL Server (T-SQL).
It’s built around operational data from a multi-store liquor group, featuring sales, inventory, supplier, and customer data modeled into a unified SQL schema for advanced analytics.

## The goal is to demonstrate:
- Strong data modeling and normalization skills.
- Advanced SQL query writing for business insight generation.
- ETL and data quality management within SQL Server.
- Real retail performance reporting and KPI automation.

## Data Sources:
- Sales Data: Transactional sales dataset with outlet, product, quantity, revenue, cost, profit, and timestamp.
- Price Data: Current product price listings per store and branch.
- PO Data: Purchase orders and receiving records by supplier and outlet.
- Transfer Data: Internal stock transfers between outlets.
- Customer Data: Customer profiles and IDs.
- Supplier Data: Supplier master list and IDs.

## Key SQL Features Demonstrated
- Data cleansing and transformation using TRY_CONVERT, ROUND, and CASE logic.
- Creation of views (v_sales_clean, v_sales_weekly) for reusable analytical layers.
- Advanced window functions for ranking, rolling averages, and trend detection.
- Aggregations by time, store, and category dimensions.
- Joins across multiple fact and dimension tables.
- Business logic queries for KPIs such as margin in %, churn, and inventory turnover.
- Real operational insight generation ready for Power BI or Excel dashboards.

## Highlighted Analytical Queries
| #  | Query                               | Purpose                                         |
| -- | ----------------------------------- | ----------------------------------------------- |
| 1  | Monthly Sales by Outlet             | Track outlet performance over time              |
| 2  | Top 10 Products by Revenue          | Identify high-performing SKUs                   |
| 5  | Customers with Outstanding Balances | Monitor credit exposure                         |
| 7  | Price Consistency Across Branches   | Detect price discrepancies                      |
| 9  | Product Profitability League        | Rank products by profit and margin contribution |
| 13 | Transfer Flow Between Outlets       | Visualize inter-store stock movement            |
| 17 | Rolling 28-Day Average Sales        | Smooth demand trends for forecasting            |

## Business Insights Generated
- Revenue & profit trends by outlet, product, and category.
  - Showcased by: [Monthly Sales by Outlet](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/1%20MONTHLY%20SALES%20BY%20OUTLET.csv), [Weekly Trend by Outlet](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/10%20WEEKLY%20TREND%20BY%20OUTLET.csv), [Category Performance](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/3%20CATEGORY%20PERFORMANCE.csv), [Product Profitability League](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/9%20PRODUCT%20PROFITABILITY%20LEAGUE%20(YTD).csv)
  - Recommendation:

| Focus Area                  | Evidence                                             | Recommendation                                                                          | Expected Impact                      |
| --------------------------- | ---------------------------------------------------- | --------------------------------------------------------------------------------------- | ------------------------------------ |
| **High-performing outlets** | Charlemont Rise (+12.2%), Ferntree Gully (+8.8%)     | Continue premium assortment strategy; expand RTD and spirits facing.                    | +5–8% incremental sales uplift       |
| **Underperforming outlets** | St Albans (−4.4%), Ballarat (−2.6%)                  | Review product mix and price competitiveness; introduce local bundle promotions.        | Recover lost sales within 1–2 months |
| **Category mix**            | Spirits margin 23.8% vs Beer 14.3%                   | Increase Spirit and RTD shelf share by 10–15%; cross-merchandise with mixers.           | +1–2 ppt gross margin improvement    |
| **Low-margin category**     | Cider margin <10%                                    | Evaluate supplier pricing; consider fewer SKUs or switch to higher-margin local brands. | Margin normalization to ≥15%         |
| **Top profitable SKUs**     | Great Northern, VB, Smirnoff, Jack Daniels, Hennessy | Secure volume rebates with suppliers; maintain consistent pricing across branches.      | Sustained margin protection          |
| **Forecasting**             | Weekly trend (file #10) shows stable demand pattern  | Feed last 8 weeks’ weekly data into rolling forecast (SQL query #17).                   | Improved replenishment accuracy      |

- Supplier lead times and purchase fill-rate KPIs.
  - Showcased by: [Supplier Lead Time and Receipt Fill Rate](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/11%20SUPPLIER%20LEAD%20TIME%20AND%20RECEIPT%20FILL%20RATE.csv), [Fill Rate by PO](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/12%20FILL%20RATE%20BY%20PURCHASE%20ORDER.csv)
  - Recommendation:

| Focus Area                              | Evidence (Actual Metrics)                                | Recommended Action                                                              | Expected Impact                   |
| --------------------------------------- | -------------------------------------------------------- | ------------------------------------------------------------------------------- | --------------------------------- |
| **Slow Suppliers (Avg Lead > 14 days)** | Bottom 10 suppliers average 17.6 days vs target 10 days. | Include lead-time SLA in contracts; pre-order 7 days earlier for slow vendors.  | +95% on-time delivery compliance. |
| **Low Fill-Rate Suppliers (< 0.85)**    | Lowest fill-rate suppliers average 0.78 ratio.           | Apply performance scorecards; switch to higher-fulfilment vendors for key SKUs. | +10 ppt fill-rate improvement.    |
| **Supplier Mix Optimization**           | 80/20 split (top 5 suppliers = 78% volume).              | Consolidate minor suppliers with < 3 orders per quarter to streamline inbound.  | −8 % inbound freight cost.        |
| **PO Efficiency**                       | Avg freight 1.8 % of cost, payment fees 0.9 %.           | Bundle POs monthly to reduce logistics and payment transaction overhead.        | −2 % COGS savings.                |

- Churn detection for wholesale and on-premise customers.
  - Showcased by: [Customer Churn Candidates](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/6%20CUSTOMER%20CHURN%20CANDIDATES.csv), [Customers with Outstanding Balances](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/5%20CUSTOMERS%20WITH%20OUTSTANDING%20BALANCES.csv)
  - Recommendation:

| Focus Area                 | Evidence (Actual Metrics)                          | Recommended Action                                           | Expected Impact                |
| -------------------------- | -------------------------------------------------- | ------------------------------------------------------------ | ------------------------------ |
| **Churn Volume**           | 312 inactive customers (> 90 days).                | Implement 3-stage win-back program (7-, 30-, 60-day offers). | 15–20 % reactivation rate.     |
| **High-Value Churners**    | Top 20 churners = $410 k revenue past 6 months.    | Personal outreach + volume-based rebate to re-engage.        | +$60–80 k sales recovery.      |
| **Wholesale Segment Risk** | 65% of churners from wholesale/on-premise segment. | Add loyalty pricing & guaranteed delivery windows.           | Reduce churn by 10 ppt.        |
| **Credit-Linked Churn**    | 14 % churners have outstanding balances.           | Offer structured payment plans tied to reactivation.         | Recover $25 k+ in receivables. |

- Margin leakage and low-profit SKU identification.
  - Showcased by: [Margin Leakage Detection](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/16%20MARGIN%20LEAKAGE%20DETECTION.csv)
  - Recommendation:

| Focus Area                         | Evidence (Actual Metrics)                          | Recommended Action                                        | Expected Impact            |
| ---------------------------------- | -------------------------------------------------- | --------------------------------------------------------- | -------------------------- |
| **Negative-Profit SKUs (n = 36)**  | Avg Profit −$1.4 k / SKU; Revenue >$10 k each.     | Audit supplier cost mapping & apply corrective pricing.   | +$50 k annual margin lift. |
| **Low-Margin High-Sales Items**    | 20 SKUs > $5 k revenue but < 10 % margin.          | Raise retail price 1–1.5 %; seek tiered supplier rebates. | +$35 k gross profit.       |
| **Outlet Variance**                | Margin spread > 6 ppt between stores for same SKU. | Standardize branch pricing (±3 % band).                   | Consistent margin control. |
| **Deadweight SKUs (< $2 k sales)** | 140 SKUs < 1 % of sales but > 5 % inventory lines. | Phase-out and reallocate shelf to top quartile products.  | Inventory turn ↑ 15 %.     |

- Pricing consistency and branch-level spread analysis.
  - Showcased by: [Price Consistency Across Branches](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/7%20PRICE%20CONSISTENCY%20ACROSS%20BRANCHES.csv), [Cheapest and Most Expensive Branch per SKU](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/8%20CHEAPEST%20AND%20MOST%20EXPENSIVE%20BRANCH%20PER%20SKU.csv), [Price Attribute Comparison Across Branches](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/15%20PRICE%20ATTRIBUTE%20COMPARISON%20ACROSS%20BRANCHES.csv)
  - Recommendation:

| Focus Area               | Evidence (Actual Metrics)                           | Recommended Action                                        | Expected Impact                         |
| ------------------------ | --------------------------------------------------- | --------------------------------------------------------- | --------------------------------------- |
| **Large Price Spreads**  | 23 SKUs > $3 spread between branches.               | Introduce central pricing control with ± $1 variance cap. | Cut customer complaints by 20 %.        |
| **Branch Parity Gaps**   | Example: VB 24pk $53 vs $56 (max $3 diff).          | Standardize $54.50 RRP across all branches.               | Preserve margin consistency.            |
| **Attribute Mispricing** | 12 cases of 6-pack > $/L than 24-pack.              | Apply price-per-litre parity rules.                       | Avoid confusion; margin neutral.        |
| **High-Cost Locations**  | 2 branches operate > 5 % rent load → higher prices. | Use targeted “premium-zone” labelling to justify pricing. | Customer trust ↑ and margin maintained. |

- Rolling sales metrics for forecasting and planning.
  - Showcased by: [Rolling Sales Metrics for Forecasting and Planning](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/17%20ROLLING%2028-DAY%20AVERAGE%20SALES%20BY%20SKU.csv)
  - Recommendation: 

| Focus Area             | Evidence (Actual Metrics)                            | Recommended Action                                    | Expected Impact                 |
| ---------------------- | ---------------------------------------------------- | ----------------------------------------------------- | ------------------------------- |
| **Rising SKUs**        | 28-day rolling avg ↑ > 20 % for 42 SKUs (last week). | Increase purchase orders by 15 %; add promo stock.    | Prevent stock-outs; +3 % sales. |
| **Falling SKUs**       | 37 SKUs ↓ > 15 % vs prior week.                      | Decrease replenishment 25 %; bundle with promos.      | Reduce over-stock by 12 %.      |
| **Forecast Alignment** | 80 % weekly sales stable ±5 %.                       | Use rolling average + smoothing for 8-week forecast.  | Forecast accuracy ↑ 10 ppt.     |
| **Trend Integration**  | RTD and Spirits show +18 % rolling avg; Beer flat.   | Shift ad budget to RTD and premium spirits campaigns. | ROI ↑ 1.4× on promo spend.      |

## Tech Stack
- Database: Microsoft SQL Server 2022
- Language: T-SQL
- Tools: SQL Server Management Studio (SSMS), Power BI, Excel
- Data Volume: ~500K sales rows, 12 outlets, 90+ suppliers

## Author
- Frank Dinh
- Retail & Wholesale Data Analyst (Melbourne, Australia)
- Focused on retail data automation, forecasting, and Power BI dashboarding.
