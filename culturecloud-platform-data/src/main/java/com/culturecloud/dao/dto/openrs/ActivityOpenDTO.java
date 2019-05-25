package com.culturecloud.dao.dto.openrs;

public class ActivityOpenDTO {

	private String activityId;
	
	private String activityName;
	
	private String activityAddress;
	
	private String activityArea;
	
	private String activityStartTime;
	
	private String activityEndTime;
	
	private String activityIsFree;
	
	private String activityIconUrl;
	
	private String activityIsReservation;
	
	private String activityState;
	
	private String activityIsDel;
	
	private String spikeType;
	
	private String extTagName;
	
	private String extTagSubName;
	
	private String extBusinessName;
	
	private String venueId;
	
	private String updateTime;
	
	private String createTime;
	
	private String activityCreateUser;
	
	private String activityLon;
	
	private String activityLat;
	
	private Integer activitySupplementType;		//补充活动类型 1.不可预订 2.直接前往 3.电话预约

	private Integer lowestCredit;    //参与此活动用户拥有的最低积分

    private Integer costCredit;    //参与此活动消耗的积分数

    private Integer deductionCredit;        //没有核销将扣除的积分
	

	public String getActivityId() {
		return activityId;
	}

	public void setActivityId(String activityId) {
		this.activityId = activityId;
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

	

	public String getActivityStartTime() {
		return activityStartTime;
	}

	public void setActivityStartTime(String activityStartTime) {
		this.activityStartTime = activityStartTime;
	}

	public String getActivityEndTime() {
		return activityEndTime;
	}

	public void setActivityEndTime(String activityEndTime) {
		this.activityEndTime = activityEndTime;
	}

	

	public String getActivityIsFree() {
		return activityIsFree;
	}

	public void setActivityIsFree(String activityIsFree) {
		this.activityIsFree = activityIsFree;
	}

	public String getActivityIconUrl() {
		return activityIconUrl;
	}

	public void setActivityIconUrl(String activityIconUrl) {
		this.activityIconUrl = activityIconUrl;
	}

	public String getActivityIsReservation() {
		return activityIsReservation;
	}

	public void setActivityIsReservation(String activityIsReservation) {
		this.activityIsReservation = activityIsReservation;
	}

	public String getActivityState() {
		return activityState;
	}

	public void setActivityState(String activityState) {
		this.activityState = activityState;
	}


	public String getActivityIsDel() {
		return activityIsDel;
	}

	public void setActivityIsDel(String activityIsDel) {
		this.activityIsDel = activityIsDel;
	}

	public String getSpikeType() {
		return spikeType;
	}

	public void setSpikeType(String spikeType) {
		this.spikeType = spikeType;
	}

	public String getExtTagName() {
		return extTagName;
	}

	public void setExtTagName(String extTagName) {
		this.extTagName = extTagName;
	}

	public String getExtTagSubName() {
		return extTagSubName;
	}

	public void setExtTagSubName(String extTagSubName) {
		this.extTagSubName = extTagSubName;
	}

	public String getExtBusinessName() {
		return extBusinessName;
	}

	public void setExtBusinessName(String extBusinessName) {
		this.extBusinessName = extBusinessName;
	}

	public String getVenueId() {
		return venueId;
	}

	public void setVenueId(String venueId) {
		this.venueId = venueId;
	}

	public String getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}

	public String getActivityLon() {
		return activityLon;
	}

	public void setActivityLon(String activityLon) {
		this.activityLon = activityLon;
	}

	public String getActivityLat() {
		return activityLat;
	}

	public void setActivityLat(String activityLat) {
		this.activityLat = activityLat;
	}

	public Integer getActivitySupplementType() {
		return activitySupplementType;
	}

	public void setActivitySupplementType(Integer activitySupplementType) {
		this.activitySupplementType = activitySupplementType;
	}

	public Integer getLowestCredit() {
		return lowestCredit;
	}

	public void setLowestCredit(Integer lowestCredit) {
		this.lowestCredit = lowestCredit;
	}

	public Integer getCostCredit() {
		return costCredit;
	}

	public void setCostCredit(Integer costCredit) {
		this.costCredit = costCredit;
	}

	public Integer getDeductionCredit() {
		return deductionCredit;
	}

	public void setDeductionCredit(Integer deductionCredit) {
		this.deductionCredit = deductionCredit;
	}

	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}

	public String getActivityArea() {
		return activityArea;
	}

	public void setActivityArea(String activityArea) {
		this.activityArea = activityArea;
	}

	public String getActivityCreateUser() {
		return activityCreateUser;
	}

	public void setActivityCreateUser(String activityCreateUser) {
		this.activityCreateUser = activityCreateUser;
	}

}
