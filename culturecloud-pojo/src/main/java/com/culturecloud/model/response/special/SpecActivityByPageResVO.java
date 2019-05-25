package com.culturecloud.model.response.special;

public class SpecActivityByPageResVO {

	/** 活动ID*/
	private String activityId;
	
	/** 活动图片*/
	private String activityIconUrl;
	
	/** 活动名称*/
	private String activityName;
	
	/** 活动地址*/
	private String activityAddress;
	
	/** 活动开始时间*/
	private String endTimePoint;
	
	/** 活动详情*/
	private String activityMemo;
	
	/** 活动余票*/
	private String availableCount;
	
	/**活动是否过期*/
	private Integer isOver;	//(0：未过期；1：过期)

	public String getActivityId() {
		return activityId;
	}

	public void setActivityId(String activityId) {
		this.activityId = activityId;
	}

	public String getActivityIconUrl() {
		return activityIconUrl;
	}

	public void setActivityIconUrl(String activityIconUrl) {
		this.activityIconUrl = activityIconUrl;
	}

	public String getActivityName() {
		return activityName;
	}

	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}

	public String getActivityAddress() {
		return activityAddress;
	}

	public void setActivityAddress(String activityAddress) {
		this.activityAddress = activityAddress;
	}

	public String getEndTimePoint() {
		return endTimePoint;
	}

	public void setEndTimePoint(String endTimePoint) {
		this.endTimePoint = endTimePoint;
	}

	public String getActivityMemo() {
		return activityMemo;
	}

	public void setActivityMemo(String activityMemo) {
		this.activityMemo = activityMemo;
	}

	public String getAvailableCount() {
		return availableCount;
	}

	public void setAvailableCount(String availableCount) {
		this.availableCount = availableCount;
	}

	public Integer getIsOver() {
		return isOver;
	}

	public void setIsOver(Integer isOver) {
		this.isOver = isOver;
	}
	
}
