--No.2205 The Number of Users That Are Eligible for Discount🌟🆕
Table: Purchases
+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| user_id     | int      |
| time_stamp  | datetime |
| amount      | int      |
+-------------+----------+
(user_id, time_stamp) is the primary key for this table.
Each row contains information about the purchase time and the amount paid for the user with ID user_id.
A user is eligible for a discount if they had a purchase in the inclusive interval of time [startDate, endDate] with at least minAmount amount.
Write an SQL query to report the number of users that are eligible for a discount.

--create funtion:https://www.tutorialspoint.com/plsql/plsql_functions.htm encapsulate a piece of reusable logic
CREATE FUNCTION getUserIDs(startDate DATE, endDate DATE, minAmount INT) RETURNS INT
BEGIN
RETURN (
SELECT COUNT(DISTINCT user_id) AS user_cnt 
FROM Purchases 
WHERE amount >= minAmount AND (time_stamp BETWEEN startDate AND endDate));
END

--Normal Usage:
CREATE [OR REPLACE] FUNCTION function_name 
[(parameter_name [IN | OUT | IN OUT] type [, ...])] 
RETURN return_datatype 
{IS | AS} 
BEGIN 
   < function_body > 
END [function_name];


--No.1709:Biggest Window Between Visits
Table: UserVisits
+-------------+------+
| Column Name | Type |
+-------------+------+
| user_id     | int  |
| visit_date  | date |
+-------------+------+
This table does not have a primary key.
This table contains logs of the dates that users visited a certain retailer.
Assume today date is "2021-1-1".
Write an SQL query that will, for each user_id, find out the largest window of days between each visit and the one right after it (or today if you are considering the last visit).
Return the result table ordered by user_id.

SELECT user_id, MAX(diff) AS biggest_window
FROM
(SELECT user_id,
DATEDIFF(LEAD(visit_date, 1, '2021-01-01') OVER (PARTITION BY user_id ORDER BY visit_date), visit_date) AS diff
FROM userVisits) a
GROUP BY user_id
ORDER BY user_id

--LEAD:https://www.sqltutorial.org/sql-window-functions/sql-lead/
--Definiton:A window function that provides access to a row at a specified physical offset which follows the current row.
--Normal Usage:
LEAD(return_value [,offset[, default ]]) OVER (
    PARTITION BY expr1, expr2,...
	ORDER BY expr1 [ASC | DESC], expr2,...)
--from the current row, we can access data of the next row, or the second row that follows the current row
--be very useful for calculating the difference between the value of the current row and the value of the following row


--No.1667:Fix Names in a Table
Table: Users
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| user_id        | int     |
| name           | varchar |
+----------------+---------+
user_id is the primary key for this table.
This table contains the ID and the name of the user. The name consists of only lowercase and uppercase characters.
Write an SQL query to fix the names so that only the first character is uppercase and the rest are lowercase.
Return the result table ordered by user_id.

SELECT user_id, CONCAT(UPPER(LEFT(name, 1)), LOWER(SUBSTRING(name, 2))) AS name
FROM Users ORDER BY user_id;
--UPPER/LOWER改变大小写
--CONCAT:https://www.w3schools.com/sql/func_mysql_concat.asp  adds two or more expressions together
--normal usage:CONCAT(expression1, expression2, expression3,...)
