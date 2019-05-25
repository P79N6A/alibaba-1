package com.culturecloud.model.request.vote;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class QueryVoteUserVO  extends BaseRequest{

	@NotNull(message = "用户id不能为空")
	private String userId;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	
}
