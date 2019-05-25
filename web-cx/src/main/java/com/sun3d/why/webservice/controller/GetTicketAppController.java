package com.sun3d.why.webservice.controller;
import com.sun3d.why.util.*;
import com.sun3d.why.webservice.service.ActivityAppOrderService;
import com.sun3d.why.webservice.service.RoomAppOrderService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.servlet.http.HttpServletResponse;
/**
 * 取票机取票
 */
@RequestMapping("/ticket")
@Controller
public class GetTicketAppController {
    @Autowired
    private ActivityAppOrderService activityOrderAppService;
    @Autowired
    private RoomAppOrderService roomAppOrderService;
    /**
     * 取票机获取订单详情
     * @param orderValidateCode 取票码
     * @return json  14112.订单参数缺失 14113取票码有误
     * @throws Exception
     */
    @RequestMapping(value = "/orderDetails")
    public String queryOrderDetails(HttpServletResponse response, String orderValidateCode) throws Exception {
        String json = "";
        if (orderValidateCode!=null && StringUtils.isNotBlank(orderValidateCode)) {
            json = activityOrderAppService.queryAppOrderDetails(orderValidateCode);
        }else {
            json= JSONResponse.toAppResultFormat(14112, "取票码缺失");
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }


    /**
     * 取票机活动取票流程
     * @param validateCode 取票码
     * @param seats 座位号
     * @return json  14112.取票码参数缺失 14113取票码有误
     */
    @RequestMapping(value = "/activeOrderTake")
    public String activeOrderTake(HttpServletResponse response, String validateCode,String seats,int i,String machineCode) throws Exception {
        String json = "";
        if (validateCode != null && StringUtils.isNotBlank(seats)) {
            json = activityOrderAppService.takeAppActivityValidateCode(validateCode, seats, i,machineCode);
            System.out.print("json数据"+json);
        }else {
            json= JSONResponse.toAppResultFormat(14112, "取票码缺失");
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    /**
     * 取票机活动室取票流程
     * @param validateCode 取票码
     * @return json  14112.取票码参数缺失 14113取票码有误
     */
    @RequestMapping(value = "/roomOrderTake")
    public String roomOrderTake(HttpServletResponse response, String validateCode) throws Exception {
        String json = "";
        if (validateCode != null && StringUtils.isNotBlank(validateCode)) {
            json = roomAppOrderService.takeAppRoomValidateCode(validateCode);
            System.out.print("json数据"+json);
        }else {
            json= JSONResponse.toAppResultFormat(14112, "取票码缺失");
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }


}
