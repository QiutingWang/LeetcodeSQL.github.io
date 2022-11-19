--No.1795:Rearrange Products Table
Table: Products
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| store1      | int     |
| store2      | int     |
| store3      | int     |
+-------------+---------+
product_id is the primary key for this table.
Each row in this table indicates the product's price in 3 different stores: store1, store2, and store3.
If the product is not available in a store, the price will be null in that store's column.
Write an SQL query to rearrange the Products table so that each row has (product_id, store, price). 
If a product is not available in a store, do not include a row with that product_id and store combination in the result table.

--Method1:Union three queries.逻辑清楚了这个方法不难...
SELECT product_id, 'store1' AS store, store1 AS price FROM Products WHERE store1 IS NOT NULL
UNION 
SELECT product_id, 'store2' AS store, store2 AS price FROM Products WHERE store2 IS NOT NULL
UNION 
SELECT product_id, 'store3' AS store, store3 AS price FROM Products WHERE store3 IS NOT NULL
ORDER BY 1,2 ASC

--Method2:Pivot & Unpivot https://www.geeksforgeeks.org/pivot-and-unpivot-in-sql/
--Definitions:
--transform one table into another in order to achieve more simpler view of table
--Pivot operator converts the rows data of the table into the column data.
--Unpivot operator does the opposite that is it transform the column based data into rows.
--Normal Usage:
SELECT (ColumnNames) 
FROM (TableName) 
PIVOT --or UNPIVOT
 ( 
   AggregateFunction(ColumnToBeAggregated)
   FOR PivotColumn IN (PivotColumnValues)
 ) AS (Alias) //Alias is a temporary name for a table

--Answer:
SELECT product_id,store,price
FROM Products
UNPIVOT
(   price
	FOR store in (store1,store2,store3)
) AS T


--No.1811:Find Interview Candidates (LAG function)
Table: Contests
+--------------+------+
| Column Name  | Type |
+--------------+------+
| contest_id   | int  |
| gold_medal   | int  |
| silver_medal | int  |
| bronze_medal | int  |
+--------------+------+
contest_id is the primary key for this table.
This table contains the LeetCode contest ID and the user IDs of the gold, silver, and bronze medalists.
It is guaranteed that any consecutive contests have consecutive IDs and that no ID is skipped.
 
Table: Users
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| mail        | varchar |
| name        | varchar |
+-------------+---------+
user_id is the primary key for this table.
This table contains information about the users.
Write an SQL query to report the name and the mail of all interview candidates. A user is an interview candidate if at least one of these two conditions is true:
The user won any medal in three or more consecutive contests. --连续性问题
The user won the gold medal in three or more different contests (not necessarily consecutive).

with cte as (select user_id,name,mail,contest_id,
                    user_id = gold_medal as gold,
                    user_id = silver_medal as silver,
                    user_id = bronze_medal as bronze,
                    lag(contest_id, 2) over (partition by user_id order by contest_id) as prevprev
            from Users
            left join Contests 
            on user_id = gold_medal or user_id = silver_medal or user_id = bronze_medal)
select name,mail
from cte
group by user_id
having sum(gold) >= 3 or sum(contest_id - prevprev = 2) >= 1

--LAG OVER: 
--Definition:Query more than one row in a table at a time without having to join the table to itself. It returns values from a previous row in the table. 
--To return a value from the next row, try using the LEAD function.
--Normal usage: https://www.sqlservertutorial.net/sql-server-window-functions/sql-server-lag-function/
LAG(return_value ,offset [,default])     --offset:从当前行返回的要从中访问数据的行数。default=1;can be an expression, subquery, or column that evaluates to a positive integer.
OVER ([PARTITION BY partition_expression, ... ]
      ORDER BY sort_expression [ASC | DESC], ...)
