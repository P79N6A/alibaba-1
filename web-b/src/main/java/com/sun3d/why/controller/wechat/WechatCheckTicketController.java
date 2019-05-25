package com.sun3d.why.controller.wechat;

import java.net.URLDecoder;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsUserService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.RandomUtils;
import com.sun3d.why.webservice.service.ActivityAppOrderService;

@RequestMapping("/wechatcheckTicket")
@Controller
public class WechatCheckTicketController {

    @Autowired
    private CacheService cacheService;
    @Autowired
    private CmsUserService cmsUserService;

    @Autowired
    private ActivityAppOrderService activityOrderAppService;


    private Logger logger = LoggerFactory.getLogger(WechatCheckTicketController.class);


    /**
     * 验票登录页面
     *
     * @return
     */
    @RequestMapping(value = "/toLogin")
    public String toLogin(HttpServletRequest request) {
        String userName = null;
        String pwd = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null && cookies.length > 0) {
            for (Cookie c : cookies) {
                if (StringUtils.isNotBlank(userName) && StringUtils.isNotBlank(pwd)) {
                    break;
                }
                if ("ticketUserName".equals(c.getName())) {
                    try {
                        userName = URLDecoder.decode(c.getValue(), "UTF-8");
                    } catch (Exception e) {
                    }
                } else if ("ticketPwd".equals(c.getName())) {
                    try {
                        pwd = URLDecoder.decode(c.getValue(), "UTF-8");
                    } catch (Exception e) {
                    }
                }
            }
        }
        if (StringUtils.isNotBlank(userName) && StringUtils.isNotBlank(pwd)) {
            SysUser sysUser = cmsUserService.loginCheckUser(userName, pwd);
            if (sysUser != null) {
                if (sysUser.getUserState() != 1) {
                    return "wechat/ticket/login";
                }
                request.setAttribute("orderNumber", RandomUtils.genOrderNumberPrefix());
                return "wechat/ticket/ticketCheck";
            } else {
                return "wechat/ticket/login";
            }
        }
        return "wechat/ticket/login";
    }
    
    /**
     * 验票登录页面(ipad)
     *
     * @return
     */
    @RequestMapping(value = "/toLoginPad")
    public String toLoginPad(HttpServletRequest request) {
        String userName = null;
        String pwd = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null && cookies.length > 0) {
            for (Cookie c : cookies) {
                if (StringUtils.isNotBlank(userName) && StringUtils.isNotBlank(pwd)) {
                    break;
                }
                if ("ticketUserName".equals(c.getName())) {
                    try {
                        userName = URLDecoder.decode(c.getValue(), "UTF-8");
                    } catch (Exception e) {
                    }
                } else if ("ticketPwd".equals(c.getName())) {
                    try {
                        pwd = URLDecoder.decode(c.getValue(), "UTF-8");
                    } catch (Exception e) {
                    }
                }
            }
        }
        if (StringUtils.isNotBlank(userName) && StringUtils.isNotBlank(pwd)) {
            SysUser sysUser = cmsUserService.loginCheckUser(userName, pwd);
            if (sysUser != null) {
                if (sysUser.getUserState() != 1) {
                    return "wechat/ticketPad/login";
                }
                request.setAttribute("orderNumber", RandomUtils.genOrderNumberPrefix());
                return "wechat/ticketPad/ticketCheck";
            } else {
                return "wechat/ticketPad/login";
            }
        }
        return "wechat/ticketPad/login";
    }

    /**
     * 验票页面
     *
     * @return
     */
    @RequestMapping(value = "/ticketCheck")
    public String ticketCheck(HttpServletRequest request) {
        request.setAttribute("orderNumber", RandomUtils.genOrderNumberPrefix());
        return "wechat/ticket/ticketCheck";
    }
    
    /**
     * 验票页面(ipad)
     *
     * @return
     */
    @RequestMapping(value = "/ticketCheckPad")
    public String ticketCheckPad(HttpServletRequest request) {
        request.setAttribute("orderNumber", RandomUtils.genOrderNumberPrefix());
        return "wechat/ticketPad/ticketCheck";
    }

    /**
     * 票务信息页面
     *
     * @return
     */
    @RequestMapping(value = "/ticketInfo")
    public String ticketInfo(HttpServletRequest request, String code) {
        request.setAttribute("code", code);
        return "wechat/ticket/ticketInfo";
    }
    
    /**
     * 票务信息页面(ipad)
     *
     * @return
     */
    @RequestMapping(value = "/ticketInfoPad")
    public String ticketInfoPad(HttpServletRequest request, String code) {
        request.setAttribute("code", code);
        return "wechat/ticketPad/ticketInfo";
    }

    /**
     * 验票登录
     *
     * @return
     */
    @RequestMapping(value = "/login")
    public String login(HttpServletRequest request, HttpServletResponse response, String userName, String pwd) {
        //微信权限验证配置
        Map<String, String> sign = BindWS.sign(BindWS.getUrl(request), cacheService);
        request.setAttribute("sign", sign);
        String json = null;
        try {
            if (StringUtils.isBlank(userName)) {
                json = JSONResponse.commonResultFormat(10101, "账号不能为空!", null);
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().print(json);
                return null;
            }
            if (StringUtils.isBlank(pwd)) {
                json = JSONResponse.commonResultFormat(10102, "密码不能为空!", null);
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().print(json);
                return null;
            }
            json = cmsUserService.queryAppSysUserById(userName, pwd);
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().print(json);
            response.getWriter().flush();
            response.getWriter().close();
        } catch (Exception ex) {
            logger.info("checkTicket Login error" + ex.getMessage());
        }
        return null;
    }

    /**
     * 验证系统验证活动订单详情
     *
     * @param orderValidateCode 取票码
     * @return
     */
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
            if (StringUtils.isNotBlank(ticketUserId)) {
                userId = ticketUserId;
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

}
