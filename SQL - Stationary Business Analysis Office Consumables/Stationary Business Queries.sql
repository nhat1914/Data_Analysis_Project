---------------------------------------------------------------------------------------------
-- Total sales of furniture products by quarter
---------------------------------------------------------------------------------------------

SELECT 
    CONCAT('Q', DATEPART(QUARTER, o.order_date), '-', DATEPART(YEAR, o.order_date)) AS Quarter_Year,
    SUM(o.sales) AS Total_Sales
FROM orders AS o
JOIN product AS p 
    ON o.product_id = p.id
WHERE p.name = 'Furniture'
GROUP BY DATEPART(YEAR, o.order_date), DATEPART(QUARTER, o.order_date)
ORDER BY DATEPART(YEAR, o.order_date), DATEPART(QUARTER, o.order_date);


---------------------------------------------------------------------------------------------
-- Total profit for each category by discount class
-- Analyze the impact of different discount levels on sales performance across product categories, specifically looking at the number of orders and total profit generated for each discount classification.
/*
Discount level condition:
No Discount = 0
0 < Low Discount <= 0.2
0.2 < Medium Discount <= 0.5
High Discount > 0.5 
*/
---------------------------------------------------------------------------------------------

WITH discount_level AS (
  SELECT
    p.CATEGORY,
    CASE
      WHEN o.Discount = 0 THEN 'No Discount'
      WHEN o.Discount > 0 AND o.Discount <= 0.20 THEN 'Low Discount'
      WHEN o.Discount > 0.20 AND o.Discount <= 0.50 THEN 'Medium Discount'
      WHEN o.Discount > 0.50 THEN 'High Discount'
    END AS Discount_Class,
    COUNT(o.ORDER_ID) AS Number_of_Orders,
    ROUND(SUM(o.PROFIT),2) AS Total_Profit
  FROM orders o
  JOIN product p ON p.ID = o.PRODUCT_ID
  GROUP BY
    p.CATEGORY,
    CASE
      WHEN o.Discount = 0 THEN 'No Discount'
      WHEN o.Discount > 0 AND o.Discount <= 0.20 THEN 'Low Discount'
      WHEN o.Discount > 0.20 AND o.Discount <= 0.50 THEN 'Medium Discount'
      WHEN o.Discount > 0.50 THEN 'High Discount'
    END
)
SELECT CATEGORY, Discount_Class,
       SUM(Number_of_Orders) AS Number_of_Orders,
       SUM(Total_Profit) AS Total_Profit
FROM discount_level
GROUP BY CATEGORY, Discount_Class
ORDER BY CATEGORY, Discount_Class;

---------------------------------------------------------------------------------------------
-- Determine the top-performing product categories within each customer segment based on sales and profit, focusing specifically on those categories that rank within the top two for profitability. 
---------------------------------------------------------------------------------------------

WITH ranked_categories AS (
    SELECT 
        c.segment,
        p.category,
        SUM(o.sales) AS Sales,
        SUM(o.profit) AS Profit,
        ROW_NUMBER() OVER (PARTITION BY c.segment ORDER BY SUM(o.profit) DESC) AS Profit_Rank,
        ROW_NUMBER() OVER (PARTITION BY c.segment ORDER BY SUM(o.sales) DESC) AS Sales_Rank
    FROM orders AS o
    JOIN product AS p 
        ON o.product_id = p.id
    JOIN customer AS c 
        ON o.customer_id = c.id
    GROUP BY c.segment, p.category
)
SELECT 
    segment,
    category,
    Sales_Rank,
    Profit_Rank,
    ROUND(Sales,2) AS Sales,
    ROUND(Profit,2) AS Profit
FROM ranked_categories
WHERE Profit_Rank <= 2
ORDER BY segment, Profit_Rank, Sales_Rank;

---------------------------------------------------------------------------------------------
-- Creating a report that displays each employee's performance across different product categories, showing not only the total profit per category but also what percentage of their total profit each category represents, with the result ordered by the percentage in descending order for each employee.
---------------------------------------------------------------------------------------------

WITH employee_profit AS (
    SELECT 
        e.id_employee,
        e.name,
        p.category,
        SUM(o.profit) AS Profit
    FROM employee AS e
    JOIN orders AS o 
        ON e.id_employee = o.id_employee
    JOIN product AS p 
        ON o.product_id = p.id
    GROUP BY e.id_employee, e.name, p.category
)
SELECT 
    id_employee,
    category,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit) / SUM(SUM(Profit)) OVER (PARTITION BY id_employee) * 100, 2) AS Profit_Percentage
FROM employee_profit
GROUP BY id_employee, category
ORDER BY id_employee, Total_Profit DESC;


---------------------------------------------------------------------------------------------
-- Developing a user-defined function in SQL Server to calculate the profitability ratio for each product category an employee has sold, and then apply this function to generate a report that sorts each employee's product categories by their profitability ratio.
---------------------------------------------------------------------------------------------

CREATE OR ALTER FUNCTION dbo.profit_ratio (@Profit DECIMAL(18,2), @Sales DECIMAL(18,2))
RETURNS DECIMAL(10,4)
AS
BEGIN
  RETURN (CASE WHEN @Sales = 0 THEN 0 ELSE @Profit / @Sales END);
END;
GO

WITH report AS (
  SELECT
    e.ID_EMPLOYEE, e.NAME, p.CATEGORY,
    ROUND(SUM(o.PROFIT),2) AS Profit,
    ROUND(SUM(o.SALES),2)  AS Sales
  FROM employee e
  JOIN orders o   ON o.ID_EMPLOYEE = e.ID_EMPLOYEE
  JOIN product p  ON p.ID = o.PRODUCT_ID
  GROUP BY e.ID_EMPLOYEE, e.NAME, p.CATEGORY
)
SELECT
  ID_EMPLOYEE, CATEGORY,
  Sales AS Total_Sales, Profit AS Total_Profit,
  dbo.profit_ratio(Profit, Sales) AS Profitability_Ratio
FROM report
ORDER BY ID_EMPLOYEE, Profitability_Ratio DESC;


---------------------------------------------------------------------------------------------
-- Stored procedure to calculate the total sales and profit for a specific EMPLOYEE_ID over a specified date range. The procedure should accept EMPLOYEE_ID, StartDate, and EndDate as parameters.
---------------------------------------------------------------------------------------------

CREATE OR ALTER PROCEDURE dbo.GetEmployeeSalesProfit
    @EmployeeID TINYINT,
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    SELECT 
        e.name AS Employee_Name,
        ROUND(SUM(o.sales), 2) AS Total_Sales,
        ROUND(SUM(o.profit), 2) AS Total_Profit
    FROM orders AS o
    JOIN employee AS e 
        ON o.id_employee = e.id_employee
    WHERE o.id_employee = @EmployeeID
      AND o.order_date BETWEEN @StartDate AND @EndDate
    GROUP BY e.name;
END;
GO
EXEC GetEmployeeSalesProfit @EmployeeID=3, @StartDate = '2016-12-01',@EndDate = '2016-12-31';



---------------------------------------------------------------------------------------------
-- Query using dynamic SQL query to calculate the total profit for the last six quarters in the datasets, pivoted by quarter of the year, for each state.
---------------------------------------------------------------------------------------------

DECLARE @columns NVARCHAR(MAX);
DECLARE @sql NVARCHAR(MAX);

SELECT @columns = STRING_AGG(QUOTENAME(Quarter_Of_Year), ', ')
FROM (
    SELECT DISTINCT 
        CONCAT('Q', DATEPART(QUARTER, order_date), '-', DATEPART(YEAR, order_date)) AS Quarter_Of_Year
    FROM orders
    WHERE order_date >= DATEADD(QUARTER, -5, (SELECT MAX(order_date) FROM orders))
) AS q;

SET @sql = '
SELECT * 
FROM (
    SELECT 
        c.state,
        CONCAT(''Q'', DATEPART(QUARTER, o.order_date), ''-'', DATEPART(YEAR, o.order_date)) AS Quarter_Of_Year,
        ROUND(SUM(o.profit), 2) AS Profit
    FROM orders AS o
    JOIN customer AS c 
        ON o.customer_id = c.id
    GROUP BY c.state, CONCAT(''Q'', DATEPART(QUARTER, o.order_date), ''-'', DATEPART(YEAR, o.order_date))
) AS src
PIVOT (
    SUM(Profit) 
    FOR Quarter_Of_Year IN (' + @columns + ')
) AS p;';

EXEC sp_executesql @sql;
GO
		




