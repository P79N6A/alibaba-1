package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.culture.CcpCultureContestAnswer;
import com.sun3d.why.dao.dto.CcpCultureContestAnswerDto;

public interface CcpCultureContestAnswerService {

	
	/**
	 * 查询用户答题
	 * @param userId
	 * @param stageNumber
	 * @return
	 */
	public List<CcpCultureContestAnswer> queryCcpCultureContestAnswerByUser(String userId,Integer stageNumber);

	/**
	 * 更新答案
	 * @param answer
	 * @return
	 */
	public int updateCcpCultureContestAnswer(CcpCultureContestAnswer answer);
	
	public CcpCultureContestAnswer queryCcpCultureContestAnswerById(String cultureAnswerId);
	
	/**
	 * 查询得分排行
	 * @param cultureUserId
	 * @param stageNumber
	 * @param answerId
	 * @return
	 */
	public List<CcpCultureContestAnswerDto> queryAnswerRanking(String cultureUserId,Integer stageNumber,String answerId,Integer groupType,Integer limit);

	public List<CcpCultureContestAnswerDto> queryAnswerSumRanking(String cultureUserId,Integer stageNumber,String answerId,Integer groupType,Integer limit);
}
