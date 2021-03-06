package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.culturecloud.model.bean.contest.CcpContestTopicQuestion;
import com.culturecloud.model.bean.contest.CcpContestTopicQuestionKey;
import com.sun3d.why.dao.dto.CcpContestTopicQuestionDto;


public interface CcpContestTopicQuestionMapper {
	
	int queryContestTopicQuestionCount(Map<String, Object> map);
	
	List<CcpContestTopicQuestionDto> queryCcpContestTopicQuestion(Map<String, Object> map);
	
	/**
	 * 查询主题中试题最大题序号
	 * @param topicId
	 * @return
	 */
	Integer questionTopicQuestionMaxNumber(String topicId);
	
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_contest_topic_question
     *
     * @mbggenerated Thu Jul 07 13:37:16 CST 2016
     */
    int deleteByPrimaryKey(CcpContestTopicQuestionKey key);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_contest_topic_question
     *
     * @mbggenerated Thu Jul 07 13:37:16 CST 2016
     */
    int insert(CcpContestTopicQuestion record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_contest_topic_question
     *
     * @mbggenerated Thu Jul 07 13:37:16 CST 2016
     */
    int insertSelective(CcpContestTopicQuestion record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_contest_topic_question
     *
     * @mbggenerated Thu Jul 07 13:37:16 CST 2016
     */
    CcpContestTopicQuestion selectByPrimaryKey(CcpContestTopicQuestionKey key);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_contest_topic_question
     *
     * @mbggenerated Thu Jul 07 13:37:16 CST 2016
     */
    int updateByPrimaryKeySelective(CcpContestTopicQuestion record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_contest_topic_question
     *
     * @mbggenerated Thu Jul 07 13:37:16 CST 2016
     */
    int updateByPrimaryKey(CcpContestTopicQuestion record);
}