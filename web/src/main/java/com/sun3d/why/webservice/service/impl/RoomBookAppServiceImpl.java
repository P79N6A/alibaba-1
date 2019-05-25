package com.sun3d.why.webservice.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsActivityRoomMapper;
import com.sun3d.why.dao.CmsRoomBookMapper;
import com.sun3d.why.dao.CmsRoomOrderMapper;
import com.sun3d.why.dao.CmsTerminalUserMapper;
import com.sun3d.why.dao.CmsUserOperatorLogMapper;
import com.sun3d.why.dao.CmsVenueMapper;
import com.sun3d.why.enumeration.UserOperationEnum;
import com.sun3d.why.model.CmsActivityRoom;
import com.sun3d.why.model.CmsRoomBook;
import com.sun3d.why.model.CmsRoomOrder;
import com.sun3d.why.model.CmsTeamUser;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsUserOperatorLog;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.extmodel.RoomBookConfig;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CacheConstant;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsRoomBookService;
import com.sun3d.why.service.CmsTeamUserService;
import com.sun3d.why.service.CmsUserMessageService;
import com.sun3d.why.util.CompareTime;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.service.RoomBookAppService;

/**
 * 活动室预订信息
 */
@Service
@Transactional
public class RoomBookAppServiceImpl implements RoomBookAppService {
    private Logger logger = Logger.getLogger(RoomBookAppServiceImpl.class);
    @Autowired
    private CmsRoomBookMapper cmsRoomBookMapper;
    @Autowired
    private CacheService cacheService;
    @Autowired
    private CmsTerminalUserMapper userMapper;
    @Autowired
    private CmsVenueMapper cmsVenueMapper;
    @Autowired
    private CmsRoomOrderMapper cmsRoomOrderMapper;
    @Autowired
    private CmsUserMessageService userMessageService;
    @Autowired
    private CmsRoomBookService cmsRoomBookService;
    @Autowired
    private RoomBookConfig roomBookConfig;
    @Autowired
    private CmsActivityRoomMapper activityRoomMapper;
    
    @Autowired
    private CmsTeamUserService cmsTeamUserService;
    
    @Autowired
	private StaticServer staticServer;
    
    @Autowired
    private CmsUserOperatorLogMapper cmsUserOperatorLogMapper;
    
    /**
     * app根据条件查询活动室预订信息
     * @param roomId 活动室id
     * @param orderRoomDate  活动室预订日期
     * @return
     */
    @Override
    public String queryAppRoomBookByCondition(String roomId, String bookId,String userId) {
       Map<String,Object> result=new HashMap<String, Object>();
    	
    	//获取活动室信息
    	CmsActivityRoom cmsActivityRoom = activityRoomMapper.queryCmsActivityRoomById(roomId);
    	
    	 //获取场馆信息
    	CmsVenue cmsVenue = cmsVenueMapper.queryVenueById(cmsActivityRoom.getRoomVenueId());
    	
    	if(cmsVenue==null)
    	{
    		return JSONResponse.commonResultFormat(15102,"活动室已被删除，不能预订!",null);
    	}
    	 
    	// 活动室预订
    	CmsRoomBook cmsRoomBook = cmsRoomBookMapper.queryCmsRoomBookById(bookId);
    	
    	String price=null;
    	
    	if(cmsActivityRoom.getRoomIsFree()==1)
    	{
    		price="免费";
    	}
    	else
    		price=cmsActivityRoom.getRoomFee();
    	
    	
    	Integer dayOfWeek =cmsRoomBook.getDayOfWeek();
    	
    	Date curDate=cmsRoomBook.getCurDate();
    	
    	String date=getBookDateStr(curDate,dayOfWeek);
    	
		CmsTerminalUser cmsTerminalUser=userMapper.queryTerminalUserById(userId);
	
		List<CmsTeamUser> teamUserList=  cmsTeamUserService.queryTeamUserList(userId);
		
		List<Map<String,Object>> teamUserListMapList=new ArrayList();
		
		for (CmsTeamUser teamUser : teamUserList) {
			Map<String,Object> map=new HashMap<String,Object>();
			
			map.put("tuserId", teamUser.getTuserId());
			map.put("tuserName", teamUser.getTuserName());
			
			teamUserListMapList.add(map);
		}
		
		result.put("cmsRoomBookId", bookId);
		result.put("roomName", cmsActivityRoom.getRoomName());
		result.put("cmsVenueName", cmsVenue.getVenueName());
		// 场馆坐标经度
		result.put("venueLon", cmsVenue.getVenueLon());
		// 场馆坐标纬度
		result.put("venueLat", cmsVenue.getVenueLat());
		
		String roomPicUrl = "";
		if(StringUtils.isNotBlank(cmsActivityRoom.getRoomPicUrl())){
			roomPicUrl=staticServer.getStaticServerUrl()+cmsActivityRoom.getRoomPicUrl();
		}
		result.put("roomPicUrl",roomPicUrl);
		
 		result.put("date", date);
		
		result.put("openPeriod",cmsRoomBook.getOpenPeriod());
		
		result.put("teamList",teamUserListMapList);
		
		result.put("orderName", cmsTerminalUser.getUserNickName());
		result.put("orderTel", cmsTerminalUser.getUserMobileNo());
		
		
		result.put("price",price);
		
		
		
		return JSONResponse.toAppResultFormat(0, result);
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
        String weekCn=" 周";
        
        switch (dayOfWeek) {
		case 1:
			weekCn+="一";
			break;
		case 2:
			weekCn+="二";
			break;
		case 3:
			weekCn+="三";
			break;
		case 4:
			weekCn+="四";
			break;
		case 5:
			weekCn+="五";
			break;
		case 6:
			weekCn+="六";
			break;
		case 7:
			weekCn+="日";
			break;
		}
        
        String date=strDate+weekCn;
        
        return date;
    }

    
    /* (non-Javadoc)
     * @see com.sun3d.why.webservice.service.RoomBookAppService#appRoomOrderByCondition(java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String)
     */
    @Override
    @Transactional(isolation=Isolation.REPEATABLE_READ)
    public String appRoomOrderByCondition(String bookId, String teamUserId,String teamUserName, String userId, String orderName, String orderTel,String purpose) {
        String json = "";
        
        CmsTerminalUser cmsTerminalUser=userMapper.queryTerminalUserById(userId);
        
        int count = cmsRoomOrderMapper.getRoomBookCountOneDay(userId);
        if (count >= roomBookConfig.getMaxRoomBookCount()) {
            json=JSONResponse.commonResultFormat(1, "当日已预订五次，请明天再试！", null);
        } else{
            CmsRoomBook cmsRoomBook = cmsRoomBookMapper.queryCmsRoomBookById(bookId);
            
            if (cmsRoomBook != null) {
            
            CmsActivityRoom cmsActivityRoom  = activityRoomMapper.queryCmsActivityRoomById(cmsRoomBook.getRoomId());
            
            CmsVenue cmsVenue = cmsVenueMapper.queryVenueById(cmsActivityRoom.getRoomVenueId());
            
         // 预订状态
    		Integer bookStatus=cmsRoomBook.getBookStatus();
        	
        	// 活动室预订状态 (1-可选 2-已选 3-不可选)
    		if(bookStatus==null||bookStatus!=1)
    		{
    			return JSONResponse.commonResultFormat(15101,"该时间段不可预订活动室",null);
    		}
    		
    		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
    		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    		
    		Date date=new Date();
    		
    		String curDate=sdf.format(cmsRoomBook.getCurDate());
    		
    		
    		
    		int index = cmsRoomBook.getOpenPeriod().indexOf("-");
			
			String openPeriod=cmsRoomBook.getOpenPeriod().substring(0, index);
			
			String time=curDate+" "+openPeriod;
    		
    		String nowDate2=sdf2.format(date);
			int statusDate= CompareTime.timeCompare2(time, nowDate2);
			
			//返回 0 表示时间日期相同
			//返回 1 表示日期1>日期2
			//返回 -1 表示日期1<日期2
			if (statusDate==-1){
				
				return JSONResponse.commonResultFormat(15102,"该场次活动室已过期",null);
			}
        	
            //   tmpCmsRoomBook.setOrderNo(orderNo);
            cmsRoomBook.setTuserId(teamUserId);
            cmsRoomBook.setUserId(userId);
            cmsRoomBook.setUserName(orderName);
            cmsRoomBook.setUserTel(orderTel);	
            cmsRoomBook.setTuserName(teamUserName);
            
            //避免重复，生成唯一的ID值
           // cmsRoomBook.setsId(UUIDUtils.createUUId());
            //---------------*******************预订活动室
           // ActivityRoomBookClient activityRoomBookClient = new ActivityRoomBookClient();
           //JmsResult jmsResult = activityRoomBookClient.bookActivityRoom(cmsRoomBook, cacheService);
           
            //if (jmsResult.getSuccess()) {
                json= roomConfirm(cmsRoomBook,cmsVenue,cmsActivityRoom,cmsTerminalUser,purpose);

           // } else {
             //   if (jmsResult.getMessage().equals("server data error")) {
              //      jmsResult.setMessage("服务器数据异常!");
//                    final String finalRoomId = cmsRoomBook.getRoomId();
//                    Runnable runnable = new Runnable() {
//                        @Override
//                        public void run() {
//                            setRoomBookToRedis(finalRoomId);
//                        }
//                    };
//                    Thread thread = new Thread(runnable);
//                    thread.start();
//                    logger.info("预订失败!" + jmsResult.getMessage());
//                    json = JSONResponse.commonResultFormat(2, jmsResult.getMessage(), null);
//                } else if (jmsResult.getMessage().equals("occupied")) {
//                    //如果当前活动室之前已被预订但是MQ或其它通信异常导致数据库段没有成功预订，再次被预订时置为成功
//                    if (cmsRoomBook.getBookStatus() == 1) {
//                        json= roomConfirm(cmsRoomBook,cmsVenue,cmsActivityRoom,cmsTerminalUser,purpose);
//                    } else {
//                        json = JSONResponse.commonResultFormat(5, "该活动室已被预订！", null);
//                    }
//                } else {
//                    json = JSONResponse.commonResultFormat(2, "未知异常，请重试！", null);
//                }
//            }
            
                    
            } else {
                json = JSONResponse.commonResultFormat(4, "预订活动室不存在", null);
            }
           
        }
        return json;
    }
    
    /**
     *  预订信息通过校验后进行的操作
     *  1.新增预订用户的信息
     *  2.更改预订状态
     *  3.活动室订单新增
     * @param cmsRoomBook
     * @return
     */
    @Override
	public String roomConfirm(CmsRoomBook cmsRoomBook, CmsVenue cmsVenue, CmsActivityRoom cmsActivityRoom, CmsTerminalUser cmsTerminalUser,
			String purpose) {
			
	    	Map<String,Object> result=new HashMap<String, Object>();
	     	
	    	CmsRoomOrder msgOrder = null;
	    	
	   	  // 预订状态 改为可选
	         if(cmsRoomBook.getBookStatus() == 1){
	        	 
	        	String tuserId=cmsRoomBook.getTuserId();
	        	 
	        	//是否禁用 0-草稿 1-正常 2-禁用
	 	 		if(StringUtils.isBlank(tuserId))
	 	 		{
	 	 			result.put("tuserIsDisplay", 0);
	 	 		}
	 	 		else
	 	 		{
	 	 			CmsTeamUser cmsTeamUser=cmsTeamUserService.queryAppTeamUserById(tuserId);
	 	 			
	 	 			// 有效使用者ID 使用该用该 使用者名称
	 	 			if(cmsTeamUser!=null)
	 	 			{
	 	 				result.put("tuserIsDisplay", 1);
	 	 				
	 	 				cmsRoomBook.setTuserName(cmsTeamUser.getTuserName());
	 	 			}
	 	 			// ID无效 使用使用者名称
	 	 			else
	 	 			{
	 	 				cmsRoomBook.setTuserId(null);
	 	 				
	 	 				result.put("tuserIsDisplay", 0);
	 	 			}
	 	 		}
	 	     
	             
	             // 预订状态改为 已选
	             //  cmsRoomBook.setBookStatus(2);
	
	            // int count = cmsRoomBookMapper.editCmsRoomBook(cmsRoomBook);
	
	            // if (count == 1) {
	        	 
	        	 Map<String,Object> map=new HashMap<String, Object>();
	        	 
	        	 map.put("userId", cmsTerminalUser.getUserId());
	        	 map.put("roomId", cmsRoomBook.getRoomId());
	        	 map.put("bookId", cmsRoomBook.getBookId());
	        	 
	        	 List<CmsRoomOrder> orderList=cmsRoomOrderMapper.queryRoomBookOrder(map);
	        	 
	        	  //添加活动室订单信息
	             CmsRoomOrder cmsRoomOrder = null;
	        	 
	        	 if(orderList.size()>0)
	        	 {
	        		 cmsRoomOrder=orderList.get(0);
	        		 
	        		  cmsRoomOrder.setUserTel(cmsRoomBook.getUserTel());
		              cmsRoomOrder.setUserId(cmsRoomBook.getUserId());
		              cmsRoomOrder.setUserName(cmsRoomBook.getUserName());
		              cmsRoomOrder.setTuserId(cmsRoomBook.getTuserId());
		              cmsRoomOrder.setTuserName(cmsRoomBook.getTuserName());
		              cmsRoomOrder.setPurpose(purpose); 
		              cmsRoomOrder.setOrderUpdateTime(new Date());
		              cmsRoomOrder.setOrderUpdateUser(cmsTerminalUser.getUserName());
		              
		              cmsRoomOrderMapper.editCmsRoomOrder(cmsRoomOrder);
		              
	        		 result.put("cmsRoomOrderId", cmsRoomOrder.getRoomOrderId());
	        	 }
	        	 else
	        	 {
	        		 cmsRoomOrder = new CmsRoomOrder();
	                 cmsRoomOrder.setRoomOrderId(UUIDUtils.createUUId());
	                 cmsRoomOrder.setOrderNo(cacheService.genOrderNumber());
	                 cmsRoomOrder.setVenueId(cmsVenue.getVenueId());
	                 cmsRoomOrder.setRoomId(cmsRoomBook.getRoomId());
	                 cmsRoomOrder.setBookId(cmsRoomBook.getBookId());
	                 cmsRoomOrder.setUserTel(cmsRoomBook.getUserTel());
	                 cmsRoomOrder.setUserId(cmsRoomBook.getUserId());
	                 cmsRoomOrder.setUserName(cmsRoomBook.getUserName());
	                 cmsRoomOrder.setTuserId(cmsRoomBook.getTuserId());
	                 cmsRoomOrder.setTuserName(cmsRoomBook.getTuserName());
	                 cmsRoomOrder.setSysId(cmsRoomBook.getSysId());
	                 cmsRoomOrder.setSysNo(cmsRoomBook.getSysNo());
	                 //取票码
	                 cmsRoomOrder.setValidCode(cmsRoomOrder.getOrderNo() + (100 + new Random().nextInt(999)));
	                 //状态0为 待审核
	                 cmsRoomOrder.setBookStatus(0);
	                 cmsRoomOrder.setOrderCreateTime(new Date());
	                 cmsRoomOrder.setOrderUpdateTime(new Date());
	                 cmsRoomOrder.setOrderUpdateUser(cmsTerminalUser.getUserName());
	                 cmsRoomOrder.setPurpose(purpose);
	                 
	                 //int insertCount = 1;
	                 //活动室预订订单接口暂未对接
	                 int insertCount = cmsRoomOrderMapper.addRoomOrder(cmsRoomOrder);
	                 if(insertCount>0) {
	//                 	msgOrder = cmsRoomOrderMapper.querySendMsg(cmsRoomOrder.getRoomOrderId());
	//                 	
	                	 CmsUserOperatorLog record= CmsUserOperatorLog.createInstance(null, cmsRoomOrder.getRoomOrderId(), tuserId, cmsRoomBook.getUserId(), CmsUserOperatorLog.USER_TYPE_NORMAL, UserOperationEnum.CREATE);
	                	 
	                	 cmsUserOperatorLogMapper.insert(record);
	                	 
	                 	result.put("cmsRoomOrderId", cmsRoomOrder.getRoomOrderId());
	                 }
	        	 }
	        	 
	                
	                 
	                
	             //}
	//             if (msgOrder != null) {
	//                 //场馆短信发送
	//                 Map<String, Object> map = new HashMap<String, Object>();
	//                 map.put("userName", msgOrder.getUserName());
	//                 map.put("venueName", msgOrder.getVenueName());
	//                 map.put("activityRoomName", msgOrder.getRoomName());
	//                 map.put("ticketCode", msgOrder.getValidCode());
	//                 //发送短信--阿里大鱼
	//                 SmsUtil.sendVenueOrderSms(cmsRoomBook.getUserTel(),map);
	//             }
	         }
	         
	    	 else {
	    		return JSONResponse.commonResultFormat(5, "该活动室已被预订！", null);
	    	}
	         
	       
	         result.put("roomName", cmsActivityRoom.getRoomName());
	         result.put("venueName",cmsVenue.getVenueName());
	         result.put("date", this.getBookDateStr(cmsRoomBook.getCurDate(),cmsRoomBook.getDayOfWeek()));
	 		 result.put("openPeriod",cmsRoomBook.getOpenPeriod());
	 		 
	 		 // 用户实名认证
	 		 Integer userType=cmsTerminalUser.getUserType();
	 		 
	 		 result.put("tuserName", cmsRoomBook.getTuserName());
	 		 
	 		result.put("orderName", cmsRoomBook.getUserName());
	 		result.put("orderTel", cmsRoomBook.getUserTel());
	 		
	 		result.put("userType", userType);
	 		
	 		
	 			return JSONResponse.toAppResultFormat(0, result);
	       
    	
	}
    
    /**
     * 将活动室预订信息放入Redis
     * @param finalRoomId
     */
    public void setRoomBookToRedis(String finalRoomId){
        //将未来七天的预订信息放入Redis
        List<String> roomBookList = cmsRoomBookService.queryRoomBookDataToRedis(finalRoomId, 7);
        //*********************************************************往Redis中放入活动室预订数据，活动室预订队列
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        //设置过期时间为当前时间之后的24小时
        calendar.add(Calendar.HOUR_OF_DAY,24);
        //将活动室预订信息放入Redis
        cacheService.setRoomBookList(finalRoomId,roomBookList,calendar.getTime());
        //将活动室队列放入内存中的一个set集合中
        cacheService.saveActivityRoomToQueues(CacheConstant.ACTIVITY_ROOM_QUEUES, finalRoomId + "_N");
        //**********************************************************往Redis中放入活动室预订数据，活动室预订队列
    }

	
}
