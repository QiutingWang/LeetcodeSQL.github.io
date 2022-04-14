--No.1607:
--NOT IN() 以及YEAR()   https://www.w3schools.com/sql/func_sqlserver_year.asp
SELECT YEAR('1998/05/25 09:08') AS Year;
--return:{"headers": ["Year"], "values": [[1998]]}


--No.580:count student number in department
--当需要用两个变量来排序：Return the result table ordered by student_number in descending order. In case of a tie, order them by dept_name alphabetically.
order by student_number desc,D.dept_name;


--No.1454:Active Users真的难🤯
Table1: Accounts
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| name          | varchar |
+---------------+---------+
id is the primary key for this table.
This table contains the account id and the user name of each account.

Table2: Logins
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| login_date    | date    |
+---------------+---------+
There is no primary key for this table, it may contain duplicates.
This table contains the account id of the user who logged in and the login date. A user may log in multiple times in the day.
Requirement:
Active users are those who logged in to their accounts for five or more consecutive days.
Write an SQL query to find the id and the name of active users.
Return the result table ordered by id.

WITH temp0 AS
(SELECT  id,login_date,DENSE RANK() OVER(PARTITION BY id ORDER BY login_date) AS row_num
FROM Logins),
temp1 AS 
(SELECT id, login_date, row_num,DATE_ADD(login_date, INTERVAL -row_num DAY) AS Groupings
FROM temp0),

answer_table AS (SELECT id,
         MIN(login_date) AS startDate,
         MAX(login_date) AS EndDate,
         row_num,
         Groupings, 
         COUNT(id),
         DATEDIFF(MAX(login_date), MIN(login_date)) AS duration
FROM temp1
GROUP BY id, Groupings
HAVING DATEIFF(MAX(login_date), MIN(login_date)) >= 4
ORDER BY id, StartDate)
 
SELECT DISTINCT a.id, name
FROM answer_table AS a
JOIN Accounts AS acc ON acc.id = a.id
ORDER BY a.id;

--CTE:https://www.sqlservertutorial.net/sql-server-basics/sql-server-cte/   common table expression
--usually with sql statement:SELECT, INSERT, UPDATE, DELETE, or MERGE, include previous cte statement
--Normal expression:
WITH expression_name[(column_name [,...])] AS (CTE_definition)
SQL_statement;

--DENSE RANK():https://www.sqltutorial.org/sql-window-functions/sql-dense_rank/
--a window function that assigns ranks to rows in partitions with no gaps in the ranking values.
--Different from the RANK() function, the DENSE_RANK() function always generates consecutive rank values.
--Example:
col.   dense_rank.    rank
A      1              1
B      2              2
B.     2              2
C      3              4
D      4              5
D      4              5
E      5              7

--normal usage:
DENSE_RANK() OVER (
	PARTITION BY expr1[{,expr2...}]
	ORDER BY expr1 [ASC|DESC], [{,expr2...}])

