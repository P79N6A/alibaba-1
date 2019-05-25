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
@RequestMapping("/ticketUser")
@Controller
public class TicketUserController {


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
    @RequestMapping(value = "/ticketUserLogin")
    public void ticketUserLogin(CmsTerminalUser user,String rememberUser, HttpServletRequest request, HttpServletResponse response) {
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

    /**
     * 进入登录页面
     * @param request
     * @return
     */
    @RequestMapping(value = "/preTicketUserLogin",method = RequestMethod.GET)
    public ModelAndView preTicketUserLogin(HttpServletRequest request){
        if (null!=request.getSession().getAttribute(Constant.terminalUser)) {
            return new ModelAndView("redirect:/ticketActivity/ticketActivityList.do");
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
        return new ModelAndView("ticket/user/ticketUserLogin");
    }

    //清除cookie 退出登录
    @RequestMapping("/ticketOutLogin")
    public void ticketOutLogin(HttpServletRequest request,HttpServletResponse response){
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





}
