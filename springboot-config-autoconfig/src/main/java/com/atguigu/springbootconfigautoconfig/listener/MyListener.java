package com.atguigu.springbootconfigautoconfig.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class MyListener implements ServletContextListener {
    @Override
    //监听web服务器启动
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("应用启动了");
    }

    @Override
    //监听web服务期关闭
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("应用结束了");

    }
}
