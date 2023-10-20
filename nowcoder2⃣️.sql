-- Active: 1691111812853@@127.0.0.1@3306
-- SQL184 某宝店铺连续2天及以上购物的用户及其对应的天数
select user_id, count(*) as days_count
from (
    select *,
    row_number() over(partition by user_id
                      order by sales_date ASC) as rn 
    from sales_tb
) t
group by user_id, date_add(sales_date, interval-rn day) 
having days_count>1
order by user_id
-- dateadd: 用于将指定的时间间隔添加到日期值


-- SQL156  各个视频的平均完播率
select b.video_id as video_id, 
round(sum(if(TIMESTAMPDIFF(second, a.start_time, a.end_time)>=b.duration,1,0))/count(b.video_id),3) as avg_comp_play_rate
from tb_user_video_log a
left join tb_video_info b
on a.video_id=b.video_id
where year(a.start_time)=2021
group by video_id
order by avg_comp_play_rate desc
-- TIMESTAMPDIFF(unit, start, end)类似于DATEDIFF(unit, end, start);
-- 区别：❗️但是二者计算反向相反，很多时候在某些版本datediff只能求unit为day的差值


-- SQL157 平均播放进度大于60%的视频类别
-- 播放进度=播放时长÷视频时长*100%，当播放时长大于视频时长时，播放进度均记为100%。结果保留两位小数，并按播放进度倒序排序。
select b.tag as tag, 
concat(round(avg(
case when timestampdiff(second, a.start_time, a.end_time)<=b.duration
then timestampdiff(second, a.start_time, a.end_time)/b.duration
else 1 
end)*100, 2), '%') as avg_play_progress
from tb_video_info b 
right join tb_user_video_log a
on b.video_id=a.video_id
group by b.tag
having substring_index(avg_play_progress, '%', 1)>60
order by avg_play_progress desc
-- CONCAT连接2个及以上的字符，输入的order很重要
  -- format: CONCAT(str1, str2, ...)
-- substring_index(str, symbol, count),用于实现提取表单列表中的字符串
  -- symbol:分隔符
  -- 如果count>0，从左往右数 第k个分隔符左边的全部内容
  -- 如果count<0，从右往左数 第k个分隔符右边的全部内容
  -- 如果想要取中间的值，2次substring_index实现嵌套，一个count>0,另一个count<0。
    -- 即substring_index(substring_index(str, symbol, count), symbol, count);


-- SQL158 每类视频近一个月的转发量/率
-- 统计在有用户互动的最近一个月（按包含当天在内的近30天算，比如10月31日的近30天为10.2~10.31之间的数据）中，每类视频的转发量和转发率（保留3位小数).注：转发率＝转发量÷播放量。结果按转发率降序排序。
select b.tag as tag,
sum(a.if_retweet) as retweet_cnt,
round(sum(if_retweet)/count(*), 3) as retweet_rate
from tb_user_video_log a
left join tb_video_info b
on a.video_id=b.video_id
where datediff(date((select max(start_time) 
                     from tb_user_video_log)),
               date(a.start_time))<30
group by b.tag
order by retweet_rate desc


-- SQL160 国庆期间每类视频点赞量和转发量
-- 统计2021年国庆头3天每类视频每天的近一周总点赞量和一周内最大单天转发量，结果按视频类别降序、日期升序排序。假设数据库中数据足够多，至少每个类别下国庆头3天及之前一周的每天都有播放记录。
select *
from(
select tag,
date_format(start_time, '%Y-%m-%d') as dt,
sum(sum(if_like)) over(partition by tag order by date_format(start_time, '%Y-%m-%d') rows 6 preceding) as sum_like_cnt_7d,
max(sum(if_retweet)) over(partition by tag order by date_format(start_time, '%Y-%m-%d') rows 6 preceding) as max_retweet_cnt_7d --今天及前6天
from tb_user_video_log a
join tb_video_info b
on a.video_id=b.video_id
where date_format(start_time, '%Y-%m-%d') between '2021-09-25' and '2021-10-03'
group by tag, dt
) as t1
where t1.dt between '2021-10-01' and '2021-10-03'
order by tag desc, dt asc
-- <窗口函数> over (partition by <用于分组的列名> order by <用于排序的列名> frame_clause <窗口大小>)
  -- partition by和order by过程不改变原table的行数
  -- frame_clause:对分组进一步细分，可以用range或rows
    -- frame_end和frame_start的选择:
      -- rows current row: 当前行
      -- rows n preceding:当前行之前的n行
      -- rows n following:当前行之后的n行
      -- range n preceding: 等于当前行的值减去n的所有行
      -- range n following: 等于当前行的值加上n的所有行
      -- unbounded preceding: 分组中的第一行
      -- unbounded following: 分组中的最后一行
  -- 重要参考：https://blog.csdn.net/Txixi/article/details/115338572
