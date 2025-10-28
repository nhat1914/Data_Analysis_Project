# Wisabi Bank — ATM Transactions Analysis (Power BI)

## Overview
This Power BI project analyzes Wisabi Bank’s 2022 ATM transactions to uncover customer behavior, location performance, and operational improvement opportunities. It distills more than 2.1M transactions into executive KPIs and interactive visuals that support branch managers, ATM operations, and head-office strategy.

[Dashboard Interactive Link](https://app.powerbi.com/view?r=eyJrIjoiYzZjMGRmODEtYTQyYS00NmQwLTk0MGUtMjRhYmU1MzkyZjA1IiwidCI6IjYxYTI3ZWZiLTM2ZjMtNDY1Zi04NWRmLWUyMWFlZGMxM2MwNCJ9)

**Timeframe:** January–December 2022  
**Core KPIs (from the report):**
- **₦38,555,885,000** total amount processed
- **2,143,838** transactions
- **8,819** unique customers
- **12.9%** average ATM utilization rate

## Project Goals
- Profile customer demographics and transaction patterns across locations and times of day.
- Identify most-used ATM services and quantify their trends and seasonality.
- Pinpoint growth opportunities by state, branch, and customer segments.
- Optimize ATM operations through utilization, availability, and duration metrics.
- Provide a single, self-serve reporting layer for managers and analysts.

## Data Sources & Scope
- **Fact:** `Transactions` (amount, duration, count, timestamps, customer key, location key, transaction type key)
- **Dimensions:** `Date`, `Hour`, `Location` (state, branch), `Customer` (age band, gender, occupation), `TransactionType` (Withdrawal, Deposit, Transfer, Balance Inquiry)
- **Geography:** Lagos, Kano, Rivers State, Enugu, FCT Abuja
- **Period:** 2022-01-01 to 2022-12-31

## Data Transformation (Power Query)
**Objectives:** standardize types, derive reporting attributes, remove noise, and ensure model-ready tables.

### Typical M steps (per table)
```m
// Transactions (canonical pattern)
let
  Source = Excel.Workbook(File.Contents("transactions_2022.xlsx"), null, true),
  Data = Source{[Item="Transactions",Kind="Table"]}[Data],
  Trimmed = Table.TransformColumns(Data,{{"CustomerID", Text.Trim, type text},{"Branch", Text.Trim, type text}}),
  Types = Table.TransformColumnTypes(Trimmed,{{"TxnID", Int64.Type},{"Amount", type number},{"DurationMin", type number},{"IsWisabi", type logical},{"TxnDateTime", type datetime}}),
  WithDate = Table.AddColumn(Types, "Date", each Date.From([TxnDateTime]), type date),
  WithHour = Table.AddColumn(WithDate, "Hour", each Time.Hour(Time.From([TxnDateTime])), Int64.Type),
  FilterAmount = Table.SelectRows(WithHour, each [Amount] >= 0),
  FilterDuration = Table.SelectRows(FilterAmount, each [DurationMin] >= 0 and [DurationMin] <= 30),
  CleanCols = Table.RemoveColumns(FilterDuration, {"TxnDateTime"})
in
  CleanCols
```
```m
// Date dimension
let
  Start = #date(2022,1,1),
  End = #date(2022,12,31),
  Dates = List.Dates(Start, Duration.Days(End-Start)+1, #duration(1,0,0,0)),
  ToTable = Table.FromList(Dates, Splitter.SplitByNothing(), {"Date"}, null, ExtraValues.Error),
  Add = Table.TransformColumnTypes(
          Table.AddColumn(
            Table.AddColumn(
              Table.AddColumn(ToTable,"Year", each Date.Year([Date]), Int64.Type),
              "MonthNum", each Date.Month([Date]), Int64.Type),
            "MonthName", each Date.ToText([Date], "MMMM"), type text),
          {{"Date", type date}}),
  WeekStart = Table.AddColumn(Add, "StartOfWeek", each Date.StartOfWeek([Date], Day.Monday), type date),
  MonthYear = Table.AddColumn(WeekStart, "MonthYear", each Date.ToText([Date], "MMM yyyy"), type text)
in
  MonthYear
```
```m
// Hour dimension
let
  Hours = List.Numbers(0,24),
  TableH = Table.FromList(Hours, Splitter.SplitByNothing(), {"Hour"}),
  WithBand = Table.AddColumn(TableH, "DayPart", each if [Hour] < 6 then "Early" else if [Hour] < 12 then "Morning" else if [Hour] < 17 then "Afternoon" else if [Hour] < 21 then "Evening" else "Late")
in
  WithBand
```

**Quality gates**
- Remove negative amounts/durations
- Cap extreme durations (`<= 30 min`)
- Normalize strings and keys
- Validate referential integrity to dimensions

## Data Modelling
A **star schema** with `Transactions` at the center and conformed dimensions for time, customer, location, and transaction type.

**Relationships**
- `Transactions[Date]` → `Date[Date]` (1:*)
- `Transactions[Hour]` → `Hour[Hour]` (1:*)
- `Transactions[LocationKey]` → `Location[LocationKey]` (1:*)
- `Transactions[CustomerKey]` → `Customer[CustomerKey]` (1:*)
- `Transactions[TxnTypeKey]` → `TransactionType[TxnTypeKey]` (1:*)

**Key calculated columns (examples)**
```DAX
Age Band = 
VAR a = 'Customer'[Age]
RETURN 
SWITCH(TRUE(),
 a < 15, "0-14",
 a <= 25, "15-25",
 a <= 35, "26-35",
 a <= 45, "36-45",
 a <= 55, "46-55",
 a <= 65, "56-65",
 "Above 65")
```

**Core measures**
```DAX
Total Transactions = COUNTROWS(Transactions)

Total Amount = SUM(Transactions[Amount])

Avg Duration (min) = AVERAGE(Transactions[DurationMin])

Unique Customers = DISTINCTCOUNT(Transactions[CustomerKey])

Utilization Rate % = 
DIVIDE([Total Transactions], CALCULATE([Total Transactions], ALL('Date')))

Withdrawal % = 
DIVIDE(CALCULATE([Total Transactions], 'TransactionType'[Type] = "Withdrawal"), [Total Transactions])

Avg Amount by Type = AVERAGEX(VALUES('TransactionType'[Type]), [Total Amount])
```

> Note: Adjust utilization formula to the bank’s operational definition (e.g., share of active hours vs. capacity).

<img width="1640" height="930" alt="image" src="https://github.com/user-attachments/assets/75cff223-ac8f-4300-b7d4-db03bbde2d2d" />

## Dashboard Overview
The report ships with **two main pages** and drill-throughs:

### 1) Overview

<img width="1399" height="830" alt="image" src="https://github.com/user-attachments/assets/3b7161f5-bc69-4800-a3e5-3d1d73c7190f" />

- **KPI tiles:** Total Amount, Total Transactions, Unique Customers, Utilization Rate
- **Trend visuals:** Monthly transaction count & amount; daily intraday curve by state
- **Comparatives:** Average transaction amount by state & type; utilization by state
- **Scatter:** Avg Amount vs Avg Duration by state and transaction type

**Insights**
- Highest volumes and amount in **March**, followed by **Jan/May/Jul/Oct/Dec**; lowest in **February**.
- **Kano** shows the highest utilization; **FCT** the lowest.
- Withdrawals have the highest average amount; deposits the lowest.
- Intraday: Lagos remains active after 7pm; other states taper earlier.

### 2) Demography

<img width="1273" height="829" alt="image" src="https://github.com/user-attachments/assets/d251598f-290d-4582-82ed-3c3b28349552" />

- **Composition:** Transaction distribution by type
- **Segments:** Count by age group × type; frequency by age group
- **Durations:** State × type matrix for average duration

**Insights**
- 15–25 age band has the highest transaction frequency; **Above 65** is surprisingly high.
- Kano durations skew longer across multiple types.

### Filters & Interactions
- Global filters: Date, State, Branch, Transaction Type, IsWisabi/Other Bank, Age Band, Gender, Occupation
- Drill-through: State → Branch; Age band → Occupation; Type → Hour band

## KPI Definitions
- **Total Amount:** Sum of ATM-processed amounts
- **Utilization Rate:** Share of active demand vs. capacity (configurable by business rule)
- **Avg Duration:** Mean minutes per transaction, bounded to remove outliers
- **Unique Customers:** Distinct customer keys transacting in period

## Assumptions & Constraints
- Data is accurate, pre-cleaned, and privacy-compliant.
- Scope limited to 2022 and listed states.
- Secure access via enterprise gateway for refresh.

## Recommendations (from analysis)
- Lift **FCT** utilization via placement, visibility, incentives, marketing, and added ATM services.
- Reduce **Kano** durations via capacity, hardware upgrades, maintenance cadence, UI prompts, and customer education.
- Migrate **balance/transfer** traffic toward online & phone banking with incentives and onboarding.
- Align maintenance to **low-activity windows**; ensure peak-time availability by branch.

## How to Use
1. Open `Wisabi Bank.pbix` in Power BI Desktop.
2. Refresh data connections or replace with your SQL extracts.
3. Publish to Power BI Service, configure scheduled refresh via on-premises gateway.
4. Share workspaces with stakeholders, enable row-level security if applicable.

## Future Enhancements
- SLA uptime by ATM with incident logs
- Customer lifetime value and cross-channel migration tracking
- Queue-time modeling by branch-hour
- Anomaly detection for fraud/operational issues
- Seasonality decomposition with Auto-ARIMA or Prophet for demand forecasting

---

**Files included (this project):**
- `Wisabi Bank.pbix` — report file
- `Wisabi Bank Report.pdf` — snapshot report
- `Power BI Dashboard Snapshot.pdf` — additional visuals
- `Business Requirement Document.docx` — business context
- `Project Brief.docx` — scope and deliverables
- `README.md` — this document
