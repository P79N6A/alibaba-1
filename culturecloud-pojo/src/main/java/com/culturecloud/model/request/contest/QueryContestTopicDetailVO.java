package com.culturecloud.model.request.contest;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class QueryContestTopicDetailVO extends BaseRequest {

	 @NotNull(message = "主题id不能为空")
	 private String topicId;

	public String getTopicId() {
		return topicId;
	}

	public void setTopicId(String topicId) {
		this.topicId = topicId;
	}
	 
	 
}
