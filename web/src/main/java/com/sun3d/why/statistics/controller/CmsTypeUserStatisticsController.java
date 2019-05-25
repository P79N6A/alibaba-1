package com.sun3d.why.statistics.controller;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.*;
import com.sun3d.why.statistics.service.*;
import com.sun3d.why.util.*;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.concurrent.*;
/*
 * 活动明细表管理模块 activitySave 活动保存
 * 场馆明细表管理模块 venueSave 场馆保存
 * 藏品明细表管理模块 antiqueSave 藏品保存
 * 团体明细表管理模块 termUserSave 团体保存
 * 非遗明细表管理模块 cultureSave 非遗保存
 * @param operateType:操作类型 1.浏览次数 2.被赞次数 3.收藏次数4.分享次数
 */
@Controller
@RequestMapping(value = "/cmsTypeUser")
public class CmsTypeUserStatisticsController {
    private Logger logger = Logger.getLogger(CmsTypeUserStatisticsController.class);
    @Autowired
    private StatisticActivityUserService statisticActivityUserService;
    @Autowired
    private StatisticVenueUserService statisticVenueUserService;
    @Autowired
    private StatisticAntiqueUserService statisticAntiqueUserService;
    @Autowired
    private StatisticTermUserService statisticTermUserService;
    @Autowired
    private CmsTerminalUserService terminalUserService;
    @Autowired
    private StatisticCultureUserService statisticCultureUserService;
    @Autowired
    public CollectService collectService;
    @Autowired
    private HttpSession session;

    @RequestMapping(value = "/activitySave")
    @ResponseBody
    public String activityUserSave(HttpServletRequest request,String activityId,Integer operateType) throws ExecutionException,InterruptedException {
           CmsTerminalUser user = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
           //创建一个线程池
            ExecutorService pool = Executors.newFixedThreadPool(2);
            Callable activityCallable = new ActivityCallable(operateType, activityId, request, user,statisticActivityUserService,collectService,terminalUserService);
            //执行任务并获取Future对象
             Future f1 = pool.submit(activityCallable);
             // 关闭线程池
             pool.shutdown();
              //从Future对象上获取任务的返回值，并输出到控制台
             return f1.get().toString();
    }

    @RequestMapping(value = "/venueSave")
    @ResponseBody
    public String venueUserSave(HttpServletRequest request,String venueId,Integer operateType) throws ExecutionException,InterruptedException{
        CmsTerminalUser user= (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
        //创建一个线程池
        ExecutorService pool=Executors.newFixedThreadPool(2);
        Callable venueCallable=new VenueCallable(operateType,venueId,request,user,statisticVenueUserService,collectService,terminalUserService);
        //执行任务并获取future对象
        Future f1=pool.submit(venueCallable);
        //关闭线程池
        pool.shutdown();
        //从Future对象上获取任务的返回值，并输出到控制台
        return f1.get().toString();
    }

    @RequestMapping(value = "/antiqueSave")
    @ResponseBody
    public String antiqueUserSave(HttpServletRequest request,String antiqueId,Integer operateType) throws ExecutionException, InterruptedException {
        CmsTerminalUser user= (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
        //创建一个线程池
        ExecutorService pool=Executors.newFixedThreadPool(2);
        Callable antiqueCallable=new AntiqueCallable(operateType,antiqueId,request,user,statisticAntiqueUserService,collectService,terminalUserService);
        //执行任务并获取future对象
        Future f1=pool.submit(antiqueCallable);
        //关闭线程池
        pool.shutdown();
        //从Future对象上获取任务的返回值,并输出到控制台
        return f1.get().toString();
    }

    @RequestMapping(value = "/termUserSave")
    @ResponseBody
    public String termUserSave(HttpServletRequest request,String tuserId,Integer operateType) throws ExecutionException, InterruptedException {
        CmsTerminalUser user= (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
        //创建一个线程池
        ExecutorService pool=Executors.newFixedThreadPool(2);
        Callable tuserCallable=new TuserCallable(operateType,tuserId,request,user,statisticTermUserService,collectService,terminalUserService);
        //执行任务并获取future对象
        Future f1=pool.submit(tuserCallable);
        //关闭线程池
        pool.shutdown();
        //从Future对象上获取任务的返回值,并输出到控制台
        return f1.get().toString();
    }

/*
    public void addCollect(Integer operateType,String userId,String relateId,int type){
        CmsCollect cmsCollect = new CmsCollect();
        try {
            if(operateType!=null && operateType==3){
                cmsCollect.setUserId(userId);
                cmsCollect.setRelateId(relateId);
                cmsCollect.setType(type);
                collectService.insertSelective(cmsCollect);
            }
         } catch (Exception e) {
            logger.error("添加收藏数据时出错",e);
            e.printStackTrace();
        }
    }*/

    @RequestMapping("/cultureSave")
    @ResponseBody
    public String cultureSave(String id,HttpServletRequest request ,Integer operateType) throws Exception {
            CmsTerminalUser user= (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
            //创建一个线程池
            ExecutorService pool = Executors.newFixedThreadPool(2);
            Callable oneCallable = new CultureCallable(operateType,id,request,user,terminalUserService,statisticCultureUserService,collectService);
            //执行任务并获取Future对象
            Future f1 = pool.submit(oneCallable);
            // 关闭线程池
            pool.shutdown();
            return f1.get().toString();
    }
}
