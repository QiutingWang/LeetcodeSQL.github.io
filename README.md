# LeetcodeSQL Summarize #

- Ranking Problem: 排名函数必须有包含 ORDER BY 的 OVER 语句。
     - ROW_NUMBER()
           - Get a unique sequential number for each row in the specified data
           - By default, it sorts the data in ascending order and starts assigning ranks for each row.
           -`select ROW_NUMBER() OVER(order by column_name desc) as row_num
             from table_name`
     - RANK()
           - Specify rank for each row in the result set对查询出来的记录进行排名
           - `select RANK() OVER(order by column_name) as rank 
              from tablename`
           - Rank函数考虑到了over子句中排序字段值相同的情况
           - DENSE_RANK()
                - Specify a unique rank number within the partition as per the specified column value.
                - If we have duplicate values,SQL assigns different ranks to those rows as well.dense_rank函数在生成序号时是连续的,dense_rank函数出现相同排名时，将不跳过相同排名号
                - `select DENSE_RANK() OVER(order by column_name) as den_rank 
                   from tablename`
     - NTILE()
         - Distribute the number of rows in the specified (N) number of groups.Specify the value for the desired number of groups. 
         - `select NTILE(4) OVER(order by columnname desc) as ntile
            from tablename`
         - 对序号进行分组处理，将有序分区中的行分发到指定数目的组中
                  
- Consecutive Problems
     - LAG()
          - Access to a value stored in a different row above the current row.
          - `lead(expr, offset, default) Over(Order by columnname)` ,default values: offset = 1, default = NULL
          - `SELECT seller_name, sale_value,
             LAG(sale_value) OVER(ORDER BY sale_value) as previous_sale_value
             FROM sale;`
     - LEAD()
         - Accesses a value stored in a row below.
         - `SELECT seller_name, sale_value,
            LEAD(sale_value) OVER(ORDER BY sale_value) as next_sale_value
            FROM sale;`
         - We can also use lag and lead for comparing differences
             
- Datetime 
    - <https://www.sqlshack.com/sql-convert-date-functions-and-formats/>
    - `Datediff(string enddate,string startdate)` 日期比较函数：结束日期-开始日期
    - `Weekofyear(string date)` 日期转周数：得出日期在当前的周数
    - `Date_add(string startdate, int days)` & `Date_sub(string startdate, int days)` 得到开始日期后增加/减少的日期
    -  `year(string date)` 
       `month(string date)`
       `day(string date)` 
       `hour(string date)` 
       `minute(string date)`
       `second(string date)` 
       返回日期中的年/月/日/小时/秒
             
- Distribution Functions
    - percent_rank() over (order by columnname)
        - the percentile ranking number of a row—a value in [0, 1] interval: (rank-1) / (total number of rows - 1)
        - cume_dist() over (order by columnname)
        - the cumulative distribution of a value within a group of values
                  
- Logical Order in Operations
        - Select,From, Where, Group by, Having, Order By, Limit

- Convert data format
        - CAST
            - `CAST ( expression AS data_type [ ( length ) ] )`
        - Convert
            - `CONVERT ( data_type [ ( length ) ] , expression [ , style ] )`
                 
                             
