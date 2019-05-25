package com.culturecloud.dao.contest;

import org.apache.ibatis.annotations.Param;

import com.culturecloud.dao.dto.contest.CcpContestUserResultDto;
import com.culturecloud.model.bean.contest.CcpContestUserResult;
import com.culturecloud.model.request.contest.QueryQuestionShareInfoVO;
import com.culturecloud.model.request.contest.QueryTopicPassShareVO;

public interface CcpContestUserResultMapper {

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_contest_user_result
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	int deleteByPrimaryKey(String userTopicResultId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_contest_user_result
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	int insert(CcpContestUserResult record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_contest_user_result
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	int insertSelective(CcpContestUserResult record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_contest_user_result
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	CcpContestUserResult selectByPrimaryKey(String userTopicResultId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_contest_user_result
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	int updateByPrimaryKeySelective(CcpContestUserResult record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_contest_user_result
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	int updateByPrimaryKey(CcpContestUserResult record);

	/**
	 * 查询用户主题结果
	 * 
	 * @param userId
	 * @param topicId
	 * @return
	 */
	CcpContestUserResultDto queryUserContestResult(@Param("userId") String userId,@Param("topicId") String topicId);
	
	/**
	 * 根据vo查出升级分享信息
	 * @param questionShareInfoVO
	 * @return
	 */
	String queryTopicPassRanking(QueryQuestionShareInfoVO questionShareInfoVO);
	
	/**
	 * 根据vo查出通关分享信息
	 * @param queryTopicPassVO
	 * @return
	 */
	String queryTopicAllPassRanking(QueryTopicPassShareVO queryTopicPassShareVO);
	
	/**
	 * 获取所有参与人数
	 * @return
	 */
	String getAllUserNum();
}