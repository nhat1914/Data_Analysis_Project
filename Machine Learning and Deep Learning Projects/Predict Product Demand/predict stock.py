import pandas as pd
import numpy as np
from prophet import Prophet
from statsmodels.tsa.statespace.sarimax import SARIMAX
from sklearn.metrics import mean_absolute_error, mean_absolute_percentage_error
from tqdm import tqdm
from dateutil.parser import parse
import warnings

warnings.filterwarnings("ignore")

# === Load and Combine Data ===
sales_csv = "sales from 1st DEC.csv"
sales_excel = "LW & Store Onhand - With Case Quantity Sources.xlsx"
product_file = "All products.xlsx"
sales_data_csv = pd.read_csv(sales_csv, low_memory=False)
sales_data_excel = pd.read_excel(sales_excel, header=1)
product_df = pd.read_excel(product_file, sheet_name='Sheet1')
sales_data = pd.concat([sales_data_csv, sales_data_excel], ignore_index=True)

#=== Parse timestamp (keep only dd/mm/yyyy)
sales_data['timestamp'] = sales_data['timestamp'].astype(str).str[:10].str.strip()
sales_data['timestamp'] = pd.to_datetime(sales_data['timestamp'], dayfirst=True, errors='coerce')

# === Quantity Sold (Case) without filtering nulls
sales_data = sales_data[sales_data['case_quantity'] != '#N/A']
sales_data['quantity sold'] = pd.to_numeric(sales_data['quantity sold'], errors='coerce')
sales_data['case_quantity'] = pd.to_numeric(sales_data['case_quantity'], errors='coerce')
sales_data = sales_data[sales_data['quantity sold'] > 0]
sales_data = sales_data[sales_data['case_quantity'] > 0]
sales_data['Quantity Sold (Case)'] = sales_data['quantity sold'] / sales_data['case_quantity']
results = []
skipped = []
product_ids = sales_data['product_id'].unique()

for product_id in tqdm(product_ids):
    try:
        filtered_sales = sales_data[sales_data['product_id'] == product_id]
        product_data = filtered_sales.groupby(filtered_sales['timestamp'].dt.to_period('W'))['Quantity Sold (Case)'].sum().reset_index()
        product_data['Week'] = product_data['timestamp'].dt.start_time
        product_data = product_data.drop(columns='timestamp')

        inferred_freq = pd.infer_freq(product_data['Week'].sort_values())
        week_range = pd.date_range(start=product_data['Week'].min(), end=product_data['Week'].max(), freq=inferred_freq)

        product_data = product_data.set_index('Week').reindex(week_range).fillna(0)
        product_data.index.name = 'Week'
        product_data = product_data.reset_index()

        product_data = product_data.sort_values("Week")
        avg_weekly = product_data['Quantity Sold (Case)'].mean()

        train = product_data[:-2]
        test = product_data[-2:]

        # === SARIMAX ===
        sarimax_series = train.set_index('Week')['Quantity Sold (Case)']
        sarimax_series.index.freq = inferred_freq
        sarimax_model = SARIMAX(sarimax_series, order=(1, 1, 1), seasonal_order=(0, 1, 1, 4),
                                enforce_stationarity=False, enforce_invertibility=False)
        sarimax_result = sarimax_model.fit(disp=False)
        sarimax_forecast = sarimax_result.get_forecast(steps=2).predicted_mean

        sarimax_mae = mean_absolute_error(test['Quantity Sold (Case)'], sarimax_forecast)
        sarimax_mape = mean_absolute_percentage_error(test['Quantity Sold (Case)'], sarimax_forecast)

        # === Prophet ===
        prophet_train = train.rename(columns={"Week": "ds", "Quantity Sold (Case)": "y"})
        prophet_model = Prophet(weekly_seasonality=True, daily_seasonality=False)
        prophet_model.fit(prophet_train)
        future = prophet_model.make_future_dataframe(periods=2, freq='W')
        forecast = prophet_model.predict(future)
        prophet_pred = forecast.set_index('ds').iloc[-2:]['yhat']

        prophet_mae = mean_absolute_error(test['Quantity Sold (Case)'], prophet_pred)
        prophet_mape = mean_absolute_percentage_error(test['Quantity Sold (Case)'], prophet_pred)

        # === Final full forecast ===
        full_prophet_df = product_data.rename(columns={"Week": "ds", "Quantity Sold (Case)": "y"})
        full_prophet_model = Prophet(weekly_seasonality=True, daily_seasonality=False)
        full_prophet_model.fit(full_prophet_df)
        full_future = full_prophet_model.make_future_dataframe(periods=2, freq='W')
        prophet_forecast = full_prophet_model.predict(full_future)
        prophet_future = prophet_forecast.set_index('ds').iloc[-2:]['yhat']

        full_sarimax_series = product_data.set_index('Week')['Quantity Sold (Case)']
        full_sarimax_series.index.freq = inferred_freq
        final_sarimax_model = SARIMAX(full_sarimax_series, order=(1, 1, 1), seasonal_order=(0, 1, 1, 4),
                                      enforce_stationarity=False, enforce_invertibility=False)
        final_sarimax_result = final_sarimax_model.fit(disp=False)
        sarimax_future = final_sarimax_result.get_forecast(steps=2).predicted_mean

        product_name = product_df.loc[product_df['product_id'] == product_id, 'name'].values[0] if 'name' in product_df.columns else ''

        results.append({
            'product_id': product_id,
            'Product Name': product_name,
            'Actual Avg Weekly Sales': round(avg_weekly, 2),
            'Prophet MAE': round(prophet_mae, 2),
            'Prophet MAPE (%)': round(prophet_mape * 100, 2),
            'Prophet Forecast (1w)': round(prophet_future.iloc[0], 2),
            'Prophet Forecast (2w)': round(prophet_future.sum(), 2),
            'SARIMAX MAE': round(sarimax_mae, 2),
            'SARIMAX MAPE (%)': round(sarimax_mape * 100, 2),
            'SARIMAX Forecast (1w)': round(sarimax_future.iloc[0], 2),
            'SARIMAX Forecast (2w)': round(sarimax_future.sum(), 2)
        })

    except Exception as e:
        skipped.append({'product_id': product_id, 'reason': f'Error: {str(e)}'})
        continue

# === Export ===
results_df = pd.DataFrame(results)
results_df.to_csv("weekly_forecast_comparison.csv", index=False)
pd.DataFrame(skipped).to_csv("skipped_products_log.csv", index=False)

print("Forecast saved to weekly_forecast_comparison.csv")
print("Skipped product log saved to skipped_products_log.csv")

