--No.1050:count pairs
select actor_id, director_id 
from ActorDirector 
group by actor_id, director_id 
having count(actor_id + director_id) >= 3; --both group by and having should include this pair


--No.197:rising temperature:时间
Table: Weather
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the primary key for this table.
This table contains information about the temperature on a certain day.
Write an SQL query to find all dates Id with higher temperatures compared to its previous dates (yesterday).
--DateDiff:计算时间差 https://blog.csdn.net/Candy_Sir/article/details/85231400
select distinct w1.id
FROM Weather w1 INNER JOIN Weather w2 ON DATEDIFF(w1.recordDate, w2.recordDate) = 1
WHERE  w1.temperature > w2.temperature
--DATEDIFF(datepart , startdate , enddate):datepare值: year | quarter | month | week | day | hour | minute | second | millisecond; GetDate()：获取当前的系统日期
--to_days:给定的日期，返回一个天数(以0年以来的天数) http://www.hechaku.com/sqlfunction/SQL_TO_DAYS__hanshu.html
SELECT DISTINCT w1.id
FROM Weather w1 INNER JOIN Weather w2 ON TO_DAYS(w1.recordDate) = TO_DAYS(w2.recordDate) + 1
WHERE  w1.temperature > w2.temperature


--No.613:Shortest Distance in a Line
--abs()绝对值


--No.626:Exchange Seat
--Table: Seat
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
--id is the primary key column for this table.
--Write an SQL query to swap the seat id of every two consecutive students. If the number of students is odd, the id of the last student is not swapped.
--Return the result table ordered by id in ascending order.
--using CASE WHEN and MOD() method:https://www.w3schools.com/sql/func_mysql_mod.asp; MOD(x,y)| x MOD y | x%y -->x divid by y

SELECT (CASE
        WHEN id = (SELECT MAX(id) FROM seat) AND MOD(id, 2) = 1 THEN id
        WHEN MOD(id, 2) = 0 THEN id-1
        WHEN MOD(id, 2) = 1 THEN id+1
     END) AS id, student
FROM seat
ORDER BY id;


--No.1303:find the team size
--use window function:ROUND/COUNT() OVER (PARTITION BY() ) https://www.sqltutorial.org/sql-window-functions/sql-partition-by/

select employee_id, count(team_id) over(partition by team_id) as team_size
from Employee
group by employee_id;
--normal usage:
window_function ( expression ) OVER (
    PARTITION BY expression1, expression2, ...
    order_clause
    frame_clause
)
--The PARTITION BY clause divides the result set into partitions and changes how the window function is calculated.

