package com.bjpowernode.crm.web.filter;

import javax.servlet.*;
import java.io.IOException;

public class EncodingFilter implements Filter {

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {

        //处理post请求中文参数的问题
        req.setCharacterEncoding("UTF-8");

        //处理响应流响应中文的问题
        resp.setContentType("text/html;charset=utf-8");

        //将请求放行
        chain.doFilter(req,resp);

    }
}
