package com.culturecloud.dao.contest;

import com.culturecloud.model.bean.contest.CcpContestTopicPass;
import com.culturecloud.model.request.contest.QueryQuestionShareInfoVO;

public interface CcpContestTopicPassMapper {

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_contest_topic_pass
	 * @mbggenerated  Fri Jul 08 17:34:50 CST 2016
	 */
	int deleteByPrimaryKey(String topicPassId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_contest_topic_pass
	 * @mbggenerated  Fri Jul 08 17:34:50 CST 2016
	 */
	int insert(CcpContestTopicPass record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_contest_topic_pass
	 * @mbggenerated  Fri Jul 08 17:34:50 CST 2016
	 */
	int insertSelective(CcpContestTopicPass record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_contest_topic_pass
	 * @mbggenerated  Fri Jul 08 17:34:50 CST 2016
	 */
	CcpContestTopicPass selectByPrimaryKey(String topicPassId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_contest_topic_pass
	 * @mbggenerated  Fri Jul 08 17:34:50 CST 2016
	 */
	int updateByPrimaryKeySelective(CcpContestTopicPass record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_contest_topic_pass
	 * @mbggenerated  Fri Jul 08 17:34:50 CST 2016
	 */
	int updateByPrimaryKey(CcpContestTopicPass record);
	
	/**
	 * 根据vo查关卡过关信息
	 * @param questionShareInfoVO
	 * @return
	 */
	CcpContestTopicPass queryCcpContestTopicPassByVo(QueryQuestionShareInfoVO questionShareInfoVO);
	
}