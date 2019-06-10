package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.settings.service.impl.UserServiceImpl;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.PrintJson;
import com.bjpowernode.crm.utils.ServiceFactory;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.TranHistory;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.ClueService;
import com.bjpowernode.crm.workbench.service.CustomerService;
import com.bjpowernode.crm.workbench.service.TranService;
import com.bjpowernode.crm.workbench.service.impl.ActivityServiceImpl;
import com.bjpowernode.crm.workbench.service.impl.ClueServiceImpl;
import com.bjpowernode.crm.workbench.service.impl.CustomerServiceImpl;
import com.bjpowernode.crm.workbench.service.impl.TranServiceImpl;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Author: 动力节点
 * 2019/5/27
 */
public class TranController extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        System.out.println("进入到交易控制器");

        String path = request.getServletPath();

        if("/workbench/transaction/add.do".equals(path)){

            add(request,response);

        }else if("/workbench/transaction/getCustomerName.do".equals(path)){

            getCustomerName(request,response);

        }else if("/workbench/transaction/save.do".equals(path)){

            save(request,response);

        }else if("/workbench/transaction/detail.do".equals(path)){

            detail(request,response);

        }else if("/workbench/transaction/getHistoryList.do".equals(path)){

            getHistoryList(request,response);

        }else if("/workbench/transaction/changeStage.do".equals(path)){

            changeStage(request,response);

        }
    }

    private void changeStage(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("执行改变阶段的操作");

        String id = request.getParameter("id");
        String money = request.getParameter("money");
        String stage = request.getParameter("stage");
        String expectedDate = request.getParameter("expectedDate");
        String editTime = DateTimeUtil.getSysTime();
        String eidtBy = ((User)request.getSession().getAttribute("user")).getName();

        Tran t = new Tran();

        t.setId(id);
        t.setMoney(money);
        t.setStage(stage);
        t.setExpectedDate(expectedDate);
        t.setEditBy(eidtBy);
        t.setEditTime(editTime);

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());

        boolean flag = ts.changeStage(t);

        //取得阶段和可能性之间的对应关系
        Map<String,String> pMap = (Map<String,String>)this.getServletContext().getAttribute("pMap");
        //取得可能性
        String possibility = pMap.get(stage);
        t.setPossibility(possibility);

        /*

            将flag和t同时提供给前端
            vo
            map

         */

        Map<String,Object> map = new HashMap<String,Object>();
        map.put("success",flag);
        map.put("t",t);

        PrintJson.printJsonObj(response,map);




    }

    private void getHistoryList(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("根据交易id，取得交易历史列表");

        String tranId = request.getParameter("tranId");

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());

        List<TranHistory> thList = ts.getHistoryList(tranId);

        //取得阶段和可能性之间的对应关系
        Map<String,String> pMap = (Map<String,String>)this.getServletContext().getAttribute("pMap");

        //遍历每一条历史，通过阶段，取得可能性
        for(TranHistory th:thList){

            String stage = th.getStage();
            String possibility = pMap.get(stage);

            th.setPossibility(possibility);


        }

        PrintJson.printJsonObj(response,thList);

    }

    private void detail(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

        System.out.println("进入到 跳转到交易详细信息页 的操作");

        String id = request.getParameter("id");

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());

        Tran t = ts.detail(id);

        //处理可能性
        //取得阶段
        String stage = t.getStage();
        //取得阶段和可能性之间的对应关系
        Map<String,String> pMap = (Map<String,String>)this.getServletContext().getAttribute("pMap");
        //取得可能性
        String possibility = pMap.get(stage);

        t.setPossibility(possibility);

        request.setAttribute("t",t);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request,response);


    }

    private void save(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

        System.out.println("执行交易的添加操作");

        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String money = request.getParameter("money");
        String name = request.getParameter("name");
        String expectedDate = request.getParameter("expectedDate");
        String customerName = request.getParameter("customerName"); //待处理（要保存到表中的信息是客户id）
        String stage  = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String activityId = request.getParameter("activityId");
        String contactsId = request.getParameter("contactsId");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");

        Tran t = new Tran();
        t.setId(id);
        t.setContactSummary(contactSummary);
        t.setType(type);
        t.setMoney(money);
        t.setName(name);
        t.setExpectedDate(expectedDate);
        t.setStage(stage);
        t.setActivityId(activityId);
        t.setCreateBy(createBy);
        t.setCreateTime(createTime);
        t.setSource(source);
        t.setOwner(owner);
        t.setNextContactTime(nextContactTime);
        t.setDescription(description);
        t.setContactsId(contactsId);

        //以上为t对象封装了属性值，但是差一个customerId

        TranService ts = (TranService) ServiceFactory.getService(new TranServiceImpl());

        boolean flag = ts.save(t,customerName);

        if(flag){

            response.sendRedirect(request.getContextPath() + "/workbench/transaction/index.jsp");

        }


    }

    private void getCustomerName(HttpServletRequest request, HttpServletResponse response) {

        System.out.println("取得客户名称列表（根据客户名称进行模糊查询）");

        String name = request.getParameter("name");

        CustomerService cs = (CustomerService) ServiceFactory.getService(new CustomerServiceImpl());

        List<String> sList = cs.getCustomerName(name);

        PrintJson.printJsonObj(response,sList);


    }

    private void add(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

        System.out.println("进入到 跳转到交易添加页 的操作");

        //为了添加页上的所有者下拉框，我们需要取得用户信息列表

        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());

        List<User> uList = us.getUserList();

        request.setAttribute("uList",uList);
        request.getRequestDispatcher("/workbench/transaction/save.jsp").forward(request,response);


    }


}




























