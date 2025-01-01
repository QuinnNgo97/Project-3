-- Create temp table to house SalesOrderDetail:
WITH cte AS (SELECT SalesOrderID, OrderDate, TerritoryID FROM sales.SalesOrderHeader
WHERE OrderDate BETWEEN '2012-05-30' AND '2014-05-30')

SELECT cte.*, s.ProductID, s.OrderQty, s.SpecialOfferID, s.UnitPrice, s.LineTotal INTO #TempSales
FROM Sales.SalesOrderDetail s

-- Inner join SalesOrderHeader
INNER JOIN 
cte ON cte.SalesOrderID = s.SalesOrderID;

SELECT * FROM #TempSales

-- Create temp table to house SalesTerritory:
SELECT TerritoryID, [Name], CountryRegionCode, [Group]
INTO #TempTerritory
FROM Sales.SalesTerritory;

-- Create temp table to house ProductInventory:
SELECT ProductID, Quantity
INTO #TempInventory
FROM Production.ProductInventory;

-- Create cte to house Product that are Salable Products: FinishedGoodsFlag = 1
WITH cte2 AS (SELECT ProductID, [Name], StandardCost, ListPrice, ProductSubcategoryID, ProductLine, Class, Style, [Size], SafetyStockLevel, Color, MakeFlag
FROM Production.Product tp
WHERE FinishedGoodsFlag = 1)

-- Add productcategoryname + productsubcategoryname and create a temp table to house Product info:
SELECT cte2.* , ps.Name AS SubCatName, ps.ProductCategoryID, pc.Name AS CatName INTO #TempProduct FROM cte2 
LEFT JOIN Production.ProductSubcategory AS ps
ON cte2.ProductSubcategoryID = ps.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS pc
ON ps.ProductCategoryID = pc.ProductCategoryID;

-- Drop CategoryID column:
ALTER TABLE #TempProduct DROP COLUMN ProductCategoryID;

-- Check temporary Product table:
SELECT * FROM #TempProduct

