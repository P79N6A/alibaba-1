package com.culturecloud.model.request.api;

/**
 * 子平台用户新增VO
 * */
public class UserCreateApi{

	/** 子平台用户ID*/
	private String userId;
	
	/** 用户名(昵称)*/
	private String userName;
	
	private String userPwd;

	private String userHeadImgUrl;
	
	/** 手机号*/
	private String userTelephone;


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

	public String getUserPwd() {
		return userPwd;
	}

	public void setUserPwd(String userPwd) {
		this.userPwd = userPwd;
	}

	public String getUserHeadImgUrl() {
		return userHeadImgUrl;
	}

	public void setUserHeadImgUrl(String userHeadImgUrl) {
		this.userHeadImgUrl = userHeadImgUrl;
	}

	public String getUserTelephone() {
		return userTelephone;
	}

	public void setUserTelephone(String userTelephone) {
		this.userTelephone = userTelephone;
	}
}
