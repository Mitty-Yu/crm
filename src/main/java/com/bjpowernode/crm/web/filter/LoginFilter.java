package com.bjpowernode.crm.web.filter;

import com.bjpowernode.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class LoginFilter implements Filter {

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {

        System.out.println("进入到验证是否已经登录过的过滤器");

        /*

            取得session对象
            从session对象中取得user对象

            判断user对象是否为null
                如果user对象不为null，说明已经登录过了，将请求放行即可
                如果user对象为null，说明没有登录过，重定向到登录页


         */

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;

        //取得访问路径
        String path = request.getServletPath();

        //如果用户访问的资源是登录页，以及验证登录操作，那么我们需要将请求自动放行
        if("/login.jsp".equals(path) || "/settings/user/login.do".equals(path)){


            chain.doFilter(req,resp);


        //其他资源我们需要去验证有没有登录过
        }else{

            User user = (User) request.getSession().getAttribute("user");

            //如果user不为null，说明登录过
            if(user!=null){

                chain.doFilter(req,resp);


                //如果user为null，说明没登录过
            }else{

                //重定向到登录页
            /*

                不论使用转发，还是使用重定向
                对于路径，一律使用绝对路径

                对于绝对路径传统写法：/项目名/具体的资源路径

                转发：
                    转发使用的是一种特殊的绝对路径，这种路径的前面是不加/项目名的，这种路径，也被称作为项目的内部路径
                    /login.jsp

                重定向：
                    重定向使用的是传统的绝对路径，前面必须加/项目名
                    /crm01/login.jsp

             */
            /*

                request.getContextPath():动态的取得当前项目的/项目名

             */
                response.sendRedirect(request.getContextPath()+"/login.jsp");

            }

        }






    }
}
