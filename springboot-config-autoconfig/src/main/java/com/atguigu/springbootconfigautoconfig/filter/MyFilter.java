package com.atguigu.springbootconfigautoconfig.filter;

import javax.servlet.*;
import javax.servlet.http.HttpFilter;
import java.io.IOException;

public class MyFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        System.out.println("MyFilter ");
        chain.doFilter(request,response);
    }

    @Override
    public void destroy() {

    }
}
