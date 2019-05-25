package com.culturecloud.model.bean.activity;

import com.culturecloud.model.bean.activity.CmsActivity;

public class CmsActivityDto extends CmsActivity{

	private static final long serialVersionUID = 3040659485973146783L;

	private String venueName;

	// 余票数
	private Integer availableCount;

	// 游览次数
	private Integer yearBrowseCount;

	// 时间段
	private String eventimes;

	private String dictName;

	/**
	 * 用户与活动之间的距离
	 **/
	private Double distance;

	private String tagName;

	//活动是否被用户收藏
	private Integer collectNum;

	// 模板名称
	private String funName;

	//活动剩余天数
	private Integer dateNums;

	private Integer activityIsWant;

	// 场馆等级
	private String rating;

	public String getVenueName() {
		return venueName;
	}

	public void setVenueName(String venueName) {
		this.venueName = venueName;
	}

	public Integer getAvailableCount() {
		return availableCount;
	}

	public void setAvailableCount(Integer availableCount) {
		this.availableCount = availableCount;
	}

	public Integer getYearBrowseCount() {
		return yearBrowseCount;
	}

	public void setYearBrowseCount(Integer yearBrowseCount) {
		this.yearBrowseCount = yearBrowseCount;
	}

	public String getEventimes() {
		return eventimes;
	}

	public void setEventimes(String eventimes) {
		this.eventimes = eventimes;
	}

	public String getDictName() {
		return dictName;
	}

	public void setDictName(String dictName) {
		this.dictName = dictName;
	}

	public Double getDistance() {
		return distance;
	}

	public void setDistance(Double distance) {
		this.distance = distance;
	}

	public String getTagName() {
		return tagName;
	}

	public void setTagName(String tagName) {
		this.tagName = tagName;
	}

	public Integer getCollectNum() {
		return collectNum != null ? collectNum : 0;
	}

	public void setCollectNum(Integer collectNum) {
		this.collectNum = collectNum;
	}

	public String getFunName() {
		return funName;
	}

	public void setFunName(String funName) {
		this.funName = funName;
	}

	public Integer getDateNums() {
		return dateNums;
	}

	public void setDateNums(Integer dateNums) {
		this.dateNums = dateNums;
	}

	public Integer getActivityIsWant() {
		return activityIsWant != null ? activityIsWant : 0;
	}

	public void setActivityIsWant(Integer activityIsWant) {
		this.activityIsWant = activityIsWant;
	}

	public String getRating() {
		return rating;
	}

	public void setRating(String rating) {
		this.rating = rating;
	}


}
