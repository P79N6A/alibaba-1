package com.sun3d.why.controller.ticket;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsActivityEvent;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CmsActivityEventService;
import com.sun3d.why.service.CmsActivityOrderService;
import com.sun3d.why.service.CmsActivityService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by yujinbing on 2015/6/27.
 */
    @RequestMapping("/ticketUserActivity")
@Controller
public class TicketUserActivityController {

    private Logger logger = LoggerFactory.getLogger(TicketUserActivityController.class);

    @Autowired
    private CmsActivityOrderService cmsActivityOrderService;

    @Autowired
    private CmsActivityService cmsActivityService;

    @Autowired
    private CmsActivityEventService cmsActivityEventService;

    @Autowired
    private HttpSession session;

    @RequestMapping("/ticketUserActivity")
    public  ModelAndView ticketUserActivity(){
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("/ticket/userCenter/ticketUserActivityOrder");
        return modelAndView;
    }

    @RequestMapping(value = "/ticketUserActivityList")
    public ModelAndView ticketUserActivityList(String activityName,HttpServletRequest request, Pagination page,CmsActivityOrder cmsActivityOrder,String fromTicket) {
        //准备返回显示视图与数据
        ModelAndView model = new ModelAndView();
        //获取用户信息
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        //如果为空就跳转到登录界面
        if(cmsTerminalUser == null){
            return new ModelAndView("redirect:/ticketUser/preTicketUserLogin.do");
        } else {//获取用户的ID
            String userId = cmsTerminalUser.getUserId();
            page.setRows(5);
            List<CmsActivityOrder> activityOrderList = cmsActivityOrderService.queryUserOrderListById(userId,page,activityName, null);
            model.addObject("activityOrderList", activityOrderList);
            model.addObject("page", page);
            model.setViewName("/ticket/userCenter/ticketUserActivityOrderLoad");
            return model;
        }
    }

    @RequestMapping(value = "/ticketUserActivityLoad")
    public String ticketUserActivityLoad(HttpServletRequest request,String userId, Pagination page,String type) {
        try {
            // type 1:已买票未进行的活动   2 未支付的活动  3 已经完成的活动
            Map map = new HashMap();
            map.put("userId", userId);
            page.setRows(5);
            List<Map> list = cmsActivityOrderService.queryUserOrderByMap(map, page);
            request.setAttribute("list", list);
            request.setAttribute("page", page);
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("ticketUserActivityLoad error {}", ex);
        }
        return "ticket/userCenter/ticketUserActivityOrderLoad";
    }


    /**
     * 用户历史活动列表
     * @return
     */
    @RequestMapping(value = "/ticketUserActivityHistory")
    public ModelAndView ticketUserActivityHistory(String fromTicket){
        ModelAndView modelAndView = new ModelAndView();
        //获取用户信息
        CmsTerminalUser user = (CmsTerminalUser)session.getAttribute("terminalUser");
        if (user == null) {
            return new ModelAndView("redirect:/ticketUser/preTicketUserLogin.do");
        } else {
            modelAndView.setViewName("ticket/userCenter/ticketUserActivityHistory");
        }
        return modelAndView;
    }


    /**
     * 用户历史活动后台数据
     * @param activityName
     * @param page
     * @param request
     * @return
     */
    @RequestMapping("ticketUserActivityHistoryList")
    public ModelAndView ticketUserActivityHistoryList(String activityName,Pagination page,HttpServletRequest request){

        ModelAndView  mode = new ModelAndView();
        try {
            CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
            if(cmsTerminalUser != null){
                page.setRows(5);
                String userId = cmsTerminalUser.getUserId();
                List<CmsActivityOrder> activityList = cmsActivityOrderService.queryUserActivityHistory(userId, page, activityName, null);
                mode.addObject("activityList",activityList);
                mode.addObject("page",page);
                mode.setViewName("ticket/userCenter/ticketUserActivityHistoryLoad");
            } else {
                return new ModelAndView("redirect:/ticketUser/preTicketUserLogin.do");
            }
        } catch (Exception e){
            logger.error("ticketUserActivityHistoryList error {}", e);
            e.printStackTrace();
        }
        return mode;
    }


    /**
     * 评论数
     * @return
     */
    @RequestMapping("/queryActivityCommentByActivityId")
    @ResponseBody
    public int queryActivityCommentByActivityId(){
        int ActivityComment = 0;
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        if(cmsTerminalUser != null){
            String userId = cmsTerminalUser.getUserId();
            ActivityComment = cmsActivityOrderService.queryActivityCommentByActivityId(userId ,2);
        }
        return ActivityComment;
    }



    /**
     * 查询可以预定的时间段信息
     * @param activityId
     * @param eventDate
     * @return
     */
    @RequestMapping(value = "/queryTicketCanBookEventTime")
    @ResponseBody
    public List queryTicketCanBookEventTime(String activityId,String eventDate) {
        try {
            return cmsActivityEventService.queryCanBookEventTime(activityId,eventDate);
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }


    /**
     * 通过ID删除订单
     * @param activityOrderId
     * @return
     */
    @RequestMapping("/deleteTicketUserActivityHistory")
    public String deleteTicketUserActivityHistory(String activityOrderId ){
        int count = 0 ;
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        if(cmsTerminalUser != null){
            String userId = cmsTerminalUser.getUserId();
            if (activityOrderId != null)
                count = cmsActivityOrderService.deleteUserActivityHistory(activityOrderId,userId);
        }
        if(count > 0 ){
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }



    /**
     * 取消用户订单
     *
     * @param request
     * @param activityOrderId
     * @return
     */
    @RequestMapping(value = "/cancelTicketUserOrder")
    @ResponseBody
    public Map<String, String> cancelTicketUserOrder(HttpServletRequest request, String activityOrderId,String orderSeat,Integer cancelCount) {
        Map map = new HashMap();
        try {
            CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
            map = cmsActivityOrderService.cancelUserOrder(activityOrderId, terminalUser,orderSeat,cancelCount);
            return map;
        } catch (Exception ex) {
            map.put("success", "N");
            map.put("msg", ex.toString());
            return map;
        }
    }

}
