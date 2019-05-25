package com.culturecloud.model.request.pay;

import com.culturecloud.bean.BaseRequest;

public class PayOrderReqVO extends BaseRequest{

	/** 订单UUID*/
	private String orderId;
	
	/** openID*/
	private String openId;
	
	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getOpenId() {
		return openId;
	}

	public void setOpenId(String openId) {
		this.openId = openId;
	}
	
}
