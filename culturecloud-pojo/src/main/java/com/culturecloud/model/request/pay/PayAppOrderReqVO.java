package com.culturecloud.model.request.pay;

import com.culturecloud.bean.BaseRequest;

public class PayAppOrderReqVO extends BaseRequest{

	/** 订单UUID*/
	private String orderId;
	
	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}


	
}
