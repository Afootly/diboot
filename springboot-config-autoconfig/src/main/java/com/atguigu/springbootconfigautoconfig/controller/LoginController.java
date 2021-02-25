package com.atguigu.springbootconfigautoconfig.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.Map;

@Controller
public class LoginController {
    //@RequestMapping(value = "/user/login" ,method = RequestMethod.POST)
    //使用restful 风格的方式
    @PostMapping(value = "/user/login")
    public String login(@RequestParam("username") String usernaem, @RequestParam("password") String password , Map<String ,Object> map, HttpSession httpSession) {
        if ((usernaem != null && usernaem.length() > 0) && "1".equals(password)) { //推荐使用，效率高
            //防止表单重提交可以重定向到mian主页
            httpSession.setAttribute("LoginUser",usernaem);

            return "redirect:/main.html";
        } else {
            map.put("msg","用户名密码密码错误");
            return "login";
        }


    }
}
