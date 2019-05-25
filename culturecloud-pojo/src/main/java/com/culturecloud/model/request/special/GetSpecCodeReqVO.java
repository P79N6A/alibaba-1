package com.culturecloud.model.request.special;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class GetSpecCodeReqVO extends BaseRequest{

	/** 入口ID*/
	@NotNull(message="入口ID不能为空")
	private String enterId;
	
	/** 姓名*/
	@NotNull(message="姓名不能为空")
	private String name;
	
    /** 手机号*/
	@NotNull(message="手机号不能为空")
	private String telphone;

	public String getEnterId() {
		return enterId;
	}

	public void setEnterId(String enterId) {
		this.enterId = enterId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTelphone() {
		return telphone;
	}

	public void setTelphone(String telphone) {
		this.telphone = telphone;
	}
	
	
}
