package com.culturecloud.model.request.common;

import com.culturecloud.bean.BaseRequest;

public class AddOrderIntegralReqVO extends BaseRequest{

	private String userId;
	
	private String orderCostTotalCredit;
	
	private Integer lowestCredit;
	
	private String activityOrderId;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getOrderCostTotalCredit() {
		return orderCostTotalCredit;
	}

	public void setOrderCostTotalCredit(String orderCostTotalCredit) {
		this.orderCostTotalCredit = orderCostTotalCredit;
	}

	public Integer getLowestCredit() {
		return lowestCredit;
	}

	public void setLowestCredit(Integer lowestCredit) {
		this.lowestCredit = lowestCredit;
	}

	public String getActivityOrderId() {
		return activityOrderId;
	}

	public void setActivityOrderId(String activityOrderId) {
		this.activityOrderId = activityOrderId;
	}

}