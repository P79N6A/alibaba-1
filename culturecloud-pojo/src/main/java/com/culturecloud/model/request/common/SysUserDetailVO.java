package com.culturecloud.model.request.common;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class SysUserDetailVO extends BaseRequest{

	@NotNull(message = "管理员ID不能为空")
    private String userId;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	
	
	
}
