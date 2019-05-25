package com.sun3d.why.webservice.api.service;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.BookActivitySeatInfo;
import com.sun3d.why.webservice.api.model.CmsApiData;
import com.sun3d.why.webservice.api.model.CmsApiMessage;
import com.sun3d.why.webservice.api.model.CmsApiOrder;

/*
**
**@author lijing
**@version 1.0 2015年8月24日 下午2:44:32
*/
public interface CmsApiActivityOrderService {
	
	public CmsApiOrder addOrder(BookActivitySeatInfo activitySeatInfo, CmsTerminalUser terminalUser,String seatValues);

	public CmsApiMessage save(CmsApiData<CmsActivityOrder> apiData, Integer bookCount) throws Exception;

	public CmsApiOrder cancelOrder(CmsActivityOrder activityOrder,CmsActivity cmsActivity) throws Exception;

	/**
	 * 子系统退订成功后 修改文化云中的数据库订单的状态
	 * @param activityOrderId
	 * @param orderLines
	 * @return
	 */
	public String updateActivityOrderState(String activityOrderId, String orderLines,String type);

	/**
	 * 根据活动id获得子系统中的剩余票数
	 * @param activityIds
	 * @return
	 */
	public String getSubSystemActivityTicketCount(String[] activityIds);


	/**
	 * 检查活动的预定座位信息
	 * @param activityId
	 * @param seatIds
	 * @param bookCount
	 * @param userId
	 * @return
	 */
	public String checkActivitySeatStatus(String activityId, String [] seatIds, Integer bookCount, String userId);



}
