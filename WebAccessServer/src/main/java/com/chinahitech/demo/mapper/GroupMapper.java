package com.chinahitech.demo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.chinahitech.demo.bean.GroupBean;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface GroupMapper extends BaseMapper<GroupBean> {
    @Select("select ip as name,times as value from access_log_ip_black order by value")
    public List<GroupBean> selectIpBlackList();

    @Select("select url as name,times as value from access_log_url_top order by value limit 5")
    public List<GroupBean> selectAccessTopN();

    @Select("select access_hour as name,count(id) as value from access_log group by access_hour;")
    public List<GroupBean> selectAccessTime();

    @Select("select rt as name,count(rt) as value from (select case ref_type when 'other' then '其他链接' when 'self' then '直接访问' else '搜索引擎' end as rt from access_log) t group by rt;")
    public List<GroupBean> selectAccessSource();
    @Select("select client_browser as name,count(id) as value from access_log group by client_browser;")
    public List<GroupBean> selectBrowser();

    @Select("select ref_type as name,count(ref_type) as value\n" +
            "from access_log   group by ref_type having ref_type != 'self' and ref_type != 'other';")
    public List<GroupBean> selectSearch();

    @Select("select t.isp as name, count(t.isp) as value from\n" +
            "(\n" +
            "select \n" +
            "case when\n" +
            "INSTR(isp,\"移动\") > 0 then \"移动\"\n" +
            "when INSTR(isp,\"联通\") > 0 then \"联通\"\n" +
            "when INSTR(isp,\"电信\") > 0 then \"电信\"\n" +
            "else \"其他\"\n" +
            "end as isp\n" +
            "from access_log\n" +
            ") t group by t.isp order by value;")
    public List<GroupBean> selectCompany();

    @Select("select province as name,count(id) as value from access_log group by province;")
    public List<GroupBean> selectArea();
}
