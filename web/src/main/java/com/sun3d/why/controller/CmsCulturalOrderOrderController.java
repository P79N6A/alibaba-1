package com.sun3d.why.controller;

import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.CmsCulturalOrder;
import com.sun3d.why.model.CmsCulturalOrderOrder;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CmsCulturalOrderOrderService;
import com.sun3d.why.service.CmsCulturalOrderService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@RequestMapping("/culturalOrderOrder")
@Controller
public class CmsCulturalOrderOrderController {
    private Logger logger = LoggerFactory.getLogger(CmsCulturalOrderOrderController.class);


    @Autowired
    private CmsCulturalOrderOrderService cmsCulturalOrderOrderService;
    
    @Autowired
    private CmsCulturalOrderService cmsCulturalOrderService;
    
    /**
     * 文化云3.4前端   首页活动列表查询
     *
     * @return
     */
    @RequestMapping("/culturalOrderOrderList")
    @ResponseBody
    public String culturalOrderOrderList(HttpServletRequest request, String culturalOrderId) {
        JSONObject jsonObject = new JSONObject();
        try {
    		List<CmsCulturalOrderOrder> culturalOrderOrderList = cmsCulturalOrderOrderService.queryOrderOrderListByCulturalOrderId(culturalOrderId);
    		jsonObject.put("list", culturalOrderOrderList);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return jsonObject.toString();
    }
    
    /**
     * 加载报名页面
     * @param culturalOrderId
     * @return
     */
    @RequestMapping("/preAddUserOrder")
    public ModelAndView preAddUserOrder(String culturalOrderId, String culturalOrderEventId, String culturalOrderEventDate, String culturalOrderEventTime, Integer eventTicketNum, Integer usedTicketNum){
    	ModelAndView mv = new ModelAndView();
    	mv.addObject("culturalOrderId", culturalOrderId);
    	mv.addObject("culturalOrderEventId", culturalOrderEventId);
    	mv.addObject("culturalOrderEventDate", culturalOrderEventDate);
    	mv.addObject("culturalOrderEventTime", culturalOrderEventTime);
    	mv.addObject("eventTicketNum", eventTicketNum);
    	mv.addObject("usedTicketNum", usedTicketNum);
    	Integer eventAvailableTicketNum = eventTicketNum - usedTicketNum;
    	mv.addObject("eventAvailableTicketNum", eventAvailableTicketNum);
    	mv.setViewName("index/culturalOrder/bmFormPop");
    	
    	CmsCulturalOrder order = cmsCulturalOrderService.queryCulturalOrderById(culturalOrderId, 1, "");
    	mv.addObject("culturalOrderMustKnow", order.getCulturalOrderMustKnow());
    	
    	return mv;
    }
    
    /**
     * 添加订单
     * @param culturalOrderId
     * @return
     */
    @RequestMapping("/addUserOrder")
    @ResponseBody
    public String addUserOrder(HttpServletRequest request, CmsCulturalOrderOrder order){
//    	String culturalOrderId 			= request.getParameter("culturalOrderId");
//    	String culturalOrderEventId 	= request.getParameter("culturalOrderEventId");
//    	String userDescription 			= request.getParameter("userDescription");
    	CmsTerminalUser user = (CmsTerminalUser) request.getSession().getAttribute(Constant.terminalUser);
    	String userId = "";
    	if (user != null){
    		userId = user.getUserId();
    		order.setCulturalOrderOrderId(UUIDUtils.createUUId());
            order.setCreateTime(new Date());
    		order.setUserId(userId);
    		Integer result = cmsCulturalOrderOrderService.addCulturalOrderOrder(order);
    		if(result > 0){
    			return Constant.RESULT_STR_SUCCESS;
    		}else{
    			return Constant.RESULT_STR_FAILURE;
    		}
    	}else{
    		return Constant.RESULT_STR_NOACTIVE;
    	}
    		
    }
    
    /**
     * 根据largeType显示页面
     * @param request
     * @param culturalOrderLargeType
     * @return
     */
    @RequestMapping(value="/culturalOrderUserOrderList")
    public ModelAndView culturalOrderUserOrderList(HttpServletRequest request, Integer culturalOrderLargeType){
    	ModelAndView mv = new ModelAndView();
    	mv.addObject("culturalOrderLargeType", culturalOrderLargeType);
    	CmsTerminalUser user = (CmsTerminalUser) request.getSession().getAttribute(Constant.terminalUser);
    	if (user != null){
    		user.getUserId();
    		mv.setViewName("index/culturalOrder/userOrderList");
    	}else{
    		mv.setViewName("redirect:/frontTerminalUser/userLogin.do");
    	}
    	return mv;
    }
    
    /**
     * 获取用户点单
     * @return
     */  
    @RequestMapping(value="/loadUserOrderList")
    public ModelAndView loadUserOrderList(HttpServletRequest request, Pagination page){
    	ModelAndView mv = new ModelAndView();
       
    	Integer culturalOrderLargeType = Integer.valueOf(request.getParameter("culturalOrderLargeType"));
        page.setRows(3);
    	CmsTerminalUser user = (CmsTerminalUser) request.getSession().getAttribute(Constant.terminalUser);
    	if (user != null){
    		List<CmsCulturalOrderOrder> culturalOrderOrderList = cmsCulturalOrderOrderService.queryOrderOrderListByUserId(culturalOrderLargeType, user.getUserId(), page);
    		mv.addObject("culturalOrderOrderList", culturalOrderOrderList);
            mv.addObject("page", page);
            mv.setViewName("/index/culturalOrder/userCulturalOrderOrderLoad");
    	}else{
    		mv.setViewName("redirect:/culturalOrder/culturalOrderIndex.do");
    	}
        
        return mv;
    }
    
    @RequestMapping("/addUserInvitaionOrder")
    public ModelAndView addUserInvitaionOrder(HttpServletRequest request, String culturalOrderId, String culturalOrderDate, Integer culturalOrderDemandLimit, String culturalOrderAreaLimit){
    	ModelAndView mv = new ModelAndView();
    	CmsTerminalUser user = (CmsTerminalUser) request.getSession().getAttribute(Constant.terminalUser);
    	if (user != null){
    		mv.addObject("culturalOrderId", culturalOrderId);
    		mv.addObject("culturalOrderDate", culturalOrderDate);
    		mv.addObject("culturalOrderDemandLimit", culturalOrderDemandLimit);
    		mv.addObject("culturalOrderAreaLimit", culturalOrderAreaLimit);
    		CmsCulturalOrder order = cmsCulturalOrderService.queryCulturalOrderById(culturalOrderId, 2, user.getUserId());
        	mv.addObject("culturalOrderMustKnow", order.getCulturalOrderMustKnow());
    		mv.setViewName("index/culturalOrder/yqFormPop");
    	}
    	return mv;
    }
    
    @RequestMapping("/cancelCulturalOrderOrder")
    @ResponseBody
    public String cancelCulturalOrderOrder(HttpServletRequest request, String culturalOrderOrderId){
    	CmsTerminalUser user = (CmsTerminalUser) request.getSession().getAttribute(Constant.terminalUser);
    	String resultStr = "";
    	if (user != null){
    		Integer result = cmsCulturalOrderOrderService.cancelCulturalOrderOrder(culturalOrderOrderId);
    		if(result > 0){
    			resultStr = Constant.RESULT_STR_SUCCESS;
    		}else{
    			resultStr = Constant.RESULT_STR_FAILURE;
    		}
    	}else{
    		resultStr = Constant.RESULT_STR_NOACTIVE;
    	}
    	return resultStr;
    }
    
    @RequestMapping("/getOrderReply")
    @ResponseBody
    public String getOrderReply(String culturalOrderOrderId){
    	CmsCulturalOrderOrder order = cmsCulturalOrderOrderService.queryOrderOrderById(culturalOrderOrderId);
    	String result = order.getCulturalOrderReply();
    	return result;
    }
}
