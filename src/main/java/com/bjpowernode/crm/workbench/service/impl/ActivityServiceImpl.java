package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.vo.PaginationVo;
import com.bjpowernode.crm.workbench.dao.ActivityDao;
import com.bjpowernode.crm.workbench.dao.ActivityRemarkDao;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;
import com.bjpowernode.crm.workbench.service.ActivityService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {

    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    public boolean save(Activity a) {

        boolean flag = true;

        int count = activityDao.save(a);

        if(count!=1){

            flag = false;

        }

        return flag;
    }

    public PaginationVo<Activity> pageList(Map<String, Object> map) {

        //取total
        int total = activityDao.getTotalByCondition(map);

        //取dataList
        List<Activity> dataList = activityDao.getActivityListByCondition(map);

        //创建一个PaginationVo对象
        PaginationVo<Activity> vo = new PaginationVo<Activity>();
        //将total和dataList封装到vo对象中
        vo.setTotal(total);
        vo.setDataList(dataList);


        //将vo返回到控制器
        return vo;
    }

    public boolean delete(String[] ids) {

        boolean flag = true;

        //删除市场活动关联的所有的备注
        //应该删除的备注的数量
        int count1 = activityRemarkDao.getTotalByAids(ids);

        //删除备注返回实际删除的数量
        int count2 = activityRemarkDao.deleteByAids(ids);

        if(count1!=count2){

            flag = false;

        }

        //删除市场活动
        int count3 = activityDao.delete(ids);
        if(count3!=ids.length){

            flag = false;

        }

        return flag;
    }

    public Map<String, Object> getUserListAndActivity(String id) {

        //取得uList
        List<User> uList = userDao.getUserList();


        //取得a
        Activity a = activityDao.getById(id);


        //创建一个map，将uList和a保存到map中
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("uList",uList);
        map.put("a",a);


        //返回map
        return map;
    }

    public boolean update(Activity a) {

        boolean flag = true;

        int count = activityDao.update(a);

        if(count!=1){

            flag = false;

        }

        return flag;
    }

    public Activity detail(String id) {

        Activity a = activityDao.detail(id);

        return a;
    }

    public List<ActivityRemark> getRemarkListByAid(String activityId) {

        List<ActivityRemark> arList = activityRemarkDao.getRemarkListByAid(activityId);

        return arList;
    }

    public boolean deleteRemark(String id) {

        boolean flag = true;

        int count = activityRemarkDao.deleteRemark(id);

        if(count!=1){

            flag = false;

        }

        return flag;
    }

    public boolean saveRemark(ActivityRemark ar) {

        boolean flag = true;

        int count = activityRemarkDao.saveRemark(ar);

        if(count!=1){
            flag =false;
        }

        return flag;
    }

    public boolean updateRemark(ActivityRemark ar) {
        boolean flag = true;

        int count = activityRemarkDao.updateRemark(ar);

        if(count!=1){
            flag =false;
        }

        return flag;
    }

    public List<Activity> getActivityListByClueId(String clueId) {

        List<Activity> aList = activityDao.getActivityListByClueId(clueId);

        return aList;
    }

    public List<Activity> getActivityListByNameAndNotByClueId(Map<String, String> map) {

        List<Activity> aList = activityDao.getActivityListByNameAndNotByClueId(map);

        return aList;
    }

    public List<Activity> getActivityListByName(String aname) {

        List<Activity> aList = activityDao.getActivityListByName(aname);

        return aList;
    }
}




























