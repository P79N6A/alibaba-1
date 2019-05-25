package com.culturecloud.model.bean.activity;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

import javax.persistence.Column;
import java.util.Date;

@Table(value="cms_activity_event")
public class CmsActivityEvent implements BaseEntity {

    private static final long serialVersionUID = -3586841584989510841L;

    @Id
    @Column(name="EVENT_ID")
    private String eventId;


    @Column(name="ACTIVITY_ID")
    private String activityId;


    @Column(name="EVENT_DATE")
    private String eventDate;


    @Column(name="EVENT_END_DATE")
    private String eventEndDate;


    @Column(name="EVENT_TIME")
    private String eventTime;


    @Column(name="AVAILABLE_COUNT")
    private Integer availableCount;


    @Column(name="EVENT_DATE_TIME")
    private String eventDateTime;


    @Column(name="SINGLE_EVENT")
    private Integer singleEvent;


    @Column(name="SPIKE_TYPE")
    private Integer spikeType;


    @Column(name="SPIKE_TIME")
    private Date spikeTime;


    @Column(name="ORDER_PRICE")
    private String orderPrice;
    
    @Column(name="ORDER_COUNT")
    private Integer orderCount;


    public String getEventId() {
        return eventId;
    }


    public void setEventId(String eventId) {
        this.eventId = eventId;
    }


    public String getActivityId() {
        return activityId;
    }


    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }


    public String getEventDate() {
        return eventDate;
    }


    public void setEventDate(String eventDate) {
        this.eventDate = eventDate;
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
        this.eventTime = eventTime;
    }


    public Integer getAvailableCount() {
        return availableCount;
    }


    public void setAvailableCount(Integer availableCount) {
        this.availableCount = availableCount;
    }


    public String getEventDateTime() {
        return eventDateTime;
    }


    public void setEventDateTime(String eventDateTime) {
        this.eventDateTime = eventDateTime;
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


	public Integer getOrderCount() {
		return orderCount;
	}


	public void setOrderCount(Integer orderCount) {
		this.orderCount = orderCount;
	}
    
    
}