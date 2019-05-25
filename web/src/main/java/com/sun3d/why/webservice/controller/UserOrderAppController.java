package com.sun3d.why.webservice.controller;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.webservice.service.UserOrderAppService;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.servlet.http.HttpServletResponse;
/**
 * 手机app接口 用户订单列表(活动与活动室)
 * Created by Administrator on 2016/2/17
 */
@RequestMapping("/appUserOrder")
@Controller
public class UserOrderAppController {
    private Logger logger = Logger.getLogger(UserOrderAppController.class);
    @Autowired
    private UserOrderAppService userOrderAppService;

    /**
     * app显示或搜索用户活动与活动室订单信息（当前与历史）
     * @param userId 用户id
     * @param orderValidateCode 取票码
     * @param venueName 展馆名称
     * @param activityName 活动名称
     * @param orderNumber 订单号
     * @return json 10111:用户id不存在
     */
    @RequestMapping(value = "/userOrders")
    public String userOrdersByCondition(PaginationApp pageApp,HttpServletResponse response,String pageIndex,String pageNum,String userId,String orderValidateCode,String venueName,String activityName,String orderNumber) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            if (StringUtils.isNotBlank(userId) ) {
                json=userOrderAppService.queryAppOrdersById(pageApp,userId,orderValidateCode,venueName,activityName,orderNumber);
            } else {
                json = JSONResponse.commonResultFormat(10111, "用户id缺失", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("query userOrdersByCondition error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * why3.5.2 app获取用户活动订单详情
     * @param userId 用户id
     * @param activityOrderId 订单ID
     */
    @RequestMapping(value = "/userActivityOrderDetail")
    public String userActivityOrderDetail(HttpServletResponse response,String userId,String activityOrderId) throws Exception {
        String json = "";
        try {
            if (StringUtils.isNotBlank(userId) ) {
                json=userOrderAppService.queryAppUserActivityOrderDetail(userId,activityOrderId);
            } else {
                json = JSONResponse.toAppResultFormat(400, "用户id缺失");
            }
        } catch (Exception e) {
            json = JSONResponse.toAppResultFormat(500, e.getMessage());
            logger.info("query userActivityOrderDetail error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * why3.5.2 app获取用户活动室订单详情
     * @param userId 用户id
     * @param activityOrderId 订单ID
     */
    @RequestMapping(value = "/userRoomOrderDetail")
    public String userRoomOrderDetail(HttpServletResponse response,String userId,String roomOrderId) throws Exception {
        String json = "";
        try {
            if (StringUtils.isNotBlank(userId) ) {
                json=userOrderAppService.queryAppUserRoomOrderDetail(userId,roomOrderId);
            } else {
                json = JSONResponse.toAppResultFormat(400, "用户id缺失");
            }
        } catch (Exception e) {
            json = JSONResponse.toAppResultFormat(500, e.getMessage());
            logger.info("query userActivityOrderDetail error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * why3.5 app显示或搜索用户活动与活动室订单信息（当前未过期订单）
     * @param userId 用户id
     * @return json 10111:用户id不存在
     */
    @RequestMapping(value = "/appUserOrder")
    public String appUserOrder(PaginationApp pageApp,HttpServletResponse response,String pageIndex,String pageNum,String userId) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            if (StringUtils.isNotBlank(userId) ) {
                json=userOrderAppService.queryAppUserOrderByUserId(pageApp, userId);
            } else {
                json = JSONResponse.commonResultFormat(10111, "用户id缺失", null);
            }
        } catch (Exception e) {
            json = JSONResponse.toAppResultFormat(10112, e.getMessage());
            logger.info("query userOrdersByCondition error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * why3.5 app显示或搜索用户活动与活动室历史订单信息（过期订单，即历史订单）
     * @param userId 用户id
     * @return json 10111:用户id不存在
     */
    @RequestMapping(value = "/appUserHistoryOrder")
    public String appUserHistoryOrderByUserId(PaginationApp pageApp,HttpServletResponse response,String pageIndex,String pageNum,String userId) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            if (StringUtils.isNotBlank(userId) ) {
                json=userOrderAppService.queryAppUserHistoryOrderByUserId(pageApp,userId);
            } else {
                json = JSONResponse.commonResultFormat(10111, "用户id缺失", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("query userOrdersByCondition error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * why3.5.2 app显示或搜索用户活动室待审核订单（当前未过期订单）
     * @param userId 用户id
     * @return json 10111:用户id不存在
     */
    @RequestMapping(value = "/appUserCheckOrder")
    public String appUserCheckOrder(PaginationApp pageApp,HttpServletResponse response,String pageIndex,String pageNum,String userId) throws Exception {
        String json = "";
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        try {
            if (StringUtils.isNotBlank(userId) ) {
                json=userOrderAppService.queryAppUserCheckOrderByUserId(pageApp,userId);
            } else {
                json = JSONResponse.commonResultFormat(10111, "用户id缺失", null);
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("query userOrdersByCondition error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
}