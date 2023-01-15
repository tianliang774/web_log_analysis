package com.chinahitech.demo.controller;

import com.chinahitech.demo.bean.User;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;


// /user/login

@RestController
@RequestMapping("/user")
@CrossOrigin
public class UserController {

    @PostMapping("/login")
    public Map login(@RequestBody User user){
        System.out.println(user.getUsername());
        System.out.println(user.getPassword());
//      查询数据库
        /*
            {
                code: 20000,
                data: {token: "xxxxxxxx"}
            }
         */
        Map<String,Object> map = new HashMap<>();
        map.put("code",20000);
        HashMap token = new HashMap<>();
        token.put("token","dasdwqe121sqwq");
        map.put("data",token);

        return map;
    }
    @GetMapping("/info")
    public Map info(String token){
        System.out.println(token);
//      验证token是否合法
//      查询用户信息
        /*
            {
                code:20000,
                data:{
                    name:"xxx",
                    avstar:"xxxxxx.png"
                }
            }

         */
        Map<String,Object> map = new HashMap<>();
        map.put("code",20000);
        Map data = new HashMap();
        data.put("name","张三");
        data.put("avatar","https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif");
        map.put("data",data);

        return map;
    }

}
