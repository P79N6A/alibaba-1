package com.culturecloud.model.request.common;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class UserLoginVO extends BaseRequest{

	@NotNull(message = "手机号不能为空")
	private String mobileNo;
	
	@NotNull(message = "验证码不能为空")
	private String code;
	
	private String callback;	//回调地址
	
	// 注册来源
	private String registerOrigin;

	public String getMobileNo() {
		return mobileNo;
	}

	public void setMobileNo(String mobileNo) {
		this.mobileNo = mobileNo;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getCallback() {
		return callback;
	}

	public void setCallback(String callback) {
		this.callback = callback;
	}

	public String getRegisterOrigin() {
		return registerOrigin;
	}

	public void setRegisterOrigin(String registerOrigin) {
		this.registerOrigin = registerOrigin;
	}
	
	
}
