package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;
import com.culturecloud.model.bean.culture.CcpCultureContestUser;

public interface CcpCultureContestUserMapper {

	/**
     * 查询用户数
     * @param map
     * @return int
     */
	int selectUserCountByCondition(Map<String, Object> map);

    
	
	/**
     * 查询用户详细信息	
     * @param map
     * @return list
     */
	List<CcpCultureContestUser>  queryDetailByUserId(String id);
	
	
	
	
	/**
     * 查询用户的用户名
     * @param map
     * @return list
     */
	String queryUsernameByUserId(String userId);
	
	
	
	/**
     * 查询用户记录数
     * @param map
     * @return int
     */
	int queryCountByUserId(Map<String, Object> map);
	

	
	int insert(CcpCultureContestUser record);

	
	int insertSelective(CcpCultureContestUser record);

	
	int updateByPrimaryKeySelective(CcpCultureContestUser record);

	
	int updateByPrimaryKey(CcpCultureContestUser record);
	
	
}