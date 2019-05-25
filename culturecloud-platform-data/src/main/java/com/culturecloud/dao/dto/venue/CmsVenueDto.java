package com.culturecloud.dao.dto.venue;

import com.culturecloud.model.bean.venue.CmsVenue;

public class CmsVenueDto extends CmsVenue{

	
	private String tagName;
	
	private Integer venueSort;

	public String getTagName() {
		return tagName;
	}

	public void setTagName(String tagName) {
		this.tagName = tagName;
	}

	public Integer getVenueSort() {
		return venueSort;
	}

	public void setVenueSort(Integer venueSort) {
		this.venueSort = venueSort;
	}
	
	
}
