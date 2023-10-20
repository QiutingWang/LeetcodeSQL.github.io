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

