# Liquor Business Analysis (Power BI)

## Overview
End-to-end analytics for a multi-outlet **Liquor Retail & Wholesale** group, built in **Power BI**.

This model integrates **Sales**, **Purchasing**, **Inventory**, **Transfers**, **Supplier**, and **Customer** data into a single semantic layer. The goal is to give both head-office and operational teams a live, self-service view of performance, with a focus on:

- Revenue, profit, and margin trends over time
- Product/category performance
- Outlet and customer contributions
- Stock holding and cost events
- Slow movers and new products

The report uses a star-schema model, Power Query for transformation, and DAX for measures and calculation tables. It is presented in an **8-page dashboard** layout with key insights and usage notes.

<a href="https://app.powerbi.com/view?r=eyJrIjoiYWUwNDllZjAtNmY5Ny00ODNiLThjYzQtNmM3OWRlYWU2OGRlIiwidCI6IjYxYTI3ZWZiLTM2ZjMtNDY1Zi04NWRmLWUyMWFlZGMxM2MwNCJ9" target="_blank">Dashboard Interactive Link</a>

**Primary KPIs (1 Jan 2025 – 26 Oct 2025):**
- **$46,941,719.47** Revenue
- **565,224.48** Cases Sold
- **171,924** Total Orders
- **$4,831,891** Profit (≈ **10.3%** of revenue)
- **23.62%** Average Margin per Order
- **$102.09** Average Order Value
- **~$4.81M** Stock Holding Value

## Project Goals
1. **Sales & Margin Visibility**  
   Provide a clear, consolidated view of revenue, profit, margin and cases sold across all outlets and months.

2. **Trading Pattern Insights**  
   Understand **when** the business trades (weekday × hour) and **at what price points**, to guide staffing, operations and pricing decisions.

3. **Product & Basket Performance**  
   Identify **power SKUs** that drive revenue and strong baskets (high cases per order and high order value), and understand how basket structure changes when these products are present.

4. **Customer & Segment Contribution**  
   Quantify how different **customer groups** (W2W, W2R, Retail, Restaurant, Internal, etc.) and key accounts contribute to revenue and category performance.

5. **Decision Support for Future Planning**  
   Create a reusable analytical base for future work on forecasting, promotion planning, pricing and customer retention.

## Data Transformation (Power Query)
The project uses Power Query to ingest, clean, and shape data from multiple sources:

- POS exports (sales order lines)
- Purchase orders
- Inventory/on-hand snapshots
- Transfer records (warehouse ↔ stores)
- Product, outlet, supplier, and customer masters

Core steps include:

- **Ingest & combine**:
  - Append multiple POS extracts where required.
  - Merge purchase and transfer data from separate systems.
- **Standardisation**:
  - Normalise outlet codes, product naming, and supplier names.
- **Derive**:
  - Start of Week, Week/Month keys, fiscal/calendar attributes.
  - Cleaned category and subcategory fields.
- **Business logic**:
  - Compute revenue, cost, profit, GP% at line level.
  - Compute holding value (Case On-hand × Cost per Case).
  - Identify transfer IN/OUT directions and quantities.
- **Data quality**:
  - Remove negative revenue rows where they represent refunds not in scope.
  - Ensure referential integrity to:
    - `Date`, `Outlet`, `Product`, `Supplier`, `Customer` dimensions.

These transformations produce model-ready fact tables and conformed dimensions for Power BI.

## Data Modelling
The model follows a **star schema** for performance and clarity.

<img width="1920" height="1079" alt="image" src="Liquor Business Data Modelling and Table Relationship.png" />

### Fact tables
- `Sales`
  - Revenue, Cost, Profit, GP%
  - Units & Cases Sold
  - Timestamps (date + time of day)
  - Outlet, Product, Customer keys
- `PurchaseOrders`
  - PO amount, units/cases ordered
  - Supplier, Outlet
  - Order dates
- `Inventory`
  - Case On-hand
  - Holding Value
  - Snapshot dates
- `Transfers`
  - IN/OUT quantities by outlet
  - Source/receiver outlet
  - Transfer dates
- `Costs`
  - Cost per case over time by product/outlet
  - Used for cost change events

### Dimension tables
- `Date`
  - Calendar/fiscal attributes, week, month-year, day of week
- `Outlet`
  - Outlet name, type (warehouse, retail, wholesale), region
- `Product`
  - Product name, pack size, brand, category, subcategory
- `Category`
  - Beer, Spirits, RTD, Wine, Cider, Soft Drinks, Other
- `Supplier`
  - Supplier name, group
- `Customer`
  - Customer name, type/group (W2W, W2R, Retail, Restaurant, Internal)

Relationships are mostly one-to-many (dimensions → facts) with `Date`, `Outlet`, `Product`, `Supplier`, and `Customer` serving as slicers.

## Dashboard Overview

### **Page 1 — Sales Performance**

<img width="1920" height="1079" alt="image" src="Sales Performance Snapshot.png" />



- **Monthly Revenue & Profit** chart showing revenue and profit per month from Jan–Oct 2025.  
- **Selling Order Weekday & Hour** heatmap highlighting trading peaks by day of week and hour of day (late morning–evening, especially Fri–Sun).  
- **Total Cases Sold vs Price Point per Case** view to give an initial read on price elasticity and demand at different price bands.  
- **Outlet Contribution to Total Revenue** with LW Warehouse, BTO, LARA and EWT as the main contributors.  
- **Product Category Performance & Contribution** for Beers, Spirits, RTDs, Wine and other categories.  
- **Top 10 Customers** and **Top 10 Products** visuals showing which accounts and SKUs drive the largest share of revenue and profit.

**Operational cues**
- LW Warehouse is the core revenue engine; BTO, LARA and EWT are key outlets.  
- Beers and Spirits dominate revenue, with RTDs adding strong incremental value and margin.  
- Trading intensity is highest from late morning to early evening and on Fridays and weekends.  

### **Page 2 — Product, Basket & Customer Group Performance**

<img width="1917" height="1079" alt="image" src="Product Performance Snapshot.png" />

- **Revenue per Category by Month** to show how Beers, Spirits, RTDs and Wine contribute across the year and how mix shifts over time.  
- **Basket Details Table** for top products, including number of orders, total revenue, total cases, **average cases per order** and **average order value** when each product is in the basket.  
- **Global Basket Metrics** summarising total orders, revenue, cases, average cases per order and average order value across the whole business.  
- **Customer Sales Breakdown by Product Category** visual showing category mix for each customer group (W2W, W2R, Retail, Restaurant, Internal, etc.).  
- **Revenue Generated per Customer Group (by Month)** highlighting how each segment contributes to revenue over time.

**Actions**
- Use the **weekday × hour heatmap** to align staffing, warehousing and delivery operations to true trading peaks.  
- Prioritise **top SKUs** and categories that deliver the biggest baskets and highest order values for range, merchandising and promotion.  
- Focus on **key accounts and high-value customer groups** (W2W & W2R) with tailored offers and category mixes.  
- Monitor **category mix and segment trends** to identify growth opportunities and early signs of declining segments.

## Key Insights
- The business generated **$46.9M** in revenue and **565k cases** from **171k+ orders**, delivering around **$4.83M** profit over the period.  
- While profit is about **10.3% of revenue**, the **average margin per order** is higher at **23.62%**, indicating a healthy basket mix and discount structure.  
- **Beers, Spirits and RTDs** account for over **93%** of total revenue, confirming them as the core pillars of the range.  
- **LW Warehouse** is the primary revenue hub (~$31.3M), with **BTO**, **LARA** and **EWT** as key stores contributing significant additional volume.  
- Typical baskets are compact but efficient: ~**2.7 products** and **1.23 cases** per order, with an **average order value around $102**.  
- A relatively small set of **power SKUs** (e.g. Martell Blue Swift, Carlton Dry & Draught, Great Northern, Heineken, Smirnoff, Jack Daniels, Johnnie Walker) drive a large share of revenue and basket value.  
- Customer group analysis shows **W2W & W2R** as major contributors, with Retail and Restaurant still meaningful but smaller; trends by month help flag emerging growth or softening segments.  
- Trading peaks in **late morning to evening**, especially on **Fridays and weekends**, which has strong implications for staffing, logistics and replenishment planning.

## Recommendations
1. **Double-down on high-impact SKUs**  
   Treat the identified **Top 10 products** and largest categories as strategic lines: ensure strong availability, prominent visibility (for retail) and margin-aware pricing (for wholesale customers).

2. **Segmented strategy by customer group**  
   Use the **Customer Group** and **Category Mix** views to design differentiated offers for W2W, W2R, Retail and Restaurant segments based on their spending pattern and preferred categories.

3. **Align operations to true trading peaks**  
   Roster staff, schedule deliveries and plan warehouse picking against the **weekday × hour heatmap**, leaning into late-morning and evening peaks on Fridays and weekends.

4. **Price band and margin management**  
   Use the **price point vs cases** view to identify safe price bands where you can increase price with minimal volume impact, and avoid price moves that materially damage demand.

5. **Inventory and capital efficiency**  
   Combine **holding value** with category and outlet performance to reduce overstock in slower areas and reallocate capital into fast, profitable lines.

6. **Prepare for forecasting and promotions**  
   Use this model as the foundation for **demand forecasting**, **promotion ROI analysis**, and **churn/retention** analytics, focusing first on the most valuable customer groups and products.

