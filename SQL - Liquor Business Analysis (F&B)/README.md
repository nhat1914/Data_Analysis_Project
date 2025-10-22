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
- Churn detection for wholesale and on-premise customers.
  - Showcased by: [Customer Churn Candidates](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/6%20CUSTOMER%20CHURN%20CANDIDATES.csv), [Customers with Outstanding Balances](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/5%20CUSTOMERS%20WITH%20OUTSTANDING%20BALANCES.csv)
  - Recommendation: 
- Margin leakage and low-profit SKU identification.
  - Showcased by: [Margin Leakage Detection](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/16%20MARGIN%20LEAKAGE%20DETECTION.csv)
  - Recommendation: 
- Pricing consistency and branch-level spread analysis.
  - Showcased by: [Price Consistency Across Branches](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/7%20PRICE%20CONSISTENCY%20ACROSS%20BRANCHES.csv), [Cheapest and Most Expensive Branch per SKU](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/8%20CHEAPEST%20AND%20MOST%20EXPENSIVE%20BRANCH%20PER%20SKU.csv), [Price Attribute Comparison Across Branches](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/15%20PRICE%20ATTRIBUTE%20COMPARISON%20ACROSS%20BRANCHES.csv)
  - Recommendation: 
- Rolling sales metrics for forecasting and planning.
  - Showcased by: [Rolling Sales Metrics for Forecasting and Planning](https://github.com/nhat1914/Data_Analysis_Project/blob/main/SQL%20-%20Liquor%20Business%20Analysis%20(F%26B)/17%20ROLLING%2028-DAY%20AVERAGE%20SALES%20BY%20SKU.csv)
  - Recommendation: 

## Tech Stack
- Database: Microsoft SQL Server 2022
- Language: T-SQL
- Tools: SQL Server Management Studio (SSMS), Power BI, Excel
- Data Volume: ~500K sales rows, 12 outlets, 90+ suppliers

## Author
Frank Dinh
Retail & Wholesale Data Analyst (Melbourne, Australia)
Focused on retail data automation, forecasting, and Power BI dashboarding.
