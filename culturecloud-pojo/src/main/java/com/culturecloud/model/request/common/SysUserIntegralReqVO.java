package com.culturecloud.model.request.common;

import com.culturecloud.bean.BaseRequest;

public class SysUserIntegralReqVO extends BaseRequest{

	private String activityId;
	
	private String userId;
	
	private String integral;
	
	private String lastWeedEndDate;		//用于每周积分定时任务
	
	public SysUserIntegralReqVO() {
		super();
	}

	public SysUserIntegralReqVO(String activityId, String userId, String integral) {
		super();
		this.activityId = activityId;
		this.userId = userId;
		this.integral = integral;
	}

	public String getActivityId() {
		return activityId;
	}

	public void setActivityId(String activityId) {
		this.activityId = activityId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getIntegral() {
		return integral;
	}

	public void setIntegral(String integral) {
		this.integral = integral;
	}

	public String getLastWeedEndDate() {
		return lastWeedEndDate;
	}

	public void setLastWeedEndDate(String lastWeedEndDate) {
		this.lastWeedEndDate = lastWeedEndDate;
	}

}