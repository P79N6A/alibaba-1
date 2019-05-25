package com.sun3d.why.webservice.service;

import java.util.Date;

import com.sun3d.why.model.CmsActivityRoom;
import com.sun3d.why.model.CmsRoomBook;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsVenue;

/**
 * 活动室预定时间段
 */
public interface RoomBookAppService {
    /**
     * app根据条件查询活动室预定信息
     * @param roomId 活动室id
     * @param orderRoomDate  活动室预定日期
     * @param openPeriod 活动室预定时间段
     * @return
     */
//	public String queryAppRoomBookByCondition(String roomId, String orderRoomDate,String openPeriod);
	
	
	/**
	 * app根据条件查询活动室预定信息
	 * 
	 * @param roomId
	 * @param bookId
	 * @param userId
	 * @return
	 */
	public String queryAppRoomBookByCondition(String roomId, String bookId,String userId);

    /**
     * app活动室预定
     * @param bookId 活动室预定Id
     * @param teamUserId 团体id
     * @param teamUserName 团体名称
     * @param userId 用户id
     * @param orderName 预定人姓名
     * @param orderTel 预定手机号码
     * @param purpose 用途
     * @return
     */
	public String appRoomOrderByCondition(String bookId, String teamUserId,String teamUserName, String userId, String orderName, String orderTel,String purpose);
	
	/**
     *  预定信息通过校验后进行的操作
     *  1.新增预定用户的信息
     *  2.更改预定状态
     *  3.活动室订单新增
     * @param cmsRoomBook
     * @return
     */
	public String roomConfirm(final CmsRoomBook cmsRoomBook,final CmsVenue cmsVenue,final CmsActivityRoom cmsActivityRoom,final CmsTerminalUser cmsTerminalUser,String purpose);
}
