package com.culturecloud.openapi.user;

import com.culturecloud.bean.BaseRequest;
import com.culturecloud.openapi.BaseOpen;

public class UserInfoRequest extends BaseRequest{

	private String userId;
	
	private String userHeadUrl;	
	
	private String userNickName;
	
	private String sex;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserHeadUrl() {
		return userHeadUrl;
	}

	public void setUserHeadUrl(String userHeadUrl) {
		this.userHeadUrl = userHeadUrl;
	}

	public String getUserNickName() {
		return userNickName;
	}

	public void setUserNickName(String userNickName) {
		this.userNickName = userNickName;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}
	
	
}
