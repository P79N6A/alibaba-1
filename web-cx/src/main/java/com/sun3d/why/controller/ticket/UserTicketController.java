package com.sun3d.why.controller.ticket;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsActivityEvent;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.BookActivitySeatInfo;
import com.sun3d.why.service.*;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.sun3d.why.util.Constant.RESULT_STR_FAILURE;

/**
 * Created by yujinbing on 2015/11/30.
 */
@RequestMapping("/userTicket")
@Controller
public class UserTicketController {


    @Autowired
    private CmsTerminalUserService terminalUserService;

    @Autowired
    private CmsActivityService activityService;

    @Autowired
    private CmsActivityEventService cmsActivityEventService;

    @Autowired
    private CmsVenueService cmsVenueService;

    @Autowired
    private CacheService cacheService;

    @Autowired
    private HttpSession session;

    /**
     * 登陆
     *
     * @param user
     * @param rememberUser
     * @param request
     * @param response
     *String str = Base64.encode(user.getUserName() + "," + user.getUserPwd());
     * autoLogin.setMaxAge(cookieInfo.getCookieTime());
     */
    // 前端2.0登录
    @RequestMapping(value = "/terminalLogin",method = RequestMethod.POST)
    public void terminalLogin(CmsTerminalUser user,String rememberUser, HttpServletRequest request, HttpServletResponse response) {
        try {
            if(user==null||StringUtils.isEmpty(user.getUserName())||StringUtils.isEmpty(user.getUserPwd())){
                return;
            }
            //user.setUserIsDisable(Constant.USER_IS_ACTIVATE);
            String result = terminalUserService.webLogin(user, request.getSession());
            if (Constant.RESULT_STR_SUCCESS.equals(result)) {
                if (StringUtils.isNotEmpty(rememberUser) && "on".equals(rememberUser)) {
                    response.setContentType("text/html;charset=utf-8");
                    Cookie userName = new Cookie("userName", URLEncoder.encode(user.getUserName(), "UTF-8") );
                    userName.setPath("/");
                    userName.setMaxAge(Integer.MAX_VALUE);
                    response.addCookie(userName);
                }
                response.getWriter().write(Constant.RESULT_STR_SUCCESS);
            } else {
                response.getWriter().write(result);
            }
        }catch (Exception e) {
            try {
                response.getWriter().write(RESULT_STR_FAILURE);
            } catch (IOException el) {
            }
        }
    }

    //去登录
    @RequestMapping(value = "/userLogin",method = RequestMethod.GET)
    public ModelAndView userLogin(HttpServletRequest request){
        if (null!=request.getSession().getAttribute(Constant.terminalUser)) {
            return new ModelAndView("redirect:/frontActivity/venueBookIndex.do");
        }
        String LoginType  = request.getParameter("LoginType");
        if(StringUtils.isNotEmpty(LoginType)){
            request.setAttribute("LoginType",LoginType);
        }
        Cookie[] cookies =  request.getCookies();
        if(cookies!=null&&cookies.length>0){
            for (Cookie c : cookies){
                if("userName".equals(c.getName())){
                    try {
                        request.setAttribute("userName", URLDecoder.decode(c.getValue(), "UTF-8"));
                    } catch (UnsupportedEncodingException e) {
                    }
                    break;
                }
            }
        }
        //return new ModelAndView("redirect:/frontActivity/frontActivityList.do");
        return new ModelAndView("ticket/userLoginTicket");
    }

    //清除cookie 退出登录
    @RequestMapping("/outLogin")
    public void outLogin(HttpServletRequest request,HttpServletResponse response){
        try{
            request.getSession().removeAttribute(Constant.terminalUser);
            response.getWriter().write(Constant.RESULT_STR_SUCCESS);
            return;
        }catch (Exception e){
            e.printStackTrace();
        }
        try {
            response.getWriter().write(RESULT_STR_FAILURE);
        } catch (IOException e) {
        }
    }


    /**
     * 去注册页面
     * @return
     */
    @RequestMapping(value = "/userRegister")
    public ModelAndView userRegister(HttpServletRequest request) {
        //如果当前登录用户不为空 不能去注册
        if(null!=request.getSession().getAttribute(Constant.terminalUser)){
            return new ModelAndView("redirect:/frontActivity/venueBookIndex.do");
        }
        return new ModelAndView("ticket/userRegister");
    }


    /**
     * 进入活动预定选坐页面
     *
     * @return
     */
    @RequestMapping(value = "/frontActivityBook")
    public ModelAndView frontActivityBook(String activityId) {
        ModelAndView model = new ModelAndView();
        try {
            CmsActivity cmsActivity = activityService.queryFrontActivityByActivityId(activityId);
            if (cmsActivity != null && cmsActivity.getActivityIsDel() == 1 && cmsActivity.getActivityState() == 6) {
                //在线选座情况
                //查询场次信息 时间段
                List<CmsActivityEvent> activityEventTimes = cmsActivityEventService.queryEventTimeByActivityId(activityId);
                //查询场次信息 最大 和最小的有效 日期 且有余票的
                Map map = cmsActivityEventService.queryMinMaxDateByActivityId(activityId);
                if (map != null && map.size() > 0) {
                    cmsActivity.setActivityStartTime(map.get("minEventDate").toString());
                    cmsActivity.setActivityEndTime(map.get("maxEventDate").toString());
                }
                String canNotEventStrs = cmsActivityEventService.queryCanNotBookEventTime(activityId);
                List<CmsActivityEvent> activityEventDates = cmsActivityEventService.queryEventDateByActivityId(activityId);
                model.addObject("activityEventTimes", activityEventTimes);
                model.addObject("activityEventDates", activityEventDates);
                model.addObject("activityId", activityId);
                model.addObject("cmsActivity", cmsActivity);
                model.addObject("canNotEventStrs",canNotEventStrs);
                model.setViewName("ticket/frontActivityBook");
                return model;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
        return null;
    }


    /**
     * 验证活动预定
     *
     * @param seatId
     * @param cmsActivityOrder
     * @return
     */
    @RequestMapping(value = "/checkFrontActivityBook")
    @ResponseBody
    public Map checkFrontActivityBook(String[] seatId, Integer bookCount, CmsActivityOrder cmsActivityOrder) {
        Map map = new HashMap();
        try {
            CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
            if (terminalUser == null) {
                map.put("success", "N");
                map.put("msg", "login");
                return map;
            }
            BookActivitySeatInfo activitySeatInfo = new BookActivitySeatInfo();
            activitySeatInfo.setActivityId(cmsActivityOrder.getActivityId());
            activitySeatInfo.setSeatIds(seatId);
            activitySeatInfo.setBookCount(bookCount);
            activitySeatInfo.setUserId(terminalUser.getUserId());
            activitySeatInfo.setPrice(cmsActivityOrder.getOrderPrice());
            activitySeatInfo.setPhone(cmsActivityOrder.getOrderPhoneNo());
            activitySeatInfo.setsId(UUIDUtils.createUUId());
            activitySeatInfo.setEventId(cmsActivityOrder.getEventId());
            activitySeatInfo.setEventDateTime(cmsActivityOrder.getEventDateTime());
            String checkRs = cacheService.checkActivitySeatStatus(activitySeatInfo, activitySeatInfo.getSeatIds(), bookCount, terminalUser.getUserId());
            if (!Constant.RESULT_STR_SUCCESS.equals(checkRs)) {
                map.put("success", "N");
                map.put("msg", checkRs);
                return map;
            } else {
                map.put("success", "Y");
                return map;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            map.put("success", "N");
            map.put("msg", ex.toString());
            return map;
        }
    }


    /**
     * 确定订单页面
     *
     * @param request
     * @param cmsActivityOrder
     * @param seatId
     * @param bookCount
     * @return
     */
    @RequestMapping(value = "/preSaveActivityOder")
    public String preSaveActivityOder(HttpServletRequest request, CmsActivityOrder cmsActivityOrder, String[] seatId, Integer bookCount) {
        try {
            CmsActivity cmsActivity = activityService.queryFrontActivityByActivityId(cmsActivityOrder.getActivityId());
            cmsActivityOrder.setOrderNumber(cacheService.genOrderNumber());
            if (seatId != null) {
                cmsActivityOrder.setOrderSummary(arrayToString(seatId));
                request.setAttribute("seatIds", arrayToString(seatId));
            }
            cmsActivityOrder.setOrderVotes(bookCount);
            request.setAttribute("activityOrder", cmsActivityOrder);
            request.setAttribute("activity", cmsActivity);
            request.setAttribute("bookCount", bookCount);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return "ticket/activityBookOrder";
    }


    public String arrayToString(String[] strs) {
        StringBuffer sb = new StringBuffer();
        for (String str : strs) {
            sb.append(str + ",");
        }
        return sb.toString();
    }


    /**
     * 提交订单后，返回活动预定选坐页面
     *
     * @return
     */
    @RequestMapping(value = "/updateActivityBookInfo")
    public ModelAndView updateActivityBookInfo(String activityId, String selectSeatInfo, Integer bookCount,String eventDateTime,String orderPhoneNo) {
        ModelAndView model = new ModelAndView();
        try {
            CmsActivity cmsActivity = activityService.queryFrontActivityByActivityId(activityId);
            if (cmsActivity != null) {
                model.addObject("eventDateTime", eventDateTime);
                //在线选座情况
                //查询场次信息 时间段
                List<CmsActivityEvent> activityEventTimes = cmsActivityEventService.queryEventTimeByActivityId(activityId);
                //查询场次信息 最大 和最小的有效 日期
                Map map = cmsActivityEventService.queryMinMaxDateByActivityId(activityId);
                if (map != null && map.size() > 0) {
                    cmsActivity.setActivityStartTime(map.get("minEventDate").toString());
                    cmsActivity.setActivityEndTime(map.get("maxEventDate").toString());
                }
                List<CmsActivityEvent> activityEventDates = cmsActivityEventService.queryEventDateByActivityId(activityId);
                String canNotEventStrs = cmsActivityEventService.queryCanNotBookEventTime(activityId);
                model.addObject("activityEventTimes", activityEventTimes);
                model.addObject("activityEventDates", activityEventDates);
                model.addObject("activityId", activityId);
                model.addObject("cmsActivity", cmsActivity);
                model.addObject("selectSeatInfo", selectSeatInfo);
                model.addObject("canNotEventStrs",canNotEventStrs);
                model.addObject("bookCount", bookCount);
                model.addObject("orderPhoneNo", orderPhoneNo);
                model.setViewName("ticket/frontActivityBook");
                return model;
            }
            model.setViewName("ticket/frontActivityBook");
            return model;
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }



}
