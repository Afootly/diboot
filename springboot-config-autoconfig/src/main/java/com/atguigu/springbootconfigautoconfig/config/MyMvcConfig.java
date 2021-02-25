package com.atguigu.springbootconfigautoconfig.config;

import com.atguigu.springbootconfigautoconfig.component.LoginHandlerInterceptor;
import com.atguigu.springbootconfigautoconfig.component.MyLocaleresolver;
import org.springframework.boot.web.server.ConfigurableWebServerFactory;
import org.springframework.boot.web.server.WebServerFactory;
import org.springframework.boot.web.server.WebServerFactoryCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.PathMatchConfigurer;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
//使用WebMvcConfigurer来扩展springmvc 的功能
@Configuration
public class MyMvcConfig implements WebMvcConfigurer {

    @Override
    //防止重复提交表单
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/atguigu").setViewName("success");
        registry.addViewController("/main.html").setViewName("dashboard");

    }

    @Override
    public void configurePathMatch(PathMatchConfigurer configurer) {

    }
//   所有的 WebMvcConfigurer组件都会起作用
    @Bean //将组件注册在容器中
    public  WebMvcConfigurer webMvcConfigurer(){
            WebMvcConfigurer webMvcConfigurer=new WebMvcConfigurer() {
                @Override
                public void addViewControllers(ViewControllerRegistry registry) {
                    registry.addViewController("/").setViewName("login");
                    registry.addViewController("/index.html").setViewName("login");

                }
                @Override
                //注册拦截器

                public void addInterceptors(InterceptorRegistry registry) {
                    registry.addInterceptor(new LoginHandlerInterceptor()).addPathPatterns("/**")//addPathPatterns:拦截的请求
                            .excludePathPatterns("/index.html","/","/user/login","/asserts/**","/webjars/**","/static/**","/emp","/MyServlet");//excludePathPatterns:放行的请求


                }

            };
            return  webMvcConfigurer;

    }



    @Bean
    public LocaleResolver localeResolver(){
        return  new MyLocaleresolver();
    }
}
