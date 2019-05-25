package com.culturecloud.model.request.common;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class QueryCityPageInfoVO extends BaseRequest{

    private Integer cityId;
    
    private String cityCode;

	public Integer getCityId() {
		return cityId;
	}

	public void setCityId(Integer cityId) {
		this.cityId = cityId;
	}

	public String getCityCode() {
		return cityCode;
	}

	public void setCityCode(String cityCode) {
		this.cityCode = cityCode;
	}

	
	
	
	
}
