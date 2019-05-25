package com.culturecloud.model.request.special;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class SpecialCodeUseReqVO extends BaseRequest{
	
	/** Y码*/
	@NotNull(message="Y码不能为空")
	private String specialCode;
	
	/** 活动ID*/
	@NotNull(message="活动ID不能为空")
	private String activityId;
	
	/** 手机号*/
	private String telphone;
	
	/** 姓名*/
	private String name;
	
	/** uuid*/
	private String userId;
	

	public String getSpecialCode() {
		return specialCode;
	}

	public void setSpecialCode(String specialCode) {
		this.specialCode = specialCode;
	}

	public String getActivityId() {
		return activityId;
	}

	public void setActivityId(String activityId) {
		this.activityId = activityId;
	}

	public String getTelphone() {
		return telphone;
	}

	public void setTelphone(String telphone) {
		this.telphone = telphone;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	
}
