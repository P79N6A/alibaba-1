package com.culturecloud.model.request.venue;

import com.culturecloud.bean.BaseRequest;

public class SearchVenueVO extends BaseRequest{

	// 搜索关键字
	private String keyword;

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}
	
	
	
}
