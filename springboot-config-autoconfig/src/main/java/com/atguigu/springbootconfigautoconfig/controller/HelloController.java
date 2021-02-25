package com.atguigu.springbootconfigautoconfig.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Arrays;
import java.util.Map;

@Controller
public class HelloController {

//    @RequestMapping({"/","login.html"})
//    public String index(){
//        return "login";
//
//    }
@ResponseBody
    @RequestMapping("/hello")
    public String  hello(){
        return "hello spring boot";
    }
@RequestMapping("/seccess")
    public String   success(Map<String, Object> map){
    map.put("name","<h1>张三<h1/>");
    map.put("users",Arrays.asList("张三","李四","王五"));
        return  "success";
    }
}
