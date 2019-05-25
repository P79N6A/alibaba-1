package com.sun3d.why.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsRoomBookMapper;
import com.sun3d.why.dao.CmsRoomOrderMapper;
import com.sun3d.why.dao.CmsUserOperatorLogMapper;
import com.sun3d.why.enumeration.UserOperationEnum;
import com.sun3d.why.model.CmsActivityRoom;
import com.sun3d.why.model.CmsRoomBook;
import com.sun3d.why.model.CmsRoomOrder;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsUserOperatorLog;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.SmsConfig;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsActivityRoomService;
import com.sun3d.why.service.CmsRoomOrderService;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.CmsUserMessageService;
import com.sun3d.why.service.CmsVenueService;
import com.sun3d.why.util.CompareTime;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.SmsUtil;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.service.CmsApiRoomOrderService;

/**
 * Created by Administrator on 2015/7/3.
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class CmsRoomOrderServiceImpl implements CmsRoomOrderService {


    private Logger logger = Logger.getLogger(CmsRoomOrderServiceImpl.class);

    @Autowired
    private CmsRoomOrderMapper cmsRoomOrderMapper;

    @Autowired
    private CmsRoomBookMapper cmsRoomBookMapper;

    @Autowired
    private CacheService cacheService;

    @Autowired
    private CmsUserMessageService userMessageService;

    @Autowired
    private SmsConfig smsConfig;

    @Autowired
    private CmsApiRoomOrderService cmsApiRoomOrderService;
    
    @Autowired
    private CmsActivityRoomService cmsActivityRoomService;
    
    @Autowired
    private CmsTerminalUserService terminalUserService;
    
    @Autowired
    private CmsVenueService cmsVenueService;
    
    @Autowired
    private CmsUserOperatorLogMapper cmsUserOperatorLogMapper;

    /**
     * 前端显示我的场馆中的列表
     * @param userId
     * @param page
     * @param pageApp
     * @return
     */
    @Override
    public List<CmsRoomOrder> queryRoomOrderListService(String userId, Pagination page, PaginationApp pageApp) {
        Map<String, Object> map = new HashMap<String, Object>();

        map.put("userId",userId);
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = cmsRoomOrderMapper.queryRoomOrderListCount(map);
            page.setTotal(total);
        }
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        return cmsRoomOrderMapper.queryRoomOrderList(map);
    }

    @Override
    public int queryRoomOrderListCountService(Map<String, Object> map) {
        return cmsRoomOrderMapper.queryRoomOrderListCount(map);
    }

    /**
     * 前端显示我的历史场馆的列表
     * @param userId
     * @param page
     * @param pageApp
     * @return
     */
    @Override
    public List<CmsRoomOrder> queryRoomOrderListHistoryService(String userId, Pagination page, PaginationApp pageApp) {
        Map<String, Object> map = new HashMap<String, Object>();

        map.put("userId",userId);
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = cmsRoomOrderMapper.queryRoomOrderListHistoryCount(map);
            page.setTotal(total);
        }
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        return cmsRoomOrderMapper.queryRoomOrderHistoryList(map);
    }

    @Override
    public int queryRoomOrderListCountHistoryService(Map<String, Object> map) {
        return cmsRoomOrderMapper.queryRoomOrderListHistoryCount(map);
    }

    /**
     * 物理删除活动室预定订单
     * @param roomOrderId
     * @return
     */
    @Override
    public int deleteRoomOrder(String roomOrderId){
        int count = cmsRoomOrderMapper.deleteRoomOrder(roomOrderId);
        if(count>0){
            return  count;
        }else{
            return  0;
        }
    }

    @Override
    public int addRoomOrder(CmsRoomOrder cmsRoomOrder) {

        if(cmsRoomOrder != null){
            cmsRoomOrder.setRoomOrderId(UUIDUtils.createUUId());//创建主键
            cmsRoomOrder.setBookStatus(0); //默认设为0
            cmsRoomOrder.setOrderCreateTime(new Date());
        }
        return cmsRoomOrderMapper.addRoomOrder(cmsRoomOrder);
    }

    /**
     * 编辑活动室订单信息
     * @param cmsCollection
     * @return
     */
    @Override
    public int editCmsRoomOrder(CmsRoomOrder cmsCollection){

        return cmsRoomOrderMapper.editCmsRoomOrder(cmsCollection);
    }

    /**
     *  通过指定的活动室ID查询该活动室的信息
     * @param roomId
     * @return
     */
    @Override
    public List<CmsRoomOrder> queryAllRoomOrderList(String roomId,Pagination page,CmsRoomOrder cmsRoomOrder) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("roomId",roomId);
        if(cmsRoomOrder != null){
            if(StringUtils.isNotBlank(cmsRoomOrder.getOrderNo())){
                map.put("orderNo","%"+cmsRoomOrder.getOrderNo()+"%");
            }
        }
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = queryAllRoomOrderCount(map);
            page.setTotal(total);
        }
        return cmsRoomOrderMapper.queryAllRoomOrderList(map);
    }

    /**
     * 带条件查询活动室总个数
     * @param map
     * @return
     */ @Override
    public int queryAllRoomOrderCount(Map<String,Object> map){

        return cmsRoomOrderMapper.queryAllRoomOrderCount(map);
    }


    @Override
    public List<CmsRoomOrder> queryVenueRooms(String venueId, PaginationApp pageApp) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (venueId != null && StringUtils.isNotBlank(venueId)){
            map.put("venueId", venueId);
        }
        //app分页
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        return cmsRoomOrderMapper.queryVenueRooms(map);
    }



    /**
     * 根据活动室订单ID查询活动室订单信息
     * @param roomOrderId
     * @return
     */
    @Override
    public CmsRoomOrder queryCmsRoomOrderById(String roomOrderId){

        return cmsRoomOrderMapper.queryCmsRoomOrderById(roomOrderId);
    }


    /**
     * 取消单个活动室订单
     * @param roomOrderId
     * @return
     */
    @Override
    public boolean cancelRoomOrder(String roomOrderId,String userName){
        boolean result = false;
        try {
            CmsRoomOrder cmsRoomOrder = cmsRoomOrderMapper.queryCmsRoomOrderById(roomOrderId);
            //if(cmsRoomOrder.getBookStatus()<2){
                //状态为2代表取消
                cmsRoomOrder.setBookStatus(2);
                cmsRoomOrder.setOrderUpdateTime(new Date());
                cmsRoomOrder.setOrderUpdateUser(userName);
                //更改活动室订单状态
                int orderCount = cmsRoomOrderMapper.editCmsRoomOrder(cmsRoomOrder);
                
                if(orderCount > 0 ){
                    result = true;
                }

                //获取活动室预定信息并修改预定状态
                CmsRoomBook cmsRoomBook = cmsRoomBookMapper.queryCmsRoomBookById(cmsRoomOrder.getBookId());
               
                if(cmsRoomBook.getTuserId()!=null)
                
                if(cmsRoomBook.getTuserId().equals(cmsRoomOrder.getTuserId())
                		&&cmsRoomBook.getUserId().equals(cmsRoomOrder.getUserId())&&cmsRoomBook.getBookStatus()==2)
                {
                	   //状态为1代表可选
                    cmsRoomBook.setBookStatus(1);
                    cmsRoomBook.setUpdateTime(new Date());
                    int bookCount = cmsRoomBookMapper.editCmsRoomBook(cmsRoomBook);
                    
                    //&& cancelResult.equals(Constant.RESULT_STR_SUCCESS)
                    if(orderCount > 0 && bookCount > 0 ){
                        result = true;
                    }
                    
                    //场馆短信发送
                    Map<String,Object> map = new HashMap<String, Object>();
                    map.put("userName",cmsRoomOrder.getUserName());
                    map.put("orderId",cmsRoomOrder.getOrderNo());
                    //发送短信--阿里大鱼
                    SmsUtil.cancelVenueOrderSms(cmsRoomOrder.getUserTel(), map);
                }

                //修改Redis活动室预定状态
                //String cancelResult = cacheService.cancelRoomBook(cmsRoomBook);
                
                

                //当文化系统取消成功以后，刷新子系统的取消功能
                this.cmsApiRoomOrderService.cancelOrder(cmsRoomOrder);
              
               
//            }else{
//                result = false;
//            }
        } catch (Exception e) {
            logger.error("取消活动室订单出错!",e);
            result = false;
        }
        return result;
    }

    /**
     * app当前用户预定的活动室数量
     * @param roomId
     * @return
     */
    @Override
    public int queryRoomOrderCount(String roomId) {

        return cmsRoomOrderMapper.queryRoomOrderCount(roomId);
    }

    /**
     * app根据订单号查询活动室订单信息
     * @param validCode
     * @param bookStatus
     * @return
     */
    @Override
    public CmsRoomOrder queryValidateCode(String validCode, Integer bookStatus) {
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("validCode",validCode);
        if(bookStatus==1){
            map.put("bookStatus",bookStatus);
        }
        else {
            map.put("bookStatus",bookStatus);
        }
        return cmsRoomOrderMapper.queryValidateCode(map);
    }

    /**
     * 统计各个区县活动室预定总数
     * @param map
     * @return
     */
    public List<Map> queryBookCountByArea(Map map) {
        return cmsRoomOrderMapper.queryBookCountByArea(map);
    }

    /**
     * 得到给定用户当天的预订数量
     * @param userId
     * @return
     */
    @Override
    public int getRoomBookCountOneDay(String userId) {

        return cmsRoomOrderMapper.getRoomBookCountOneDay(userId);
    }

    /**
     * 根据预订ID获取已预订状态订单
     * @param bookId
     * @return
     */
    @Override
    public List<CmsRoomOrder> queryRoomOrderListByBookId(String bookId) {

        return cmsRoomOrderMapper.queryRoomOrderListByBookId(bookId);
    }

    /**
     * 发送短消息接口
     * @param roomOrderId
     * @return
     */
	@Override
	public String selectPhoneByRoomOrderId(String roomOrderId) {
		//定义发送短消息返回消息是否成功
        try{
            CmsRoomOrder roomOrder = cmsRoomOrderMapper.queryCmsRoomOrderById(roomOrderId);

            CmsActivityRoom cmsActivityRoom = cmsActivityRoomService.queryCmsActivityRoomById(roomOrder.getRoomId());
            CmsVenue cmsVenue = cmsVenueService.queryVenueById(roomOrder.getVenueId());
            Map tempMap = new HashMap();
            CmsTerminalUser terminalUser = terminalUserService.queryTerminalUserById(roomOrder.getUserId());
            tempMap.put("userName", terminalUser.getUserName());
            tempMap.put("venueName",cmsVenue.getVenueName());
            tempMap.put("activityRoomName",cmsActivityRoom.getRoomName());
            tempMap.put("ticketCode",roomOrder.getValidCode());
            //发送短信--阿里大鱼
            SmsUtil.sendVenueOrderSms(roomOrder.getUserTel(),tempMap);
            return Constant.RESULT_STR_SUCCESS;
        }catch (Exception e){
            logger.info("selectPhoneByRoomOrderId", e);
            return Constant.RESULT_STR_FAILURE;
        }
	}

	@Override
	public List<CmsRoomOrder> queryRoomOrderCheck(SysUser user,Integer userType, Integer tuserIsDisplay, String curDateStart,
			String curDateEnd, String orderCreateTimeStart, String orderCreateTimeEnd, String roomName,
			Pagination page) {
		
		Map<String,Object> map=new HashMap<String, Object>();
		
		map.put("userType",userType);
		map.put("tuserIsDisplay",tuserIsDisplay);
		map.put("curDateStart",curDateStart);
		map.put("curDateEnd",curDateEnd);
		map.put("orderCreateTimeStart",orderCreateTimeStart);
		map.put("orderCreateTimeEnd",orderCreateTimeEnd);
		map.put("roomName",roomName);
		
		 if(user != null){
			 map.put("sysUserId", user.getUserId());
			 map.put("userDeptPath",user.getUserDeptPath());
			 map.put("userLabel1",user.getUserLabel1());
             map.put("userLabel2",user.getUserLabel2());
             map.put("userLabel3",user.getUserLabel3());
         }
		
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = cmsRoomOrderMapper.queryAppUserCheckOrderByUserIdCount(map);
            page.setTotal(total);
        }
		
		List<CmsRoomOrder> roomOrderList=cmsRoomOrderMapper.queryAppUserCheckOrderByUserId(map);
		
		return roomOrderList;
	}

	@Override
	@Transactional(rollbackFor = Exception.class,isolation=Isolation.SERIALIZABLE)
	public int checkPass(String roomOrderId,SysUser sysUser) {
		
		int result=0;
		
		try {
			
			CmsRoomOrder order = cmsRoomOrderMapper.queryCmsRoomOrderById(roomOrderId);
			
			CmsRoomBook cmsRoomBook = cmsRoomBookMapper.queryCmsRoomBookById(order.getBookId());
			
			if(cmsRoomBook.getBookStatus()!=1)
			{
				// 场次不可选
				return -1;
			}
			   
			String roomBookId=order.getBookId();
			
			// 该时间的所有订单
			List<CmsRoomOrder> allCmsRoomOrderList= cmsRoomOrderMapper.queryRoomOrderListByBookId(roomBookId);
			
			for (CmsRoomOrder cmsRoomOrder : allCmsRoomOrderList) {
				
				// 当前订单 审核通过
				if(cmsRoomOrder.getRoomOrderId().equals(roomOrderId))
				{
					// 审核状态 0.待审核 1.审核通过 2.审核未通过
					cmsRoomOrder.setCheckStatus(1);
					// 状态预定成功
					cmsRoomOrder.setBookStatus(1);
					
					cmsRoomOrder.setOrderUpdateTime(new Date());
					cmsRoomOrder.setOrderUpdateUser(sysUser.getUserNickName());
					
					result=cmsRoomOrderMapper.editCmsRoomOrder(cmsRoomOrder);
					
					cmsRoomBook.setUserId(cmsRoomOrder.getUserId());
					cmsRoomBook.setTuserId(cmsRoomOrder.getTuserId());
					cmsRoomBook.setUserName(cmsRoomOrder.getUserName());
					cmsRoomBook.setUserTel(cmsRoomOrder.getUserTel());
					// 已选
					cmsRoomBook.setBookStatus(2);
					cmsRoomBook.setUpdateTime(new Date());
					
					int r=cmsRoomBookMapper.editCmsRoomBook(cmsRoomBook);
					
					if(r>0){
						
						CmsUserOperatorLog log=CmsUserOperatorLog.createInstance(null, cmsRoomOrder.getRoomOrderId(), null, sysUser.getUserId(), CmsUserOperatorLog.USER_TYPE_ADMIN, UserOperationEnum.CHECK_PASS);
    		        	
    		        	cmsUserOperatorLogMapper.insert(log);
						
						// 发送成功短信
						this.selectPhoneByRoomOrderId(roomOrderId);
					}
					
					
				}
				else
				{
			                //状态为2代表取消
			                cmsRoomOrder.setBookStatus(2);
			                cmsRoomOrder.setOrderUpdateTime(new Date());
			                cmsRoomOrder.setOrderUpdateUser(sysUser.getUserNickName());
			                
			            	// 审核状态 0.待审核 1.审核通过 2.审核未通过
							cmsRoomOrder.setCheckStatus(2);
							// 状态预定成功
							cmsRoomOrder.setBookStatus(2);
							
							int r=cmsRoomOrderMapper.editCmsRoomOrder(cmsRoomOrder);
							
							if(r>0)
							{
								   //场馆短信发送
								HashMap<String, Object> map = new HashMap();
			                    map.put("userName",cmsRoomOrder.getUserName());
			                    map.put("orderId",cmsRoomOrder.getOrderNo());
								
								CmsUserOperatorLog log=CmsUserOperatorLog.createInstance(null, cmsRoomOrder.getRoomOrderId(), null, sysUser.getUserId(), CmsUserOperatorLog.USER_TYPE_ADMIN, UserOperationEnum.CANCEL);
		    		        	
		    		        	cmsUserOperatorLogMapper.insert(log);
		    		        	
		    		        	   //发送短信--阿里大鱼
			                    SmsUtil.cancelVenueOrderSms(cmsRoomOrder.getUserTel(), map);
		    		        	
		    		        	 //当文化系统取消成功以后，刷新子系统的取消功能
				                this.cmsApiRoomOrderService.cancelOrder(cmsRoomOrder);
							}
							
						 
				}
			}
			
			return result;
			
		} catch (Exception e) {
			return -2;
		}
		
	}

	@Override
	public List<CmsRoomOrder> queryRoomOrder(SysUser user,Integer userType, Integer tuserIsDisplay, String curDateStart,
			String curDateEnd, String orderCreateTimeStart, String orderCreateTimeEnd, String roomName,
			Pagination page) {
		
		Map<String,Object> map=new HashMap<String, Object>();
		
		map.put("userType",userType);
		map.put("tuserIsDisplay",tuserIsDisplay);
		map.put("curDateStart",curDateStart);
		map.put("curDateEnd",curDateEnd);
		map.put("orderCreateTimeStart",orderCreateTimeStart);
		map.put("orderCreateTimeEnd",orderCreateTimeEnd);
		map.put("roomName",roomName);
		
		 if(user != null){
			 map.put("sysUserId", user.getUserId());
			 map.put("userDeptPath",user.getUserDeptPath());
			 map.put("userLabel1",user.getUserLabel1());
             map.put("userLabel2",user.getUserLabel2());
             map.put("userLabel3",user.getUserLabel3());
         }
		
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = cmsRoomOrderMapper.queryAppRoomOrderByUserIdCount(map);
            page.setTotal(total);
        }
		
		List<CmsRoomOrder> roomOrderList=cmsRoomOrderMapper.queryAppRoomOrderByUserId(map);
		
		return roomOrderList;
	}

	@Override
	public List<CmsRoomOrder> queryRoomOrderHistory(SysUser user,Integer bookStatus,Integer userType, Integer tuserIsDisplay, String curDateStart,
			String curDateEnd, String orderCreateTimeStart, String orderCreateTimeEnd, String roomName,
			Pagination page) {
		
		Map<String,Object> map=new HashMap<String, Object>();
		
		map.put("userType",userType);
		map.put("tuserIsDisplay",tuserIsDisplay);
		map.put("curDateStart",curDateStart);
		map.put("curDateEnd",curDateEnd);
		map.put("orderCreateTimeStart",orderCreateTimeStart);
		map.put("orderCreateTimeEnd",orderCreateTimeEnd);
		map.put("roomName",roomName);
		map.put("bookStatus",bookStatus);
		
		 if(user != null){
			 map.put("sysUserId", user.getUserId());
			 map.put("userDeptPath",user.getUserDeptPath());
			 map.put("userLabel1",user.getUserLabel1());
             map.put("userLabel2",user.getUserLabel2());
             map.put("userLabel3",user.getUserLabel3());
         }
		
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = cmsRoomOrderMapper.queryAppRoomHistoryOrderByUserIdCount(map);
            page.setTotal(total);
        }
		
		List<CmsRoomOrder> roomOrderList=cmsRoomOrderMapper.queryAppRoomHistoryOrderByUserId(map);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		
		String nowDate = sdf.format(new Date());
		
		  for (CmsRoomOrder roomOrder : roomOrderList) {
			  
			 Integer orderBookStatus = roomOrder.getBookStatus();
			  
			if(orderBookStatus == 0 || orderBookStatus == 1){
          	  
          	  //拼接活动室时间段与具体时间点
                StringBuffer sbTime = new StringBuffer();
                sbTime.append(roomOrder.getCurDates() + " ");
                sbTime.append(roomOrder.getOpenPeriod());
             
                int statusDate2 = CompareTime.timeCompare2(sbTime.toString().substring(0, sbTime.toString().lastIndexOf("-")), nowDate);
          	  
                //返回 0 表示时间日期相同
                //返回 1 表示日期1>日期2
                //返回 -1 表示日期1<日期2
                if (statusDate2 == -1) {
                    
                    roomOrder.setBookStatus(6);
                    
                    cmsRoomOrderMapper.editCmsRoomOrder(roomOrder);
                }
            }
		}

		return roomOrderList;
	}
}
