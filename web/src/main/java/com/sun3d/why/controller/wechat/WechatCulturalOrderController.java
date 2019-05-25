package com.sun3d.why.controller.wechat;

import com.sun3d.why.model.CmsApplyJoinTeam;
import com.sun3d.why.model.CmsCulturalOrder;
import com.sun3d.why.model.CmsCulturalOrderEvent;
import com.sun3d.why.model.CmsCulturalOrderOrder;
import com.sun3d.why.service.*;
import com.sun3d.why.util.*;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@RequestMapping("/wechatCulturalOrder")
@Controller
public class WechatCulturalOrderController {
    private Logger logger = LoggerFactory.getLogger(WechatCulturalOrderController.class);

    @Autowired
    private HttpSession session;
    @Autowired
    private CacheService cacheService;
    @Autowired
    CmsCulturalOrderService cmsCulturalOrderService;
    @Autowired
    CmsCulturalOrderEventService cmsCulturalOrderEventService;
    @Autowired
    CmsCulturalOrderOrderService cmsCulturalOrderOrderService;
    @Autowired
    CmsTeamUserService cmsTeamUserService;

    /**
     * 我要参与
     * @return
     */
    @RequestMapping("/culturalCyOrderIndex")
    public String culturalCyOrderIndex(HttpServletRequest request) {
    	//微信权限验证配置
    	String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);
        return "wechat/culturalOrder/culturalCyOrderIndex";
    }
    
    /**
     * 我要邀请
     * @return
     */
    @RequestMapping("/culturalYqOrderIndex")
    public String culturalYqOrderIndex(HttpServletRequest request) {
    	//微信权限验证配置
    	String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);
        return "wechat/culturalOrder/culturalYqOrderIndex";
    }
    
 	@RequestMapping("culturalOrderList")
 	public String culturalOrderList(HttpServletResponse response,CmsCulturalOrder cmsCulturalOrder,Pagination page,Integer orderType) throws IOException{
 		SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
 		String json ="";
 		try {
 			List<CmsCulturalOrder> orderList = cmsCulturalOrderService.queryCulturalOrderList(cmsCulturalOrder, page, orderType,null);
 			if (cmsCulturalOrder.getCulturalOrderLargeType() == 1) {							 			
	 			for (CmsCulturalOrder order : orderList) {
					order.setStartDateStr(sdf.format(order.getStartDate()));
					order.setEndDateStr(sdf.format(order.getEndDate()));
				}
 			}
 			
 			if (cmsCulturalOrder.getCulturalOrderLargeType() == 2) {							 			
	 			for (CmsCulturalOrder order : orderList) {
					order.setStartDateStr(sdf.format(order.getCulturalOrderStartDate()));
					order.setEndDateStr(sdf.format(order.getCulturalOrderEndDate()));
				}
 			}
 			
 			json = JSONResponse.toAppResultFormat(200, orderList);
 		} catch (Exception e) {
            e.printStackTrace();
            logger.info("culturalOrderList error"+e.getMessage());
            json = JSONResponse.toAppResultFormat(500,e.getMessage());
        }
 		 response.setContentType("text/html;charset=UTF-8");
         response.getWriter().write(json);
         response.getWriter().flush();
         response.getWriter().close();
         return null;
 	}
 	
 	/**
     * 详情
     * @return
     */
    @RequestMapping("/culturalOrderDetail")
    public String culturalOrderDetail(HttpServletRequest request,String culturalOrderId,Integer culturalOrderLargeType,String userId) {
    	//微信权限验证配置
    	String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);
    	String urlString = "";
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
    	CmsCulturalOrder order = cmsCulturalOrderService.queryCulturalOrderById(culturalOrderId, culturalOrderLargeType, userId);   	      
    		if (culturalOrderLargeType == 1) {							 			
				order.setStartDateStr(sdf.format(order.getStartDate()));
				order.setEndDateStr(sdf.format(order.getEndDate()));
				List<CmsCulturalOrderEvent> events = cmsCulturalOrderEventService.queryCulturalOrderEventByCulturalOrderId(culturalOrderId, userId);
				
				String ifend = "1";//1:没过期 2:已过期
				if(events!=null&&events.size()>0){
		    		SimpleDateFormat sdfe = new SimpleDateFormat("yyyy.MM.dd HH:mm");
		    		try {
						Date endDate = sdfe.parse(sdf.format(order.getEndDate()) + " " + events.get(events.size()-1).getCulturalOrderEventTime().substring(6));
						Date nowDate = sdfe.parse(sdfe.format(new Date()));
						if(endDate.getTime()<nowDate.getTime()){
							ifend = "0";
						}
		    		} catch (ParseException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
		    	}
				request.setAttribute("ifend", ifend);
				
				request.setAttribute("events", events);
		    	
		    	urlString = "wechat/culturalOrder/culturalCyOrderDetail";
			}
    		if (culturalOrderLargeType == 2) {							 			
				order.setStartDateStr(sdf.format(order.getCulturalOrderStartDate()));
				order.setEndDateStr(sdf.format(order.getCulturalOrderEndDate()));
		    	
				urlString = "wechat/culturalOrder/culturalYqOrderDetail";
			}
    		 request.setAttribute("culturalOrderLargeType", culturalOrderLargeType);
    		 request.setAttribute("order", order);
    		 
    		 return urlString;
    }   
    
    /**
     * 报名
     * @return
     */
    @RequestMapping("/culturalOrderApplyIndex")
    public String culturalOrderApplyIndex(HttpServletRequest request,String culturalOrderId,Integer culturalOrderLargeType,String userId) {
    	String urlString = "";
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    	CmsCulturalOrder order = cmsCulturalOrderService.queryCulturalOrderById(culturalOrderId, culturalOrderLargeType, userId);   	      
    		if (culturalOrderLargeType == 1) {							 			
				order.setStartDateStr(sdf.format(order.getStartDate()));
				order.setEndDateStr(sdf.format(order.getEndDate()));
		    	
		    	urlString = "wechat/culturalOrder/culturalCyOrderApplyIndex";
			}
    		if (culturalOrderLargeType == 2) {							 			
				order.setStartDateStr(sdf.format(order.getCulturalOrderStartDate()));
				order.setEndDateStr(sdf.format(order.getCulturalOrderEndDate()));
		    	
				urlString = "wechat/culturalOrder/culturalYqOrderApplyIndex";
			}
    		 request.setAttribute("culturalOrderLargeType", culturalOrderLargeType);
    		 request.setAttribute("order", order);
    		 
    		 return urlString;
    }

    /**
     * 服务时间
     * @return
     * @throws Exception 
     */
    @RequestMapping("/queyOrderEventList")
    public String queyOrderEventList(HttpServletResponse response,String culturalOrderId,String userId) throws Exception {
    	 String json = "";
         try {
             if (StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(culturalOrderId)) {
            	 List<CmsCulturalOrderEvent> events = cmsCulturalOrderEventService.queryCulturalOrderEventByCulturalOrderId(culturalOrderId, userId);
            	 json =JSONResponse.toAppResultFormat(200, events);
             } else {
                 json = JSONResponse.commonResultFormat(500, "参数缺失", null);
             }
         } catch (Exception e) {
             e.printStackTrace();
             json = JSONResponse.commonResultFormat(500, "查询失败", null);
         }
         response.setContentType("text/html;charset=UTF-8");
         response.getWriter().print(json);
         response.getWriter().flush();
         response.getWriter().close();
         return null;
    }
    
    /**
     * 提交报名
     * @return
     * @throws Exception 
     */
    @RequestMapping("/addCulturalOrderOrder")
    public String addCulturalOrderOrder(HttpServletResponse response,CmsCulturalOrderOrder order,Integer culturalOrderDemandLimit,String culturalOrderOrderDateStr,CmsApplyJoinTeam applyJoinTeam) throws Exception {
    	 String json = "";
    	 int cs = 0;
         try {
        	 if (StringUtils.isNotBlank(culturalOrderOrderDateStr)) {
        		 order.setCulturalOrderOrderDate(DateUtils.Convert(culturalOrderOrderDateStr));
			}      
        	 if (StringUtils.isNotBlank(order.getUserId())) {
        		  if (order.getCulturalOrderLargeType() == 2 && culturalOrderDemandLimit == 2) {
					 applyJoinTeam.setApplyCheckState(3);
	        		 applyJoinTeam.setUserId(order.getUserId());
	        		 int ct = cmsTeamUserService.queryMyManagerTeamUserCount(applyJoinTeam,2,1);
	        		 if (ct > 0) {
	        			  cs = cmsCulturalOrderOrderService.addCulturalOrderOrder(order);
					}else {
						  cs = 102411;
					}   
				} else {
					 cs = cmsCulturalOrderOrderService.addCulturalOrderOrder(order);
				}      		    		 
			} 
        	 json =JSONResponse.toAppResultFormat(200, cs);	            	
         } catch (Exception e) {
             e.printStackTrace();
             json = JSONResponse.commonResultFormat(500, "查询失败", null);
         }
         response.setContentType("text/html;charset=UTF-8");
         response.getWriter().print(json);
         response.getWriter().flush();
         response.getWriter().close();
         return null;
    }
    
    /**
     * 报名成功页面
     * @return
     */
    @RequestMapping("/culturalOrderWinIndex")
    public String culturalOrderWinIndex(HttpServletRequest request,String culturalOrderId,Integer culturalOrderLargeType) {
    	request.setAttribute("culturalOrderLargeType", culturalOrderLargeType);
		request.setAttribute("culturalOrderId", culturalOrderId);
    	
        return "wechat/culturalOrder/culturalOrderWinIndex";
    }
    
    /**
     * 我的报名
     * @return
     */
    @RequestMapping("/myCulturalOrderIndex")
    public String myCulturalOrderIndex(HttpServletRequest request,Integer culturalOrderLargeType) {
    	request.setAttribute("culturalOrderLargeType", culturalOrderLargeType);
    	
        return "wechat/culturalOrder/myCulturalOrderIndex";
    }
    
    /**
     * 我的订单列表
     * @return
     * @throws Exception 
     */
    @RequestMapping("/queryOrderOrderList")
    public String queryOrderOrderList(HttpServletResponse response,Integer culturalOrderLargeType,String userId,Pagination page) throws Exception {
    	 SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
    	 String json = "";
         try {
        	 List<CmsCulturalOrderOrder> orders = cmsCulturalOrderOrderService.queryOrderOrderListByUserId(culturalOrderLargeType,userId,page);
        	 if (culturalOrderLargeType == 1) {	
        		 for (CmsCulturalOrderOrder order : orders) {
					order.setCulturalOrderEventDateStr(sdf.format(order.getCulturalOrderEventDate()));
				}
 			}
     		if (culturalOrderLargeType == 2) {	
     			for (CmsCulturalOrderOrder order : orders) {
					order.setCulturalOrderOrderDateStr(sdf.format(order.getCulturalOrderOrderDate()));
				}
 			}
            	json =JSONResponse.toAppResultFormat(200, orders);
         } catch (Exception e) {
             e.printStackTrace();
             json = JSONResponse.commonResultFormat(500, "查询失败", null);
         }
         response.setContentType("text/html;charset=UTF-8");
         response.getWriter().print(json);
         response.getWriter().flush();
         response.getWriter().close();
         return null;
    }
    
    /**
     * 取消报名
     * @return
     * @throws Exception 
     */
    @RequestMapping("/cancelCulturalOrderOrder")
    public String cancelCulturalOrderOrder(HttpServletResponse response,String culturalOrderOrderId) throws Exception {
    	 String json = "";
         try {
            	int cs = cmsCulturalOrderOrderService.cancelCulturalOrderOrder(culturalOrderOrderId);
            	json =JSONResponse.toAppResultFormat(200, cs);
         } catch (Exception e) {
             e.printStackTrace();
             json = JSONResponse.commonResultFormat(500, "取消失败", null);
         }
         response.setContentType("text/html;charset=UTF-8");
         response.getWriter().print(json);
         response.getWriter().flush();
         response.getWriter().close();
         return null;
    }
}
