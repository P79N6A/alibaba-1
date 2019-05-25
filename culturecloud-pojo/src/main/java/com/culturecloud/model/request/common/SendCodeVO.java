package com.culturecloud.model.request.common;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class SendCodeVO extends BaseRequest{

	@NotNull(message = "手机号不能为空")
	private String mobileNo;

	public String getMobileNo() {
		return mobileNo;
	}

	public void setMobileNo(String mobileNo) {
		this.mobileNo = mobileNo;
	}
	
	
}
