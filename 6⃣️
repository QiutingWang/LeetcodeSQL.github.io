--No.1683:Invalid Tweets
--count the length of string:LENGTH()

--when select a type from string variable,we use 'type'=...

--No.1543:Fix Product Name Format
date_format(date,format)
https://www.simplilearn.com/tutorials/sql-tutorial/sql-date-format
--大小写 of format in this function,inducing different results.


--No.2230:The Users That Are Eligible for Discount (✨Store Precedures✨)  https://www.w3schools.com/sql/sql_stored_procedures.asp
--A stored procedure is a prepared SQL code that you can save, so the code can be reused over and over again.
--Normal Usage Partern:Store+Execute
CREATE PROCEDURE procedure_name
AS
sql_statement
GO;

EXEC procedure_name;

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
Write an SQL query to report the IDs of the users that are eligible for a discount.
Return the result table ordered by user_id.

CREATE PROCEDURE getUserIDs(startDate DATE, endDate DATE, minAmount INT)
BEGIN
	--Write your MySQL query statement below.
	SELECT DISTINCT user_id 
    FROM Purchases 
    WHERE (time_stamp BETWEEN startDate AND endDate) AND amount >= minAmount 
    ORDER BY user_id;   
END


--No.1435:Create a Session Bar Chart
--logic:几个case when union叠加在一起
Table: Sessions
+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| session_id          | int     |
| duration            | int     |
+---------------------+---------+
session_id is the primary key for this table.
duration is the time in seconds that a user has visited the application.
You want to know how long a user visits your application. You decided to create bins of "[0-5>", "[5-10>", "[10-15>", and "15 minutes or more" and count the number of sessions on it.
Write an SQL query to report the (bin, total).

select "[0-5>" as bin,sum(case when duration/60 between 0 and 5 then 1 else 0 end)Total from sessions
union
select "[5-10>" ,sum(case when duration/60 between 5 and 10 then 1 else 0 end) from sessions
union
select "[10-15>",sum(case when duration/60 between 10 and 15 then 1 else 0 end) from sessions
union
select "15 or more" ,sum(case when duration/60 >15 then 1 else 0 end) from sessions
--return:{"headers": ["bin", "total"],
          "values": [["[0-5>", 3], 
                    ["[5-10>", 1], 
                    ["[10-15>", 0], 
                    ["15 or more", 1]]}

--No.1677: Product's Worth Over Invoices
--The COALESCE() function returns the first non-null value in a list.
SELECT COALESCE(NULL, NULL, NULL, 'W3Schools.com', NULL, 'Example.com');
--return: 'W3Schools.com'

