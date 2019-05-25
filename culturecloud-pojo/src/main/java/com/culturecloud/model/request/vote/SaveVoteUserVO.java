package com.culturecloud.model.request.vote;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class SaveVoteUserVO extends BaseRequest{

	@NotNull(message = "用户id不能为空")
    private String userId;

    private String userName;

    private String userMobile;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserMobile() {
		return userMobile;
	}

	public void setUserMobile(String userMobile) {
		this.userMobile = userMobile;
	}
    
    
    
}
