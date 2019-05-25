package com.culturecloud.model.request.ticketmachine;

import com.culturecloud.bean.BaseRequest;

public class CheckTicketVO extends BaseRequest{

	private String orderValidateCode;

	public String getOrderValidateCode() {
		return orderValidateCode;
	}

	public void setOrderValidateCode(String orderValidateCode) {
		this.orderValidateCode = orderValidateCode;
	}
	
	

}
