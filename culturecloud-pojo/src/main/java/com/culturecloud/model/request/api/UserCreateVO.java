package com.culturecloud.model.request.api;

import com.culturecloud.bean.BaseRequest;

import java.util.List;


/**
 * 子平台用户新增VO
 */
public class UserCreateVO extends BaseRequest{

	private List<UserCreateApi> userList;

	private String platSource;

	public String getPlatSource() {
		return platSource;
	}

	public void setPlatSource(String platSource) {
		this.platSource = platSource;
	}

	public List<UserCreateApi> getUserList() {
		return userList;
	}

	public void setUserList(List<UserCreateApi> userList) {
		this.userList = userList;
	}
}
