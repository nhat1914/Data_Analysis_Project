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
- Supplier lead times and purchase fill-rate KPIs.
- Churn detection for wholesale and on-premise customers.
- Margin leakage and low-profit SKU identification.
- Pricing consistency and branch-level spread analysis.
- Rolling sales metrics for forecasting and planning.

## Tech Stack
- Database: Microsoft SQL Server 2022
- Language: T-SQL
- Tools: SQL Server Management Studio (SSMS), Power BI, Excel
- Data Volume: ~500K sales rows, 12 outlets, 90+ suppliers

## Author
Frank Dinh
Retail & Wholesale Data Analyst (Melbourne, Australia)
Focused on retail data automation, forecasting, and Power BI dashboarding.
