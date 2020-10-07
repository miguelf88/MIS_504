-- 1. Show the CategoryName, CategoryDescription, and number of products in each category. You will have trouble grouping by CategoryDescription, because of its data type.

SELECT      Categories.CategoryName                         AS  [Category],
            CONVERT(NVARCHAR(MAX), Categories.Description)  AS  [Description], 
            COUNT(Products.ProductID)                       AS  [Count of Products]
FROM        Products
    JOIN    Categories  ON  Products.CategoryID = Categories.CategoryID
GROUP BY    Categories.CategoryName,
            Categories.CategoryID,
            CONVERT(NVARCHAR(MAX), Categories.Description)
ORDER BY    Categories.CategoryName,
            Categories.CategoryID,
            CONVERT(NVARCHAR(MAX), Categories.Description)

-- 2. We want to know the percentage of buffer stock we hold on every product. We want to see this as a percentage above/below the reorderLevel. 
--    Show the ProductID, productname, unitsInstock, reOrderLevel, and the percent above/below the reorderlevel. So if unitsInstock is 13 and the reorderLevel level is 10, 
--    the percent above/below would be 0.30. Make sure you convert at the appropriate times to ensure no rounding occurs. Check your work carefully.

SELECT      ProductID                                   AS  [ProductID],
            ProductName                                 AS  [Product Name],
            UnitsInStock                                AS  [Units in Stock],
            ReorderLevel                                As  [Reorder Level],
            (CAST(UnitsInStock AS FLOAT) - CAST(ReorderLevel AS FLOAT))
                / CAST(ReorderLevel AS FLOAT) * 100     AS  [Reorder Buffer Percent]
FROM        Products
WHERE       ReorderLevel != 0
ORDER BY    ProductID

-- 3. Show the orderID, orderdate, and total amount due for each order, including freight. Make sure that the amount due is a money data type and that there is no loss in accuracy as conversions happen. 
--    Do not do any unnecessary conversions. The trickiest part of this is the making sure that freight is NOT in the SUM.

SELECT      Orders.OrderID          AS  [OrderID],
            Orders.OrderDate        AS  [Order Date],
            CAST(
                SUM(
                [Order Details].UnitPrice
                * [Order Details].Quantity
                * (1 -[Order Details].Discount)
                )   AS  MONEY
            )                       AS  [Total Amount Due]
FROM        Orders
    JOIN    [Order Details] ON  Orders.OrderID = [Order Details].[OrderID]
GROUP BY    Orders.OrderID,
            Orders.OrderDate,
            Orders.CustomerID,
            [Order Details].ProductID
ORDER BY    [Total Amount Due] DESC

-- 4. Our company is located in Wilmington NC, the eastern time zone (UTC-5). We've been mostly local, but are now doing business in other time zones. Right now all of our dates in the orders
--    table are actually our server time, and the server is located in an Amazon data center outside San Francisco, in the pacific time zone (UTC-8). For only the orders we ship to France, 
--    show the orderID, customerID, orderdate in UTC-5, and the shipped date in UTC+1 (France's time zone.) You might find the TODATETIMEOFFSET() function helpful in this regard, and also the
--    SWITCHOFFSET() function.. Remember the implied time zone (EST) when you do this.

SELECT      OrderID                                                           AS  [OrderID],
            CustomerID                                                        AS  [CustomerID],
            OrderDate                                                         AS  [Order Date],
            TODATETIMEOFFSET(OrderDate, '-08:00')                             AS  [Server Time PST],
            SWITCHOFFSET(TODATETIMEOFFSET(OrderDate, '-08:00'), '-05:00')     AS  [Order Date EST],
            SWITCHOFFSET(TODATETIMEOFFSET(ShippedDate, '-08:00'), '+01:00')   AS  [Shipped Date CET]
FROM        Orders
WHERE       ShipCountry = 'France'
    AND     ShippedDate IS NOT NULL
ORDER BY    OrderID

-- 5. We are realizing that our data is taking up more space than necessary, which is making some of our regular data become "big data", in other words, difficult to deal with. In preparation 
--    for a data migration, we'd like to convert many of the fields in the Customers table to smaller data types. We anticipate having 1 million customers, and this conversion could save us up to 58MB 
--    on just this table. Do a SELECT statement that shows all fields in the table, in their original order, and rows ordered by customerID, with these fields converted:
        -- CustomerID converted to CHAR(5) - saves at least 5 bytes per record
        -- PostalCode converted to VARCHAR(10) - saves up to 5 bytes per record
        -- Phone converted to VARCHAR(24) - saves up to 24 bytes per record
        -- Fax converted to VARCHAR(24) - saves up to 24 bytes per record

SELECT      CONVERT(CHAR(5), CustomerID)            AS  [CustomerID],
            CompanyName                             AS  [Company Name],
            Contactname                             AS  [Contact Name],
            ContactTitle                            AS  [Contact Title],
            [Address]                               AS  [Address],
            City                                    AS  [City],
            Region                                  AS  [Region],
            CONVERT(VARCHAR(10), PostalCode)        AS  [PostalCode],
            Country                                 AS  [Country],
            CONVERT(VARCHAR(24), Phone)             AS  [Phone],
            CONVERT(VARCHAR(24), Fax)               AS  [Fax]    
FROM        Customers
ORDER BY    CustomerID

-- 6. Show a list of products, their unit price, and their ROW_NUMBER() based on price, ASC. Order the records by productname.

SELECT      ProductName                                         AS  [Product Name],
            UnitPrice                                           AS  [Unit Price],
            ROW_NUMBER()    OVER    (ORDER BY UnitPrice ASC)    AS  [Row Number]
FROM        Products    
ORDER BY    ProductName

-- 7. Do #6, but show the DENSE_RANK() based on price, ASC, rather than ROW_NUMBER().

SELECT      ProductName                                         AS  [Product Name],
            UnitPrice                                           AS  [Unit Price],
            DENSE_RANK()    OVER    (ORDER BY UnitPrice ASC)    AS  [Dense Rank]
FROM        Products    
ORDER BY    ProductName

-- 8. Show a list of products ranked by price into three categories based on price: 1, 2, 3. The highest 1/3 of the products will be marked with a 1, the second 1/3 as 2, the last 1/3 as 3. 
--    HINT: this is NTILE(3), order by unitprice DESC.

SELECT      ProductName                                     AS  [Product Name],
            UnitPrice                                       AS  [Unit Price],
            NTILE(3)    OVER    (ORDER BY   UnitPrice DESC) AS  [Tertile]
FROM        Products
ORDER BY    UnitPrice DESC

-- 9. Show a list of products from categories 1, 2, 7, 4 and 5. Show their RANK() based on value in inventory.

SELECT      ProductName                                                     AS  [Product Name],
            CategoryID                                                      AS  [CategoryID],
            UnitPrice * UnitsInStock                                        AS  [Value in Inventory],
            RANK()  OVER    (ORDER BY   (UnitPrice * UnitsInStock) DESC)    AS  [Rank]
FROM        Products
WHERE       CategoryID  IN  (1,2,4,5,7)
ORDER BY    [Rank]

-- 10 Show a list of orders, ranked based on freight cost, highest to lowest. Order the orders by the orderdate.

SELECT      OrderID                                     AS  [OrderID],
            OrderDate                                   AS  [Order Date],
            Freight                                     AS  [Freight Cost],
            RANK()  OVER    (ORDER BY   Freight DESC)   AS  [Rank]
FROM        Orders
ORDER BY    OrderDate
