package com.sun3d.why.webservice.service;

import com.sun3d.why.util.PaginationApp;

public interface ActivityRoomAppService {
	/**
	 * app根据场馆id查询活动室
	 * @param venueId 展馆id
	 * @param pageApp 分页对象
	 * @return
	 */	
	public String queryAppActivityRoomListById(String venueId,PaginationApp pageApp);
	
	/**
	 * app根据活动室id查询活动室
	 * @param roomId 活动室id
	 * @return
	 */
	public String queryAppActivityRoomByRoomId(String roomId);
	

}
