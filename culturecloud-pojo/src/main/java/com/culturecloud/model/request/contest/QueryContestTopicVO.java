package com.culturecloud.model.request.contest;

import com.culturecloud.bean.BaseRequest;

import javax.validation.constraints.NotNull;

public class QueryContestTopicVO extends BaseRequest{

	@NotNull(message = "主题类型不能为空")
    private int topicStatus;

	public int getTopicStatus() {
		return topicStatus;
	}

	public void setTopicStatus(int topicStatus) {
		this.topicStatus = topicStatus;
	}
}
