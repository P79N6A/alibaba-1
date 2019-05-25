package com.culturecloud.model.request.activity;


import com.culturecloud.bean.BaseRequest;

import java.math.BigDecimal;

public class ActivityOrderVO extends BaseRequest {

	private String activityOrderId;
	
    private String activityId;

    private String eventId;

    private String userId;

    private BigDecimal orderPrice;

    private String orderName;

    private String orderIdentityCard;

    private String orderPhoneNo;

    private String orderSummary;

    private String seatIds;

    private String costTotalCredit;

    private Integer orderVotes;

    private Short orderPaymentStatus;
    
    private String orderCustomInfo;

	public String getActivityOrderId() {
		return activityOrderId;
	}

	public void setActivityOrderId(String activityOrderId) {
		this.activityOrderId = activityOrderId;
	}

	public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public BigDecimal getOrderPrice() {
        return orderPrice;
    }

    public void setOrderPrice(BigDecimal orderPrice) {
        this.orderPrice = orderPrice;
    }

    public String getOrderName() {
        return orderName;
    }

    public void setOrderName(String orderName) {
        this.orderName = orderName;
    }

    public String getOrderIdentityCard() {
        return orderIdentityCard;
    }

    public void setOrderIdentityCard(String orderIdentityCard) {
        this.orderIdentityCard = orderIdentityCard;
    }

    public String getOrderPhoneNo() {
        return orderPhoneNo;
    }

    public void setOrderPhoneNo(String orderPhoneNo) {
        this.orderPhoneNo = orderPhoneNo;
    }

    public String getOrderSummary() {
        return orderSummary;
    }

    public void setOrderSummary(String orderSummary) {
        this.orderSummary = orderSummary;
    }

    public String getCostTotalCredit() {
        return costTotalCredit;
    }

    public void setCostTotalCredit(String costTotalCredit) {
        this.costTotalCredit = costTotalCredit;
    }

    public Integer getOrderVotes() {
        return orderVotes;
    }

    public void setOrderVotes(Integer orderVotes) {
        this.orderVotes = orderVotes;
    }

    public String getSeatIds() {
        return seatIds;
    }

    public void setSeatIds(String seatIds) {
        this.seatIds = seatIds;
    }

	public Short getOrderPaymentStatus() {
		return orderPaymentStatus;
	}

	public void setOrderPaymentStatus(Short orderPaymentStatus) {
		this.orderPaymentStatus = orderPaymentStatus;
	}

	public String getOrderCustomInfo() {
		return orderCustomInfo;
	}

	public void setOrderCustomInfo(String orderCustomInfo) {
		this.orderCustomInfo = orderCustomInfo;
	}
    
}
