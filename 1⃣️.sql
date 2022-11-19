--No.584:is null & !=/<>（不等于的两种表达）
select name
from Customer
where referee_id<>2 or referee_id IS NULL; --Another way for the last code:where ifnull(referee_id,0)<>2;


--No.596  Classes More Than 5 Students
select class
from Courses
group by class
having count(distinct student)>=5; --having的用法,count distinct;注意区分having和where的差别;
--HAVING:https://www.dofactory.com/sql/having
--requires that a GROUP BY clause is present;
--used with aggregrates: COUNT, MAX, SUM, etc;


--No.176:Second Highest Salary
--Employee
+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| salary      | int  |
+-------------+------+
--id is the primary key column for this table.
--Each row of this table contains information about the salary of an employee.
--Write an SQL query to report the second highest salary from the Employee table. If there is no second highest salary, the query should report null.
--Use rank() over method:
select max(salary) as SecondHighestSalary
from 
(select salary, 
rank() over (order by salary desc) as salary_rank
from Employee) ranked
where salary_rank = 2
--offset method: 去掉第几行的元素
SELECT
    (SELECT DISTINCT salary
     FROM Employee
     ORDER BY Salary DESC
     LIMIT 1 OFFSET 1) AS SecondHighestSalary;


--No.181
--Table: Employee
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| salary      | int     |
| managerId   | int     |
+-------------+---------+
id is the primary key column for this table.
Each row of this table indicates the ID of an employee, their name, salary, and the ID of their manager.
Write an SQL query to find the employees who earn more than their managers.
--Nested Query:
Select name as Employee 
from Employee e1 
where salary > (select salary 
                from Employee 
                where id=e1.managerId);


--No.196:Delete Duplicate Emails
--DELETE用法：similar to SELECT，删除某值，删重，删除所有行：https://blog.csdn.net/zcp528/article/details/107150165/


--No.597:Friend Request:Overall Acceptance Rate
--ROUND的用法：SELECT ROUND(column_name,decimals) FROM TABLE_NAME;
--IFNULL:IFNULL(expression, alt_value)-->if the expression is null,return the second alternative value
select
round(ifnull(
(select count(distinct requester_id, accepter_id) from RequestAccepted)
/
(select COUNT(distinct sender_id, send_to_id)
from FriendRequest),0.00),2) as accept_rate
--Another Way:
select ifnull(
round(
count(distinct requester_id,accepter_id)/count(distinct sender_id,send_to_id),2),0.00) 
as accept_rate
from friendrequest,requestaccepted --when the numbers come from two tables, we can put them into right order



