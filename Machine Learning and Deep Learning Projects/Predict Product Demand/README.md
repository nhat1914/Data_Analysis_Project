# Multi-Model Product Sales Forecasting

This project automates **weekly product-level sales forecasting** using a hybrid approach with **Prophet** and **SARIMAX** models.  
It forecasts liquor product demand based on historical sales data from multiple sources (CSV + Excel).  
The outputs include **side-by-side forecast comparisons**, **error metrics**, and **weekly trend insights** — helping optimize wholesale inventory and replenishment planning.

## Project Overview

### Objective
To build a **robust and automated forecasting script** capable of:
- Combining sales and product metadata across multiple files
- Cleaning and preparing time series data per product
- Running **Prophet** and **SARIMAX** models in parallel
- Comparing their forecast accuracy (MAE, MAPE)
- Exporting predictions and diagnostics for operational decision-making

### Workflow Summary

1. **Data Integration**
   - Reads from:
     - `sales from 1st DEC.csv`
     - `LW & Store Onhand - With Case Quantity Sources.xlsx`
     - `All products.xlsx`
   - Merges all sales datasets into one unified frame.

2. **Data Cleaning**
   - Extracts and standardizes timestamp to `dd/mm/yyyy`.
   - Removes invalid or zero quantities.
   - Computes `Quantity Sold (Case)` = quantity sold ÷ case size.

3. **Weekly Aggregation**
   - Aggregates sales by **week start date**.
   - Handles missing weeks and infers frequency automatically.
   - Calculates **average weekly sales** per product.

4. **Model Training and Forecasting**
   - **Prophet Model**:
     - Captures weekly seasonality patterns.
     - Generates 2-week-ahead forecasts.
   - **SARIMAX Model**:
     - Captures autoregressive and seasonal components.
     - Parallel 2-week forecast generation.
   - Both models are evaluated via:
     - **Mean Absolute Error (MAE)**
     - **Mean Absolute Percentage Error (MAPE)**

5. **Result Compilation**
   - Compares Prophet vs SARIMAX forecasts per product.
   - Exports:
     - `weekly_forecast_comparison.csv` → model results  
     - `skipped_products_log.csv` → products skipped due to data or model issues

## Tech Stack

| Category | Tools / Libraries |
|-----------|------------------|
| **Language** | Python |
| **Core Libraries** | Pandas, NumPy, tqdm |
| **Forecasting Models** | Prophet, Statsmodels (SARIMAX) |
| **Metrics** | Mean Absolute Error (MAE), Mean Absolute Percentage Error (MAPE) |
| **Utilities** | dateutil, warnings |

## Model Comparison Logic

| Model | Key Strength | Parameters Used | Output |
|--------|---------------|----------------|---------|
| **Prophet** | Captures trend and seasonality automatically | `weekly_seasonality=True` | `Prophet Forecast (1w, 2w)` |
| **SARIMAX** | Handles autocorrelation and seasonality explicitly | `(1,1,1)(0,1,1,4)` | `SARIMAX Forecast (1w, 2w)` |

> For each product, both models are trained separately and evaluated on the final 2 weeks of sales data.

## Output Structure

The main output file `weekly_forecast_comparison.csv` contains:

| Column | Description |
|---------|--------------|
| `product_id` | Product unique ID |
| `Product Name` | Product descriptive name |
| `Actual Avg Weekly Sales` | Average of past weekly sales |
| `Prophet MAE` / `MAPE (%)` | Prophet model error metrics |
| `SARIMAX MAE` / `MAPE (%)` | SARIMAX model error metrics |
| `Prophet Forecast (1w)` / `(2w)` | Prophet forecasted volume |
| `SARIMAX Forecast (1w)` / `(2w)` | SARIMAX forecasted volume |

<img width="1749" height="913" alt="image" src="https://github.com/user-attachments/assets/52b67ea2-18c6-497e-9841-541e1666637b" />

## Outputs

| File | Description |
|------|--------------|
| `weekly_forecast_comparison.csv` | Model performance & 2-week forecasts for each product |
| `skipped_products_log.csv` | Products skipped due to missing data or model errors |

## Notes & Recommendations

- Ensure all input files (`CSV`, `Excel`) share consistent **column names** and **timestamp format**.  
- Data should cover **at least 20–30 weeks** for reliable trend detection.  
- Products with insufficient data are logged in `skipped_products_log.csv`.  
- Model parameters can be tuned for performance:
  - Prophet → add `seasonality_mode='multiplicative'`
  - SARIMAX → adjust `(p,d,q)` or seasonal period `(P,D,Q, s)`

## Author

**Author:** [Frank Dinh]  
**Email:** [dinh.qnhat@gmail.com]  
**Affiliation:** Product Forecasting Project  
**Year:** 2025  

> © 2025 All Rights Reserved. Unauthorized reuse or distribution of this code is prohibited.
