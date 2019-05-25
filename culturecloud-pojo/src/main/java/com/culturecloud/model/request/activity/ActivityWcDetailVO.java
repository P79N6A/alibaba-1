package com.culturecloud.model.request.activity;

import com.culturecloud.bean.BaseRequest;

public class ActivityWcDetailVO extends BaseRequest{

	private String activityId;
	
	private String userId;
	
	private String activityIsDel;
	
	private Integer integralNow;	//用户当前积分

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

	public String getActivityIsDel() {
		return activityIsDel;
	}

	public void setActivityIsDel(String activityIsDel) {
		this.activityIsDel = activityIsDel;
	}

	public Integer getIntegralNow() {
		return integralNow;
	}

	public void setIntegralNow(Integer integralNow) {
		this.integralNow = integralNow;
	}
	
}
