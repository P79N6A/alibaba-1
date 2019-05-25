package com.culturecloud.model.request.contest;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class SaveContestUserResultVO extends BaseRequest{

	@NotNull(message = "用户id不能为空")
    private String userId;

	@NotNull(message = "主题id不能为空")
    private String topicId;
	
	private Integer trueQuestionNumber;
	
	private Integer answerQuestionNumber;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getTopicId() {
		return topicId;
	}

	public void setTopicId(String topicId) {
		this.topicId = topicId;
	}

	public Integer getTrueQuestionNumber() {
		return trueQuestionNumber;
	}

	public void setTrueQuestionNumber(Integer trueQuestionNumber) {
		this.trueQuestionNumber = trueQuestionNumber;
	}

	public Integer getAnswerQuestionNumber() {
		return answerQuestionNumber;
	}

	public void setAnswerQuestionNumber(Integer answerQuestionNumber) {
		this.answerQuestionNumber = answerQuestionNumber;
	}


	
}
