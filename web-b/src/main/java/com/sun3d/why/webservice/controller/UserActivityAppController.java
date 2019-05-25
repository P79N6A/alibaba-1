package com.sun3d.why.webservice.controller;
import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.dao.UserIntegralDetailMapper;
import com.sun3d.why.dao.UserIntegralMapper;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.UserIntegral;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.service.CmsActivityOrderService;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.service.ActivityAppOrderService;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletResponse;

import java.util.*;
/**
 * 手机app接口 用户活动列表
 * Created by Administrator on 2015/7/4
 */
@RequestMapping("/appUserActivity")
@Controller
public class UserActivityAppController {
    private Logger logger = Logger.getLogger(UserActivityAppController.class);
    @Autowired
    private CmsActivityOrderService cmsActivityOrderService;
    @Autowired
    private CmsTerminalUserService terminalUserService;
    @Autowired
    private ActivityAppOrderService activityOrderAppService;
    @Autowired
    private UserIntegralMapper userIntegralMapper;
    @Autowired
    private UserIntegralDetailMapper userIntegralDetailMapper;

    /**
     * app获取电子票订单信息
     * @param activityOrderId 活动订单id
     */
    @RequestMapping(value = "/electronicTicket")
    public String electronicTicket(HttpServletResponse response,String activityOrderId) throws Exception {
        String json="";
        try {
            if (StringUtils.isNotBlank(activityOrderId) && activityOrderId != null) {
                json=activityOrderAppService.queryAppELectronicTicketById(activityOrderId);
            } else {
                json = JSONResponse.commonResultFormat(11111, "活动订单id缺失", null);
            }
        } catch (Exception e) {
             json = JSONResponse.commonResultFormat(11112, "系统错误", null);
        }
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().print(json);
            response.getWriter().flush();
            response.getWriter().close();
            return null;
    }


    /**
     * app显示用户当前活动订单信息
     * @return json 10111:用户id不存在
     */
    @RequestMapping(value = "/userAppNowActivity")
    public String userAppCurrentActivity(PaginationApp pageApp,HttpServletResponse response,String pageIndex,String pageNum,String userId) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            if (StringUtils.isNotBlank(userId) && userId != null) {
                json=activityOrderAppService.queryAppCurrentOrdersByUserId(pageApp, userId);
            } else {
                json = JSONResponse.commonResultFormat(10111, "用户id缺失", null);
            }
        } catch (Exception e) {
            json = JSONResponse.commonResultFormat(101112, "系统错误", null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app获取用户以往活动订单信息
     * @param userId 用户id
     * @param pageIndex 首页下标
     * @param pageNum  显示条数
     * @return json 10111:用户id不存在
     */
    @RequestMapping(value = "/userAppOldActivity")
    public String userAppOldActivity(PaginationApp pageApp,HttpServletResponse response,String userId,String pageIndex,String pageNum) throws Exception {
        String json = "";
        try {
            if (StringUtils.isNotBlank(userId) && userId != null) {
                pageApp.setFirstResult(Integer.valueOf(pageIndex));
                pageApp.setRows(Integer.valueOf(pageNum));
                json=activityOrderAppService.queryAppPastOrdersByUserId(userId,pageApp);
            } else {
                json = JSONResponse.commonResultFormat(10111, "用户id缺失", null);
            }
        } catch (Exception e) {
            json = JSONResponse.commonResultFormat(101112, "系统错误", null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app取消用户活动
     * @ 在线选座 传 activityOrderId和 orderLine,自由入座 activityOrderId
     * @return json 10112:用户与活动订单id缺失   10111 用户不存在 0订单取消成功
     */
    @RequestMapping(value = "/removeAppActivity")
    public String removeAppActivity(HttpServletResponse response,String userId,String activityOrderId,String orderSeat) throws Exception {
        JSONObject jsonObject = new JSONObject();
        try {
            Map map = new HashMap();
            if (StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(activityOrderId)) {
                CmsTerminalUser terminalUser = terminalUserService.queryTerminalUserById(userId);
                if (terminalUser != null) {
                    map = cmsActivityOrderService.cancelUserOrder(activityOrderId, terminalUser,orderSeat,null);
                    if ("Y".equals(map.get("success"))) {
                        jsonObject.put("data", "订单取消成功!");
                        jsonObject.put("status", 0);
                    } else if ("N".equals(map.get("success"))) {
                        jsonObject.put("status", 1);
                        jsonObject.put("data", map.get("msg"));
                    }
                } else {
                    jsonObject.put("data", "用户不存在!");
                    jsonObject.put("status", 10111);
                }
            } else {
                jsonObject.put("data", "用户与活动订单id缺失!");
                jsonObject.put("status", 10112);
            }
        } catch (Exception e) {
            logger.debug("系统错误!");
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(jsonObject.toString());
        return null;
    }

    /**
     * app删除以往活动订单
     * @param userId 用户id
     * @param activityOrderId 活动订单id
     * @return json 0:删除以往活动订单成功 1.删除以往活动订单失败  11101 活动订单或用户id缺失  11112.系统错误
     */
    @RequestMapping(value = "/deleteAppUserActivityHistory")
    public String deleteAppUserActivityHistory(HttpServletResponse response,String userId,String activityOrderId) throws Exception {
        String json="";
        int count = 0 ;
        try {
            if(StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(activityOrderId)){
                  count=activityOrderAppService.deleteUserActivityHistory(activityOrderId,userId);
               if(count > 0 ){
                   json = JSONResponse.commonResultFormat(0, "删除以往活动订单成功!", null);
                } else {
                   json = JSONResponse.commonResultFormat(1, "删除以往活动订单失败!", null);
               }
            }else {
                json = JSONResponse.commonResultFormat(11101, "活动订单或用户id缺失", null);
            }
         } catch (Exception e) {
                json = JSONResponse.commonResultFormat(11112, "系统错误!", null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json.toString());
        return null;
    }
}