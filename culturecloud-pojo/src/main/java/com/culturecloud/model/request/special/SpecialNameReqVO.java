package com.culturecloud.model.request.special;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class SpecialNameReqVO extends BaseRequest{

	/** 渠道参数*/
	@NotNull(message="渠道参数不能为空")
	private String specialName;

	public String getSpecialName() {
		return specialName;
	}

	public void setSpecialName(String specialName) {
		this.specialName = specialName;
	}
	
	
}
