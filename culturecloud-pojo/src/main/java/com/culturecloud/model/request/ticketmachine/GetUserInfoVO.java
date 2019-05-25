package com.culturecloud.model.request.ticketmachine;

import com.culturecloud.bean.BaseRequest;

public class GetUserInfoVO extends BaseRequest{

	private String userCardNo;

	public String getUserCardNo() {
		return userCardNo;
	}

	public void setUserCardNo(String userCardNo) {
		this.userCardNo = userCardNo;
	}

}
