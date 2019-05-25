package com.culturecloud.dao.dto.activity;

import com.culturecloud.bean.BaseEntity;

import java.util.Date;
import java.util.List;

public class ActivityEventVO implements BaseEntity {

    private static final long serialVersionUID = -3586841584989510841L;

    private String eventId;


    /*
    private string activityId;
    
     
    private String eventDate;


    private String eventEndDate;


    private String eventTime;*/


    private Integer availableCount;


    private String eventDateTime;


    private Integer singleEvent;


    private Integer spikeType;


    private Date spikeTime;


    private String orderPrice;
    
    private Integer orderCount;

    private List<ActivitySeatVO> activityEventSeat;

    public String getEventId() {
        return eventId;
    }


    public void setEventId(String eventId) {
        this.eventId = eventId;
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


	public List<ActivitySeatVO> getActivityEventSeat() {
		return activityEventSeat;
	}


	public void setActivityEventSeat(List<ActivitySeatVO> activityEventSeat) {
		this.activityEventSeat = activityEventSeat;
	}


    
}