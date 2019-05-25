package com.sun3d.why.model;

import java.io.Serializable;

/**
 * @author  yjb
 */
public class ActivityData implements Serializable {

    private String area; //区域

    private String dictName; //街道
    private String dictId; //街道

    private String venueName; //场馆
    private String venueId; //场馆

    private int activityCount; // 活动总数

    private int bookActivityCount; //可预订活动数

    private int activityTicketCount; //发票数

    private int orderCount;//订单数

    private int orderTicketCount;//订票数

    /**
     * 活动开始时间
     */
    private String activityStartTime;

    /**
     * 活动结束时间
     */
    private String activityEndTime;

    private Integer queryType;//1:昨日，2:本周，3：本月，4：自定义

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public int getActivityCount() {
        return activityCount;
    }

    public void setActivityCount(int activityCount) {
        this.activityCount = activityCount;
    }

    public int getBookActivityCount() {
        return bookActivityCount;
    }

    public void setBookActivityCount(int bookActivityCount) {
        this.bookActivityCount = bookActivityCount;
    }

    public int getActivityTicketCount() {
        return activityTicketCount;
    }

    public void setActivityTicketCount(int activityTicketCount) {
        this.activityTicketCount = activityTicketCount;
    }

    public int getOrderCount() {
        return orderCount;
    }

    public void setOrderCount(int orderCount) {
        this.orderCount = orderCount;
    }

    public int getOrderTicketCount() {
        return orderTicketCount;
    }

    public void setOrderTicketCount(int orderTicketCount) {
        this.orderTicketCount = orderTicketCount;
    }

    public String getVenueName() {
        return venueName;
    }

    public void setVenueName(String venueName) {
        this.venueName = venueName;
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

    public Integer getQueryType() {
        return queryType;
    }

    public void setQueryType(Integer queryType) {
        this.queryType = queryType;
    }

    public String getDictName() {
        return dictName;
    }

    public void setDictName(String dictName) {
        this.dictName = dictName;
    }

    public String getDictId() {
        return dictId;
    }

    public void setDictId(String dictId) {
        this.dictId = dictId;
    }

    public String getVenueId() {
        return venueId;
    }

    public void setVenueId(String venueId) {
        this.venueId = venueId;
    }
}