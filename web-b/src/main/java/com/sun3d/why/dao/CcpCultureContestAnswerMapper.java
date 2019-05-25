package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.culturecloud.model.bean.culture.CcpCultureContestAnswer;
import com.sun3d.why.dao.dto.CcpCultureContestAnswerDto;

public interface CcpCultureContestAnswerMapper {

	/**
     * 查询用户信息	
     * @param map
     * @return list
     */
	List<CcpCultureContestAnswerDto> queryUserContestAnswerList(Map<String, Object> map);
	
	
	
	/**
     * 查询所有用户信息	
     * @param map
     * @return list
     */
	List<CcpCultureContestAnswerDto> queryUserContestAnswerAllList(Map<String, Object> map); 
	
	
	
	
	/**
     * 查询用户的答题详情记录	
     * @param map
     * @return list
     */
	List<CcpCultureContestAnswerDto> queryUserContestAnswerDetailList(String cultureUserId);
	
	
	
	/**
     * 查询用户的排名
     * @param map
     * @return map
     */
	List queryUserContestAnswerSort(Map<String,Object> map);
	
	
	
	
	/**
	 *查询用户明细总的排名
     * @param map
     * @return map
	 * */
	List queryUserContestAnswerSortAll(Map<String,Object> map);
	
	
	CcpCultureContestAnswer selectByPrimaryKey(String cultureAnswerId);
	
	
	int deleteByPrimaryKey(String cultureAnswerId);
    
	
	int insert(CcpCultureContestAnswer record);

	
	int insertSelective(CcpCultureContestAnswer record);
	
	int updateByPrimaryKeySelective(CcpCultureContestAnswer record);

	
	int updateByPrimaryKeyWithBLOBs(CcpCultureContestAnswer record);

	
	int updateByPrimaryKey(CcpCultureContestAnswer record);
}