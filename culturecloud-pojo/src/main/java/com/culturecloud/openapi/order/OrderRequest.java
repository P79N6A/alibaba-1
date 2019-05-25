package com.culturecloud.openapi.order;

import com.culturecloud.openapi.BaseOpen;

public class OrderRequest extends BaseOpen{

	/** 用户ID*/
	private String userId;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}
	
}
