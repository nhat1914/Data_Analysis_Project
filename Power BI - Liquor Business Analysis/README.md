# Liquor Business Analysis (Power BI)

## Overview
End‑to‑end analytics for a multi‑outlet **Liquor Retail & Wholesale** group, integrating **Sales**, **Purchasing**, **Inventory**, **Transfers**, **Supplier**, and **Customer** views. This README documents the model, transformations, measures, and an **8‑page dashboard** layout with key insights and usage notes.

## [Dashboard Interactive Link](https://app.powerbi.com/view?r=eyJrIjoiMDE5MDBiMGEtMDVjYi00NjY5LWIyNTMtNTMzOWZhNGViODYyIiwidCI6IjYxYTI3ZWZiLTM2ZjMtNDY1Zi04NWRmLWUyMWFlZGMxM2MwNCJ9)

**Primary KPIs (snapshot Aug–Oct 2025):**
- **$13,327,412** Revenue
- **178,715** Cases Sold
- **$1,301,808** Profit
- **~9.77%** Gross Margin
- **$4.8M** Stock Holding Value

## Project Goals
1. Give executives a live view of revenue, profit, GP%, and volume by category and outlet.  
2. Enable buyers to manage **supplier performance, cost changes, and purchase cadence**.  
3. Detect **slow movers, forecast short‑term demand**, and reduce holding costs.  
4. Support wholesale account management via **customer purchasing power** and mix.  
5. Track **inter‑store transfers** and warehouse flows to balance stock.

## Data Transformation (Power Query)
- Consolidate POS exports (sales order lines), purchase orders, inventory on‑hand, transfers.
- Standardize outlet codes, product/category naming, and supplier names.
- Derive: Start of Week, Week/Month keys, GP%, Holding Value, Forecast (short horizon, using Sarimax statistical model).
- Remove negative revenue, null keys; cap outlier quantities if > P99.9 (investigate rather than drop).
- Ensure referential integrity to Date, Outlet, Product, Supplier, and Customer dims.

## Data Modelling
**Star schema** with conformed time, outlet, product, supplier, and customer dimensions.

**Highlighted Facts**
- `Sales` (Revenue, Profit, Cases, Orders)
- `PurchaseOrders` (PO$, PO Cases, Latest Order Date)
- `Inventory` (Case On‑hand, Holding Value, Stock Loss)
- `Transfers` (IN, OUT by outlet/date)
- `Costs` (daily cost changes)

**Highlighted Dims**
- `Date`
- `Outlet`
- `Product`
- `Category`
- `Supplier`
- `Customer`

**Highlighted Measures/Tables (DAX)**
```DAX
LW Cost Change = 
VAR AnchorDate =
    CALCULATE ( MAX ( 'Store Order'[Order Date] ), ALL ( 'Store Order' ) )

-- Transfers into LW (last 8 weeks)
VAR TransfersLW =
    SELECTCOLUMNS (
        ADDCOLUMNS (
            FILTER (
                'transfer',
                'transfer'[receiver_id] = "11efb0234cfc3f6c95fb0ae2611d356d" &&
                'transfer'[Case Received] > 0 &&
                'transfer'[case_quantity] > 0 &&
                'transfer'[order_date] >= AnchorDate - 56
            ),
            "CostPerCase", DIVIDE ( 'transfer'[cost], 'transfer'[Case Received])
        ),
        "product_id",   'transfer'[product_id],
        "Event Date",   'transfer'[order_date],
        "CostPerCase",  [CostPerCase]
    )

-- Store Orders for LW (last 8 weeks)
VAR OrdersLW =
    SELECTCOLUMNS (
        ADDCOLUMNS (
            FILTER (
                'Store Order',
                'Store Order'[Outlet Name] = "LW" &&
                'Store Order'[Case Quantity] > 0 &&
                'Store Order'[Order Date] >= AnchorDate - 56
            ),
            "CostPerCase", DIVIDE ( 'Store Order'[Total Cost], 'store order'[Case Received])
        ),
        "product_id",   'Store Order'[product_id],
        "Event Date",   'Store Order'[Order Date],
        "CostPerCase",  [CostPerCase]
    )

-- Combine both tables
VAR Events =
    UNION ( TransfersLW, OrdersLW )

-- Calculate previous cost per product
VAR WithPrev =
    ADDCOLUMNS (
        Events,
        "PrevCost",
            MAXX (
                FILTER (
                    Events,
                    [product_id] = EARLIER ( [product_id] ) &&
                    [Event Date] < EARLIER ( [Event Date] )
                ),
                [CostPerCase]
            )
    )

-- Keep only first entry or rows where cost changed
VAR ChangesOnly =
    FILTER ( WithPrev, ISBLANK ( [PrevCost] ) || [CostPerCase] <> [PrevCost] )

-- Return final cost-change table
RETURN
SELECTCOLUMNS (
    ADDCOLUMNS (
        ChangesOnly,
        "Product Name",
            CALCULATE (
                FIRSTNONBLANK ( 'Store Order'[Product Name], 1 ),
                FILTER ( 'Store Order', 'Store Order'[product_id] = [product_id] )
            )
    ),
    "product_id",     [product_id],
    "Product Name",   [Product Name],
    "Time of Change", [Event Date],
    "Cost per Case",  [CostPerCase]
)
```

```DAX
New Product List (Last 30 Days) = 
VAR AnchorDate =
    CALCULATE ( MAX ( 'Store Order'[Order Date] ), ALL ( 'Store Order' ) )

VAR FirstOrderPerProduct =
    ADDCOLUMNS (
        SUMMARIZE ( FILTER ( ALL ( 'Store Order' ), 'Store Order'[Case Quantity] > 0 ),
                    'Store Order'[product_id] ),
        "First Order Date",
            CALCULATE ( MIN ( 'Store Order'[Order Date] ),
                        'Store Order'[Case Quantity] > 0 ),
        "Product Name",
            CALCULATE (
                FIRSTNONBLANK ( 'Store Order'[Product Name], 1 ),
                FILTER ( 'Store Order',
                    'Store Order'[product_id] = EARLIER ( 'Store Order'[product_id] ) )
            )
    )

RETURN
SELECTCOLUMNS (
    FILTER (
        FirstOrderPerProduct,
        [First Order Date] >= AnchorDate - 30
            && [First Order Date] <= AnchorDate
    ),
    "Product ID",      [product_id],
    "Product Name",    [Product Name],
    "Date Order",      [First Order Date]
)

```

<img width="2335" height="1172" alt="image" src="https://github.com/user-attachments/assets/631ea6bf-0287-4185-96ae-a7f1561f5f83" />

## Dashboard Overview

### **Page 1 — Executive Overview**

<img width="2051" height="1156" alt="image" src="https://github.com/user-attachments/assets/25b61105-03ac-42df-9f55-bd29643755be" />

- KPI tiles (Revenue, Cases, Profit, GP%) and **Weekly Revenue vs Profit** trend.  
- **Category Performance** table (Revenue, Profit, AVG GP%) and **Outlet Performance** table.  
- **Holding Value & Stock Loss** summary.

**Operational cues**
- Local & Spirits drive revenue scale; RTDs show higher GP%.  
- LW Warehouse dominates revenue; EWT/LARA post GP% > 23%.

### **Page 2 — Purchasing by Outlet**

<img width="2050" height="1159" alt="image" src="https://github.com/user-attachments/assets/1952a7f5-6fb4-4ee8-bea7-412a7493f830" />

- **Product Purchased per Outlet** matrix (top SKUs; e.g., Carlton Dry/Draught).  
- **Cases Purchased per Outlet** weekly timeline to spot spikes and restock cycles.

**Use it to**
- Align inbound with outbound velocity; audit anomalies; confirm promo readiness.

### **Page 3 — Supplier Performance**

<img width="2056" height="1160" alt="image" src="https://github.com/user-attachments/assets/6b1377cf-42fb-4e85-a261-2f51d1104a1d" />

- **Supplier Breakdown**: PO$, PO Cases, Total Revenue, Profit, Case on hand, Latest Order Date.  
- **Supplier Summary**: purchase trend by week and **Times Ordered** leaderboard.

**Signals**
- HB CUB and Tru Cellars are core; Pernod Ricard tops PO$ for premium spirits.

### **Page 4 — Customer & Channel**

<img width="2056" height="1160" alt="image" src="https://github.com/user-attachments/assets/fa52f6ab-03b4-465d-b727-81f7d3f3b885" />

- **Customer Purchasing Power** (weekly revenue by account).  
- **Revenue by Customer Group** (W2W, W2R, Retail, Restaurant, etc).  
- **Orders per Customer** and **Product Category Mix by Customer**.

**Actions**
- Prioritise top accounts; tailor category bundles by customer mix; watch churn dips.

### **Page 5 — Revenue Mix & Product Performance**

<img width="2056" height="1161" alt="image" src="https://github.com/user-attachments/assets/fb7ab673-cb51-4cef-a869-00b04af7244e" />

- **Revenue per Category** by week.  
- **Revenue per Customer Group** drill.  
- **Product Performance**: Revenue, Cases, Profit, Orders, Case on hand, **Forecast Next 2 Weeks**, Holding Value.

**Usage**
- Forecasting seed table; replenishment and credit control (case on hand vs forecast).

### **Page 6 — Basket & Daypart Dynamics**

<img width="2059" height="1161" alt="image" src="https://github.com/user-attachments/assets/48731a39-fe15-4a06-a014-79884fa689f8" />

- **Basket Details**: Avg Case/Order, Avg Order Value, median/min/max cases per order.  
- **Selling Order by Weekday & Hour** heatmap (staffing windows).  
- **Product Selling Frequency** and **Price Elasticity** (Cases vs Price/Case).

**Takeaways**
- Lunch and late‑afternoon trading are densest; price elasticity stable within core ranges.

### **Page 7 — Slow Movers & Risk**

<img width="2055" height="1160" alt="image" src="https://github.com/user-attachments/assets/d636ae85-da78-4e03-b15e-3df70ae91743" />

- **Slow Moving Product** panel with last received/sold dates and status.  
- **Total Slow Movers per Store** ranking.

**Governance**
- Trigger markdowns/transfers; reduce re‑orders; set par resets by outlet/category.

### **Page 8 — Transfers, New Products & Cost Changes**

<img width="2058" height="1160" alt="image" src="https://github.com/user-attachments/assets/a245f8c2-f060-450e-9526-0528511e0b80" />

- **LW Transfers OUT/IN** timelines across outlets (balancing stock).  
- **New Product Performance (≤30 days)**: Sales Orders, Cases/Order, Revenue, Profit.  
- **LW Cost Change** tracker (daily cost movements by SKU).

**Why it matters**
- Validate launch traction; guard GP% during cost shifts; time transfers ahead of peaks.

## Key Insights
- **$13.3M** revenue with **~9.8% GP%**; **RTD/Spirits** higher margin; **Local Beer** largest revenue share.  
- Top SKUs: **Carlton Dry/Draught**, **Heineken 330ml**; premium spirits (e.g., **Martell Blue Swift**) lift profit per case.  
- **$4.8M** holding with low recorded stock loss; **1,500+ slow movers** flagged — immediate optimization field.  
- Customer revenue concentrates in a few wholesale accounts; leverage bundles and payment terms.  
- Transfers smooth operational gaps; monitor **IN vs OUT** to avoid double‑handling and hidden costs.  
- Cost changes on core lines (e.g., Smirnoff 1L, JW Red 1L) require proactive price review to protect GP%.

## Recommendations
1. **Margin mix**: Expand high‑GP RTDs and premium spirits; rationalise low‑pull lines per outlet.  
2. **Inventory**: Set automated alerts (age on hand + velocity) and markdown/transfer workflows.  
3. **Purchasing**: Negotiate volume rebates with HB CUB & Tru Cellars; align PO cadence to sell‑through.  
4. **Wholesale**: Tiered incentives for top accounts; category‑specific bundles by customer mix.  
5. **Ops**: Staff to weekday/hour heatmap; throttle during peaks; ensure warehouse slotting for fast lines.  
6. **Pricing**: Track elasticity and competitor benchmarks after cost moves; avoid blanket discounts.
