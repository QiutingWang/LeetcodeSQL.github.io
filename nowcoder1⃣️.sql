-- Active: 1691111812853@@127.0.0.1@3306
-- SQL164 2021年11月每天新用户的次日留存率
select a.dt, ifnull(round(count(distinct b.uid)/count(a.uid),2),0) as uv_left_rate
from (select uid, min(date(in_time)) dt 
      from tb_user_log
      group by uid) a 
left join (select uid, date(in_time) dt 
           from tb_user_log
           union
           select uid, date(out_time)
           from tb_user_log) b
on a.uid=b.uid and a.dt=date_sub(b.dt, interval 1 day)
where date_format(a.dt, '%Y-%m')='2021-11'
group by a.dt 
order by a.dt
-- date():提取日期或日期/时间表达式的日期部分
-- 次日留存率为当天新增的用户数中第二天又活跃了的用户数占比。
-- date_sub 用于从当前日期中减去指定的时间间隔. DATE_SUB(date, INTERVAL unit value)


-- SQL166 每天的日活数及新用户占比
select a.dt, count(distinct a.uid) as dau, round(count(distinct b.uid)/count(distinct a.uid),2) as uv_new_ratio
from (select uid, date(in_time) dt
      from tb_user_log
      union all --不去重，不排序
      select uid, date(out_time) dt 
      from tb_user_log
      group by uid, dt) a  --用于计算DAU
left join (select uid, min(date(in_time))dt 
           from tb_user_log
           group by uid) b   --以该用户最早的活跃日期判定是否是当天新增用户
on a.uid=b.uid and a.dt=b.dt
group by a.dt
order by a.dt
-- 新用户占比=当天的新用户数÷当天活跃用户数（日活数）


-- SQL162 2021年11月每天的人均浏览文章时长
select date(in_time) as dt, 
       round(sum(timestampdiff(second, in_time, out_time))/count(distinct uid),1) avg_lensec
from tb_user_log
where date_format(in_time, '%Y-%m')='2021-11' and artical_id != 0 -- 0表示用户在非文章内容页（比如App内的列表页、活动页等）
group by dt
order by avg_lensec asc
-- timestampdiff(interval, time_start, time_end)
  -- interval可以是second, minute, hour, day, month, year


-- SQL163 每篇文章同一时刻最大在看人数
select artical_id, max(current_max) as max_uv
from (select artical_id, 
             sum(diff) over(partition by artical_id -- 使用SUM窗口函数，sum也可以窗口函数，排序维度为文章id
                            order by dt ASC, diff DESC) current_max --对dt升序，对diff降序，生成瞬时观看最大值
      from(
        select artical_id, in_time dt, 1 diff -- 有人进入时，设置diff的值为1
        from tb_user_log
        where artical_id != 0
        union all
        select artical_id, out_time dt, -1 diff
        from tb_user_log
        where artical_id != 0
      ) t1
    ) t2
group by artical_id
order by max_uv desc
-- 如果同一时刻有进入也有离开时，先记录用户数增加再记录减少


-- SQL167 连续签到领金币
with a as( --筛选日期，文章id，签到与否
    select distinct uid, date(in_time) as dt
    from tb_user_log
    where date_format(in_time, '%Y%m%d') between '20210707' and '20211031'and artical_id=0 and sign_in=1
),
b as(
    select *, adddate(dt, interval-rank() over(partition by uid
                                               order by dt) day) as group_tag
    from a
),
c as( --建立签到得分规则
    select uid, date_format(dt, '%Y%m') as month,
    case rank() over(partition by uid, group_tag
                     order by dt)%7
    when 3 then 3
    when 0 then 7
    else 1
    end as score
    from b
)
select uid, month, sum(score) as coin 
from c
group by uid, month
order by month asc, uid asc
-- 使用多个CTE
-- dateadd: 用于将指定的时间间隔添加到日期值
ADDDATE(date,INTERVAL expression unit)
