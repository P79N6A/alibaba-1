package com.sun3d.why.model.extmodel;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Created by yujinbing on 2015/6/25.
 */
public class BookActivitySeatInfo implements Serializable{

    private String sId;

    private Integer bookCount;

    private String userId;

    private String[] seatIds;

    private String phone;

    private String activityId;

    private String activitySeatId;

    private String orderNumber;
    
    private String orderName;
    
    private String orderIdentityCard;
    
    private String costTotalCredit;
   
    private BigDecimal price;

    private  Integer type;

    private String sysId;

    private String sysNo;

    //场次的时间信息
    private String eventDateTime;

    //场次id
    private String eventId;

    // 是否是进行预定  true 代表活动预定  false  代表取消订单的预定
    private boolean isBook;

    private String orderId;

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public boolean isBook() {
        return isBook;
    }

    public void setBook(boolean isBook) {
        this.isBook = isBook;
    }

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
        this.eventId = eventId;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public String getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(String orderNumber) {
        this.orderNumber = orderNumber;
    }

    public Integer getBookCount() {
        return bookCount;
    }

    public void setBookCount(Integer bookCount) {
        this.bookCount = bookCount;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getsId() {
        return sId;
    }

    public void setsId(String sId) {
        this.sId = sId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String[] getSeatIds() {
        return seatIds;
    }

    public void setSeatIds(String[] seatIds) {
        this.seatIds = seatIds;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    public String getActivitySeatId() {
        return activitySeatId;
    }

    public void setActivitySeatId(String activitySeatId) {
        this.activitySeatId = activitySeatId;
    }

	public String getSysId() {
		return sysId;
	}

	public void setSysId(String sysId) {
		this.sysId = sysId;
	}

	public String getSysNo() {
		return sysNo;
	}

	public void setSysNo(String sysNo) {
		this.sysNo = sysNo;
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

	public String getCostTotalCredit() {
		return costTotalCredit;
	}

	public void setCostTotalCredit(String costTotalCredit) {
		this.costTotalCredit = costTotalCredit;
	}
	
}
