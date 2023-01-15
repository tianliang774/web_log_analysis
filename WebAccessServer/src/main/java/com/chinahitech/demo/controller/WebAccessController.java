package com.chinahitech.demo.controller;

import com.chinahitech.demo.bean.GroupBean;
import com.chinahitech.demo.mapper.GroupMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@CrossOrigin
@RequestMapping("/web")
public class WebAccessController {

    @Autowired
    private GroupMapper groupMapper;

    @GetMapping("ip")
    public List<GroupBean> ipBlack(){
        return groupMapper.selectIpBlackList();
    }
    @GetMapping("topN")
    public List<GroupBean> topN(){
        return groupMapper.selectAccessTopN();
    }
    @GetMapping("time")
    public List<GroupBean> time(){
        return groupMapper.selectAccessTime();
    }

//  访问来源
    @GetMapping("source")
    public List<GroupBean> source(){
        return groupMapper.selectAccessSource();
    }
//  浏览器占比
    @GetMapping("browser")
    public List<GroupBean> browser(){
        return groupMapper.selectBrowser();
    }

//  搜索引擎
    @GetMapping("search")
    public List<GroupBean> search(){
        return groupMapper.selectSearch();
    }

//  运营商
    @GetMapping("company")
    public List<GroupBean> company(){
        return groupMapper.selectCompany();
    }
    //  地域分布
    @GetMapping("area")
    public List<GroupBean> area(){
        return groupMapper.selectArea();
    }
}
