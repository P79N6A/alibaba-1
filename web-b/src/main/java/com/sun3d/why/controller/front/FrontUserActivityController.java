package com.sun3d.why.controller.front;

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
    @RequestMapping("/userActivity")
@Controller
public class FrontUserActivityController {

    private Logger logger = LoggerFactory.getLogger(FrontUserActivityController.class);

    @Autowired
    private CmsActivityOrderService cmsActivityOrderService;

    @Autowired
    private CmsActivityService cmsActivityService;

    @Autowired
    private CmsActivityEventService cmsActivityEventService;

    @Autowired
    private HttpSession session;

    @RequestMapping("/userActivity")
    public  ModelAndView userActivity(String fromTicket){
        ModelAndView modelAndView = new ModelAndView();
        //获取用户信息
        CmsTerminalUser user = (CmsTerminalUser)session.getAttribute("terminalUser");
        if ("Y".equals(fromTicket) && user == null) {
            return new ModelAndView("redirect:/frontActivity/venueBookIndex.do");
        } else {
            modelAndView.setViewName("/index/userCenter/userActivityOrder");
        }
        return modelAndView;
    }

    @RequestMapping(value = "/userActivityList")
    public ModelAndView userActivityList(String activityName,HttpServletRequest request, Pagination page,CmsActivityOrder cmsActivityOrder,String fromTicket) {
        //准备返回显示视图与数据
        ModelAndView model = new ModelAndView();
        //获取用户信息
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        if ("Y".equals(fromTicket) && cmsTerminalUser == null) {
            return new ModelAndView("redirect:/frontActivity/venueBookIndex.do");
        }
        //如果为空就跳转到登录界面
        if(cmsTerminalUser == null){
            return new ModelAndView("redirect:/frontActivity/frontActivityIndex.do");
        } else {//获取用户的ID
            String userId = cmsTerminalUser.getUserId();
            page.setRows(5);
            List<CmsActivityOrder> activityOrderList = cmsActivityOrderService.queryUserOrderListById(userId,page,activityName, null);

            model.addObject("activityOrderList", activityOrderList);
            model.addObject("page", page);
            model.setViewName("/index/userCenter/userActivityOrderLoad");

            return model;
        }
    }

    @RequestMapping(value = "/userActivityLoad")
    public String userActivityLoad(HttpServletRequest request,String userId, Pagination page,String type) {
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
            this.logger.error("currentActivity error {}", ex);
        }
        return "index/userActivityOrderLoad";
    }

    /**
     * 展示用户未完成订单列表
     * @return
     */
    @RequestMapping("/userActivityDetail")
    public String userActivityDetail(){
        return "index/userCenter/userActivityUnfinished";
    }
    /**
     * 显示我的活动未完成订单的后台数据列表
     * @param activityName
     * @param page
     * @param request
     * @return
     */
    @RequestMapping("/userActivityUn")
    public ModelAndView userActivityUn(String activityName,Pagination page,HttpServletRequest request){
        ModelAndView  mode = new ModelAndView();
        try {
            CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
            if(cmsTerminalUser != null){
                page.setRows(5);
                String userId = cmsTerminalUser.getUserId();
                List<CmsActivityOrder> activityList = cmsActivityOrderService.queryUserActivityUn(userId, page, activityName);
                mode.addObject("activityList",activityList);
                mode.addObject("page",page);
                mode.setViewName("index/userCenter/userActivityUnfinishedLoad");
            } else {
                return new ModelAndView("redirect:/frontActivity/frontActivityIndex.do");
            }
        } catch (Exception e){
            logger.info("userActivityUn error", e);
        }
        return mode;
    }

    /**
     * 用户历史活动列表
     * @return
     */
    @RequestMapping(value = "/userActivityHistory")
    public ModelAndView userActivityHistory(String fromTicket){
        ModelAndView modelAndView = new ModelAndView();
        //获取用户信息
        CmsTerminalUser user = (CmsTerminalUser)session.getAttribute("terminalUser");
        if ("Y".equals(fromTicket) && user == null) {
            return new ModelAndView("redirect:/frontActivity/venueBookIndex.do");
        } else {
            modelAndView.setViewName("index/userCenter/userActivityHistory");
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
    @RequestMapping("userActivityHistoryList")
    public ModelAndView userActivityHistoryList(String activityName,Pagination page,HttpServletRequest request){

        ModelAndView  mode = new ModelAndView();
        try {
            CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
            if(cmsTerminalUser != null){
                page.setRows(5);
                String userId = cmsTerminalUser.getUserId();
                List<CmsActivityOrder> activityList = cmsActivityOrderService.queryUserActivityHistory(userId, page, activityName, null);
                mode.addObject("activityList",activityList);
                mode.addObject("page",page);
                mode.setViewName("index/userCenter/userActivityHistoryLoad");
            } else {
                return new ModelAndView("redirect:/frontActivity/frontActivityIndex.do");
            }
        } catch (Exception e){
            logger.info("userActivityUn error", e);
        }
        return mode;
    }

    /**
     * 通过ID删除订单
     * @param activityOrderId
     * @return
     */
    @RequestMapping("/deleteUserActivityHistory")
    public String deleteUserActivityHistory(String activityOrderId ){
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
     * 查询前端我的活动 所有已经预定但是没有参加活动的订单数量
     */
    @RequestMapping("/queryAllReserveAndNotReserved")
    public ModelAndView queryAllReserveAndNotReserved(){
        int count = 0 ;
        ModelAndView modelAndView = new ModelAndView();

        CmsTerminalUser user = (CmsTerminalUser)session.getAttribute("terminalUser");

        if(user != null){
            String userId = user.getUserId();
            count = cmsActivityOrderService.queryAllReserveAndNotReserved(userId);
        }
        if(count > 0){
            modelAndView.addObject("count",count);//将数据库中的参数获取出来添加的页面上
            modelAndView.setViewName("");//跳转的页面
        }
        return modelAndView;
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
     * 跳转至发布活动列表页
     */
    @RequestMapping("/prePublicActivityList")
    public String prePublicActivityList() {
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        if (cmsTerminalUser == null) {
            return  "redirect:/frontTerminalUser/userLogin.do";
        }
        return "index/userCenter/publicActivityList";
    }

    /**
     * 活动管理列表listLoad
     */
    @RequestMapping("/publicActivityLisLoad")
    public String publicActivityLisLoad(HttpServletRequest request,Pagination page) {
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        //已审核和未通过的
        Integer[] state = {1,3,5,6,7};
        page.setRows(3);
        List<CmsActivity> activityList = cmsActivityService.queryUserPublicActivityList(cmsTerminalUser,state,page);
        request.setAttribute("activityList", activityList);
        request.setAttribute("page",page);
        return "index/userCenter/publicActivityListLoad";
    }

    /**
     * 跳转至发布活动草稿箱列表页
     */
    @RequestMapping("/prePublicActivityListDrafts")
    public String prePublicActivityListDrafts() {
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        if (cmsTerminalUser == null) {
            return  "redirect:/frontTerminalUser/userLogin.do";
        }
        return "index/userCenter/publicActivityListDrafts";
    }

    /**
     * 活动管理草稿箱列表listLoad
     */
    @RequestMapping("/prePublicActivityListDraftsLoad")
    public String prePublicActivityListDraftsLoad(HttpServletRequest request,Pagination page) {
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        //用户保存到草稿箱的状态
        Integer[] state = {8};
        page.setRows(3);
        List<CmsActivity> activityList = cmsActivityService.queryUserPublicActivityList(cmsTerminalUser,state,page);
        request.setAttribute("activityList", activityList);
        request.setAttribute("page",page);
        return "index/userCenter/publicActivityListDraftsLoad";
    }

    /**
     * 跳转至前台发布活动页面
     */
    @RequestMapping("/prePublicActivity")
    public String prePublicActivity() {
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        if (cmsTerminalUser == null) {
            return  "redirect:/frontTerminalUser/userLogin.do";
        }
        return "index/userCenter/publicActivity";
    }

    /**
     * 保存前台发布活动
     * @param cmsActivity
     * @param eventCount
     * @return
     */
    @RequestMapping("/savePublicActivity")
    @ResponseBody
    public String savePublicActivity(CmsActivity cmsActivity,Integer eventCount,final String eventStartTimes, final String eventEndTimes) {
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        if (cmsTerminalUser == null) {
            return  "redirect:/frontTerminalUser/userLogin.do";
        }
        try {
            //验证活动名称是否重复
            if (StringUtils.isNotBlank(cmsActivity.getActivityName())) {
                boolean exists = cmsActivityService.queryActivityNameIsExists(cmsActivity.getActivityName().trim());
                if (exists) {
                    return "活动名称不能重复";
                }
            }
            String rsStr = cmsActivityService.addActivity(cmsActivity,cmsTerminalUser,eventCount);
            return rsStr;
        } catch (Exception ex) {
            ex.printStackTrace();
            return ex.toString();
        }
    }


    /**
     * 跳转至前台发布活动编辑页面
     */
    @RequestMapping("/preEditPublicActivity")
    public String prePublicActivity(String activityId,HttpServletRequest request) {
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        if (cmsTerminalUser == null) {
            return  "redirect:/frontTerminalUser/userLogin.do";
        }
        CmsActivity cmsActivity = cmsActivityService.queryCmsActivityByActivityId(activityId);
        if (cmsActivity == null) {
            return "error";
        }
        //在线选座情况
        //查询场次信息 时间段
        List<CmsActivityEvent> activityEventTimes = cmsActivityEventService.queryEventTimeByActivityId(activityId);
        request.setAttribute("activityEventTimes", activityEventTimes);
        request.setAttribute("activity",cmsActivity);
        return "index/userCenter/editPublicActivity";
    }


    /**
     * 保存前台发布活动
     * @param cmsActivity
     * @return
     */
    @RequestMapping("/editPublicActivity")
    @ResponseBody
    public String editPublicActivity(CmsActivity cmsActivity) {
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        if (cmsTerminalUser == null) {
            return  "redirect:/frontTerminalUser/userLogin.do";
        }
        try {
            String rsStr = cmsActivityService.editPublicActivity(cmsActivity, cmsTerminalUser);
            return rsStr;
        } catch (Exception ex) {
            ex.printStackTrace();
            return ex.toString();
        }
    }

    @RequestMapping("/delPublicActivity")
    @ResponseBody
    public String delPublicActivity(String activityId) {
        try {
            String rsStr = cmsActivityService.delPublicActivityByFrontUser(activityId);
            return rsStr;
        } catch (Exception ex) {
            ex.printStackTrace();
            return ex.toString();
        }
    }


}
