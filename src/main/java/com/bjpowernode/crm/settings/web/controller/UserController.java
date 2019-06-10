package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.settings.service.impl.UserServiceImpl;
import com.bjpowernode.crm.utils.MD5Util;
import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Author: 动力节点
 * 2019/5/27
 */
public class UserController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("进入到用户控制器");

        String path = request.getServletPath();

        if("/settings/user/login.do".equals(path)){

            login(request,response);

        }else if("/settings/user/xxx.do".equals(path)){

            //xxx(request,response);

        }

    }

    private void login(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行验证登录操作");

        //接收账号密码
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        //将密码转换为MD5加密后的密文形式
        loginPwd = MD5Util.getMD5(loginPwd);

        //取得浏览器端的ip地址
        /*

            如果你的请求路径，是使用localhost来代替的ip，那么通过以下方式取得的ip地址，默认是0:0:0:0...1(这不是我们想要的)

            所以我们需求去敲真实的ip地址，真实的ip或者127.0.0.1都能够代表本机的ip地址

         */

        String ip = request.getRemoteAddr();

        System.out.println("取得的ip地址："+ip);

        //创建的是代理类形态的业务层对象
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());

        try{

            User user = us.login(loginAct,loginPwd,ip);

            request.getSession().setAttribute("user", user);

            //如果程序成功的走到了该行，说明登录成功

            //{"success":true}
            PrintJson.printJsonFlag(response, true);

        }catch(Exception e){

            e.printStackTrace();

            //如果程序走了catch块，说明业务层为我们控制器抛出了异常，说明登录失败
            //{"success":false,"msg":?}

            //取得异常信息
            String msg = e.getMessage();

            Map<String,Object> map = new HashMap<String,Object>();
            map.put("success", false);
            map.put("msg", msg);

            PrintJson.printJsonObj(response, map);


        }



    }
}




























