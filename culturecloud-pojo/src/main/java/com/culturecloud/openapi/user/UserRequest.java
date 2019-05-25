package com.culturecloud.openapi.user;

import com.culturecloud.openapi.BaseOpen;

public class UserRequest extends BaseOpen{

	/** 用户ID*/
	private String userId;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}
	
}
