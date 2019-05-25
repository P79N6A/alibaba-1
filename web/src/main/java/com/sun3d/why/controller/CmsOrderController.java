package com.sun3d.why.controller;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.*;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.ExportExcel;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.webservice.service.ActivityAppOrderService;
import com.sun3d.why.webservice.service.UserMessageAppService;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2015/7/1.
 */

@RequestMapping("/order")
@Controller
public class CmsOrderController {

    /**
     * 导入log4j日志管理，记录错误信息
     */
    private Logger logger = Logger.getLogger(CmsOrderController.class);

    @Autowired
    private HttpSession session;

    @Autowired
    private CmsActivityOrderService cmsActivityOrderService;

    @Autowired
    private CmsOrderService cmsOrderService;

    @Autowired
    private CmsActivityService activityService;

    @Autowired
    private CmsActivitySeatService cmsActivitySeatService;
    
    @Autowired
    private ActivityAppOrderService activityOrderAppService;

    @Autowired
    private ExportExcel exportExcel;


    /**
     * 后台活动列表
     *
     * @param activity
     * @param page
     * @return
     */
    @RequestMapping("/queryAllUserOrderIndex")
    public ModelAndView queryAllUserOrderIndex(CmsActivity activity, String searchKey, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser user = (SysUser) session.getAttribute("user");
            if (user != null) {
                List<CmsActivity> activityList = cmsOrderService.queryCmsOrderByCondition(activity, page, user);
                model.addObject("activityList", activityList);
                model.addObject("page", page);
                model.addObject("activity", activity);
                model.addObject("searchKey", searchKey);
                model.setViewName("admin/activity/orderIndex");
            }
        } catch (Exception e) {
            logger.info("queryAllUserOrderIndex error" + e);
        }
        return model;
    }
    /**
     * 后台活动列表
     *
     * @param activity
     * @param page
     * @return
     */
    @RequestMapping("/queryAllTerminalUserOrderIndex")
    public ModelAndView queryAllTerminalUserOrderIndex(CmsActivity activity, String searchKey, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser user = (SysUser) session.getAttribute("user");
            if (user != null) {
                List<CmsActivity> activityList = cmsOrderService.queryCmsTerminalOrderByCondition(activity, page, user);
                model.addObject("activityList", activityList);
                model.addObject("page", page);
                model.addObject("activity", activity);
                model.addObject("searchKey", searchKey);
                model.setViewName("admin/activity/TerminalUserOrderIndex");
            }
        } catch (Exception e) {
            logger.info("queryAllUserOrderIndex error" + e);
        }
        return model;
    }
    /**
     * 后台活动详情
     *
     * @param request
     * @param
     * @param page
     * @return
     */
    @RequestMapping("/orderList")
    public ModelAndView orderList(HttpServletRequest request,CmsActivity activity,  Pagination page) {
        ModelAndView model = new ModelAndView();
        String id = request.getParameter("activityId");
        try {
            SysUser user = (SysUser) session.getAttribute("user");
            if (user != null) {
                List<CmsActivity> activityList = cmsOrderService.queryCmsOrderById(activity,id, page, user);
                model.addObject("activityList", activityList);
                model.addObject("activityId", id);
                model.addObject("activity", activity);
                model.addObject("page", page);
                model.setViewName("admin/activity/orderListIndex");
            }
        } catch (Exception e) {
            logger.info("orderList error" + e);
        }
        return model;
    }

    /**
     * 后台订单详情中取消订单中在取消订单式需要发送一条短消息给用户
     *
     * @param activityOrderId
     * @return
     */
    @RequestMapping("/updateOrderByActivityOrderId")
    @ResponseBody
    public String updateOrderByActivityOrderId(String activityOrderId,String[] cancelSeat) {
        SysUser user = (SysUser) session.getAttribute("user");
        if (user != null) {
            //Map map = cmsOrderService.updateOrderByActivityOrderId(activityOrderId,cancelSeat);
            String orderLines ="";
            if (cancelSeat != null && cancelSeat.length > 0) {
                for (String orderLine : cancelSeat)
                orderLines += orderLine + ",";
            }
            Map<String,String> map = cmsActivityOrderService.cancelUserOrder(activityOrderId,null,orderLines,null,null);
           if ("Y".equals(map.get("success"))) {
                return Constant.RESULT_STR_SUCCESS;
            } else {
                return map.get("msg");
            }
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 发送短消息接口
     *
     * @param activityOrderId
     * @return
     */
    @RequestMapping("/sendSmsMessage")
    @ResponseBody
    public String sendSmsMessage(String activityOrderId) {
        return cmsOrderService.selectPhoneByActivityOrderId(activityOrderId);
    }
    
    @RequestMapping(value = "/checkOrderNumValid")
    public String checkOrderNumValid(HttpServletRequest request, HttpServletResponse response, String orderValidateCode) throws Exception {
        String json = "";
        if (StringUtils.isNotBlank(orderValidateCode)) {
            json = activityOrderAppService.queryActvityOrderByValidateCode(orderValidateCode);
        } else {
            json = JSONResponse.toAppResultFormat(14112, "活动取票码参数缺失");
        }

        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 验证系统进行座位验证
     *
     * @param userId            用户id
     * @param orderValidateCode 取票码
     * @param orderPayStatus    订单状态
     * @param seats             座位号
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/updateOrderNumStatus")
    public String updateOrderNumStatus(HttpServletRequest request, String userId, String orderValidateCode, String orderPayStatus, String seats, HttpServletResponse response) throws Exception {
        String json = "";
        if (StringUtils.isNotBlank(orderValidateCode) && StringUtils.isNotBlank(seats)) {

            Cookie[] cookies = request.getCookies();
            String ticketUserId = null;
            if (cookies != null && cookies.length > 0) {
                for (Cookie c : cookies) {
                    if (StringUtils.isNotBlank(ticketUserId)) {
                        break;
                    }
                    if ("ticketUserId".equals(c.getName())) {
                        try {
                            ticketUserId = URLDecoder.decode(c.getValue(), "UTF-8");
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
            
            SysUser user = (SysUser) session.getAttribute("user");
            
            if (user!=null) {
                userId = user.getUserId();
            }
            json = activityOrderAppService.queryActvityOrderSeatsByValidateCode(orderValidateCode, seats, userId, orderPayStatus);
        } else {
            json = JSONResponse.toAppResultFormat(14112, "请选择要验证的座位");
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    

    /**
     * @param request
     * @param id
     * @return
     */
    @RequestMapping(value = "/preEditActivity", method = RequestMethod.GET)
    public String preEditActivity(HttpServletRequest request, String id) {
        if (StringUtils.isNotBlank(id)) {
            CmsActivity activity = activityService.queryCmsActivityByActivityId(id);
            request.setAttribute("activity", activity);
        }
        //判断活动之前是否有座位
        int count = cmsActivitySeatService.queryCountByActivityId(id);
        //无座位加载 藏馆模版座位信息
        if (count > 0) {
            request.setAttribute("activitySeat", "Y");
        } else {
            //有座位加载活动座位信息
            request.setAttribute("activitySeat", "N");
        }
        //省市区
        request.setAttribute("user", session.getAttribute("user"));
        return "admin/activity/editOrder";
    }

    /**
     * @param cur
     * @param seatIds
     * @return
     */
    @RequestMapping(value = "/editActivity", method = RequestMethod.POST)
    @ResponseBody
    public String editActivity(CmsActivity cur, String seatIds) {
        try {
            if (cur != null) {
                SysUser sysUser = (SysUser) session.getAttribute("user");
                return activityService.editActivity(cur, sysUser, seatIds,false);
            }
        } catch (Exception e) {
            logger.info("updateActivity error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }


    /**
     * 查看订单详情
     * @param activityOrderId
     * @return
     */
    @RequestMapping(value = "/viewOrderDetail")
    public String viewOrderDetail(String activityOrderId,HttpServletRequest request) {
        try {
            CmsActivityOrder activityOrder = cmsOrderService.queryActivityOrderByOrderId(activityOrderId);
            request.setAttribute("activityOrder",activityOrder);
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("orderDetail error" + e);
        }
        return "admin/activity/viewOrderDetail";
    }

    /**
     * 导出所有活动的订单
     * @param response
     * @param searchKey 订单号\手机号\活动名称
     * @param activityArea
     * @param orderVotes
     * @param orderPayStatus
     * @param activitySalesOnline
     * @throws Exception
     */
    @RequestMapping("/exportOrderExcel")
    public void exportOrderExcel(HttpServletResponse response,String searchKey,String activityArea,String orderVotes,String orderPayStatus,String activitySalesOnline) throws Exception {
        response.setContentType("application/vnd.ms-excel;charset=utf-8");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment;filename=" + "orderExcel.xls");
        ServletOutputStream out = response.getOutputStream();
        SysUser user = (SysUser) session.getAttribute("user");
        if(user != null){
            CmsActivity activity = new CmsActivity();
            activity.setSearchKey(searchKey);
            activity.setActivityArea(activityArea);
            if(StringUtils.isNotBlank(orderVotes)){
                activity.setOrderVotes(Integer.parseInt(orderVotes));
            }
            if(StringUtils.isNotBlank(orderPayStatus)){
                activity.setOrderPayStatus(Short.parseShort(orderPayStatus));
            }
            activity.setActivitySalesOnline(activitySalesOnline);
            List<CmsActivity> activityList = cmsOrderService.queryCmsOrderByCondition(activity, null, user);
            exportExcel.exportActivityOrderExcel("活动订单", "EXPORT_ACT_ORDER_EXCEL", activityList, out, "yyyy-MM-dd HH:mm:ss");
        }
    }



    /**
     * 跳转至取消用户页面
     * @param activityOrderId
     * @return
     */
    @RequestMapping(value = "/preCancelUserOrder")
    public String preCancelUserOrder(String activityOrderId,HttpServletRequest request) {
        try {
            CmsActivityOrder activityOrder = cmsOrderService.queryActivityOrderByOrderId(activityOrderId);
            request.setAttribute("activityOrder",activityOrder);
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("orderDetail error" + e);
        }
        return "admin/activity/cancelUserOrder";
    }

}
