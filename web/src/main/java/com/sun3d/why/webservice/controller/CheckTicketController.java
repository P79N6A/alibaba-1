package com.sun3d.why.webservice.controller;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.service.CmsUserService;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.MD5Util;
import com.sun3d.why.webservice.service.ActivityAppOrderService;
import com.sun3d.why.webservice.service.RoomAppOrderService;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
@RequestMapping("/checkTicket")
@Controller
public class CheckTicketController
{
    private Logger logger = Logger.getLogger(CheckTicketController.class);
    @Autowired
    private ActivityAppOrderService activityOrderAppService;
    @Autowired
    private RoomAppOrderService roomAppOrderService;
    @Autowired
    private CmsUserService cmsUserService;
    /**
     * 验证系统验证活动订单详情
     * @param orderValidateCode  取票码
     * @return
     */
    @RequestMapping(value = "/orderActivityCode")
    public String orderActivityCode(HttpServletResponse response,String orderValidateCode) throws Exception {
        String json="";
        if (orderValidateCode!=null && StringUtils.isNotBlank(orderValidateCode)) {
            json=activityOrderAppService.queryActvityOrderByValidateCode(orderValidateCode);
        } else {
            json=JSONResponse.toAppResultFormat(14112,"活动取票码参数缺失");
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * 验证系统进行座位验证
     * @param userId 用户id
     * @param orderValidateCode 取票码
     * @param orderPayStatus 订单状态
     * @param seats 座位号
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/activitySeatCode")
    public String activitySeatCode(String userId,String orderValidateCode,String orderPayStatus,String seats,HttpServletResponse response)throws Exception
    {
        String json="";
        if (StringUtils.isNotBlank(orderValidateCode) && StringUtils.isNotBlank(seats)) {
            json=activityOrderAppService.queryActvityOrderSeatsByValidateCode(orderValidateCode,seats,userId,orderPayStatus);
        }
        else {
            json=JSONResponse.toAppResultFormat(14112,"请选择要验证的座位");
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    /**
     * 验证系统验证活动室订单详情
     * @param orderValidateCode  取票码
     * @return
     */
    @RequestMapping(value = "/orderRoomCode")
    public String orderRoomCode(String orderValidateCode,HttpServletResponse response)
            throws Exception
    {
        String json = "";
        if (orderValidateCode != null && StringUtils.isNotBlank(orderValidateCode)) {
            json=roomAppOrderService.queryRoomOrderByValidateCode(orderValidateCode);
        } else {
            json = JSONResponse.commonResultFormat(14112, "活动室订单取票码缺失", null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    /**
     * 验证系统进行活动室预定日期验证
     * @param userId 用户id
     * @param roomOderId 活动室订单id
     * @return
     */
    @RequestMapping(value = "/checkRoomCode")
    public String checkRoomCode(String userId,String roomOderId,String roomTime,HttpServletResponse response)
            throws Exception
    {
        String json="";
        if (roomOderId!=null && StringUtils.isNotBlank(roomOderId)) {
            json=roomAppOrderService.checkCmsRoomOrderByRoomOrderId(roomOderId,userId,roomTime);
        } else {
            json=JSONResponse.toAppResultFormat(14112,"活动室订单id缺失");
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        return null;
    }

    /**
     * 验证系统后台登陆
     * @return
     */
    @RequestMapping(value = "/loginCheckSysUser")
    public String loginCheckSysUser(String userAccount,String userPassword,HttpServletResponse response)
            throws IOException
    {
        String json = "";
        try {
            if (StringUtils.isEmpty(userAccount)) {
                json = JSONResponse.commonResultFormat(10101, "账号不能为空!", null);
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().print(json);
                return null;
            }
            if (StringUtils.isEmpty(userPassword)) {
                json = JSONResponse.commonResultFormat(10102, "密码不能为空!", null);
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().print(json);
                return null;
            }
            json=cmsUserService.queryAppSysUserById(userAccount, MD5Util.toMd5(userPassword));
        } catch (Exception ex) {
            json = JSONResponse.commonResultFormat(12132, "系统错误!", null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }


    /**
     * 通过取票吗查询功能
     * @return
     * @throws IOException
     */
    @RequestMapping({"/searchInfo"})
    public String searchInfo(HttpServletRequest request, HttpServletResponse response) throws Exception{
        response.setContentType("text/html;charset=UTF-8");
        String orderValidateCode = request.getParameter("orderValidateCode");
        String json = "";
        if(StringUtils.isBlank(orderValidateCode)){
            json = JSONResponse.commonResultFormat(14112, "取票码缺失", null);
            response.getWriter().print(json);
            return null;
        }
        CmsActivityOrder cmsActivityOrder = activityOrderAppService.queryValidateCode(orderValidateCode);
        if(cmsActivityOrder != null){
            return this.orderActivityCode(response, orderValidateCode);
        }
        else{
            return this.orderRoomCode(orderValidateCode,response);
        }
    }
}