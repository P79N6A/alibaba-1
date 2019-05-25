package com.culturecloud.model.request.api;

import com.culturecloud.bean.BaseRequest;

import java.util.List;

/**
 * 
 * 新增场馆VO
 * 
 * */
public class VenueCreateVO extends BaseRequest {

	private List<VenueCreateApi> venueList;

	private String platSource;

	public List<VenueCreateApi> getVenueList() {
		return venueList;
	}

	public void setVenueList(List<VenueCreateApi> venueList) {
		this.venueList = venueList;
	}

	public String getPlatSource() {
		return platSource;
	}

	public void setPlatSource(String platSource) {
		this.platSource = platSource;
	}
}
