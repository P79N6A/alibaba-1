package com.sun3d.why.model.countyStatistics;

public class CountyStatisticsDetail {
	// 账户 com.sun3d.why.model.countyStatistics.CountyStatisticsDetail
	private String userAccount;
	// 所属场馆
	private String deptName;
	// 发布活动的数量
	private Integer publishActivity;
	// 可预订活动的数量
	private Integer activityCanBook;
	// 发布的活动室数量
	private Integer roomPublish;
	// 开发的活动室数量
	private Integer roomCanBook;

	public String getUserAccount() {
		return userAccount;
	}

	public void setUserAccount(String userAccount) {
		this.userAccount = userAccount;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public Integer getPublishActivity() {
		return publishActivity;
	}

	public void setPublishActivity(Integer publishActivity) {
		this.publishActivity = publishActivity;
	}

	public Integer getActivityCanBook() {
		return activityCanBook;
	}

	public void setActivityCanBook(Integer activityCanBook) {
		this.activityCanBook = activityCanBook;
	}

	public Integer getRoomPublish() {
		return roomPublish;
	}

	public void setRoomPublish(Integer roomPublish) {
		this.roomPublish = roomPublish;
	}

	public Integer getRoomCanBook() {
		return roomCanBook;
	}

	public void setRoomCanBook(Integer roomCanBook) {
		this.roomCanBook = roomCanBook;
	}

}
