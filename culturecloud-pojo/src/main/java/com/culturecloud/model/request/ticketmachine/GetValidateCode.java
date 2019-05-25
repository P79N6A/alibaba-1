package com.culturecloud.model.request.ticketmachine;

import com.culturecloud.bean.BaseRequest;

public class GetValidateCode extends BaseRequest {
	
	private String activityOrderId;

	public String getActivityOrderId() {
		return activityOrderId;
	}

	public void setActivityOrderId(String activityOrderId) {
		this.activityOrderId = activityOrderId;
	}
	
}
