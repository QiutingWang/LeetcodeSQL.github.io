-- Active: 1691111812853@@127.0.0.1@3306
-- LeetCode177 Nth Highest Salary https://leetcode.com/problems/nth-highest-salary/description/
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
DECLARE M INT;
SET M=N-1;
  RETURN (
      SELECT DISTINCT salary 
      FROM Employee
      ORDER BY salary DESC
      LIMIT M,1
  );
END

-- DECLARE: store procedure variable
-- Syntax: DECLARE variableName variableType(defaultValue)
-- SET: 
-- can be combined with UPDATE or DECLARE, to assign values for variables, user-defined variables, or variables in procedures, or system variables


-- LeetCode1934 Confirmation Rate
SELECT Signups.user_id, IFNULL(ROUND(SUM(action='confirmed')/COUNT(*),2), 0.00) AS confirmation_rate
FROM Signups
LEFT JOIN Confirmations ON Signups.user_id=Confirmations.user_id
GROUP BY Signups.user_id

-- IFNULL:
-- return a specific value if the expression is NULL;
-- if the expression is not NULL, returns the expression calculation result
-- Syntax: IFNULL(expression, alt_value)

-- 区分NULLIF:
-- compares two expressions and return NULL if they are equal
-- Syntax: NULLIF(expression1, expression2)

-- ROUND:
-- Syntax: ROUND(number, decimals)
-- if the decimal omitted to declare, by default, it will return an integer
-- decimal notion: 写小数点后面的位数(eg: 1,2,3...)

-- JOINs:
-- LEFT JOIN vs RIGHT JOIN vs SELF JOIN vs FULL JOIN vs INNER JOIN: the results' ranges are different
-- the orders of multiple tables which will be joined are matter
-- SELF JOIN: syntax: 
SELECT column_name(s)
FROM table1 T1, table1 T2
WHERE condition
-- T1, T2: different table aliases for the same table.


-- LeetCode 178 Rank Scores https://leetcode.com/problems/rank-scores/
SELECT score, dense_rank() OVER (ORDER BY score DESC) AS 'rank'
FROM Scores
ORDER BY score DESC

-- Rankings:
--Syntax：
ROW_NUMBER()||DENSE_RANK()|| RANK()||NTILE(n)|| PERCENT_RANK() OVER ( --n:该row所在的ordered group number
    PARTITION BY <expression>,[{,<expression>}...] --we can omit PARTITION BY clause, 使各种用于每个分区
    ORDER BY <expression> [ASC|DESC],[{,<expression>}...] --划分ordered group的依据
    ) 
-- DENSE_RANK: 相同值相同排名
-- RANK：结果集分区中的每一行分配一个unique排名
-- NTILE: 将排序分区中的行划分为 特定数量 的组
-- PERCENT_RANK：计算结果行的百分位数排名
-- ROW_NUMBER: 从1开始应用的每一行分配一个序号。unique sequential number for each row in the specified field