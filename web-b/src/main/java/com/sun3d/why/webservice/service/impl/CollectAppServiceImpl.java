package com.sun3d.why.webservice.service.impl;

import com.sun3d.why.dao.CmsCollectMapper;
import com.sun3d.why.statistics.service.StatisticActivityUserService;
import com.sun3d.why.statistics.service.StatisticVenueUserService;
import com.sun3d.why.util.*;
import com.sun3d.why.webservice.service.CollectAppService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

/**
 * 用户收藏活动与展馆
 */
@Service
@Transactional
public class CollectAppServiceImpl implements CollectAppService {
    @Autowired
    private CmsCollectMapper cmsCollectMapper;
    /**
     * app用户收藏活动
     * @param userId 用户id
     * @param activityId 活动id
     * @param request
     * @param statisticActivityUserService
     * @return
     */
    @Override
    public String addCollectActivity(String userId, String activityId, HttpServletRequest request, StatisticActivityUserService statisticActivityUserService)throws Exception {
        String json="";
        int flag = 0;
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("userId",userId);
        map.put("type",Constant.TYPE_ACTIVITY);
        map.put("relateId",activityId);
        //查询该用户是否已经收藏了这个活动
        int count=cmsCollectMapper.isHadCollect(map);
        if(count>0){
            json= JSONResponse.commonResultFormat(10122, "用户已收藏该活动", null);
        }
        else {
            //创建一个线程池
            ExecutorService pool = Executors.newFixedThreadPool(2);
            Callable activityStatisticCallable=new activityStatisticCallable(CommonUtil.getIpAddr(request),activityId,Constant.OPERATE_TYPE_COLLECT,userId,statisticActivityUserService);
            //执行任务并获取Future对象
            Future f1 = pool.submit(activityStatisticCallable);
            // 关闭线程池
            pool.shutdown();
            if(Integer.valueOf(f1.get().toString())==2){
                json=JSONResponse.commonResultFormat(10122,"用户已收藏该活动",null);
            }else if(Integer.valueOf(f1.get().toString())==1){
                flag=cmsCollectMapper.insertCollect(map);
                if(flag>0){
                    json=JSONResponse.commonResultFormat(0,"收藏成功",null);
                }else {
                    json=JSONResponse.commonResultFormat(1,"收藏失败",null);
                }
            }else {
                json=JSONResponse.commonResultFormat(10123,"查无此人",null);
            }
        }
        return  json;
    }

    /**
     * app删除用户收藏活动
     * @param userId
     * @param activityId
     * @param request
     * @param statisticActivityUserService
     * @return
     */
    @Override
    public String delCollectActivity(String userId, String activityId, HttpServletRequest request, StatisticActivityUserService statisticActivityUserService)throws Exception{
        String json="";
        int status=0;
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("userId",userId);
        map.put("type",Constant.TYPE_ACTIVITY);
        map.put("relateId",activityId);
        //查询该用户是否已经收藏了这个活动
        int count = cmsCollectMapper.isHadCollect(map);
        if(count>0){
            //创建一个线程池
            ExecutorService pool = Executors.newFixedThreadPool(2);
            Callable activityStatisticDelCallable=new activityStatisticDelCallable(activityId,Constant.OPERATE_TYPE_COLLECT,userId,statisticActivityUserService);
            //执行任务并获取Future对象
            Future f1 = pool.submit(activityStatisticDelCallable);
            // 关闭线程池
            pool.shutdown();
            if(Integer.valueOf(f1.get().toString())==2){
                json=JSONResponse.commonResultFormat(10122,"该用户未收藏此活动",null);
            } else  if(Integer.valueOf(f1.get().toString())==1){
                //删除用户收藏记录
             //   CmsCollect cmsCollect=new CmsCollect();
              //  cmsCollect.setUserId(userId);
               // cmsCollect.setRelateId(activityId);
              //  cmsCollect.setType(Constant.TYPE_ACTIVITY);
               // status=collectService.deleteCollectByCondition(cmsCollect);
                status=cmsCollectMapper.deleteUserCollectByCondition(map);
                if(status>0){
                    json=JSONResponse.commonResultFormat(0,"用户取消收藏成功",null);
                }else {
                    json=JSONResponse.commonResultFormat(1,"取消收藏失败",null);
                }
            }else {
                json=JSONResponse.commonResultFormat(1,"取消收藏失败",null);
            }
        } else{
            json=JSONResponse.commonResultFormat(10122,"该用户未收藏此活动",null);
        }
        return json;
    }

    /**
     * app用户收藏展馆
     * @param userId 用户id
     * @param venueId 展馆id
     * @param request
     * @param statisticVenueUserService 展馆用户统计对象
     * @return
     */
    @Override
    public String addCollectVenue(String userId, String venueId, HttpServletRequest request, StatisticVenueUserService statisticVenueUserService)throws Exception{
        int flag=0;
        String json="";
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("userId",userId);
        map.put("type",Constant.TYPE_VENUE);
        map.put("relateId",venueId);
        //查询该用户是否已经收藏展馆
        int count = cmsCollectMapper.isHadCollect(map);
        if (count > 0) {
            json = JSONResponse.commonResultFormat(10122, "用户已收藏该展馆", null);
        } else {
            //创建一个线程池
            ExecutorService pool = Executors.newFixedThreadPool(2);
            Callable venueStatisticCallable=new venueStatisticCallable(CommonUtil.getIpAddr(request),venueId,Constant.OPERATE_TYPE_COLLECT,userId,statisticVenueUserService);
            //执行任务并获取Future对象
            Future f1 = pool.submit(venueStatisticCallable);
            // 关闭线程池
            pool.shutdown();
            if(Integer.valueOf(f1.get().toString())==2){
                json = JSONResponse.commonResultFormat(10122, "用户已收藏该展馆", null);
            }else if(Integer.valueOf(f1.get().toString())==1){
                 flag=cmsCollectMapper.insertCollect(map);
                if (flag > 0) {
                    json = JSONResponse.commonResultFormat(0, "收藏展馆成功", null);
                } else {
                    json = JSONResponse.commonResultFormat(1, "收藏展馆失败", null);
                }
            }else {
                json = JSONResponse.commonResultFormat(10123,"查无此人", null);
            }
        }
              return json;
    }

    /**
     * app取消用户收藏展馆
     * @param userId 用户id
     * @param venueId 展馆id
     * @param request
     * @param statisticVenueUserService 展馆用户统计对象
     * @return
     */
    @Override
    public String delCollectVenue(String userId, String venueId, HttpServletRequest request, StatisticVenueUserService statisticVenueUserService) throws Exception{
        int status=0;
        String json="";
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("userId",userId);
        map.put("type",Constant.TYPE_VENUE);
        map.put("relateId",venueId);
        //查询该用户是否已经收藏了展馆
        int count = cmsCollectMapper.isHadCollect(map);
        if(count>0){
            //创建一个线程池
            ExecutorService pool = Executors.newFixedThreadPool(2);
            Callable venueStatisticDelCallable=new venueStatisticDelCallable(venueId,Constant.OPERATE_TYPE_COLLECT,userId,statisticVenueUserService);
            //执行任务并获取Future对象
            Future f1 = pool.submit(venueStatisticDelCallable);
            // 关闭线程池
            pool.shutdown();
            if (Integer.valueOf(f1.get().toString())==2){
                json=JSONResponse.commonResultFormat(10122,"该用户未收藏此展馆!",null);
            }
            else  if(Integer.valueOf(f1.get().toString())==1){
              //  CmsCollect cmsCollect=new CmsCollect();
              //  cmsCollect.setUserId(userId);
              //  cmsCollect.setRelateId(venueId);
             //   cmsCollect.setType(Constant.TYPE_VENUE);
              //  status=collectService.deleteCollectByCondition(cmsCollect);
                status=cmsCollectMapper.deleteUserCollectByCondition(map);
                if(status>0){
                    json=JSONResponse.commonResultFormat(0,"取消展馆收藏成功!",null);
                }else {
                    json=JSONResponse.commonResultFormat(1,"取消展馆收藏失败!",null);
                }
            }else {
                json=JSONResponse.commonResultFormat(1,"取消展馆收藏失败!",null);
            }
        }else{
            json=JSONResponse.commonResultFormat(10122,"该用户未收藏此展馆!",null);
        }
        return json;
    }


}
