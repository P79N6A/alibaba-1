package com.culturecloud.model.response.contest;

import java.util.List;

public class QuestionAnswerInfoVO {
	
	private String topicId;
	
	private String topicName;
	
	private String questionId;
	
	private String questionTitle;
	
	private Integer questionNumber;

	// 试题选项集合
	private List<CcpContestAnswerVO> answerList;

	public String getTopicId() {
		return topicId;
	}

	public void setTopicId(String topicId) {
		this.topicId = topicId;
	}

	public String getTopicName() {
		return topicName;
	}

	public void setTopicName(String topicName) {
		this.topicName = topicName;
	}

	public String getQuestionId() {
		return questionId;
	}

	public void setQuestionId(String questionId) {
		this.questionId = questionId;
	}

	public String getQuestionTitle() {
		return questionTitle;
	}

	public void setQuestionTitle(String questionTitle) {
		this.questionTitle = questionTitle;
	}

	public List<CcpContestAnswerVO> getAnswerList() {
		return answerList;
	}

	public void setAnswerList(List<CcpContestAnswerVO> answerList) {
		this.answerList = answerList;
	}

	public Integer getQuestionNumber() {
		return questionNumber;
	}

	public void setQuestionNumber(Integer questionNumber) {
		this.questionNumber = questionNumber;
	}

}
