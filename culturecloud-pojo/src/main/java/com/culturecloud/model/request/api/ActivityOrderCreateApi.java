package com.culturecloud.model.request.api;

import com.culturecloud.model.bean.activity.CmsActivityOrderDetail;

import java.util.List;

/**
 * 子平台上传活动VO
 */
public class ActivityOrderCreateApi  {

    private String activityOrderId;

    private String activityId;

    private String eventId;

    private String userId;

    private String orderNumber;

    private String orderName;

    private String orderIdentityCard;

    private String orderPhoneNo;

    private String orderSummary;

    private Short orderIsValid;

    private Short orderPayStatus;

    private String orderValidateCode;

    private List<CmsActivityOrderDetail> orderDetailList;

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

    public String getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(String orderNumber) {
        this.orderNumber = orderNumber;
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

    public Short getOrderIsValid() {
        return orderIsValid;
    }

    public void setOrderIsValid(Short orderIsValid) {
        this.orderIsValid = orderIsValid;
    }

    public Short getOrderPayStatus() {
        return orderPayStatus;
    }

    public void setOrderPayStatus(Short orderPayStatus) {
        this.orderPayStatus = orderPayStatus;
    }

    public String getOrderValidateCode() {
        return orderValidateCode;
    }

    public void setOrderValidateCode(String orderValidateCode) {
        this.orderValidateCode = orderValidateCode;
    }

    public List<CmsActivityOrderDetail> getOrderDetailList() {
        return orderDetailList;
    }

    public void setOrderDetailList(List<CmsActivityOrderDetail> orderDetailList) {
        this.orderDetailList = orderDetailList;
    }
}
