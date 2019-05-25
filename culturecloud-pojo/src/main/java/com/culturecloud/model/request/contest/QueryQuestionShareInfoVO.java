package com.culturecloud.model.request.contest;

import com.culturecloud.bean.BaseRequest;

import javax.validation.constraints.NotNull;

public class QueryQuestionShareInfoVO extends BaseRequest{

	@NotNull(message = "关卡数不能为空")
    private Integer passNumber;
	
	@NotNull(message = "主题id不能为空")
    private String topicId;

	public Integer getPassNumber() {
		return passNumber;
	}

	public void setPassNumber(Integer passNumber) {
		this.passNumber = passNumber;
	}

	public String getTopicId() {
		return topicId;
	}

	public void setTopicId(String topicId) {
		this.topicId = topicId;
	}
	
	

}
