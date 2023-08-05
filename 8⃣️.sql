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


-- LeetCode 180 Consecutive Numbers https://leetcode.com/problems/consecutive-numbers/description/
WITH ConsecutiveCountings
AS (SELECT id,
    num AS CurrNum,
    LAG(num) OVER (ORDER BY id) AS PrevNum,
    LEAD(num) OVER (ORDER BY id) AS NextNum
    FROM Logs)
SELECT DISTINCT CurrNum as ConsecutiveNums
FROM ConsecutiveCountings
WHERE CurrNum=PrevNum AND CurrNum=NextNum

-- CTE(Common Table Expression):  returns a temporary data set that can be used by another query.
  -- start from WITH clause before SELECT, UPDATE, INSERT, DELETE, CREATE, VIEW, OR MERGE. WITH can contain multiple CTEs, separated by commas.
  -- a temporary, which cannot store anywhere. Once executed, the query will be lost.
  -- make queries readable and helpful to recursive implementation
    -- Recursive CTE Syntax: the initial CTE is repeatedly executed, returning subsets of data, until the complete result is returned.
WITH RECURSIVE CTE_expression_name (ColumnNames)
AS(
  CTE_query_definition1 --anchor_member
  UNION ALL -- or we can use UNION, connect anchor & recursive member
  CTE_query_definition2 --recursive_member
) 
-- to view and use CTE results:
SELECT * FROM CTE_expression_name;
    -- usage of Recursive CTE: query hierarchical data or graphs. Eg: organizational structure, family tree, restaurant menu, or various routes between cities.
  -- Multiple CTE can be used for UNION, UNIONALL, JOIN, INTERSECT, EXCEPT
  -- But cannot use some keywords clauses, such as DISTINGUISH, GROUP BY, HAVE, JOIN
  -- CTE cannot be nested when using VIEW
  -- Non-recursive CTE Syntax:
WITH CTE_expression_name (ColumnName)
AS (CTE_query_definition)
  -- to view and use CTE results:
Select ColumnNames from CTE_expression_name

-- Positional Functions:
  -- LEAD: get value from row after the current row.
  -- LAG: get value from row before the current row.
  -- Syntax: 
  LEAD/LAG (expression [, offset[, default_value]]) OVER(PARTITION BY columnName ORDER BY columns) AS...
    -- OFFSET: optional, the number of rows “forward/backward” in the result set to look at. If omitted, default=1
    -- DEFAULT: optional, be default, it is NULL. If declared the value to be returned if the offset is outside the bounds of the table.
  -- cannot used with nested functions, and they can not used in WHERE clause

-- ❗️Window Function CheatSheet and Explanation: https://learnsql.com/blog/sql-window-functions-cheat-sheet/
