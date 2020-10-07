-- 1. Find any products that have not appeared on an order, ever. (LEFT JOIN, WHERE IS NULL)

SELECT          Products.ProductID,
                Products.ProductName
FROM            Products
    LEFT JOIN   [Order Details] ON Products.ProductID = [Order Details].ProductID
WHERE           [Order Details].ProductID IS NULL
ORDER BY        Products.ProductID

-- -- 2. Find any products that have not appeared on an order in 1996. (subquery with NOT IN)

SELECT  Products.ProductID,
        Products.ProductName
FROM    Products
WHERE   Products.ProductID NOT IN (SELECT    [Order Details].ProductID
                                   FROM      [Order Details]
                                        JOIN    Orders  ON  [Order Details].OrderID = Orders.OrderID
                                   WHERE     YEAR(OrderDate) = 1996)

-- 3. Find any customers who have not placed an order, ever (similar to #1).

SELECT          Customers.CustomerID,
                Customers.CompanyName
FROM            Customers
    LEFT JOIN   Orders ON Customers.CustomerID = Orders.CustomerID
WHERE           Orders.CustomerID IS NULL
ORDER BY        Customers.CustomerID

-- 4. Find any customers that did not place an order in 1996 (similar to #2).

SELECT          Customers.CustomerID,
                Customers.CompanyName
FROM            Customers
WHERE           Customers.CustomerID NOT IN  (SELECT     Orders.CustomerID
                                              FROM       Orders
                                              WHERE      YEAR(OrderDate) = 1996)


-- 5. List all products that have been sold (any date). We need this to run fast, and we don't really want to see anything from the [order details] table, so use EXISTS.

SELECT ProductName
FROM   Products
WHERE  EXISTS 
         (SELECT *
          FROM   [Order Details]
          WHERE  [Order Details].ProductID = Products.ProductID)

-- 6. Give all details of all the above-average priced products. (simple subquery)

SELECT      *
FROM        Products
WHERE       Products.UnitPrice > (SELECT    AVG(Products.UnitPrice)
                                  FROM      Products)
ORDER BY    ProductID

-- 7. Find all orders where the ShipName has non-ASCII characters in it (trick: WHERE shipname <> CAST(ShipName AS VARCHAR).

SELECT      *
FROM        Orders
WHERE       Shipname <> CAST(ShipName AS VARCHAR)
ORDER BY    OrderID

-- 8. Show all Customers' CompanyName and region. Replace any NULL region with the word 'unknown'. Use the ISNULL() function. (Do a search on SQL ISNULL)

SELECT      CustomerID                  AS  [CustomerID],
            CompanyName                 AS  [Company Name],
            ISNULL(Region, 'unknown')   AS  [Region]
FROM        Customers
ORDER BY    CompanyName

-- 9. We need to know a list of customers (companyname) who paid more than $100 for freight on an order in 1996 (based on orderdate). Use the ANY operator to get this list.
-- (We are expecting this to have to run often on billions of records. This could be done much less efficiently with a JOIN and DISTINCT.)

SELECT   CompanyName
FROM     Customers
WHERE    $100 < ANY (SELECT  Freight
                     FROM    Orders
                     WHERE   Orders.CustomerID = Customers.CustomerID
                        AND  YEAR(Orderdate) = 1996)
ORDER BY CompanyName

-- 10. We want to know a list of customers (companyname) who paid more than $100 for freight on all of their orders in 1996 (based on orderdate). Use the ALL operator.
-- (We are expecting this to have to run often on billions of records. This could be done much less efficiently using COUNTs.)

SELECT   CompanyName
FROM     Customers
WHERE    $100 < ALL (SELECT  Freight
                     FROM    Orders
                     WHERE   Orders.CustomerID = Customers.CustomerID
                        AND  YEAR(Orderdate) = 1996)
ORDER BY CompanyName

-- 11. Darn! These unicode characters are messing up a downstream system. How bad is the problem? List all orders where the shipName has characters in it that are not upper case
-- letters A-Z or lower case letters a-z. Use LIKE to do this. (see the LIKE video, and use '%[^a-zA-Z]%'

SELECT      Orders.OrderID,
            Customers.CompanyName
FROM        Orders
    JOIN    Customers ON Orders.CustomerID = Orders.CustomerID
WHERE       Customers.CompanyName
    LIKE    '%[^a-zA-Z]%'
ORDER BY    Orders.OrderID
