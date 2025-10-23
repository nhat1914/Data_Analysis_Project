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
- Data transformation using CASE, ROUND, and DATEPART logic.
- Creation of views and CTEs for reusable analytical layers.
- Use of window functions for ranking, percentage shares, and trend analysis.
- Aggregation by time, product category, and employee dimensions.
- Dynamic PIVOT queries for time-series profit analysis across regions.
- Implementation of user-defined functions and stored procedures for automation.

## Highlighted Analytical Queries
| # | Query                                        | Purpose                                         |
| - | -------------------------------------------- | ----------------------------------------------- |
| 1 | Total Sales of Furniture Products by Quarter | Track category performance over time            |
| 2 | Total Profit by Discount Class               | Measure how discounts affect profitability      |
| 3 | Top Categories per Segment                   | Identify high-value categories by customer type |
| 4 | Employee Profit Contribution                 | Show which employees drive the most profit      |
| 5 | Profitability Ratio by Employee & Category   | Evaluate efficiency and upselling success       |
| 6 | Employee Profit & Sales by Date Range        | Generate KPI summaries dynamically              |
| 7 | Profit by State (Last 6 Quarters Pivot)      | Visualize geographic and temporal trends        |

## Business Insights Generated
- Revenue & Profit Trends by Category and Quarter.
  - Showcased by: [Furniture Sales by Quarter](https://github.com/nhat1914/Data_Analysis_Project/blob/3a36befb6456edee487b7dcd60a00e965dd97992/SQL%20-%20Stationary%20Business%20Analysis%20Office%20Consumables/Furniture%20Sales%20by%20Quarter.csv), [Category by Segment](https://github.com/nhat1914/Data_Analysis_Project/blob/3a36befb6456edee487b7dcd60a00e965dd97992/SQL%20-%20Stationary%20Business%20Analysis%20Office%20Consumables/Top%202%20Categories%20per%20Segment.csv), [Profitability Ratio](https://github.com/nhat1914/Data_Analysis_Project/blob/3a36befb6456edee487b7dcd60a00e965dd97992/SQL%20-%20Stationary%20Business%20Analysis%20Office%20Consumables/Profitability%20Ratio.csv)
  - Recommendation:

| Focus Area              | Evidence                                                         | Recommendation                                                             | Expected Impact              |
| ----------------------- | ---------------------------------------------------------------- | -------------------------------------------------------------------------- | ---------------------------- |
| **Seasonal Category Trend** | Furniture sales peaked in Q3 ($55.6 K) before dropping 8 % in Q4 | Adjust inventory ahead of Q2–Q3 peak; reduce stock by 10 % after September | +5 % turnover efficiency     |
| **Category Mix**            | Stationery margin 26 %, Furniture 24 %, Office Supplies 22 %     | Prioritize stationery promotions; introduce premium bundles                | +2 ppt overall margin lift   |
| **Regional Growth**         | NSW and VIC quarterly profits ↑ 5–6 % QoQ                        | Increase product allocation in top-growth states                           | +7 % sales in growth regions |

- Discount Impact on Profitability.
  - Showcased by: [Discount Impact by Category](https://github.com/nhat1914/Data_Analysis_Project/blob/3a36befb6456edee487b7dcd60a00e965dd97992/SQL%20-%20Stationary%20Business%20Analysis%20Office%20Consumables/Discount%20Impact%20by%20Category.csv)
  - Recommendation:

| Focus Area       | Evidence                                           | Recommended Action                                         | Expected Impact                     |
| ---------------- | -------------------------------------------------- | ---------------------------------------------------------- | ----------------------------------- |
| **Profit per Order** | High Discount = $8.8 avg profit vs $26 no-discount | Cap discounts ≤ 20 %; replace deep cuts with bundle offers | +12 % profit/order                  |
| **Elastic Demand**   | Low Discount (+9 % orders, stable profit)          | Run quarterly low-discount events (≤ 15 %)                 | Boost volume without margin erosion |
| **Margin Burn**      | Medium–High Discount categories < 10 % margin      | Re-negotiate supplier rebates or discontinue lines         | +40 k $/yr margin recovery          |

- Category Profit by Customer Segment.
  - Showcased by: [Categories per Segment](https://github.com/nhat1914/Data_Analysis_Project/blob/3a36befb6456edee487b7dcd60a00e965dd97992/SQL%20-%20Stationary%20Business%20Analysis%20Office%20Consumables/Top%202%20Categories%20per%20Segment.csv)
  - Recommendation:

| Focus Area        | Evidence                            | Recommendation                                     | Expected Impact                    |
| ----------------- | ----------------------------------- | -------------------------------------------------- | ---------------------------------- |
| **Consumer Segment**  | Stationery (46 k $ profit) dominant | Bundle stationery + office supplies for cross-sell | +6 % sales from existing customers |
| **Corporate Segment** | Furniture (58 k $ profit) highest   | Offer extended credit or bulk discount contracts   | +10 % B2B retention                |
| **Home Office**       | Office Supplies (25 k $ profit) key | Develop subscription restock program               | Steady recurring revenue stream    |

- Employee Performance & Profit Contribution.
  - Showcased by: [Profit per Category per Employee](https://github.com/nhat1914/Data_Analysis_Project/blob/3a36befb6456edee487b7dcd60a00e965dd97992/SQL%20-%20Stationary%20Business%20Analysis%20Office%20Consumables/Profit%20per%20Category%20per%20Employee.csv), [Profitability Ratio](https://github.com/nhat1914/Data_Analysis_Project/blob/3a36befb6456edee487b7dcd60a00e965dd97992/SQL%20-%20Stationary%20Business%20Analysis%20Office%20Consumables/Profitability%20Ratio.csv)
  - Recommendation:

| Focus Area           | Evidence                                      | Recommendation                          | Expected Impact                    |
| -------------------- | --------------------------------------------- | --------------------------------------- | ---------------------------------- |
| **Top Performer**        | Employee 102 Profitability = 0.277            | Use as benchmark for peer coaching      | +8 % team-wide profit gain         |
| **Skill Specialization** | Employee 103 → 60 % profit in Office Supplies | Assign to key accounts in same category | Higher conversion rate             |
| **Underperformers**      | Ratio < 0.20 across 3 employees               | Provide pricing & upsell training       | +0.03 ppt profit ratio improvement |

- Regional Profit Trend Analysis.
  - Showcased by: [Profit by State and Last 6 Quarters (Pivot)](https://github.com/nhat1914/Data_Analysis_Project/blob/3a36befb6456edee487b7dcd60a00e965dd97992/SQL%20-%20Stationary%20Business%20Analysis%20Office%20Consumables/Profit%20by%20State%20and%20Last%206%20Quarters%20(Pivot).csv)
  - Recommendation:

| Focus Area     | Evidence               | Recommendation                           | Expected Impact     |
| -------------- | ---------------------- | ---------------------------------------- | ------------------- |
| **Growth States**  | NSW +38 → 53 k $ (6 Q) | Expand distribution to match growth pace | +15 k $/quarter     |
| **Stable Regions** | VIC steady 3–4 % QoQ   | Maintain pricing; invest in local ads    | Brand consistency   |
| **Lagging States** | SA < 16 k $            | Run targeted B2B promotions              | +10 % profit growth |

- Profitability Ratios & Sales Efficiency.
  - Showcased by: [Profit Ratio Function & Report](https://github.com/nhat1914/Data_Analysis_Project/blob/3a36befb6456edee487b7dcd60a00e965dd97992/SQL%20-%20Stationary%20Business%20Analysis%20Office%20Consumables/Profit%20per%20Category%20per%20Employee.csv)
  - Recommendation:

| Focus Area              | Evidence                           | Recommendation                            | Expected Impact           |
| ----------------------- | ---------------------------------- | ----------------------------------------- | ------------------------- |
| **Avg Profit Ratio = 0.26** | High-performer ≥ 0.27              | Replicate top seller strategies           | +5 % sales uplift         |
| **Low Ratios (< 0.20)**     | Price pressure or high discounting | Review discount logic; apply profit floor | Margin stabilization      |
| **Consistent Performers**   | 80 % employees stable ± 0.03       | Automate monthly ratio report             | Continuous KPI visibility |

- Employee KPI Procedure.
  - Showcased by: [Stored Procedure – GetEmployeeSalesProfit](https://github.com/nhat1914/Data_Analysis_Project/blob/3a36befb6456edee487b7dcd60a00e965dd97992/SQL%20-%20Stationary%20Business%20Analysis%20Office%20Consumables/Stored%20Procedure%20%E2%80%93%20GetEmployeeSalesProfit.csv)
  - Recommendation:
 
| Focus Area     | Evidence                        | Recommendation                          | Expected Impact                |
| -------------- | ------------------------------- | --------------------------------------- | ------------------------------ |
| **Stable Sales**   | Avg monthly sales ≈ $29 k       | Retain sales coverage & focus on upsell | Sustainable performance        |
| **KPI Automation** | Procedure output as monthly KPI | Feed into Power BI dashboard            | Real-time performance tracking |

## Tech Stack
- Database: Microsoft SQL Server 2022
- Language: T-SQL
- Tools: SQL Server Management Studio (SSMS), Excel
- Data Volume: ~100 K transactions, 4 tables (Orders, Products, Customers, Employees)

## Author
- Frank Dinh
- Data Analyst | Retail & Operations Analytics
- Focused on SQL-based analytics, process automation, and Power BI dashboarding.




























