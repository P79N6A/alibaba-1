package com.sun3d.why.service;

import java.util.List;
import java.util.Map;

import com.culturecloud.model.bean.culture.CcpCultureContestUser;
import com.sun3d.why.dao.dto.CcpCultureContestAnswerDto;
import com.sun3d.why.util.Pagination;

public interface CcpCultureContestUserService {
	
	
	/**
     * 根据用户名称和电话号码查询用户对象
     * @param CcpCultureContestUser user
     * @return List<CcpCultureContestUser>
     */
	List<CcpCultureContestAnswerDto> queryUserByCondition(Map<String,Object> map,Pagination page);
	
	
	
	/**
     * 查询所有用户信息	
     * @param map
     * @return list
     */
	List<CcpCultureContestAnswerDto> queryUserContestAnswerAllList(Map<String,Object> map,Pagination page);
	
	
	
	
	/**
	 * 根据用的用户culture_user_id
	 * 
	 * */
	List<CcpCultureContestUser> queryDetailByUserId(String id);
	
	
	
	
	
	/**
     * 查询用户的答题详情记录	
     * @param map
     * @return list
     */
	List<CcpCultureContestAnswerDto> queryUserContestAnswerDetailList(String cultureUserId);
	
	
	
	
	
	
	/**
     * 查询用户答题排名
     * @param map
     * @return int
     */
	List queryUserContestAnswerSort(Map<String,Object> map);
	
	
	
	/**
     * 查询用户答题总的排名
     * @param map
     * @return int
     */
	List queryUserContestAnswerSortAll(Map<String,Object> map);
	
	
	
	
	/**
     * 查询用户详细信息	
     * @param map
     * @return list
     */
	String queryUsernameByUserId(String userId);

}
