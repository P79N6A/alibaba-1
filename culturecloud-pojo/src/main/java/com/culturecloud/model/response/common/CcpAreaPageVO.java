package com.culturecloud.model.response.common;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.PropertyUtils;

import com.culturecloud.model.bean.common.CcpAreaPage;

public class CcpAreaPageVO extends CcpAreaPage{
	
	private String cityName;

	private String cityCode;
	
	public CcpAreaPageVO() {
	}	
	
	
	public CcpAreaPageVO(CcpAreaPage page) {
		
		try {
			PropertyUtils.copyProperties(this, page);
		} catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
			e.printStackTrace();
		}
	}


	public String getCityName() {
		return cityName;
	}


	public void setCityName(String cityName) {
		this.cityName = cityName;
	}


	public String getCityCode() {
		return cityCode;
	}


	public void setCityCode(String cityCode) {
		this.cityCode = cityCode;
	}
	
	
}
