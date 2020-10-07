-- Project 1
-- Miguel Fernandez
-- no-table selects
-- 8/22/2020

-- 1. Show the number 337894 in a one-row, one-column table using SELECT.

SELECT 337894

-- 2. Show the word 'redundant' in a one-row, one column table using SELECT.

SELECT 'redundant'

-- 3. Show the number 88 in a one-row, one-column table using SELECT. The column should be named [Even Number].

SELECT 88 AS [Even Number]

-- 4. Show the 'Betty', 'Rubble', 'female', and 28 in a one-row, four-column table. The columns should be named [First], [Last], [gender], and [age].

SELECT 'Betty'  AS [First],
       'Rubble' AS [Last],
       'female' AS [gender],
       28       AS [age]

-- 5. Show the SQRT of 66784 using the SQRT() function. (documentation with examples (Links to an external site.))

SELECT SQRT(66784)

-- 6. Show the name 'Johnny D. Quest' in a single column. Do this by concatenating (plus sign) these things:'Johnny' 'D' '. ' 'Quest'. 

SELECT 'Johnny' + ' ' + 'D' + '. ' + 'Quest'

-- 7. Show the current server time in a column named [Current System Time]. Use the GETDATE() function.

SELECT GETDATE() AS [Current System Time]

-- 8. Show a 3-column, 1 row table that has 3378, "Betty", 36*27 in the columns. The columns should be named "number", "name", and "result".

SELECT 3378    AS [number],
       'Betty' AS [name],
       36 * 27 AS [result]

-- 9. Find the SQRT of 7867, and multiple it by the SQRT of 3872. Show the result in a one-row, one-column table where the column is called "calculation result". Use a single SELECT statement.

SELECT SQRT(7867) * SQRT(3872) AS [calculation result]

-- 10. Show the result of this calculation in a one-row, one-column table: ((897.0*13.0)+77.0)/4.0 . Name the column "calculation result".

SELECT ((897.0*13.0)+77.0)/4.0 AS [calculation result]