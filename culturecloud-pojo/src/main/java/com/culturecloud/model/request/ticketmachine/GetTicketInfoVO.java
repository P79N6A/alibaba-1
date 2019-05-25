package com.culturecloud.model.request.ticketmachine;

import com.culturecloud.bean.BaseRequest;

public class GetTicketInfoVO extends BaseRequest{

	private String orderValidateCode;
	
	private String orderIdentityCard;

	public String getOrderValidateCode() {
		return orderValidateCode;
	}

	public void setOrderValidateCode(String orderValidateCode) {
		this.orderValidateCode = orderValidateCode;
	}

	public String getOrderIdentityCard() {
		return orderIdentityCard;
	}

	public void setOrderIdentityCard(String orderIdentityCard) {
		this.orderIdentityCard = orderIdentityCard;
	}
	
	
}
