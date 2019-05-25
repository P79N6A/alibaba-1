package com.sun3d.why.webservice.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sun3d.why.enumeration.UserOperationEnum;
import com.sun3d.why.model.CmsRoomOrder;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsUserOperatorLog;
import com.sun3d.why.service.CmsRoomOrderService;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.CmsUserOperatorLogService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.webservice.service.RoomAppOrderService;
/**
 * 手机app接口 用户展馆订单列表
 * Created by Administrator on 2015/7/4
 *
 */
@RequestMapping("/appUserVenue")
@Controller
public class UserVenueAppController {
    private Logger logger = Logger.getLogger(UserVenueAppController.class);
    @Autowired
    private CmsRoomOrderService cmsRoomOrderService;
    @Autowired
    private RoomAppOrderService roomAppOrderService;
    @Autowired
    private CmsTerminalUserService terminalUserService;
    @Autowired
    private CmsUserOperatorLogService cmsUserOperatorLogService;

    /**
     * app显示用户当前预定的活动室订单
     * @param userId 用户id
     * @param pageIndex 首页下标
     * @param pageNum 显示条数
     * @return json 10111:用户id不存在
     */
    @RequestMapping(value = "/userAppNowVenue")
    public String queryCurrentRoomOrderList(PaginationApp pageApp,HttpServletResponse response,String userId,String pageIndex,String pageNum) throws Exception {
        String json = "";
        try {
            if (StringUtils.isNotBlank(userId) && userId!=null) {
                pageApp.setFirstResult(Integer.valueOf(pageIndex));
                pageApp.setRows(Integer.valueOf(pageNum));
                 json=roomAppOrderService.queryCurrentRoomOrderListById(userId,pageApp);
            } else {
                 json=JSONResponse.commonResultFormat(10111,"用户id不存在!",null);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    /**
     * app显示用户以往活动室订单
     * @param userId 用户id
     * @param pageIndex 首页下表
     * @param pageNum 显示条数
     * @return json 10111:用户id不存在
     */
    @RequestMapping(value = "/userAppOldVenue")
    public String queryPastRoomOrderList(PaginationApp pageApp, HttpServletResponse response,String userId,String pageIndex,String pageNum) throws Exception {
        String json="";
        if (StringUtils.isNotBlank(userId) && userId!=null) {
            pageApp.setFirstResult(Integer.valueOf(pageIndex));
            pageApp.setRows(Integer.valueOf(pageNum));
             json=roomAppOrderService.queryPastRoomOrderListById(userId,pageApp);
        }
        else{
            json=JSONResponse.commonResultFormat(10111,"用户id不存在!",null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    /**
     * app取消用户活动室
     * @return json 10114:用户或活动室id缺失 10111用户id缺失 0 取消活动室预定成功
     */
    @RequestMapping(value = "/removeAppRoomOrder")
    public String removeAppRoomOrder( HttpServletRequest request, HttpServletResponse response) throws Exception {
        String json="";
        String userId=request.getParameter("userId");
        String roomOrderId=request.getParameter("roomOrderId");
        try {
            if(StringUtils.isNotBlank(userId)&& StringUtils.isNotBlank(roomOrderId)){
                CmsTerminalUser terminalUser = terminalUserService.queryTerminalUserById(userId);
                if(terminalUser != null){
                    boolean cancelResult = cmsRoomOrderService.cancelRoomOrder(roomOrderId,terminalUser.getUserName());
                    if(cancelResult) {

                    	CmsUserOperatorLog record =CmsUserOperatorLog.createInstance(null, roomOrderId, null, userId, CmsUserOperatorLog.USER_TYPE_NORMAL, UserOperationEnum.CANCEL); 
                        
                    	cmsUserOperatorLogService.insert(record);
                    	
                        json=JSONResponse.commonResultFormat(0,"取消活动室预定成功!",null);
                    }else if(cancelResult==false){
                        json=JSONResponse.commonResultFormat(2,"该活动室已取消!",null);
                    }else {
                        json=JSONResponse.commonResultFormat(1,"取消活动室失败!",null);
                    }
                }else {
                    json=JSONResponse.commonResultFormat(10115,"该用户不存在!",null);
                }
            }else{
                json=JSONResponse.commonResultFormat(10114,"用户或活动室id缺失!",null);
            }
        }catch (Exception e) {
            logger.info("活动室预定出错了");
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app删除以往活动室订单
     * @param userId 用户id
     * @param roomOrderId 活动室订单id
     * @return json 10113:用户不存在 10114.用户活动活动室订单id缺失  0 删除活动室订单成功 1取消活动室订单失败
     */
    @RequestMapping(value = "/deleteAppRoomOrder")
    public String deleteAppRoomOrder(HttpServletResponse response,String userId,String roomOrderId) throws Exception {
        String json="";
        int count=0;
        if(StringUtils.isNotBlank(roomOrderId) && StringUtils.isNotBlank(userId)){
                count=roomAppOrderService.deleteRoomOrderById(roomOrderId,userId);
                if(count > 0){
                    json=JSONResponse.commonResultFormat(0,"删除以往活动室订单成功!",null);
                }else {
                    json=JSONResponse.commonResultFormat(1,"删除以往活动室订单失败!",null);
                }

        }else{
            json=JSONResponse.commonResultFormat(10114,"用户或活动室订单id缺失!",null);
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app根据取票码查询订单活动室信息
     * @return json 14112活动室订单取票码缺失
     * @throws Exception
     */
    @RequestMapping(value = "/orderValidateCode")
    public String queryValidateCode( HttpServletRequest request, HttpServletResponse response) throws Exception {
        String json="";
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        String validCode=request.getParameter("validCode");
        if(validCode!=null && StringUtils.isNotBlank(validCode)){
            CmsRoomOrder cmsRoomOrder  =cmsRoomOrderService.queryValidateCode(validCode, Constant.BOOK_STATUS1);
            if(cmsRoomOrder!=null) {
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("bookStatus", cmsRoomOrder.getBookStatus() != null ? cmsRoomOrder.getBookStatus() : "");
                map.put("tuserTeamName", cmsRoomOrder.getTuserTeamName() != null ? cmsRoomOrder.getTuserTeamName() : "");
                map.put("roomOrderNo", cmsRoomOrder.getOrderNo() != null ? cmsRoomOrder.getOrderNo() : "");
                map.put("venueName", cmsRoomOrder.getVenueName() != null ? cmsRoomOrder.getVenueName() : "");
                map.put("venueAddress", cmsRoomOrder.getVenueAddress() != null ? cmsRoomOrder.getVenueAddress() : "");
                //预定场次  还有预定人数 费用
                long curDate = cmsRoomOrder.getCurDate().getTime();
                map.put("curDate", curDate / 1000);
                map.put("openPeriod", cmsRoomOrder.getOpenPeriod() != null ? cmsRoomOrder.getOpenPeriod() : "");
                map.put("validCode", cmsRoomOrder.getValidCode() != null ? cmsRoomOrder.getValidCode() : "");
                map.put("userTel", cmsRoomOrder.getUserTel() != null ? cmsRoomOrder.getUserTel() : "");
                map.put("roomName", cmsRoomOrder.getRoomName() != null ? cmsRoomOrder.getRoomName() : "");
                listMap.add(map);
            }else{
                json=JSONResponse.commonResultFormat(14113,"活动室订单取票码有误",null);
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().print(json);
                return null;
            }
        }else{
            json=JSONResponse.commonResultFormat(14112,"活动室订单取票码缺失",null);
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().print(json);
            return null;
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(JSONResponse.toAppResultFormat(0, listMap));
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

}