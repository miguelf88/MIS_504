-- 1. Show the Supplier companyname and the count of how many products we get from that supplier. Make sure to count the primary key of the products table. Order by companyname.

SELECT      Suppliers.CompanyName       AS  [Supplier Name],
            COUNT(Products.ProductID)   AS  [Number of Products]
FROM        Products
    JOIN    Suppliers   ON  Products.SupplierID = Suppliers.SupplierID
GROUP BY    Suppliers.CompanyName,
            Suppliers.SupplierID
ORDER BY    Suppliers.CompanyName,
            Suppliers.SupplierID

-- 2. Do number 1 again, but only include products that are not discontinued.

SELECT      Suppliers.CompanyName       AS  [Supplier Name],
            COUNT(Products.ProductID)   AS  [Number of Products]
FROM        Products
    JOIN    Suppliers   ON  Products.SupplierID = Suppliers.SupplierID
WHERE       Products.Discontinued = 0
GROUP BY    Suppliers.CompanyName,
            Suppliers.SupplierID
ORDER BY    Suppliers.CompanyName,
            Suppliers.SupplierID

-- 3. Show the Supplier companyname and the average unitprice of products from that supplier. Only include products that are not discontinued.

SELECT      Suppliers.CompanyName   AS  [Supplier Name],
            AVG(Products.UnitPrice) AS  [Average Price]
FROM        Products
    JOIN    Suppliers   ON  Products.SupplierID = Suppliers.SupplierID
WHERE       Products.Discontinued = 0
GROUP BY    Suppliers.CompanyName,
            Suppliers.SupplierID
ORDER BY    Suppliers.CompanyName,
            Suppliers.SupplierID

-- 4. Show the Supplier companyname and the total inventory value of all products from that supplier. This will involve the SUM() function with some calculations inside the functions.

SELECT      Suppliers.CompanyName   AS  [Supplier Name],
            SUM(
                Products.UnitPrice * Products.UnitsInStock
            )                       AS  [Total Inventory Value]
FROM        Products
    JOIN    Suppliers   ON  Products.SupplierID = Suppliers.SupplierID
GROUP BY    Suppliers.CompanyName,
            Suppliers.SupplierID
ORDER BY    Suppliers.CompanyName,
            Suppliers.SupplierID

-- 5. Show the Category name and a count of how many products are in each category.

SELECT      Categories.CategoryName     AS  [Category],
            COUNT(Products.ProductID)   AS  [Count of Products]
FROM        Products
    JOIN    Categories  ON  Products.CategoryID = Categories.CategoryID
GROUP BY    Categories.CategoryName,
            Categories.CategoryID
ORDER BY    Categories.CategoryName,
            Categories.CategoryID

-- 6. Show the Category name and a count of how many products in each category that are packaged in jars (have the word 'jars' in the QuantityPerUnit.)

SELECT      Categories.CategoryName     AS  [Category],
            COUNT(Products.ProductID)   AS  [Count of Products]
FROM        Products
    JOIN    Categories  ON  Products.CategoryID = Categories.CategoryID
WHERE       Products.QuantityPerUnit    LIKE    '% jars %'
    OR      Products.QuantityPerUnit    LIKE    'jars %'
    OR      Products.QuantityPerUnit    LIKE    '% jars'
GROUP BY    Categories.CategoryName,
            Categories.CategoryID
ORDER BY    Categories.CategoryName,
            Categories.CategoryID

-- 7. Show the Category name, and the minimum, average, and maximum price of products in each category.

SELECT      Categories.CategoryName     AS  [Category],
            MIN(Products.UnitPrice)     AS  [Minimum Price],
            AVG(Products.UnitPrice)     AS  [Average Price],
            MAX(Products.UnitPrice)     AS  [Maximum Price]
FROM        Products
    JOIN    Categories  ON  Products.CategoryID = Categories.CategoryID
GROUP BY    Categories.CategoryName,
            Categories.CategoryID
ORDER BY    Categories.CategoryName,
            Categories.CategoryID

-- 8. Show each order ID, its orderdate, the customer ID, and a count of how many items are on each order

SELECT      Orders.OrderID                  AS  [OrderID],
            Orders.OrderDate                AS  [Order Date],
            Orders.CustomerID               AS  [CustomerID],
            COUNT([Order Details].Quantity) AS  [Items in Order]
FROM        Orders
    JOIN    [Order Details] ON  Orders.OrderID = [Order Details].OrderID
GROUP BY    Orders.OrderID,
            Orders.OrderDate,
            Orders.CustomerID
ORDER BY    Orders.OrderID,
            Orders.OrderDate,
            Orders.CustomerID

-- 9. Show each productID, its productname, and a count of how many orders it has appeared on.

SELECT      Products.ProductID              AS  [ProductID],
            Products.ProductName            AS  [Product Name],
            COUNT([Order Details].OrderID)  AS  [Numer of Orders]
FROM        Products
    JOIN    [Order Details] ON  Products.ProductID = [Order Details].ProductID
GROUP BY    Products.ProductID,
            Products.ProductName
ORDER BY    Products.ProductID,
            Products.ProductName

-- 10. Do #9 again, but limit to only orders that were place in January of 1997.

SELECT      Products.ProductID              AS  [ProductID],
            Products.ProductName            AS  [Product Name],
            COUNT([Order Details].OrderID)  AS  [Numer of Orders]
FROM        Products
    JOIN    [Order Details] ON  Products.ProductID      = [Order Details].ProductID
    JOIN    Orders          ON  [Order Details].OrderID = Orders.OrderID
WHERE       MONTH(Orders.OrderDate) = 1
    AND     YEAR(Orders.OrderDate)  = 1997
GROUP BY    Products.ProductID,
            Products.ProductName
ORDER BY    Products.ProductID,
            Products.ProductName

-- 11. Show each OrderID, its orderdate, the customerID, and the total amount due, not including freight. Sum the amounts due from each product on the order.
-- The amount due is the quantity times the unitprice, times one minus the discount. Order by amount due, descending, so the biggest dollar amount due is at the top.

SELECT      Orders.OrderID          AS  [OrderID],
            Orders.OrderDate        AS  [Order Date],
            Orders.CustomerID       AS  [CustomerID],
            SUM(
                [Order Details].UnitPrice
                * [Order Details].Quantity
                * (1 -[Order Details].Discount)
            )                       AS  [Total Amount Due]
FROM        Orders
    JOIN    [Order Details] ON  Orders.OrderID = [Order Details].[OrderID]
GROUP BY    Orders.OrderID,
            Orders.OrderDate,
            Orders.CustomerID,
            [Order Details].ProductID
ORDER BY    [Total Amount Due] DESC

-- 12. We want to know, for the year 1997, the total revenues by category. Show the CategoryID, categoryname, and the total revenue from products in that category. This is very much like #11. Don't include freight.

SELECT      Categories.CategoryID       AS  [CategoryID],
            Categories.CategoryName     AS  [Category],
            SUM(
                [Order Details].UnitPrice
                * [Order Details].Quantity
                * (1 -[Order Details].Discount)
            )                           AS  [Total Revenue]
FROM        Products
    JOIN    Categories      ON  Products.CategoryID     = Categories.CategoryID
    JOIN    [Order Details] ON  Products.ProductID      = [Order Details].[ProductID]
    JOIN    Orders          ON  [Order Details].OrderID = Orders.OrderID
WHERE       YEAR(Orders.ShippedDate) = 1997
GROUP BY    Categories.CategoryID,
            Categories.CategoryName
ORDER BY    [Total Revenue] DESC

-- 13. We want to know, for the year 1997, total revenues by month. Show the month number, and the total revenue for that month. Don't include freight.

SELECT      MONTH(Orders.ShippedDate)   AS  [Month],
            SUM(
                [Order Details].UnitPrice
                * [Order Details].Quantity
                * (1 -[Order Details].Discount)
            )                           AS  [Total Revenue]
FROM        Orders
    JOIN    [Order Details] ON  Orders.OrderID = [Order Details].[OrderID]
WHERE       YEAR(Orders.ShippedDate) = 1997
GROUP BY    MONTH(Orders.ShippedDate)
ORDER BY    MONTH(Orders.ShippedDate)

-- 14. We want to know, for the year 1997, total revenues by employee. Show the EmployeeID, lastname, title, then their total revenues. Don't include freight. 

SELECT      Employees.EmployeeID        AS  [EmployeeID],
            Employees.LastName          AS  [Last Name],
            Employees.Title             AS  [Title],
            SUM(
                [Order Details].UnitPrice
                * [Order Details].Quantity
                * (1 -[Order Details].Discount)
            )                           AS [Total Revenue]
FROM        Orders
    JOIN    Employees       ON  Orders.EmployeeID = Employees.EmployeeID
    JOIN    [Order Details] ON  Orders.OrderID    = [Order Details].OrderID
WHERE       YEAR(Orders.OrderDate) = 1997
GROUP BY    Employees.EmployeeID,
            Employees.LastName,
            Employees.Title
ORDER BY    Employees.EmployeeID,
            Employees.LastName,
            Employees.Title,
            [Total Revenue] DESC

-- 15. We want to know, for the year 1997, a breakdown of revenues by month and category. Show the month number, the categoryname, and the total revenue for that month in that category. Order the records by month then category.

SELECT      MONTH(Orders.ShippedDate)   AS  [Month],
            Categories.CategoryName     AS  [Category],
            SUM(
                [Order Details].UnitPrice
                * [Order Details].Quantity
                * (1 -[Order Details].Discount)
            )                           AS  [Total Revenue]
FROM        Orders
    JOIN    [Order Details] ON  Orders.OrderID              = [Order Details].[OrderID]
    JOIN    Products        ON  [Order Details].ProductID   = Products.ProductID
    JOIN    Categories      ON  Products.CategoryID         = Categories.CategoryID
WHERE       YEAR(Orders.ShippedDate) = 1997
GROUP BY    MONTH(Orders.ShippedDate),
            Categories.CategoryName,
            Categories.CategoryID
ORDER BY    MONTH(Orders.ShippedDate),
            Categories.CategoryName,
            Categories.CategoryID
