package com.culturecloud.dao.dto.openrs;

public class StatisticsCommonOpenDTO {
	
	private Integer activityCommentCount;
	
	private Integer venueCommentCount;
	
	private Integer activityPublishCount;
	
	private Integer venuePublishCount;
	
	private Integer registerCount;

	public Integer getActivityCommentCount() {
		return activityCommentCount;
	}

	public void setActivityCommentCount(Integer activityCommentCount) {
		this.activityCommentCount = activityCommentCount;
	}

	public Integer getVenueCommentCount() {
		return venueCommentCount;
	}

	public void setVenueCommentCount(Integer venueCommentCount) {
		this.venueCommentCount = venueCommentCount;
	}

	public Integer getActivityPublishCount() {
		return activityPublishCount;
	}

	public void setActivityPublishCount(Integer activityPublishCount) {
		this.activityPublishCount = activityPublishCount;
	}

	public Integer getVenuePublishCount() {
		return venuePublishCount;
	}

	public void setVenuePublishCount(Integer venuePublishCount) {
		this.venuePublishCount = venuePublishCount;
	}

	public Integer getRegisterCount() {
		return registerCount;
	}

	public void setRegisterCount(Integer registerCount) {
		this.registerCount = registerCount;
	}
	
}
