--No.585:Investment in 2016
--Exists:used to test for the existence of any record in a subquery;Returns TRUE if the subquery returns one or more records.https://www.w3schools.com/sql/sql_exists.asp
--Normal Usage:
SELECT column_name(s)
FROM table_name
WHERE EXISTS (SELECT column_name FROM table_name WHERE condition);


--No.1731:The Number of Employees Which Report to Each Employee
--self join
Table: Employees
+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| employee_id | int      |
| name        | varchar  |
| reports_to  | int      |
| age         | int      |
+-------------+----------+
employee_id is the primary key for this table.
This table contains information about the employees and the id of the manager they report to. Some employees do not report to anyone (reports_to is null). 
We will consider a manager an employee who has at least 1 other employee reporting to them.
Write an SQL query to report the ids and the names of all managers, the number of employees who report directly to them, and the average age of the reports rounded to the nearest integer.
Return the result table ordered by employee_id.

select mgr.employee_id, mgr.name, COUNT(emp.employee_id) as reports_count, ROUND(AVG(emp.age)) as average_age
from employees as emp 
join employees as mgr
on emp.reports_to = mgr.employee_id
group by employee_id
order by employee_id


--No.2159:Order Two Columns Independently分别排序
Table: Data
+-------------+------+
| Column Name | Type |
+-------------+------+
| first_col   | int  |
| second_col  | int  |
+-------------+------+
There is no primary key for this table and it may contain duplicates.
Write an SQL query to independently:
order first_col in ascending order.
order second_col in descending order.
--Row number over: assign a sequential integer to each row of a result set.A window function.
SELECT first_col, second_col
FROM (
    SELECT first_col, ROW_NUMBER() OVER(ORDER BY first_col ASC) AS r
    FROM Data) a
JOIN (SELECT second_col, ROW_NUMBER() OVER(ORDER BY second_col DESC) AS r
      FROM Data) b
ON a.r = b.r

--Normal usage:
ROW_NUMBER() OVER (
    [PARTITION BY partition_expression, ... ]
    ORDER BY sort_expression [ASC | DESC], ...)

