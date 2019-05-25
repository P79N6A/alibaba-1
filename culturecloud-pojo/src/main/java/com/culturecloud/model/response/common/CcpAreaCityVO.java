package com.culturecloud.model.response.common;

import java.util.ArrayList;
import java.util.List;

import com.culturecloud.model.bean.common.CcpAreaCity;

public class CcpAreaCityVO extends CcpAreaCity {

	private List<CcpAreaCityVO> cityList=new ArrayList<CcpAreaCityVO>();
	
	private Integer isQuickSearch;

	public List<CcpAreaCityVO> getCityList() {
		return cityList;
	}

	public void setCityList(List<CcpAreaCityVO> cityList) {
		this.cityList = cityList;
	}

	public Integer getIsQuickSearch() {
		return isQuickSearch;
	}

	public void setIsQuickSearch(Integer isQuickSearch) {
		this.isQuickSearch = isQuickSearch;
	}
	
	
}
