package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.utils.UUIDUtil;
import com.bjpowernode.crm.workbench.dao.CustomerDao;
import com.bjpowernode.crm.workbench.dao.TranDao;
import com.bjpowernode.crm.workbench.dao.TranHistoryDao;
import com.bjpowernode.crm.workbench.domain.Customer;
import com.bjpowernode.crm.workbench.domain.Tran;
import com.bjpowernode.crm.workbench.domain.TranHistory;
import com.bjpowernode.crm.workbench.service.TranService;

import java.util.List;

public class TranServiceImpl implements TranService {

    private TranDao tranDao = SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao = SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
    private CustomerDao customerDao = SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);

    public boolean save(Tran t,String customerName) {

        boolean flag = true;

        /*

            通过客户名称customerName到客户表进行判断，需要精确匹配
            如果有此客户，将客户查询出来，取其id，为t对象中customerId赋值
            如果没有此客户，我们需要新建一个客户，将新建客户的id取出，为t对象中的customerId赋值

         */
        Customer cus = customerDao.getCustomerByName(customerName);
        if(cus==null){

            cus = new Customer();
            cus.setId(UUIDUtil.getUUID());
            cus.setOwner(t.getOwner());
            cus.setName(customerName);
            cus.setNextContactTime(t.getNextContactTime());
            cus.setCreateTime(DateTimeUtil.getSysTime());
            cus.setCreateBy(t.getCreateBy());

            //添加客户
            int count1 = customerDao.save(cus);
            if(count1!=1){
                flag = false;
            }

        }

        t.setCustomerId(cus.getId());
        //添加交易
        int count2 = tranDao.save(t);
        if(count2!=1){
            flag = false;
        }

        //创建交易历史对象
        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setTranId(t.getId());
        th.setStage(t.getStage());
        th.setMoney(t.getMoney());
        th.setExpectedDate(t.getExpectedDate());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setCreateBy(t.getCreateBy());
        //添加交易历史
        int count3 = tranHistoryDao.save(th);
        if(count3!=1){
            flag = false;
        }


        return flag;
    }

    public Tran detail(String id) {

        Tran t = tranDao.detail(id);

        return t;
    }

    public List<TranHistory> getHistoryList(String tranId) {

        List<TranHistory> thList = tranHistoryDao.getHistoryList(tranId);

        return thList;
    }

    public boolean changeStage(Tran t) {

        boolean flag = true;

        //修改交易（阶段）
        int count1 = tranDao.changeStage(t);
        if(count1!=1){

            flag = false;

        }

        TranHistory th = new TranHistory();
        th.setId(UUIDUtil.getUUID());
        th.setTranId(t.getId());
        th.setStage(t.getStage());
        th.setMoney(t.getMoney());
        th.setExpectedDate(t.getExpectedDate());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setCreateBy(t.getEditBy());
        //添加交易历史
        int count2 = tranHistoryDao.save(th);
        if(count2!=1){
            flag = false;
        }

        return flag;
    }
}






























