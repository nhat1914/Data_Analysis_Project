
---------------------------------------------------------------------------------------------
-- STATIONERY SALES ANALYTICS – OPERATIONAL QUERIES
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
-- CLEAN ORDERS VIEW: parses dates, trims strings, normalizes numerics; drops negative qty/sales.
---------------------------------------------------------------------------------------------
CREATE OR ALTER VIEW dbo.v_orders_clean AS
SELECT
  o.ROW_ID,
  o.ORDER_ID,
  TRY_CONVERT(date, LTRIM(RTRIM(o.ORDER_DATE))) AS order_date,
  TRY_CONVERT(date, LTRIM(RTRIM(o.SHIP_DATE)))  AS ship_date,
  NULLIF(LTRIM(RTRIM(o.SHIP_MODE)),'')          AS ship_mode,
  NULLIF(LTRIM(RTRIM(o.CUSTOMER_ID)),'')        AS customer_id,
  NULLIF(LTRIM(RTRIM(o.PRODUCT_ID)),'')         AS product_id,
  TRY_CAST(o.SALES    AS decimal(18,2))         AS sales,
  TRY_CAST(o.QUANTITY AS int)                   AS quantity,
  TRY_CAST(o.DISCOUNT AS decimal(6,4))          AS discount,
  TRY_CAST(o.PROFIT   AS decimal(18,2))         AS profit,
  o.ID_EMPLOYEE
FROM dbo.ORDERS o
WHERE TRY_CAST(o.QUANTITY AS int) >= 0
  AND TRY_CAST(o.SALES AS decimal(18,2)) >= 0;
GO

---------------------------------------------------------------------------------------------
-- 1) MONTHLY SALES OVERVIEW: sales, units, and profit by year‑month.
---------------------------------------------------------------------------------------------
SELECT
  FORMAT(order_date,'yyyy-MM') AS ym,
  SUM(sales)    AS revenue,
  SUM(quantity) AS units,
  SUM(profit)   AS profit
FROM dbo.v_orders_clean
GROUP BY FORMAT(order_date,'yyyy-MM')
ORDER BY ym;
GO

---------------------------------------------------------------------------------------------
-- 2) TOP 20 PRODUCTS BY REVENUE (LAST 90 DAYS): fast movers driving value.
---------------------------------------------------------------------------------------------
WITH maxd AS (
  SELECT MAX(order_date) AS max_order_date
  FROM dbo.v_orders_clean
)
SELECT TOP 20
  p.NAME        AS product_name,
  p.SUBCATEGORY AS subcategory,
  p.CATEGORY    AS category,
  SUM(o.quantity) AS units,
  SUM(o.sales)    AS revenue,
  SUM(o.profit)   AS profit
FROM dbo.v_orders_clean o
JOIN dbo.PRODUCT p ON p.ID = o.PRODUCT_ID
CROSS JOIN maxd
WHERE o.order_date IS NOT NULL
  AND o.order_date >= DATEADD(DAY, -90, maxd.max_order_date)
GROUP BY p.NAME, p.SUBCATEGORY, p.CATEGORY
ORDER BY revenue DESC;
GO

---------------------------------------------------------------------------------------------
-- 3) CATEGORY + SUBCATEGORY PERFORMANCE: revenue, units, profit, margin%.
---------------------------------------------------------------------------------------------
SELECT
  p.CATEGORY,
  p.SUBCATEGORY,
  SUM(o.sales)    AS revenue,
  SUM(o.quantity) AS units,
  SUM(o.profit)   AS profit,
  CAST(100.0*SUM(o.profit)/NULLIF(SUM(o.sales),0) AS decimal(6,2)) AS margin_pct
FROM dbo.v_orders_clean o
JOIN dbo.PRODUCT p ON p.ID = o.PRODUCT_ID
GROUP BY p.CATEGORY, p.SUBCATEGORY
ORDER BY revenue DESC;
GO

---------------------------------------------------------------------------------------------
-- 4) CUSTOMER SEGMENT PERFORMANCE: B2B vs retail segments by revenue & margin.
---------------------------------------------------------------------------------------------
SELECT
  c.SEGMENT,
  SUM(o.sales)  AS revenue,
  SUM(o.profit) AS profit,
  CAST(100.0*SUM(o.profit)/NULLIF(SUM(o.sales),0) AS decimal(6,2)) AS margin_pct,
  COUNT(DISTINCT o.CUSTOMER_ID) AS customers
FROM dbo.v_orders_clean o
JOIN dbo.CUSTOMER c ON c.ID = o.CUSTOMER_ID
GROUP BY c.SEGMENT
ORDER BY revenue DESC;
GO

---------------------------------------------------------------------------------------------
-- 5) GEOGRAPHIC HEATMAP (STATE x CITY): revenue and orders to guide routing.
---------------------------------------------------------------------------------------------
SELECT
  c.STATE,
  c.CITY,
  COUNT(DISTINCT o.ORDER_ID) AS orders,
  SUM(o.sales)               AS revenue,
  SUM(o.profit)              AS profit
FROM dbo.v_orders_clean o
JOIN dbo.CUSTOMER c ON c.ID = o.CUSTOMER_ID
GROUP BY c.STATE, c.CITY
ORDER BY revenue DESC;
GO

---------------------------------------------------------------------------------------------
-- 6) DISCOUNT BANDS: revenue and margin by discount bucket to check elasticity.
---------------------------------------------------------------------------------------------
WITH b AS (
  SELECT
    CASE
      WHEN discount IS NULL THEN '0.00'
      WHEN discount < 0.05 THEN '0–5%'
      WHEN discount < 0.10 THEN '5–10%'
      WHEN discount < 0.20 THEN '10–20%'
      WHEN discount < 0.30 THEN '20–30%'
      ELSE '30%+'
    END AS disc_band,
    sales, profit
  FROM dbo.v_orders_clean
)
SELECT disc_band,
       SUM(sales) AS revenue,
       SUM(profit) AS profit,
       CAST(100.0*SUM(profit)/NULLIF(SUM(sales),0) AS decimal(6,2)) AS margin_pct
FROM b
GROUP BY disc_band
ORDER BY
  CASE disc_band
    WHEN '0.00' THEN 0
    WHEN '0–5%' THEN 1
    WHEN '5–10%' THEN 2
    WHEN '10–20%' THEN 3
    WHEN '20–30%' THEN 4
    ELSE 5
  END;
GO

---------------------------------------------------------------------------------------------
-- 7) EMPLOYEE PERFORMANCE: revenue, orders, and margin per salesperson.
---------------------------------------------------------------------------------------------
SELECT
  e.NAME AS employee_name,
  COUNT(DISTINCT o.ORDER_ID) AS orders,
  SUM(o.sales)  AS revenue,
  SUM(o.profit) AS profit,
  CAST(100.0*SUM(o.profit)/NULLIF(SUM(o.sales),0) AS decimal(6,2)) AS margin_pct
FROM dbo.v_orders_clean o
JOIN dbo.EMPLOYEE e ON e.ID_EMPLOYEE = o.ID_EMPLOYEE
GROUP BY e.NAME
ORDER BY revenue DESC;
GO

---------------------------------------------------------------------------------------------
-- 8) AVERAGE ORDER VALUE (AOV) BY SEGMENT AND SHIP MODE: basket health check.
---------------------------------------------------------------------------------------------
SELECT
  c.SEGMENT,
  o.ship_mode,
  SUM(o.sales)/NULLIF(COUNT(DISTINCT o.ORDER_ID),0) AS avg_order_value,
  COUNT(DISTINCT o.ORDER_ID) AS orders
FROM dbo.v_orders_clean o
JOIN dbo.CUSTOMER c ON c.ID = o.CUSTOMER_ID
GROUP BY c.SEGMENT, o.ship_mode
ORDER BY avg_order_value DESC;
GO

---------------------------------------------------------------------------------------------
-- 9) ORDER‑TO‑SHIP LEAD TIME: average days by ship mode and region.
---------------------------------------------------------------------------------------------
SELECT
  o.ship_mode,
  c.REGION,
  AVG(DATEDIFF(DAY, o.order_date, o.ship_date)) AS avg_lead_days,
  COUNT(*) AS lines
FROM dbo.v_orders_clean o
JOIN dbo.CUSTOMER c ON c.ID = o.CUSTOMER_ID
WHERE o.order_date IS NOT NULL AND o.ship_date IS NOT NULL
GROUP BY o.ship_mode, c.REGION
ORDER BY avg_lead_days;
GO

---------------------------------------------------------------------------------------------
-- 10) NEGATIVE / LOW MARGIN FLAGS: leakage by product and geography.
---------------------------------------------------------------------------------------------
SELECT
  p.NAME AS product_name,
  c.STATE,
  SUM(o.sales)  AS revenue,
  SUM(o.profit) AS profit,
  CAST(100.0*SUM(o.profit)/NULLIF(SUM(o.sales),0) AS decimal(6,2)) AS margin_pct
FROM dbo.v_orders_clean o
JOIN dbo.PRODUCT p ON p.ID = o.PRODUCT_ID
JOIN dbo.CUSTOMER c ON c.ID = o.CUSTOMER_ID
GROUP BY p.NAME, c.STATE
HAVING SUM(o.profit) <= 0 OR CAST(100.0*SUM(o.profit)/NULLIF(SUM(o.sales),0) AS decimal(6,2)) < 10
ORDER BY profit;
GO

---------------------------------------------------------------------------------------------
-- 11) REPEAT RATE & RECENCY: first vs latest order per customer.
---------------------------------------------------------------------------------------------
WITH k AS (
  SELECT customer_id,
         MIN(order_date) AS first_order,
         MAX(order_date) AS last_order,
         COUNT(DISTINCT ORDER_ID) AS orders
  FROM dbo.v_orders_clean
  GROUP BY customer_id
)
SELECT
  k.customer_id,
  c.NAME AS customer_name,
  c.SEGMENT,
  k.orders,
  k.first_order,
  k.last_order,
  DATEDIFF(DAY, k.last_order, CAST(SYSUTCDATETIME() AS date)) AS days_since_last
FROM k
JOIN dbo.CUSTOMER c ON c.ID = k.customer_id
ORDER BY days_since_last;
GO

---------------------------------------------------------------------------------------------
-- 12) BASKET PAIRINGS BY SUBCATEGORY: co‑ordered subcategory pairs.
---------------------------------------------------------------------------------------------
WITH lines AS (
  SELECT DISTINCT o.ORDER_ID, p.SUBCATEGORY
  FROM dbo.v_orders_clean o
  JOIN dbo.PRODUCT p ON p.ID = o.PRODUCT_ID
),
pairs AS (
  SELECT a.ORDER_ID, a.SUBCATEGORY AS a_sub, b.SUBCATEGORY AS b_sub
  FROM lines a
  JOIN lines b ON a.ORDER_ID=b.ORDER_ID AND a.SUBCATEGORY < b.SUBCATEGORY
)
SELECT TOP 50 a_sub, b_sub, COUNT(*) AS together_orders
FROM pairs
GROUP BY a_sub, b_sub
ORDER BY together_orders DESC;
GO

---------------------------------------------------------------------------------------------
-- 13) PRICE PER UNIT INSIGHT: average sales per unit by product (proxy price).
---------------------------------------------------------------------------------------------
SELECT
  p.NAME AS product_name,
  CAST(SUM(o.sales)/NULLIF(SUM(o.quantity),0) AS decimal(10,2)) AS avg_price_per_unit,
  SUM(o.quantity) AS units,
  SUM(o.sales)    AS revenue
FROM dbo.v_orders_clean o
JOIN dbo.PRODUCT p ON p.ID = o.PRODUCT_ID
GROUP BY p.NAME
HAVING SUM(o.quantity) > 0
ORDER BY avg_price_per_unit DESC;
GO

---------------------------------------------------------------------------------------------
-- 14) QUARTERLY CATEGORY TREND: revenue by category per quarter (for planning).
---------------------------------------------------------------------------------------------
SELECT
  CONCAT(DATEPART(YEAR, order_date), '-Q', DATEPART(QUARTER, order_date)) AS yrqtr,
  p.CATEGORY,
  SUM(o.sales) AS revenue
FROM dbo.v_orders_clean o
JOIN dbo.PRODUCT p ON p.ID = o.PRODUCT_ID
GROUP BY CONCAT(DATEPART(YEAR, order_date), '-Q', DATEPART(QUARTER, order_date)), p.CATEGORY
ORDER BY yrqtr, p.CATEGORY;
GO
