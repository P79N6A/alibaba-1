package com.culturecloud.model.request.api;

/**
 * 
 * 新增场馆VO
 * 
 * */
public class VenueCreateApi  {

	private String venueId;

	/** 场馆名称*/
	private String venueName;
	
	/** 场馆图片*/
	private String venueIconUrl;
	
	/** 省份*/
	private String venueProvince;
	
	/** 城市*/
	private String venueCity;
	
	/** 区域*/
	private String venueArea;
	
	/** 场馆地址*/
	private String venueAddress;
	
	/** 经度*/
	private Double venueLon;
	
	/** 纬度*/
	private Double venueLat;
	
	/** 联系人*/
	private String venueLinkman;
	
	/** 联系电话(手机)*/
	private String venueMobile;
	
	/** 联系电话(固定)*/
	private String venueTel;
	
	/** 场馆开放时间*/
	private String venueOpenTime;
	
	/** 场馆关闭时间*/
	private String venueEndTime;
	
	/** 开放时间公告*/
	private String openNotice;
	
	/** 是否免费*/
	private Integer venueIsFree;
	
	/** 有无活动室*/
	private Integer venueHasRoom;
	
	/** 有无藏品*/
	private String venueMemo;


	private Integer venueState;

	private String venueType;


	public String getVenueId() {
		return venueId;
	}

	public void setVenueId(String venueId) {
		this.venueId = venueId;
	}

	public String getVenueName() {
		return venueName;
	}

	public void setVenueName(String venueName) {
		this.venueName = venueName;
	}

	public String getVenueIconUrl() {
		return venueIconUrl;
	}

	public void setVenueIconUrl(String venueIconUrl) {
		this.venueIconUrl = venueIconUrl;
	}

	public String getVenueProvince() {
		return venueProvince;
	}

	public void setVenueProvince(String venueProvince) {
		this.venueProvince = venueProvince;
	}

	public String getVenueCity() {
		return venueCity;
	}

	public void setVenueCity(String venueCity) {
		this.venueCity = venueCity;
	}

	public String getVenueArea() {
		return venueArea;
	}

	public void setVenueArea(String venueArea) {
		this.venueArea = venueArea;
	}

	public String getVenueAddress() {
		return venueAddress;
	}

	public void setVenueAddress(String venueAddress) {
		this.venueAddress = venueAddress;
	}

	public Double getVenueLon() {
		return venueLon;
	}

	public void setVenueLon(Double venueLon) {
		this.venueLon = venueLon;
	}

	public Double getVenueLat() {
		return venueLat;
	}

	public void setVenueLat(Double venueLat) {
		this.venueLat = venueLat;
	}

	public String getVenueLinkman() {
		return venueLinkman;
	}

	public void setVenueLinkman(String venueLinkman) {
		this.venueLinkman = venueLinkman;
	}

	public String getVenueMobile() {
		return venueMobile;
	}

	public void setVenueMobile(String venueMobile) {
		this.venueMobile = venueMobile;
	}

	public String getVenueTel() {
		return venueTel;
	}

	public void setVenueTel(String venueTel) {
		this.venueTel = venueTel;
	}

	public String getVenueOpenTime() {
		return venueOpenTime;
	}

	public void setVenueOpenTime(String venueOpenTime) {
		this.venueOpenTime = venueOpenTime;
	}

	public String getVenueEndTime() {
		return venueEndTime;
	}

	public void setVenueEndTime(String venueEndTime) {
		this.venueEndTime = venueEndTime;
	}

	public String getOpenNotice() {
		return openNotice;
	}

	public void setOpenNotice(String openNotice) {
		this.openNotice = openNotice;
	}

	public Integer getVenueIsFree() {
		return venueIsFree;
	}

	public void setVenueIsFree(Integer venueIsFree) {
		this.venueIsFree = venueIsFree;
	}

	public Integer getVenueHasRoom() {
		return venueHasRoom;
	}

	public void setVenueHasRoom(Integer venueHasRoom) {
		this.venueHasRoom = venueHasRoom;
	}

	public String getVenueMemo() {
		return venueMemo;
	}

	public void setVenueMemo(String venueMemo) {
		this.venueMemo = venueMemo;
	}


	public Integer getVenueState() {
		return venueState;
	}

	public void setVenueState(Integer venueState) {
		this.venueState = venueState;
	}

	public String getVenueType() {
		return venueType;
	}

	public void setVenueType(String venueType) {
		this.venueType = venueType;
	}
}
