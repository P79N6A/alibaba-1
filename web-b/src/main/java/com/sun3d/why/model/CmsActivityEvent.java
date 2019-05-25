package com.sun3d.why.model;

import java.util.Date;

public class CmsActivityEvent {
    /**
     * 每个活动场次数量
     **/
    private Integer counts;

    private String eventId;

    private String activityId;

    private String eventDate;

    private String eventEndDate;

    private String eventTime;

    private Integer availableCount;

    private String eventDateTime;

    private Integer singleEvent;    //是否是单场次活动 0：非单场次 1：单场次

    private Integer spikeType;        //是否是秒杀   0：非秒杀  1:秒杀

    private Date spikeTime;        //秒杀时间

    private String orderPrice;    //每个场次的票价

    private String seatIds;       //每个场次对应的座位信息

    private Integer orderCount;



    public String getEventDateTime() {
        return eventDateTime;
    }

    public void setEventDateTime(String eventDateTime) {
        this.eventDateTime = eventDateTime;
    }

    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId == null ? null : eventId.trim();
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId == null ? null : activityId.trim();
    }

    public String getEventDate() {
        return eventDate;
    }

    public void setEventDate(String eventDate) {
        this.eventDate = eventDate == null ? null : eventDate.trim();
    }

    public String getEventEndDate() {
        return eventEndDate;
    }

    public void setEventEndDate(String eventEndDate) {
        this.eventEndDate = eventEndDate;
    }

    public String getEventTime() {
        return eventTime;
    }

    public void setEventTime(String eventTime) {
        this.eventTime = eventTime == null ? null : eventTime.trim();
    }

    public Integer getAvailableCount() {
        return availableCount;
    }

    public void setAvailableCount(Integer availableCount) {
        this.availableCount = availableCount;
    }

    public Integer getCounts() {
        return counts;
    }

    public void setCounts(Integer counts) {
        this.counts = counts;
    }

    public Integer getSingleEvent() {
        return singleEvent;
    }

    public void setSingleEvent(Integer singleEvent) {
        this.singleEvent = singleEvent;
    }

    public Integer getSpikeType() {
        return spikeType;
    }

    public void setSpikeType(Integer spikeType) {
        this.spikeType = spikeType;
    }

    public Date getSpikeTime() {
        return spikeTime;
    }

    public void setSpikeTime(Date spikeTime) {
        this.spikeTime = spikeTime;
    }

    public String getOrderPrice() {
        return orderPrice;
    }

    public void setOrderPrice(String orderPrice) {
        this.orderPrice = orderPrice;
    }

    public String getSeatIds() {
        return seatIds;
    }

    public void setSeatIds(String seatIds) {
        this.seatIds = seatIds;
    }

    public Integer getOrderCount() {
        return orderCount;
    }

    public void setOrderCount(Integer orderCount) {
        this.orderCount = orderCount;
    }
}