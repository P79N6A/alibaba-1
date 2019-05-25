package com.sun3d.why.model;

import java.io.Serializable;
import java.util.Date;

public class CmsCulturalOrder implements Serializable{
	private String culturalOrderId;
	private String culturalOrderName;
	private Integer culturalOrderLargeType;
	private String culturalOrderImg;
	private String culturalOrderType;
	private String culturalOrderArea;
	private String culturalOrderVenueType;
	private String culturalOrderVenueId;
	private String culturalOrderTown;
	private String culturalOrderAddress;
	private Date culturalOrderStartDate;
	private Date culturalOrderEndDate;
	private Integer culturalOrderDemandLimit;
	private String culturalOrderAreaLimit;
	private String culturalOrderLinkman;
	private String culturalOrderLinkno;
	private String culturalOrderMustKnow;
	private String culturalOrderServiceDetail;
	private String userDeptPath;
	private Integer culturalOrderStatus;
	private String createUser;
	private Date createTime;
	private String updateUser;
	private Date updateTime;
	
	//culturalOrderLargeType=1时，event的eventDate的最大值与最小值
	private Date startDate;
	private Date endDate;
	//前台展示用字段，两种culturalOrderLargeType共用
	private String startDateStr;
	private String endDateStr;
	
	private Integer totalTicketNum;
	private String eventPeriod;
	private String culturalOrderTypeName;
	private Integer userCollect;
	private Integer collectCount;
	
	public String getCulturalOrderId() {
		return culturalOrderId;
	}
	public void setCulturalOrderId(String culturalOrderId) {
		this.culturalOrderId = culturalOrderId;
	}
	public String getCulturalOrderName() {
		return culturalOrderName;
	}
	public void setCulturalOrderName(String culturalOrderName) {
		this.culturalOrderName = culturalOrderName;
	}
	public Integer getCulturalOrderLargeType() {
		return culturalOrderLargeType;
	}
	public void setCulturalOrderLargeType(Integer culturalOrderLargeType) {
		this.culturalOrderLargeType = culturalOrderLargeType;
	}
	public String getCulturalOrderImg() {
		return culturalOrderImg;
	}
	public void setCulturalOrderImg(String culturalOrderImg) {
		this.culturalOrderImg = culturalOrderImg;
	}
	public String getCulturalOrderType() {
		return culturalOrderType;
	}
	public void setCulturalOrderType(String culturalOrderType) {
		this.culturalOrderType = culturalOrderType;
	}
	public String getCulturalOrderVenueType() {
		return culturalOrderVenueType;
	}
	public void setCulturalOrderVenueType(String culturalOrderVenueType) {
		this.culturalOrderVenueType = culturalOrderVenueType;
	}
	public String getCulturalOrderVenueId() {
		return culturalOrderVenueId;
	}
	public void setCulturalOrderVenueId(String culturalOrderVenueId) {
		this.culturalOrderVenueId = culturalOrderVenueId;
	}
	public String getCulturalOrderTown() {
		return culturalOrderTown;
	}
	public void setCulturalOrderTown(String culturalOrderTown) {
		this.culturalOrderTown = culturalOrderTown;
	}
	public String getCulturalOrderAddress() {
		return culturalOrderAddress;
	}
	public void setCulturalOrderAddress(String culturalOrderAddress) {
		this.culturalOrderAddress = culturalOrderAddress;
	}
	public Date getCulturalOrderStartDate() {
		return culturalOrderStartDate;
	}
	public void setCulturalOrderStartDate(Date culturalOrderStartDate) {
		this.culturalOrderStartDate = culturalOrderStartDate;
	}
	public Date getCulturalOrderEndDate() {
		return culturalOrderEndDate;
	}
	public void setCulturalOrderEndDate(Date culturalOrderEndDate) {
		this.culturalOrderEndDate = culturalOrderEndDate;
	}
	public Integer getCulturalOrderDemandLimit() {
		return culturalOrderDemandLimit;
	}
	public void setCulturalOrderDemandLimit(Integer culturalOrderDemandLimit) {
		this.culturalOrderDemandLimit = culturalOrderDemandLimit;
	}
	public String getCulturalOrderAreaLimit() {
		return culturalOrderAreaLimit;
	}
	public void setCulturalOrderAreaLimit(String culturalOrderAreaLimit) {
		this.culturalOrderAreaLimit = culturalOrderAreaLimit;
	}
	public String getCulturalOrderLinkman() {
		return culturalOrderLinkman;
	}
	public void setCulturalOrderLinkman(String culturalOrderLinkman) {
		this.culturalOrderLinkman = culturalOrderLinkman;
	}
	public String getCulturalOrderLinkno() {
		return culturalOrderLinkno;
	}
	public void setCulturalOrderLinkno(String culturalOrderLinkno) {
		this.culturalOrderLinkno = culturalOrderLinkno;
	}
	public String getCulturalOrderMustKnow() {
		return culturalOrderMustKnow;
	}
	public void setCulturalOrderMustKnow(String culturalOrderMustKnow) {
		this.culturalOrderMustKnow = culturalOrderMustKnow;
	}
	public String getCulturalOrderServiceDetail() {
		return culturalOrderServiceDetail;
	}
	public void setCulturalOrderServiceDetail(String culturalOrderServiceDetail) {
		this.culturalOrderServiceDetail = culturalOrderServiceDetail;
	}
	public String getUserDeptPath() {
		return userDeptPath;
	}
	public void setUserDeptPath(String userDeptPath) {
		this.userDeptPath = userDeptPath;
	}
	public String getCreateUser() {
		return createUser;
	}
	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public String getUpdateUser() {
		return updateUser;
	}
	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}
	public Date getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	public Integer getCulturalOrderStatus() {
		return culturalOrderStatus;
	}
	public void setCulturalOrderStatus(Integer culturalOrderStatus) {
		this.culturalOrderStatus = culturalOrderStatus;
	}
	public String getCulturalOrderArea() {
		return culturalOrderArea;
	}
	public void setCulturalOrderArea(String culturalOrderArea) {
		this.culturalOrderArea = culturalOrderArea;
	}
	public Date getStartDate() {
		return startDate;
	}
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	public Date getEndDate() {
		return endDate;
	}
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	public String getStartDateStr() {
		return startDateStr;
	}
	public void setStartDateStr(String startDateStr) {
		this.startDateStr = startDateStr;
	}
	public String getEndDateStr() {
		return endDateStr;
	}
	public void setEndDateStr(String endDateStr) {
		this.endDateStr = endDateStr;
	}
	public Integer getTotalTicketNum() {
		return totalTicketNum;
	}
	public void setTotalTicketNum(Integer totalTicketNum) {
		this.totalTicketNum = totalTicketNum;
	}
	public String getEventPeriod() {
		return eventPeriod;
	}
	public void setEventPeriod(String eventPeriod) {
		this.eventPeriod = eventPeriod;
	}
	public String getCulturalOrderTypeName() {
		return culturalOrderTypeName;
	}
	public void setCulturalOrderTypeName(String culturalOrderTypeName) {
		this.culturalOrderTypeName = culturalOrderTypeName;
	}
	public Integer getUserCollect() {
		return userCollect;
	}
	public void setUserCollect(Integer userCollect) {
		this.userCollect = userCollect;
	}
	public Integer getCollectCount() {
		return collectCount;
	}
	public void setCollectCount(Integer collectCount) {
		this.collectCount = collectCount;
	}
	
}
