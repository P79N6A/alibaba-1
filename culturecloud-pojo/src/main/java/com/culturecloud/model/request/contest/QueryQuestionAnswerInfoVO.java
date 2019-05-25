package com.culturecloud.model.request.contest;

import com.culturecloud.bean.BaseRequest;

import javax.validation.constraints.NotNull;

public class QueryQuestionAnswerInfoVO extends BaseRequest{

	@NotNull(message = "试题id不能为空")
    private String questionId;
	
	@NotNull(message = "主题id不能为空")
    private String topicId;

	private String userId;


	public String getQuestionId() {
		return questionId;
	}

	public void setQuestionId(String questionId) {
		this.questionId = questionId;
	}

	public String getTopicId() {
		return topicId;
	}

	public void setTopicId(String topicId) {
		this.topicId = topicId;
	}


	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}
}
