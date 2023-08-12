-- Active: 1691111812853@@127.0.0.1@3306
-- LeetCode 1193 Monthly Transactions https://leetcode.com/problems/monthly-transactions-i/
SELECT  
DATE_FORMAT(trans_date, '%Y-%m') AS month,
country, 
COUNT(*) AS trans_count, 
COUNT(IF(state='approved', 1, NULL)) AS approved_count,
SUM(IF(state='approved', amount, 0)) AS approved_total_amount,
SUM(amount) AS trans_total_amount
FROM Transactions
GROUP BY month, country

-- Date function:
-- DATE_FORMAT(date, format)
  -- date: the date to be formatted
  -- format: https://www.w3schools.com/sql/func_mysql_date_format.asp
    -- %a: Sun to Sat
    -- %b: Jan to Dec
    -- %c: 0-12
    -- %d: 01-31
    -- %e: 0-31
    -- %H: 00 to 23
    -- %h: 00 to 12
    -- %m: 00-12
    -- %M: January to December
    -- %T: hh:mm:ss
    -- %Y: year, 4-digit value
-- Notes:表格headFeature输出的顺序一般不要和required output不同


-- LeetCode 550: Game Play Analysis4 https://leetcode.com/problems/game-play-analysis-iv/
-- Requirement: report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places
WITH firstTime AS(
    SELECT player_id, MIN(event_date) AS firstTime
    FROM Activity
    GROUP BY player_id
)
SELECT ROUND(SUM(
    CASE WHEN DATEDIFF(event_date, firstTime)=1 THEN 1
    ELSE 0 
    END)/COUNT(DISTINCT firstTime.player_id),2) AS fraction
FROM Activity
JOIN firstTime ON Activity.player_id=firstTime.player_id


-- SWAP类
-- LeetCode 627 swap by update
UPDATE Salary
SET sex= CASE sex
         WHEN 'm' THEN 'f'
         ELSE 'm'
         END
-- UPDATE: to modify the existing records in a table.(DML clause)
  -- other DML clause: DELETE, INSERT
-- syntax:
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE conditions --by using WHEN clause, we can only change selected rows, not the whole dataset


-- LeetCode 626 Swap every 2 consecutive students
SELECT (CASE WHEN MOD(id,2) != 0 AND counts!=id THEN id+1 --if it is odd-th id, but not the last one
             WHEN MOD(id,2) != 0 AND counts=id THEN id --if it is the last seat and odd-th id, fixed not change
             ELSE id-1 --for even-th id
        END) AS id,
        student
FROM Seat,
     (SELECT COUNT(*) AS counts
      FROM Seat) AS seat_counts
ORDER BY id ASC
-- MOD(value, divisor): same to `value%divisor`

-- Another method:
SELECT s1.id, COALESCE(s2.student, s1.student) AS student
FROM Seat s1
LEFT JOIN Seat s2 ON ((s1.id+1)^1)-1=s2.id
ORDER BY s1.id
-- COALESCE: return the first not NULL value
-- Syntax: COALESCE(val1, val2, ...., val_n)
-- ^ symbol: 正则表达式，在expression2范围之外的的字符;有时也是power of value
  -- Syntax: expression1^expression2


-- Other points: UNIQUE, PIVOT, CAST, CONVERT, EXTRACT, UNION ALL(allow duplicates), TRY_PARSE, TRY_CONVERT, TRY_CAST
