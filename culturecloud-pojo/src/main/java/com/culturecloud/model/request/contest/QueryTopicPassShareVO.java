package com.culturecloud.model.request.contest;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class QueryTopicPassShareVO extends BaseRequest{

	@NotNull(message = "主题id不能为空")
    private String topicId;
	
	@NotNull(message = "总关卡数不能为空")
	private String sum;

	public String getTopicId() {
		return topicId;
	}

	public void setTopicId(String topicId) {
		this.topicId = topicId;
	}

	public String getSum() {
		return sum;
	}

	public void setSum(String sum) {
		this.sum = sum;
	}

}
