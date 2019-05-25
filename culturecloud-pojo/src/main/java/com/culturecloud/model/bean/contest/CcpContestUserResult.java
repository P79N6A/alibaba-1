package com.culturecloud.model.bean.contest;

import javax.persistence.Column;
import javax.persistence.IdClass;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="ccp_contest_user_result")
public class CcpContestUserResult implements BaseEntity{

	private static final long serialVersionUID = -7460399532667444070L;

	@Id
	@Column(name="user_topic_result_id")
	private String userTopicResultId;


	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_contest_user_result.user_id
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	@Column(name="user_id")
	private String userId;


	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_contest_user_result.topic_id
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	@Column(name="topic_id")
	private String topicId;


	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_contest_user_result.all_question_number
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	@Column(name="all_question_number")
	private String allQuestionNumber;

	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_contest_user_result.true_question_number
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	@Column(name="true_question_number")
	private String trueQuestionNumber;
	
	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_contest_user_result.user_topic_result_id
	 * @return  the value of ccp_contest_user_result.user_topic_result_id
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	public String getUserTopicResultId() {
		return userTopicResultId;
	}


	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_contest_user_result.user_topic_result_id
	 * @param userTopicResultId  the value for ccp_contest_user_result.user_topic_result_id
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	public void setUserTopicResultId(String userTopicResultId) {
		this.userTopicResultId = userTopicResultId;
	}


	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_contest_user_result.user_id
	 * @return  the value of ccp_contest_user_result.user_id
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	public String getUserId() {
		return userId;
	}


	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_contest_user_result.user_id
	 * @param userId  the value for ccp_contest_user_result.user_id
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}


	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_contest_user_result.topic_id
	 * @return  the value of ccp_contest_user_result.topic_id
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	public String getTopicId() {
		return topicId;
	}


	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_contest_user_result.topic_id
	 * @param topicId  the value for ccp_contest_user_result.topic_id
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	public void setTopicId(String topicId) {
		this.topicId = topicId;
	}


	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_contest_user_result.all_question_number
	 * @return  the value of ccp_contest_user_result.all_question_number
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	public String getAllQuestionNumber() {
		return allQuestionNumber;
	}


	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_contest_user_result.all_question_number
	 * @param allQuestionNumber  the value for ccp_contest_user_result.all_question_number
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	public void setAllQuestionNumber(String allQuestionNumber) {
		this.allQuestionNumber = allQuestionNumber;
	}


	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_contest_user_result.true_question_number
	 * @return  the value of ccp_contest_user_result.true_question_number
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	public String getTrueQuestionNumber() {
		return trueQuestionNumber;
	}


	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_contest_user_result.true_question_number
	 * @param trueQuestionNumber  the value for ccp_contest_user_result.true_question_number
	 * @mbggenerated  Wed Jul 06 20:54:31 CST 2016
	 */
	public void setTrueQuestionNumber(String trueQuestionNumber) {
		this.trueQuestionNumber = trueQuestionNumber;
	}



}