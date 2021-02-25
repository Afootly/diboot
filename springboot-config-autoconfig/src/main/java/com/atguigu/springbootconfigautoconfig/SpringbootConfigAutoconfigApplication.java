package com.atguigu.springbootconfigautoconfig;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication//加载主配置类开启了自动配置功能
public class SpringbootConfigAutoconfigApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpringbootConfigAutoconfigApplication.class, args);
    }

}
