---------------------------------------------------------------------------------------------
-- CLEAN SALES VIEW
-- Creates a clean dataset excluding refunds or negative quantity sales.
---------------------------------------------------------------------------------------------
CREATE OR ALTER VIEW dbo.v_sales_clean AS
SELECT *
FROM dbo.sales
WHERE quantity_sold >= 0;
GO


---------------------------------------------------------------------------------------------
-- 1. MONTHLY SALES BY OUTLET
-- Summarizes revenue, cost, and profit per outlet by month.
---------------------------------------------------------------------------------------------

SELECT
  FORMAT(timestamp, 'yyyy-MM') AS ym,
  Outlet_Name,
  SUM(Revenue) AS Revenue,
  SUM(Cost_of_Goods_Sold) AS COGS,
  SUM(Profit) AS Profit
FROM dbo.v_sales_clean
GROUP BY FORMAT(timestamp, 'yyyy-MM'), Outlet_Name
ORDER BY ym, Outlet_Name desc;

---------------------------------------------------------------------------------------------
-- 2. TOP 10 PRODUCTS BY REVENUE (LAST 90 DAYS)
-- Finds high-performing SKUs based on recent sales value.
---------------------------------------------------------------------------------------------
SELECT TOP 10
  product_id,
  Product_Name,
  SUM(Revenue) AS Revenue
FROM dbo.v_sales_clean
WHERE timestamp >= DATEADD(DAY, -90, SYSUTCDATETIME())
GROUP BY product_id, Product_Name
ORDER BY Revenue DESC;
GO


---------------------------------------------------------------------------------------------
-- 3. CATEGORY PERFORMANCE (JOINED TO PRICE VIEW)
-- Compares revenue and profit margins by product category.
---------------------------------------------------------------------------------------------
SELECT
  pv.DimProductCategories_category_5f_name AS Category,
  SUM(s.Revenue) AS Revenue,
  SUM(s.Cost_of_Goods_Sold) AS COGS,
  SUM(s.Profit) AS Profit,
  CAST(100.0 * SUM(s.Profit) / NULLIF(SUM(s.Revenue),0) AS DECIMAL(6,2)) AS MarginPct
FROM dbo.v_sales_clean s
LEFT JOIN dbo.[All Stores Price View] pv
  ON pv.DimProducts_product_5f_code = s.product_id
GROUP BY pv.DimProductCategories_category_5f_name
ORDER BY Revenue DESC;
GO


---------------------------------------------------------------------------------------------
-- 4. AVERAGE TRANSACTION VALUE (ATV)
-- Calculates the average customer transaction value per outlet per month.
---------------------------------------------------------------------------------------------
SELECT
  FORMAT(timestamp, 'yyyy-MM') AS ym,
  Outlet_Name,
  SUM(Revenue) / NULLIF(SUM(Transaction_Count),0) AS Avg_Transaction_Value,
  SUM(Transaction_Count) AS Transactions
FROM dbo.v_sales_clean
GROUP BY FORMAT(timestamp, 'yyyy-MM'), Outlet_Name
ORDER BY ym, Outlet_Name;
GO


---------------------------------------------------------------------------------------------
-- 5. CUSTOMERS WITH OUTSTANDING BALANCES
-- Lists customers who owe money and their most recent purchase date.
---------------------------------------------------------------------------------------------
WITH last_buy AS (
  SELECT customer_id, MAX(timestamp) AS last_purchase
  FROM dbo.v_sales_clean
  WHERE customer_id IS NOT NULL
  GROUP BY customer_id
)
SELECT
  c.uuid,
  CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
  c.customer_group_name,
  c.current_owing,
  lb.last_purchase
FROM dbo.customer c
LEFT JOIN last_buy lb ON lb.customer_id = c.uuid
WHERE ISNULL(c.current_owing,0) > 0
ORDER BY c.current_owing DESC;
GO


---------------------------------------------------------------------------------------------
-- 6. CUSTOMER CHURN CANDIDATES
-- Identifies customers who haven’t purchased in the last 90 days.
---------------------------------------------------------------------------------------------
SELECT c.uuid, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, c.customer_group_name
FROM dbo.customer c
WHERE NOT EXISTS (
  SELECT 1 FROM dbo.v_sales_clean s
  WHERE s.customer_id = c.uuid
    AND s.timestamp >= DATEADD(DAY, -90, SYSUTCDATETIME())
)
AND EXISTS (
  SELECT 1 FROM dbo.v_sales_clean s2
  WHERE s2.customer_id = c.uuid
);
GO


---------------------------------------------------------------------------------------------
-- 7. PRICE CONSISTENCY ACROSS BRANCHES
-- Detects products priced differently across stores.
---------------------------------------------------------------------------------------------
SELECT
  pv.DimProducts_product_5f_code     AS product_id,
  pv.DimProducts_product_5f_name     AS product_name,
  COUNT(DISTINCT pv.DimBranches_branch_5f_name) AS branches,
  MIN(pv.FactPrices_new_5f_price)    AS min_price,
  MAX(pv.FactPrices_new_5f_price)    AS max_price,
  (MAX(pv.FactPrices_new_5f_price) - MIN(pv.FactPrices_new_5f_price)) AS spread
FROM dbo.[All Stores Price View] pv
GROUP BY pv.DimProducts_product_5f_code, pv.DimProducts_product_5f_name
HAVING COUNT(DISTINCT pv.DimBranches_branch_5f_name) > 1
ORDER BY spread DESC;
GO


---------------------------------------------------------------------------------------------
-- 8. CHEAPEST AND MOST EXPENSIVE BRANCH PER SKU
-- Ranks branches by price to find cheapest and most expensive outlets for each product.
---------------------------------------------------------------------------------------------
WITH ranked AS (
  SELECT
    pv.DimProducts_product_5f_code AS product_id,
    pv.DimProducts_product_5f_name AS product_name,
    pv.DimBranches_branch_5f_name  AS branch,
    pv.FactPrices_new_5f_price     AS price,
    RANK() OVER (PARTITION BY pv.DimProducts_product_5f_code ORDER BY pv.FactPrices_new_5f_price ASC)  AS r_min,
    RANK() OVER (PARTITION BY pv.DimProducts_product_5f_code ORDER BY pv.FactPrices_new_5f_price DESC) AS r_max
  FROM dbo.[All Stores Price View] pv
)
SELECT
  product_id, product_name,
  MIN(CASE WHEN r_min = 1 THEN CONCAT(branch, ' ($', CONVERT(VARCHAR(20), price), ')') END) AS cheapest_branch,
  MIN(CASE WHEN r_max = 1 THEN CONCAT(branch, ' ($', CONVERT(VARCHAR(20), price), ')') END) AS most_exp_branch
FROM ranked
GROUP BY product_id, product_name
ORDER BY product_name;
GO


---------------------------------------------------------------------------------------------
-- 9. PRODUCT PROFITABILITY LEAGUE (YTD)
-- Ranks SKUs by total profit and profit margin for the current year.
---------------------------------------------------------------------------------------------
SELECT
  product_id,
  Product_Name,
  SUM(Revenue) AS Revenue,
  SUM(Cost_of_Goods_Sold) AS COGS,
  SUM(Profit) AS Profit,
  CAST(100.0 * SUM(Profit) / NULLIF(SUM(Revenue),0) AS DECIMAL(6,2)) AS MarginPct,
  RANK() OVER (ORDER BY SUM(Profit) DESC) AS Profit_Rank
FROM dbo.v_sales_clean
WHERE timestamp >= DATEFROMPARTS(YEAR(GETDATE()),1,1)
GROUP BY product_id, Product_Name
ORDER BY Profit_Rank;
GO


---------------------------------------------------------------------------------------------
-- 10. WEEKLY TREND BY OUTLET
-- Weekly aggregated sales and units for each outlet.
---------------------------------------------------------------------------------------------
SELECT
  DATEADD(WEEK, DATEDIFF(WEEK, 0, timestamp), 0) AS week_start,
  Outlet_Name,
  SUM(quantity_sold) AS units,
  SUM(Revenue) AS revenue
FROM dbo.v_sales_clean
GROUP BY DATEADD(WEEK, DATEDIFF(WEEK, 0, timestamp), 0), Outlet_Name
ORDER BY week_start, Outlet_Name;
GO


---------------------------------------------------------------------------------------------
-- 11. SUPPLIER LEAD TIME AND RECEIPT FILL RATE
-- Calculates average days between order and receipt, plus overall fulfillment ratio.
---------------------------------------------------------------------------------------------
SELECT
  [Supplier]              AS Supplier_Name,
  AVG(DATEDIFF(DAY, Order_Date, Received_At))                                       AS avg_lead_days,
  SUM(Item_Received) AS items_received_total,
  COUNT(DISTINCT Order_Number) AS orders
FROM dbo.[store order]
GROUP BY [Supplier]
ORDER BY avg_lead_days desc;
GO


---------------------------------------------------------------------------------------------
-- 12. FILL RATE BY PURCHASE ORDER
-- Summarizes each purchase order’s received quantity and cost.
---------------------------------------------------------------------------------------------
SELECT
  Order_Number,
  [Supplier],
  Order_Date,
  Received_At,
  SUM(Item_Received) AS items_received,
  SUM(Total_Cost)    AS total_cost,
  SUM(Freight)       AS freight,
  SUM(Payment_Fees)  AS payment_fees
FROM dbo.[store order]
GROUP BY Order_Number, [Supplier], Order_Date, Received_At
ORDER BY Order_Date DESC;
GO


---------------------------------------------------------------------------------------------
-- 13. TRANSFER FLOW BETWEEN OUTLETS
-- Analyzes product movements between sender and receiver stores.
---------------------------------------------------------------------------------------------
SELECT
  sender      AS sender_outlet,
  receiver    AS receiver_outlet,
  COUNT(DISTINCT transfer_id) AS transfers,
  SUM(transferred_quantity)   AS units_transferred,
  SUM(cost * transferred_quantity) AS transfer_value_est
FROM dbo.transfer
WHERE transferred_quantity IS NOT NULL
GROUP BY sender, receiver
ORDER BY transfer_value_est DESC;
GO


---------------------------------------------------------------------------------------------
-- 14. NET TRANSFER POSITION PER OUTLET
-- Calculates each outlet’s total sent vs received stock movement.
---------------------------------------------------------------------------------------------
WITH sent AS (
  SELECT sender AS outlet, SUM(transferred_quantity) AS sent_units
  FROM dbo.transfer
  GROUP BY sender
),
recv AS (
  SELECT receiver AS outlet, SUM(transferred_quantity) AS recv_units
  FROM dbo.transfer
  GROUP BY receiver
)
SELECT
  COALESCE(r.outlet, s.outlet) AS outlet,
  ISNULL(r.recv_units,0) AS received_units,
  ISNULL(s.sent_units,0) AS sent_units,
  ISNULL(r.recv_units,0) - ISNULL(s.sent_units,0) AS net_units
FROM recv r
FULL OUTER JOIN sent s ON s.outlet = r.outlet
ORDER BY net_units DESC;
GO


---------------------------------------------------------------------------------------------
-- 15. PRICE ATTRIBUTE COMPARISON ACROSS BRANCHES
-- Shows product attribute (e.g., pack size) and price by branch.
---------------------------------------------------------------------------------------------
SELECT
  pv.DimProducts_product_5f_name AS product_name,
  pv.DimProductAttributes_product_5f_attribute_5f_label AS attribute_label,
  pv.DimBranches_branch_5f_name AS branch,
  pv.FactPrices_new_5f_price AS price
FROM dbo.[All Stores Price View] pv
WHERE pv.DimProductAttributes_product_5f_attribute_5f_label IS NOT NULL
ORDER BY product_name, attribute_label, branch;
GO


---------------------------------------------------------------------------------------------
-- 16. MARGIN LEAKAGE DETECTION
-- Flags SKUs or outlets with negative or low (<10%) margins.
---------------------------------------------------------------------------------------------
SELECT
  Outlet_Name,
  product_id,
  Product_Name,
  SUM(Revenue) AS Revenue,
  SUM(Cost_of_Goods_Sold) AS COGS,
  SUM(Profit) AS Profit,
  CAST(100.0 * SUM(Profit)/NULLIF(SUM(Revenue),0) AS DECIMAL(6,2)) AS MarginPct
FROM dbo.v_sales_clean
GROUP BY Outlet_Name, product_id, Product_Name
HAVING SUM(Profit) <= 0 OR CAST(100.0 * SUM(Profit)/NULLIF(SUM(Revenue),0) AS DECIMAL(6,2)) < 10
ORDER BY Profit;
GO


---------------------------------------------------------------------------------------------
-- 17. ROLLING 28-DAY AVERAGE SALES BY SKU
-- Computes a moving average of daily units sold for trend analysis.
---------------------------------------------------------------------------------------------
WITH d AS (
  SELECT
    product_id,
    CAST(timestamp AS DATE) AS d,
    SUM(quantity_sold) AS units
  FROM dbo.v_sales_clean
  GROUP BY product_id, CAST(timestamp AS DATE)
)
SELECT
  product_id,
  d,
  AVG(CAST(units AS FLOAT)) OVER (PARTITION BY product_id ORDER BY d ROWS BETWEEN 27 PRECEDING AND CURRENT ROW) AS rolling_28d_avg_units
FROM d
ORDER BY product_id, d;
GO


---------------------------------------------------------------------------------------------
-- 18. PRODUCT BASKET PAIRS (APPROX)
-- Estimates co-purchased products by customer and day (aggregated basket logic).
---------------------------------------------------------------------------------------------
WITH baskets AS (
  SELECT
    customer_id,
    CAST(timestamp AS DATE) AS d,
    product_id
  FROM dbo.v_sales_clean
  WHERE customer_id IS NOT NULL
  GROUP BY customer_id, CAST(timestamp AS DATE), product_id
)
SELECT a.product_id AS prod_a, b.product_id AS prod_b, COUNT(*) AS together_days
FROM baskets a
JOIN baskets b
  ON a.customer_id = b.customer_id
 AND a.d = b.d
 AND a.product_id < b.product_id
GROUP BY a.product_id, b.product_id
ORDER BY together_days DESC;
GO