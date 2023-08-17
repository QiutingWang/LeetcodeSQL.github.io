-- Active: 1691111812853@@127.0.0.1@3306
-- Sub-queries Practice
-- LeetCode184 https://leetcode.com/problems/department-highest-salary/
SELECT D.name AS Department, E.name AS Employee, E.salary AS Salary
FROM Employee E
JOIN Department D ON E.departmentId=D.id
WHERE (E.departmentId, E.salary) IN (
    SELECT departmentId, MAX(salary)
    FROM Employee
    GROUP BY departmentId
)

-- Pivot Practice LeetCode1179 https://leetcode.com/problems/reformat-department-table/
SELECT id, 
Jan AS Jan_Revenue,
Feb AS Feb_Revenue,
Mar AS Mar_Revenue,
Apr AS Apr_Revenue,
May AS May_Revenue,
Jun AS Jun_Revenue,
Jul AS Jul_Revenue,
Aug AS Aug_Revenue,
Sep AS Sep_Revenue,
Oct AS Oct_Revenue,
Nov AS Nov_Revenue,
Dec AS Dec_Revenue

FROM (SELECT id, revenue, month 
      FROM Department) AS tmp
PIVOT(
    SUM(revenue)
    FOR month in (Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec)
) AS pvt

-- Another Method:
SELECT id,
SUM(CASE WHEN month='Jan' THEN revenue ELSE null END) AS Jan_Revenue,
SUM(CASE WHEN month='Feb' THEN revenue ELSE null END) AS Feb_Revenue,
SUM(CASE WHEN month='Mar' THEN revenue ELSE null END) AS Mar_Revenue,
SUM(CASE WHEN month='Apr' THEN revenue ELSE null END) AS Apr_Revenue,
SUM(CASE WHEN month='May' THEN revenue ELSE null END) AS May_Revenue,
SUM(CASE WHEN month='Jun' THEN revenue ELSE null END) AS Jun_Revenue,
SUM(CASE WHEN month='Jul' THEN revenue ELSE null END) AS Jul_Revenue,
SUM(CASE WHEN month='Aug' THEN revenue ELSE null END) AS Aug_Revenue,
SUM(CASE WHEN month='Sep' THEN revenue ELSE null END) AS Sep_Revenue,
SUM(CASE WHEN month='Oct' THEN revenue ELSE null END) AS Oct_Revenue,
SUM(CASE WHEN month='Nov' THEN revenue ELSE null END) AS Nov_Revenue,
SUM(CASE WHEN month='Dec' THEN revenue ELSE null END) AS Dec_Revenue
FROM Department
GROUP BY id
ORDER BY id

-- PIVOT: row→column
-- Syntax:
SELECT <non-pivoted column>,  
    [first pivoted column] AS <column name>,  
    [second pivoted column] AS <column name>,  
    ...  
    [last pivoted column] AS <column name>  
FROM  
    (<SELECT query that produces the data>)   
    AS <alias for the source query>  
PIVOT  
(<aggregation function>(<column being aggregated>)  
FOR   
[<column that contains the values that will become column headers>]   
    IN ([first pivoted columnName], [second pivoted columnName],  ... [last pivoted columnName])  
) AS <alias for the pivot table>  
<optional ORDER BY clause>;
-- UNPIVOT: column→row


-- CAST and CONVERT LeetCode262: https://leetcode.com/problems/trips-and-users/description/
SELECT Request_at AS Day,
       CAST(COUNT(DISTINCT CASE WHEN status!='completed' 
                           THEN Id 
                           ELSE NULL 
                           END)/CAST(COUNT(*) AS DECIMAL(10,2)) 
            AS DECIMAL(10,2))  AS "Cancellation Rate" 
FROM Trips t
LEFT JOIN Users client 
ON t.Client_Id = client.Users_Id
LEFT JOIN Users driver 
ON t.Driver_Id = driver.Users_Id
WHERE client.Banned = 'No'
AND driver.Banned = 'No'
AND Request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY Request_at;
-- CAST: converts a value (of any type) into a specified datatype.
CAST(expressionToConvert AS datatype(length))
-- datatype can be:bigint, int, smallint, tinyint, bit, decimal, numeric, money, smallmoney, float, real, datetime, smalldatetime, char, varchar, text, nchar, nvarchar, ntext, binary, varbinary, or image
-- DECIMAL: Syntax:
DECIMAL(precision, scale)
  -- pecision: the maximum number of digits, including both left and right side of decimal point
  -- scale: optional, specifies the number of digits after the decimal point
-- Another NUMERIC: 
NUMERIC(precision, scale)
  -- While in Oracle, it should be written as NUMBER(p,s). In other SQLs, NUMERIC=DECIMAL.
-- INSERT INTO Syntax:
INSERT INTO tableName VALUES (columnValue1, columnValue2...);


-- LeetCode 1321 https://leetcode.com/problems/restaurant-growth/description/
