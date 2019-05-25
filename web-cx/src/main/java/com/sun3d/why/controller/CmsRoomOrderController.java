package com.sun3d.why.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.enumeration.UserOperationEnum;
import com.sun3d.why.model.CmsActivityRoom;
import com.sun3d.why.model.CmsRoomBook;
import com.sun3d.why.model.CmsRoomOrder;
import com.sun3d.why.model.CmsTeamUser;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsUserOperatorLog;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsActivityRoomService;
import com.sun3d.why.service.CmsRoomBookService;
import com.sun3d.why.service.CmsRoomOrderService;
import com.sun3d.why.service.CmsTeamUserService;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.CmsUserOperatorLogService;
import com.sun3d.why.service.CmsVenueService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.DateUtils;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.SmsUtil;

/**
 * Created by lt on 2015/7/8.
 */

@RequestMapping("/cmsRoomOrder")
@Controller
public class CmsRoomOrderController {

    @Autowired
    private HttpSession session;

    @Autowired
    private CmsRoomOrderService cmsRoomOrderService;
    
    @Autowired
    private CmsRoomBookService cmsRoomBookService;
    
    @Autowired
    private CmsVenueService cmsVenueService;
    
    @Autowired
    private CmsActivityRoomService cmsActivityRoomService;
    
    @Autowired
    private CmsTerminalUserService terminalUserService;
    
    @Autowired
    private CmsTeamUserService teamUserService;
    
    @Autowired
    private CmsUserOperatorLogService cmsUserOperatorLogService;
    @Autowired
	private SmsUtil SmsUtil;

    private Logger logger = Logger.getLogger(CmsRoomOrderController.class);

    /**
     * @param roomId
     * @param page
     * @param cmsRoomOrder
     * @return
     */
    @RequestMapping("/queryAllRoomOrderList")
    public ModelAndView queryAllRoomOrderList(String roomId,Pagination page,CmsRoomOrder cmsRoomOrder){
        ModelAndView modelAndView = new ModelAndView();
        List<CmsRoomOrder> cmsRoomOrderList = null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        try {
            SysUser user = (SysUser) session.getAttribute("user");
            if(user != null){
                cmsRoomOrderList = cmsRoomOrderService.queryAllRoomOrderList(roomId,page,cmsRoomOrder);
            }
        } catch (Exception e){
            logger.error("加载活动室订单失败!",e);
        }
        modelAndView.addObject("now",sdf.format(new Date()));
        modelAndView.addObject("cmsRoomOrderList",cmsRoomOrderList);
        modelAndView.addObject("page",page);
        modelAndView.addObject("roomId",roomId);
        modelAndView.setViewName("admin/activityRoom/activityRoomOrderList");
        return modelAndView;
    }

    /**
     * 取消预定订单
     * @param roomOrderId
     * @return
     */
    @RequestMapping(value = "/cancelRoomOrder")
    @ResponseBody
    public String cancelRoomOrder(String roomOrderId){
        String result = Constant.RESULT_STR_FAILURE;

        SysUser sysUser = (SysUser)session.getAttribute("user");
        if(sysUser != null){
            boolean cancelResult = cmsRoomOrderService.cancelRoomOrder(roomOrderId,sysUser.getUserNickName());
            if(cancelResult){
            	
            	CmsUserOperatorLog record =CmsUserOperatorLog.createInstance(null, roomOrderId, null, sysUser.getUserId(), CmsUserOperatorLog.USER_TYPE_ADMIN, UserOperationEnum.CANCEL); 
                
            	cmsUserOperatorLogService.insert(record);
            	
                result = Constant.RESULT_STR_SUCCESS;
            }
        }else {
            logger.info("当前没有用户登录，取消订单操作取消!");
        }
        return result;
    }


    /**
     * 删除预定订单
     * @param roomOrderId
     * @return
     */
    @RequestMapping(value = "/deleteRoomOrder")
    @ResponseBody
    public String deleteRoomOrder(String roomOrderId){
        String result = Constant.RESULT_STR_FAILURE;

        SysUser sysUser = (SysUser)session.getAttribute("user");
        if(sysUser != null){
//            int deleteCount = cmsRoomOrderService.deleteRoomOrder(roomOrderId);
//            if(deleteCount > 0){
//                result = Constant.RESULT_STR_SUCCESS;
//            }
        }else {
            logger.info("当前没有用户登录，删除订单操作取消!");
        }
        return result;
    }


    /**
     * 删除预定订单
     * @param roomOrderId
     * @return
     */
    @RequestMapping(value = "/logicalDeleteRoomOrder")
    @ResponseBody
    public String logicalDeleteRoomOrder(String roomOrderId){
        String result = Constant.RESULT_STR_FAILURE;

        SysUser sysUser = (SysUser)session.getAttribute("user");
        if(sysUser != null){

            CmsRoomOrder cmsRoomOrder = cmsRoomOrderService.queryCmsRoomOrderById(roomOrderId);
            //订单状态为4代表已逻辑删除
            cmsRoomOrder.setBookStatus(4);
            cmsRoomOrder.setOrderUpdateTime(new Date());
            cmsRoomOrder.setOrderUpdateUser(sysUser.getUserNickName());
            int editCount = cmsRoomOrderService.editCmsRoomOrder(cmsRoomOrder);
            if(editCount > 0){
                result = Constant.RESULT_STR_SUCCESS;
            }
        }else {
            logger.info("当前没有用户登录，删除订单操作取消!");
        }
        return result;
    }
    
    /**
     * 发送短消息接口
     *
     * @param roomOrderId
     * @return
     */
    @RequestMapping("/sendSmsMessage")
    @ResponseBody
    public String sendSmsMessage(String roomOrderId) {
        return cmsRoomOrderService.selectPhoneByRoomOrderId(roomOrderId);
    }
    
   
    @RequestMapping("/roomOrderCheckIndex")
    public ModelAndView roomOrderCheckIndex(Integer userType,Integer tuserIsDisplay,
    		String curDateStart,String curDateEnd,
    		String orderCreateTimeStart,String orderCreateTimeEnd,
    		String roomName,
    		Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
          
            List<CmsRoomOrder> roomOrderList= cmsRoomOrderService.queryRoomOrderCheck(sysUser,userType, tuserIsDisplay, curDateStart, curDateEnd, orderCreateTimeStart, orderCreateTimeEnd, roomName, page);

            model.addObject("roomOrderList", roomOrderList);
            
            model.addObject("userType", userType);
            model.addObject("tuserIsDisplay", tuserIsDisplay);
            model.addObject("curDateStart", curDateStart);
            model.addObject("curDateEnd", curDateEnd);
            model.addObject("orderCreateTimeStart", orderCreateTimeStart);
            model.addObject("orderCreateTimeEnd", orderCreateTimeEnd);
            model.addObject("roomName", roomName);
            
            model.addObject("page", page);
            
            
            model.setViewName("admin/roomOrder/roomCheckOrder");
        } catch (Exception e) {
            logger.error("roomOrderCheckIndex error {}", e);
        }
        return model;
    }
    
    @RequestMapping("/roomOrderIndex")
    public ModelAndView roomOrderIndex(Integer userType,Integer tuserIsDisplay,
    		String curDateStart,String curDateEnd,
    		String orderCreateTimeStart,String orderCreateTimeEnd,
    		String roomName,
    		Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
          
            List<CmsRoomOrder> roomOrderList= cmsRoomOrderService.queryRoomOrder(sysUser,userType, tuserIsDisplay, curDateStart, curDateEnd, orderCreateTimeStart, orderCreateTimeEnd, roomName, page);

            model.addObject("roomOrderList", roomOrderList);
            
            model.addObject("userType", userType);
            model.addObject("tuserIsDisplay", tuserIsDisplay);
            model.addObject("curDateStart", curDateStart);
            model.addObject("curDateEnd", curDateEnd);
            model.addObject("orderCreateTimeStart", orderCreateTimeStart);
            model.addObject("orderCreateTimeEnd", orderCreateTimeEnd);
            model.addObject("roomName", roomName);
            
            model.addObject("page", page);
            
            
            model.setViewName("admin/roomOrder/roomOrder");
        } catch (Exception e) {
            logger.error("roomOrderIndex error {}", e);
        }
        return model;
    }
    
    @RequestMapping("/roomOrderHistoryIndex")
    public ModelAndView roomOrderHistoryIndex(Integer bookStatus,Integer userType,Integer tuserIsDisplay,
    		String curDateStart,String curDateEnd,
    		String orderCreateTimeStart,String orderCreateTimeEnd,
    		String roomName,
    		Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
          
            List<CmsRoomOrder> roomOrderList= cmsRoomOrderService.queryRoomOrderHistory(sysUser,bookStatus,userType, tuserIsDisplay, curDateStart, curDateEnd, orderCreateTimeStart, orderCreateTimeEnd, roomName, page);

            model.addObject("roomOrderList", roomOrderList);
            
            model.addObject("userType", userType);
            model.addObject("tuserIsDisplay", tuserIsDisplay);
            model.addObject("curDateStart", curDateStart);
            model.addObject("curDateEnd", curDateEnd);
            model.addObject("orderCreateTimeStart", orderCreateTimeStart);
            model.addObject("orderCreateTimeEnd", orderCreateTimeEnd);
            model.addObject("roomName", roomName);
            model.addObject("bookStatus", bookStatus);
            
            
            model.addObject("page", page);
            
            
            model.setViewName("admin/roomOrder/roomOrderHistory");
        } catch (Exception e) {
            logger.error("roomOrderHistoryIndex error {}", e);
        }
        return model;
    }
    
    
    @RequestMapping(value = "/roomOrderDetail")
    public ModelAndView roomOrderDetail(@RequestParam String roomOrderId) throws Exception {
    	  ModelAndView model = new ModelAndView();
          try {
            
        	CmsRoomOrder cmsRoomOrder= cmsRoomOrderService.queryCmsRoomOrderById(roomOrderId);
        	  
  			// 活动室预定
  	    	CmsRoomBook cmsRoomBook = cmsRoomBookService.queryCmsRoomBookById(cmsRoomOrder.getBookId());
  	    	
  			 //获取场馆信息
  	    	CmsVenue cmsVenue = cmsVenueService.queryVenueById(cmsRoomOrder.getVenueId());
  	    	
  	    	CmsActivityRoom cmsActivityRoom = cmsActivityRoomService.queryCmsActivityRoomById(cmsRoomOrder.getRoomId());
        	  
  	    	CmsTerminalUser cmsTerminalUser=terminalUserService.queryTerminalUserById(cmsRoomOrder.getUserId());
        	
  	    	if(StringUtils.isNotBlank(cmsRoomOrder.getTuserId()))
  	    	{
  	    		CmsTeamUser teamUser=teamUserService.queryTeamUserById(cmsRoomOrder.getTuserId());
  	    		
  	    		model.addObject("teamUser", teamUser);
  	    	}
  	    	
  	    	model.addObject("user", cmsTerminalUser);
  	    	
  	    	model.addObject("cmsRoomOrder", cmsRoomOrder);
  	    	
  	    	Integer dayOfWeek =cmsRoomBook.getDayOfWeek();
	    	
	    	Date curDate=cmsRoomBook.getCurDate();
	    	
	    	String date=getBookDateStr(curDate,dayOfWeek);
	    	
	    	model.addObject("date", date);
  	    	
  	    	model.addObject("cmsRoomOrder", cmsRoomOrder);
        	
        	model.addObject("cmsRoomBook", cmsRoomBook);
        	
        	model.addObject("cmsVenue", cmsVenue);
        	
        	model.addObject("cmsActivityRoom", cmsActivityRoom);
        	
        	CmsUserOperatorLog modelLog=new CmsUserOperatorLog();
        	
        	modelLog.setOrderId(roomOrderId);
        	
        	List<CmsUserOperatorLog> logList=cmsUserOperatorLogService.queryCmsUserOperatorLogByModel(modelLog);
        	  
        	model.addObject("logList", logList);
        	
        	model.setViewName("admin/roomOrder/roomOrderDetail");
        	  
          } catch (Exception e) {
              logger.error("roomOrderDetailCheck error {}", e);
          }
          return model;
    }
    
    /**
     * 打开拒绝页面 
     * @param roomOrderId
     * @return
     */
    @RequestMapping("/refuse")
    public ModelAndView refuse(@RequestParam String roomOrderId){
    	
    	  ModelAndView model = new ModelAndView();
    	  
    	  try {
    		  
    	      model.addObject("roomOrderId", roomOrderId);
    	      
    	      model.setViewName("admin/roomOrder/refuse");
    		  
    	  } catch (Exception e) {
              logger.info("refuse error" + e);
          }
    	  return model;
    }
    
    /**
     * 提交拒绝理由 
     * @param cmsRoomOrder
     * @param text
     * @return
     */
    @RequestMapping("/subRefuse")
    @ResponseBody
    public int subRefuse(CmsRoomOrder cmsRoomOrder,String text){
    	
    	int result=0;
    	
    	  try {  
    		  SysUser sysUser = (SysUser)session.getAttribute("user");
		      
    		  
    		 if(sysUser != null){
		        	
    			 result= cmsRoomOrderService.editCmsRoomOrder(cmsRoomOrder);
        		 
        		 if(result>0)
        		 {
        		       CmsUserOperatorLog log=CmsUserOperatorLog.createInstance(null, cmsRoomOrder.getRoomOrderId(), null, sysUser.getUserId(), CmsUserOperatorLog.USER_TYPE_ADMIN, UserOperationEnum.CHECK_NOT_PASS);
        		        	
        		        cmsUserOperatorLogService.insert(log);
        		        	
        		        CmsRoomOrder roomOrder=cmsRoomOrderService.queryCmsRoomOrderById(cmsRoomOrder.getRoomOrderId());
        		            
        		        CmsActivityRoom room=cmsActivityRoomService.queryCmsActivityRoomById(roomOrder.getRoomId());
        		        
        		        CmsRoomBook cmsRoomBook=cmsRoomBookService.queryCmsRoomBookById(roomOrder.getBookId());
        		            
        		        CmsVenue venue=cmsVenueService.queryVenueById(roomOrder.getVenueId());
        		        		
        		        	Map<String,Object> map=new HashMap<String, Object>();
        		        	
        		        	map.put("userName",roomOrder.getUserName());
        		        	map.put("venue",venue.getVenueName());
        		        	map.put("activity",room.getRoomName());
        		        	map.put("time",DateUtils.formatDate(cmsRoomBook.getCurDate())+","+cmsRoomBook.getOpenPeriod());
        		        	map.put("content", StringUtils.isBlank(text)?"管理员取消":text);
        		        	
        		            SmsUtil.manCancelRoomOrder(roomOrder.getUserTel(), map);
        		   }
    		  
    			  
    		 }
    		  
    	  } catch (Exception e) {
              logger.info("subRefuse error" + e);
              
              result=-1;
          }
    	return result;
    }
    
    @RequestMapping("/editRoomOrder")
    @ResponseBody
    public int editRoomOrder(CmsRoomOrder cmsRoomOrder){
    	
    	int result=0;
    	
    	  try {  
    		  
    		 result= cmsRoomOrderService.editCmsRoomOrder(cmsRoomOrder);
    		  
    	  } catch (Exception e) {
              logger.info("editRoomOrder error" + e);
              
              result=-1;
          }
    	return result;
    }
    
    /**
     * 订单审核通过
     * 
     * @param roomOrderId
     * @return
     */
    @RequestMapping("/checkPass")
    @ResponseBody
    public int checkPass(@RequestParam String roomOrderId){
    	
        SysUser sysUser = (SysUser)session.getAttribute("user");
        if(sysUser != null&&StringUtils.isNotBlank(sysUser.getUserId())){
        	
        	return  cmsRoomOrderService.checkPass(roomOrderId,sysUser);
        }
    	
    	return 0;
    }
    
    /**
     * 获取活动室中文显示日期
     * 
     * @param curDate
     * @param dayOfWeek
     * @return
     */
    private String getBookDateStr(Date curDate,Integer dayOfWeek)
    {
    	SimpleDateFormat formatter = new SimpleDateFormat("yyyy年MM月dd日");
        String strDate = formatter.format(curDate);
        
        String[] weekDays = {"周一", "周二", "周三", "周四", "周五", "周六", "周日"};
        
        String date=""+strDate+" "+weekDays[dayOfWeek-1];
        
        return date;
    }

}
