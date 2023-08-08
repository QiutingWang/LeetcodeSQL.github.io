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

