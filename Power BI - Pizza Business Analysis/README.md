# Pizza Business Analysis (Power BI)

## Overview
This Power BI project analyzes a full year of pizza manufacturing and distribution transactions for **2015**, aiming to uncover sales drivers, product performance, and operational optimization opportunities.  

The report integrates sales, product, and ingredient data to present **KPI summaries**, **time-based trends**, **menu performance**, and **ingredient-level insights** — ultimately guiding strategic decisions in pricing, inventory, and promotions.

[Dashboard Interactive Link](https://app.powerbi.com/view?r=eyJrIjoiNjI1NjA3M2MtNDA1Ny00ZDk1LWIyZTEtZWM0MDc4MmU4ODVkIiwidCI6IjYxYTI3ZWZiLTM2ZjMtNDY1Zi04NWRmLWUyMWFlZGMxM2MwNCJ9)

**Period:** January 1 – December 31, 2015  
**Dataset:** `data_pizza.xlsx` (supported by `data_dictionary.xlsx`)  
**Report File:** `Pizza Business Analysis.pbix`  

**Headline Metrics (2015):**
- **$817,860** total revenue  
- **21,350** total orders  
- **48,620** total pizzas sold  
- **$38.31** average order value  
- **2.32** average pizzas per order  

---

## Project Goals
The project aims to:
1. Evaluate overall business performance and profitability.
2. Identify sales trends by day, time, and month to optimize staffing and promotions.
3. Rank products and categories by revenue and volume.
4. Examine ingredient popularity to improve purchasing and reduce waste.
5. Assess size and price relationships with demand.
6. Detect anomalies and uncover drivers of sales spikes or dips.
7. Provide actionable recommendations for growth, efficiency, and margin protection.

---

## Data Transformation (Power Query)
All data cleaning and shaping were performed within Power BI using **Power Query (M language)**.

### Steps Overview:
```m
let
    Source = Excel.Workbook(File.Contents("data_pizza.xlsx"), null, true),
    Data = Source{[Item="Data_pizza",Kind="Table"]}[Data],
    Trimmed = Table.TransformColumns(Data,{{"pizza_name_id", Text.Trim, type text}}),
    Types = Table.TransformColumnTypes(Trimmed, {
        {"order_id", Int64.Type},
        {"pizza_id", type text},
        {"quantity", Int64.Type},
        {"order_date", type date},
        {"order_time", type time},
        {"unit_price", type number}
    }),
    Cleaned = Table.SelectRows(Types, each [quantity] > 0 and [unit_price] > 0),
    AddedRevenue = Table.AddColumn(Cleaned, "Revenue", each [quantity] * [unit_price], type number),
    WithHour = Table.AddColumn(AddedRevenue, "Hour", each Time.Hour([order_time]), Int64.Type),
    WithWeekday = Table.AddColumn(WithHour, "Day of Week", each Date.DayOfWeekName([order_date]), type text),
    WithMonth = Table.AddColumn(WithWeekday, "Month", each Date.MonthName([order_date]), type text)
in
    WithMonth
```

### Transformation Highlights:
- Removed invalid/negative quantities and prices.
- Created `Revenue` column = `Quantity * Unit Price`.
- Derived time attributes: **Hour**, **Day of Week**, **Month**, and **Month-Year**.
- Ensured date and time were properly typed for temporal analysis.
- Validated field definitions per `data_dictionary.xlsx`.

---

## Data Modelling
The model follows a **star schema** optimized for performance and flexibility.

### Fact Table:
- `Sales` (from `data_pizza.xlsx`) — contains transactional records with revenue and quantities.

### Dimension Tables:
- `Pizza` — pizza names, categories, sizes.
- `Date` — auto-generated via Power BI’s date table.
- `Ingredient` — derived from ingredient-level mapping.
- `Time` — extracted from order timestamps.

### Relationships:
- `Sales[Pizza ID]` → `Pizza[Pizza ID]`
- `Sales[Order Date]` → `Date[Date]`
- `Pizza[Ingredient ID]` → `Ingredient[Ingredient ID]`

### Key DAX Measures:
```DAX
Total Revenue = SUM(Sales[Revenue])
Total Orders = DISTINCTCOUNT(Sales[Order_ID])
Total Quantity Sold = SUM(Sales[Quantity])
Average Order Value = DIVIDE([Total Revenue], [Total Orders])
Average Pizzas per Order = DIVIDE([Total Quantity Sold], [Total Orders])

Revenue by Category = SUMX(RELATEDTABLE(Pizza), Sales[Revenue])
Quantity by Category = SUMX(RELATEDTABLE(Pizza), Sales[Quantity])
```

<img width="1831" height="954" alt="Pizza Business Data Modelling and Table Relationship" src="https://github.com/user-attachments/assets/0b5e1b56-7935-44c3-8287-df899c0875f9" />

---

## Dashboard Overview

### Page 1 — **Business Overview**

<img width="2147" height="1202" alt="image" src="https://github.com/user-attachments/assets/c2d7a03e-767d-4ffd-be1b-09efb67da1cb" />

- **KPI Cards:** Total Revenue, Orders, Quantity Sold, Avg Order Value, Avg Pizzas/Order.
- **Trend Charts:** Monthly revenue and quantity trends.
- **Weekly Analysis:** Revenue by day of week.
- **Hourly Heatmap:** Order concentration across dayparts (Lunch vs Dinner).
- **Size Performance:** Relationship between size and sales volume.
- **Single vs Multi-Item Orders:** ratio chart and frequency gauge.

### Page 2 — **Product, Category, Correlation and Pricing Analysis**

<img width="2144" height="1186" alt="image" src="https://github.com/user-attachments/assets/03e304f1-cdd0-406c-86cc-a4fd9674ee68" />

- **Top 5 / Bottom 5 Pizzas:** by revenue and quantity.
- **Category Ranking:** Classic, Supreme, Chicken, Veggie.
- **Ingredient Analysis:** Most/least used ingredients across categories.
- **Revenue vs Quantity Scatter:** with average reference lines dividing four quadrants.
- **Price vs Demand:** trend line shows strong inverse correlation between price and sales.

### Filters:
- Date range, Pizza Category, Size, Ingredient, and Time of Day.

---

## Key Insights (from report)
**Performance Summary**
- Friday, Thursday, and Saturday were the top three revenue days.
- Revenue peaked at **lunch (12–1pm)** and **dinner (5–7pm)**.
- July, May, and March were the best months; October and December the weakest.

**Product Performance**
- Classic and Supreme pizzas dominated revenue.
- Large sizes contributed the majority of sales.
- Garlic was the most popular ingredient overall.

**Correlation & Pricing**
- Clear **negative correlation** between price and quantity sold.
- Medium-sized pizzas offered optimal balance between price and demand.

**Operations & Inventory**
- Garlic and other high-pull ingredients require higher par levels.
- Pesto Sauce, Brie Carre, Kalamata Olives, and Green Peppers should be minimized to reduce waste.

**Marketing Opportunities**
- Promote family bundles on Sunday–Monday to fill low-demand days.
- Launch time-specific campaigns: Lunch Combos (12–14h) and Family Bundles (17–20h).
- Pre-plan promotions for holidays (Thanksgiving, Black Friday, Independence Day).

---

## Recommendations
1. **Revenue Growth:**
   - Adopt a **daypart pricing plan** (Lunch vs Dinner bundles).
   - Feature best-selling pizzas more prominently in the menu.
2. **Menu Engineering:**
   - Rework or delist the lowest 5 performers.
   - Use ingredient-level contribution to redesign recipes.
3. **Inventory Optimization:**
   - Secure better pricing for high-volume ingredients.
   - Lower order frequency for low-use ingredients.
4. **Marketing & Retention:**
   - Build an annual promo calendar with event tie-ins.
   - Test targeted SMS/email offers during low traffic hours.
5. **Future Data Improvements:**
   - Include cost and campaign data for profit analysis.
   - Add customer identifiers for segmentation and loyalty metrics.
