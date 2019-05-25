package com.culturecloud.model.request.contest;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;


public class QueryUserTopicResultVO extends BaseRequest{

	  
	@NotNull(message = "用户id不能为空")
    private String userId;

	@NotNull(message = "主题id不能为空")
    private String topicId;

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



	
}
