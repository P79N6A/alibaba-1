package com.culturecloud.model.request.special;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class SpecialCodeReqVO extends BaseRequest{

	/** Y码*/
	@NotNull(message="Y码不能为空")
	private String specialCode;

	public String getSpecialCode() {
		return specialCode;
	}

	public void setSpecialCode(String specialCode) {
		this.specialCode = specialCode;
	}
	
	
}
