package com.culturecloud.model.request.activity;

import com.culturecloud.bean.BasePageRequest;

public class RecommendActivityVO extends BasePageRequest {

	private String userId;
	
	private Double lat;
	
	private Double lon;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Double getLat() {
		return lat;
	}

	public void setLat(Double lat) {
		this.lat = lat;
	}

	public Double getLon() {
		return lon;
	}

	public void setLon(Double lon) {
		this.lon = lon;
	}
	
	
}
