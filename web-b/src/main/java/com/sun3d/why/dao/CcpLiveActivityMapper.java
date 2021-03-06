package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.culturecloud.model.bean.live.CcpLiveActivity;
import com.sun3d.why.dao.dto.CcpLiveActivityDto;

public interface CcpLiveActivityMapper {
	
	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_live_activity
	 * @mbggenerated  Fri Jan 13 18:43:54 CST 2017
	 */
	int deleteByPrimaryKey(String liveActivityId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_live_activity
	 * @mbggenerated  Fri Jan 13 18:43:54 CST 2017
	 */
	int insert(CcpLiveActivity record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_live_activity
	 * @mbggenerated  Fri Jan 13 18:43:54 CST 2017
	 */
	int insertSelective(CcpLiveActivity record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_live_activity
	 * @mbggenerated  Fri Jan 13 18:43:54 CST 2017
	 */
	CcpLiveActivity selectByPrimaryKey(String liveActivityId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_live_activity
	 * @mbggenerated  Fri Jan 13 18:43:54 CST 2017
	 */
	int updateByPrimaryKeySelective(CcpLiveActivity record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_live_activity
	 * @mbggenerated  Fri Jan 13 18:43:54 CST 2017
	 */
	int updateByPrimaryKey(CcpLiveActivity record);

	int selectLiveActivityCount(Map<String,Object> data);
	
	List<CcpLiveActivityDto> selectLiveActivityList(Map<String,Object> data);
}