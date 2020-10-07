
-- 1. Select the ProductName and ProductID. Order by ProductName.

SELECT      ProductName,
            ProductID
FROM        Products
ORDER BY    ProductName

-- 2. Select the ProductID and ProductName. Order by ProductName. (note that it is natural to order first by the left-most column)

SELECT      ProductID,
            ProductName
FROM        Products
ORDER BY    ProductName

-- 3. Select the ProductID, productname, and total value of inventory. The total value is found by multiplying the unitsInstock and unitprice. Name the new column [inventory value]. Order by inventory value descending.

SELECT      ProductID,
            ProductName,
            unitsInstock * unitprice AS [inventory value]
FROM        Products
ORDER BY    [inventory value] DESC

-- 4. Select the CategoryID, ProductID, productname and inventory value. Order first by CategoryID ascending, then by inventory value descending.

SELECT      CategoryID,
            ProductID,
            Productname,
            unitsInstock * unitprice AS [inventory value]
FROM        Products
ORDER BY    CategoryID ASC,
            [inventory value] DESC

-- 5. Select the ProductID, ProductName, and unitsInstock plus unitsOnOrder. Name this column [units available].

SELECT      ProductID,
            Productname,
            unitsInstock + unitsOnOrder AS [units available]
FROM        Products

-- 6. (Note, we're switching to the customer table....) Show the CustomerID and ContactName of all customers. Order by CustomerID. Rename the columns [ID] and [name].

SELECT      CustomerID  AS [ID],
            Contactname AS [name]
FROM        Customers
ORDER BY    CustomerID

-- 7. Show the CustomerID, ContactName, location of the space character in the contactname, and the length of the contactName. Use the CHARINDEX() and LEN() functions.

SELECT      CustomerID,
            Contactname,
            CHARINDEX(' ', Contactname) AS  [blankSpace],
            LEN(Contactname)            AS  [length]
FROM        Customers

-- 8. Show the CustomerID, ContactName, and the last name of the contact. Use code from 7 above, and the RIGHT() function.

SELECT      CustomerID,
            Contactname,
            RIGHT(Contactname,
                LEN(Contactname)
                - CHARINDEX(' ', Contactname)
                )   AS [lastName]
FROM        Customers

-- 9. Show the CustomerID, CompanyName, and the City and Country concatenated together with a comma, like this: Berlin, Germany. Use the plus sign. Order first by the Country, then by the City, then by the customerID.

SELECT      CustomerID,
            CompanyName,
            City + ', ' + Country
FROM        Customers
ORDER BY    Country,
            City,
            CustomerID

-- 10. Let's check to see if the CompanyNames are clean. Show the CustomerID and CompanyName of each customer. Also show the length in characters of the CompanyName. Also show the trimmed CompanyName (use the TRIM() function.) Also show the length of the trimmed CompanyName. If those two lengths are different, then CompanyName has some trailing spaces.

SELECT      CustomerID,
            CompanyName,
            LEN(CompanyName)    AS  [length],
            TRIM(CompanyName)   AS  [trimmedName],
            LEN(TRIM(CompanyName)) AS  [lengthOfTrimmedName],
            CASE
                WHEN LEN(CompanyName) = LEN(TRIM(CompanyName)) THEN 'Clean'
                ELSE 'Dirty'
            END AS [status]
FROM        Customers

-- 11. Show the CustomerID and the customerID converted to lower case (use LOWER()).

SELECT      CustomerID          AS  [CustomerID],
            LOWER(customerID)   AS  [customerID]
FROM Customers

-- 12. Show the CustomerID, and the contactname. We'd also like to see the customer name like this: first initial, one space, then the lastname, all in one column called [short name].

SELECT      CustomerID,
            contactname,
            LEFT(
                contactname, 1) + 
                ' ' +
                RIGHT(contactname,
                    LEN(contactname)
                    - CHARINDEX(' ', contactname)
                )   AS [short name] 
FROM        Customers

