use web_log;
DROP TABLE IF EXISTS access_log_tmp1;
CREATE TABLE access_log_tmp1 (
id BIGINT,
ip STRING,
ip_num BIGINT, -- ip对应的十进制数
ip_1 BIGINT, -- ip首位数字
access_time STRING, -- 访问时间
url STRING, -- 访问链接
status STRING, -- http状态码
traffic STRING, -- 流量
referer STRING, -- 来源
c_info STRING   -- 客户端信息
);

-- 使用正则表达式提取并向临时表插入数据
INSERT OVERWRITE TABLE access_log_tmp1 
SELECT
CAST(split(content, ' ')[0] AS BIGINT) AS id, 
split(content, ' ')[1] AS ip, 
cast(split(split(content, ' ')[1], '\\.')[0] as int) * 256 * 256 * 256 +
cast(split(split(content, ' ')[1], '\\.')[1] as int) * 256 * 256 +
cast(split(split(content, ' ')[1], '\\.')[2] as int) * 256 +
cast(split(split(content, ' ')[1], '\\.')[3] as int) AS ip_num,
cast(split(split(content, ' ')[1], '\\.')[0] as int) AS ip_1, 
regexp_extract(content,'(\\[.*\\])',1) AS access_time,
split(regexp_extract(content,'(".*?")',1)," ")[1] AS url, 
split(content,' ')[9] AS status, 
split(content,' ')[10] AS traffic, 
split(content,' ')[11] AS referer, 
regexp_extract(content,'\" (".*?")$',1) AS c_info 
FROM access_log_content;

-- 初始化IP表
DROP TABLE IF EXISTS cz_ip;
CREATE TABLE cz_ip (
ip_start BIGINT,  -- 起始ip对应的十进制
ip_start_1 STRING, -- 起始ip首位
ip_end BIGINT,  -- 结束ip对应的十进制
city STRING, -- 城市
isp STRING  -- 运营商
);

-- 使用正则表达式提取并向IP表插入数据
INSERT OVERWRITE TABLE cz_ip 
SELECT
CAST(split(split(content, '\\s+')[0],'\\.')[0] AS BIGINT) * 256 * 256 * 256 +
CAST(split(split(content, '\\s+')[0],'\\.')[1] AS BIGINT) * 256 * 256 +
CAST(split(split(content, '\\s+')[0],'\\.')[2] AS BIGINT) * 256 +
CAST(split(split(content, '\\s+')[0],'\\.')[3] AS BIGINT) AS ip_start, 
split(split(content, '\\s+')[0],'\\.')[0] AS ip_start_1, 
CAST(split(split(content, '\\s+')[1],'\\.')[0] AS BIGINT) * 256 * 256 * 256 +
CAST(split(split(content, '\\s+')[1],'\\.')[1] AS BIGINT) * 256 * 256 +
CAST(split(split(content, '\\s+')[1],'\\.')[2] AS BIGINT) * 256 +
CAST(split(split(content, '\\s+')[1],'\\.')[3] AS BIGINT) AS ip_end, 
split(content, '\\s+')[2] AS city, 
split(content, '\\s+')[3] AS isp
FROM ip_content;

-- 初始化临时表
DROP TABLE IF EXISTS access_log_tmp2;
CREATE TABLE access_log_tmp2 (
id BIGINT,
ip STRING,
city STRING,
isp STRING,
access_time STRING,
url STRING,
status STRING,
traffic STRING,
referer STRING,
c_info STRING
);

-- 从ip表中查询城市和运营商信息
INSERT OVERWRITE TABLE access_log_tmp2
SELECT a.id, a.ip, b.city, b.isp, a.access_time, a.url, a.status, a.traffic, 
a.referer, a.c_info
FROM access_log_tmp1 a JOIN
cz_ip b ON a.ip_1 = b.ip_start_1 AND a.ip_num >= b.ip_start AND a.ip_num <=
b.ip_end;

-- 初始化临时表
DROP TABLE IF EXISTS access_log_tmp3;
CREATE TABLE access_log_tmp3 (
id BIGINT,
ip STRING,
province STRING,
city STRING,
isp STRING,
access_time STRING,
url STRING,
status STRING,
traffic STRING,
referer STRING,
c_info STRING
);
-- 提取省信息使用正则表达式提取访问链接的实际地址并向临时表插入数据
INSERT OVERWRITE TABLE access_log_tmp3
SELECT id,ip,
CASE WHEN INSTR(city, '省') > 0 THEN SUBSTR(city,1,INSTR(city,'省')-1)
WHEN INSTR(city,'内蒙古') > 0 THEN '内蒙古'
WHEN INSTR(city,'西藏') > 0 THEN '西藏'
WHEN INSTR(city,'广西') > 0 THEN '广西'
WHEN INSTR(city,'宁夏') > 0 THEN '宁夏'
WHEN INSTR(city,'新疆') > 0 THEN '新疆'
WHEN INSTR(city,'北京') > 0 THEN '北京'
WHEN INSTR(city,'上海') > 0 THEN '上海'
WHEN INSTR(city,'天津') > 0 THEN '天津'
WHEN INSTR(city,'重庆') > 0 THEN '重庆'
WHEN INSTR(city,'香港') > 0 THEN '香港'
WHEN INSTR(city,'澳门') > 0 THEN '澳门'
ELSE city end
AS province, 
city,
isp,
access_time,
split(url,"\\?")[0] AS url
,status, traffic, referer, c_info
FROM access_log_tmp2;

-- 初始化临时表
DROP TABLE IF EXISTS access_log_tmp4;
CREATE TABLE access_log_tmp4 (
id BIGINT,
ip STRING,
province STRING,
city STRING,
isp STRING,
access_time STRING,
access_hour STRING,
url STRING,
status STRING,
traffic STRING,
referer STRING,
ref_type STRING,
c_info STRING
);
-- 使用正则表达式提取访问时间和来源分类并向临时表插入数据
INSERT OVERWRITE TABLE access_log_tmp4 
SELECT id, ip, province, city, isp,
regexp_extract(access_time,":(\\d.*) ",1) AS access_time,
regexp_extract(access_time,":(\\d+):",1) AS access_hour
, url, status, traffic, referer
, 
CASE WHEN
INSTR(referer, 'www.pdd.com') > 0 OR LENGTH(referer) < 5 THEN 'self'
WHEN INSTR(referer, 'www.google.com') > 0 THEN 'google'
WHEN INSTR(referer, 'www.baidu.com') > 0 THEN 'baidu'
WHEN INSTR(referer, 'www.bing.com') > 0 THEN 'bing'
WHEN INSTR(referer, 'www.so.com') > 0 THEN '360'
ELSE 'other'
END AS ref_type, c_info
FROM access_log_tmp3;

-- 初始化访问日志表
DROP TABLE IF EXISTS access_log;
CREATE TABLE access_log (
id BIGINT,
ip STRING,
province STRING,
city STRING,
isp STRING,
access_time STRING,
access_hour STRING,
url STRING,
status STRING,
traffic STRING,
referer STRING,
ref_type STRING,
c_info STRING,
client_type STRING,
client_browser STRING
);
-- 使用正则表达式提取客户端信息中的操作系统和浏览器信息并向表插入数据
INSERT OVERWRITE TABLE access_log
SELECT id, ip, province, city, isp, access_time, access_hour, url, status, 
traffic, referer, ref_type,c_info
,CASE
WHEN INSTR(c_info, 'iPhone;') > 0 THEN 'IOS'
WHEN INSTR(c_info, 'iPad;') > 0 THEN 'IOS'
WHEN INSTR(c_info, 'Mac OS X ') > 0 THEN 'OS X'
WHEN INSTR(c_info, 'X11;') > 0 THEN 'Linux'
WHEN INSTR(c_info, 'Android ') > 0 THEN 'Android'
WHEN INSTR(c_info, 'Windows NT ') > 0 THEN 'Windows'
ELSE 'other'
END AS client_type
,
CASE
WHEN INSTR(c_info, ' QQBrowser') > 0 THEN 'QQBrowser'
WHEN INSTR(c_info, ' UCBrowser') > 0 THEN 'UCBrowser'
WHEN INSTR(c_info, ' Edge') > 0 THEN 'Edge'
WHEN INSTR(c_info, ' LBBROWSER') > 0 THEN 'LBBROWSER'
WHEN INSTR(c_info, ' Maxthon') > 0 THEN 'Maxthon'
WHEN INSTR(c_info, ' Firefox') > 0 THEN 'Firefox'
WHEN INSTR(c_info, ' Chrome') > 0 THEN 'Chrome'
WHEN INSTR(c_info, ' Mac OS X') > 0
AND INSTR(c_info, ' Safari') > 0 THEN 'Safari'
WHEN INSTR(c_info, ' MSIE') > 0 THEN 'IE'
ELSE 'other'
END AS client_browser
FROM access_log_tmp4;

-- 初始化访问链接TopN表
DROP TABLE IF EXISTS access_log_url_top;
CREATE TABLE access_log_url_top (
url STRING,
times INT
);
INSERT OVERWRITE TABLE access_log_url_top 
SELECT top.url, top.times
FROM
(
 SELECT url, COUNT(*) AS times
 FROM access_log
 GROUP BY url
) top
ORDER BY top.times DESC LIMIT 10;

-- 初始化每个访客的第一个访问日志
DROP TABLE IF EXISTS access_log_first;
CREATE TABLE access_log_first (
id BIGINT,
ip STRING,
province STRING,
city STRING,
isp STRING,
access_time STRING,
access_hour STRING,
url STRING,
status STRING,
traffic STRING,
referer STRING,
ref_type STRING,
c_info STRING,
client_type STRING,
client_browser STRING
);

INSERT OVERWRITE TABLE access_log_first 
SELECT a.id, a.ip, a.province, a.city, a.isp, a.access_time, a.access_hour, 
a.url, a.status, a.traffic, a.referer, a.ref_type, a.c_info, a.client_type, 
a.client_browser
FROM access_log a
JOIN
(
SELECT c.ip, MIN(c.id) AS id
FROM access_log c
GROUP BY c.ip,c.c_info
) b 
ON a.ip = b.ip AND a.id = b.id;

-- 初始化访问IP黑名单表
DROP TABLE IF EXISTS access_log_ip_black;
CREATE TABLE access_log_ip_black (
ip STRING,
times INT
);
INSERT OVERWRITE TABLE access_log_ip_black 
SELECT ip, COUNT(1) AS times
FROM access_log WHERE status = '404'
GROUP BY ip
HAVING COUNT(*) > 10;
