
-- 1. Select the ProductID, ProductName, and unitsInStock of all products that have fewer than 5 unitsInStock. Order products by productID.

SELECT      ProductID,
            ProductName,
            UnitsInStock
FROM        Products
WHERE       UnitsinStock < 5
ORDER BY    ProductID

-- 2. Select the ProductID, ProductName, and unitsInStock of all products that have unitprice greater than $8.00. Order by ProductID.

SELECT      ProductID,
            ProductName,
            UnitsInStock
FROM        Products
WHERE       UnitPrice > 8
ORDER BY    ProductID

-- 3. Select the Productname, unitprice, and total value in inventory of all products. Value in inventory is calculated by multiplying unitsInstock by unitprice. Order by productname.

SELECT      ProductName,
            UnitPrice,
            UnitsInStock * UnitPrice    AS  [Value in Inventory]
FROM        Products
ORDER BY    ProductName

-- 4. Select the Productname, categoryID and unitprice of all products that are in category 2 and cost less than $4. 

SELECT      ProductName,
            CategoryID,
            UnitPrice
FROM        Products
WHERE       CategoryID = 2
    AND     UnitPrice < 4

-- 5. Select the ProductName, categoryID, and unitprice of all products that are in category 7 and cost more than $8.

SELECT      ProductName,
            CategoryID,
            UnitPrice
FROM        Products
WHERE       CategoryID = 7
    AND     UnitPrice > 8

-- 6. Combine all the records from questions 4 and 5 into a single SELECT statement. Use parentheses, ANDs and ORs as necessary. 

SELECT      ProductName,
            CategoryID,
            UnitPrice
FROM        Products
WHERE       (CategoryID = 2
                AND UnitPrice < 4)
    OR      (CategoryID = 7
                AND UnitPrice > 8)


-- 7. Show all productnames and prices of products that are packaged in bottles. Do this by using the LIKE statement on the QuantityPerUnit field.

SELECT      ProductName,
            UnitPrice
FROM        Products
WHERE       QuantityPerUnit LIKE '%bottle%'

-- 8. Show all productnames that end in the word 'Lager'.

SELECT      ProductName
FROM        Products
WHERE       ProductName LIKE '%Lager'

-- 9. Show all products that are in one of these categories: 2, 4, 5, or 7. Use the IN clause. Show the name and unitprice of each product.

SELECT      ProductName,
            UnitPrice
FROM        Products
WHERE       CategoryID  IN  (2, 4, 5, 7)

-- 10. Select ProductID, ProductName, and SupplierID of all products that have the word "Ale" or "Lager" in the productname. Order by ProductID.

SELECT      ProductID,
            ProductName,
            SupplierID
FROM        Products
WHERE       ProductName LIKE    '% ale %'
    OR      ProductName LIKE    'ale %'
    OR      ProductName LIKE    '% ale'
    OR      ProductName LIKE    '% lager %'
    OR      ProductName LIKE    'lager %'
    OR      ProductName LIKE    '% lager'
ORDER BY    ProductID

-- 11. Select the productname, unitprice, and unitsInStock of all products whose units in stock are less than half of the reorder level. Order by units in stock ascending.

SELECT      ProductName,
            UnitPrice,
            UnitsInStock
FROM        Products
WHERE       UnitsInStock < ReorderLevel / 2
ORDER BY    UnitsInStock

-- 12. Select the productname of all products whose value in inventory is less than $200. Order by inventory value descending.

SELECT      ProductName
FROM        Products
WHERE       (UnitsInStock * UnitPrice) < 200
ORDER BY    (UnitsInStock * UnitPrice) DESC

-- 13. Select the Productname of any products whose value in inventory is more than $500 and is discontinued. Also show inventory value. Order by inventory value descending.

SELECT      ProductName,
            (UnitsInStock * UnitPrice)  AS  [inventory value]
FROM        Products
WHERE       (UnitsInStock * UnitPrice) > 500  
    AND     Discontinued = 1
ORDER BY    (UnitsInStock * UnitPrice) DESC

-- 14. Show all products that we need to reorder. These are the products that are not discontinued, and the unitsinstock plus unitsOnOrder is less than or equal to the reorderLevel.

SELECT      *
FROM        Products
WHERE       Discontinued = 0
    AND     (UnitsInStock + UnitsOnOrder) <= ReorderLevel

-- 15. Show the categoryID, productID, productname, and unitprice of all products. Order by categoryID, then unitprice descending, then productID.

SELECT      CategoryID,
            ProductID,
            ProductName,
            UnitPrice
FROM        Products
ORDER BY    CategoryID,
            UnitPrice DESC,
            ProductID