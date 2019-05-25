package com.sun3d.why.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class CmsActivityOrder implements Serializable{
    /**活动订单显示座位号 **/
    private String seatVals;
    /**订单消耗的积分 **/

    private String costTotalCredit;

    public String getSeatVals() {
        return seatVals;
    }

    public void setSeatVals(String seatVals) {
        this.seatVals = seatVals;
    }

    /**截取后的活动市 **/
    private String  city;
    /**截取后的活动区 **/
    private String area;

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    /**活动是否可预订 **/
    private Integer activityIsReservation;

    public Integer getActivityIsReservation() {
        return activityIsReservation;
    }

    public void setActivityIsReservation(Integer activityIsReservation) {
        this.activityIsReservation = activityIsReservation;
    }

    /**活动订单序号 **/
    private String orderLine;

    public String getOrderLine() {
        return orderLine;
    }

    public void setOrderLine(String orderLine) {
        this.orderLine = orderLine;
    }
    /**用户名 **/
    private String userName;

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    /**座位状态 **/
    private String seatStatus;

    public String getSeatStatus() {
        return seatStatus;
    }

    public void setSeatStatus(String seatStatus) {
        this.seatStatus = seatStatus;
    }

    /**活动座位 **/
    private String seats;

    public String getSeats() {
        return seats;
    }

    public void setSeats(String seats) {
        this.seats = seats;
    }

    /**字典名称 **/
    private String dictName;

    public String getDictName() {
        return dictName;
    }

    public void setDictName(String dictName) {
        this.dictName = dictName;
    }

    /**活动评论总数 **/
    private Integer commentNums;

    public Integer getCommentNums() {
        return commentNums;
    }

    public void setCommentNums(Integer commentNums) {
        this.commentNums = commentNums;
    }

    private String activityOrderId;

    private String activityId;

    private String activityIsFree;

    private String activitySalesOnline;

    private String activityArea;

    private String activityName;

    private  String activityAddress;

    private  String activityIconUrl;

    private String activityState;

    private String userId;

    private String orderNumber;

    private BigDecimal orderPrice;

    private String orderName;
    
    private String orderIdentityCard;

    private String orderPhoneNo;

    private String orderSummary;

    private Short orderIsValid;

    private Date orderCreateTime;

    private Short orderPayStatus;

    private Short orderPayType;

    private Date orderPayTime;

    private Integer orderVotes;

    private  Integer orderType;

    private String sysId;

    private String sysUserId;

    private String eventId;

    private Integer orderSms;

    private String orderValidateCode;

    private String activityTime;

    private String activityStartTime;

    private String activityEndTime;

    private String venueId;

    private String eventDateTime;

    private String eventDate;

    private String eventEndDate;

    private String eventTime;

    private String venueName;
    
    private String venueAddress;

    private Date orderUpdateTime;

    private Integer createActivityCode;

    private String activityCity;
    /**取票次数 **/
    private Integer printTicketTimes;

    private Date orderCheckTime;
    
    private Integer deductionCredit;

    private Integer surplusCount;

    private Short orderPaymentStatus;
    
    private String orderPayPreparId;
    
    private Date orderApplyRefundTime;
    
    private Date orderRefundTime;
    
    private Integer priceType;    //价格类型   0：XX元起  1:XX元/人
    
    private String orderCustomInfo;
    
    private Date cancelEndTime;

    public Date getOrderCheckTime() {
        return orderCheckTime;
    }

    public void setOrderCheckTime(Date orderCheckTime) {
        this.orderCheckTime = orderCheckTime;
    }

    public Integer getPrintTicketTimes() {
        return printTicketTimes;
    }

    public void setPrintTicketTimes(Integer printTicketTimes) {
        this.printTicketTimes = printTicketTimes;
    }

    public String getActivityCity() {
        return activityCity;
    }

    public void setActivityCity(String activityCity) {
        this.activityCity = activityCity;
    }

    //订单详情
    private List<CmsActivityOrderDetail> activityOrderDetailList;


    public List<CmsActivityOrderDetail> getActivityOrderDetailList() {
        return activityOrderDetailList;
    }

    public void setActivityOrderDetailList(List<CmsActivityOrderDetail> activityOrderDetailList) {
        this.activityOrderDetailList = activityOrderDetailList;
    }


    public Integer getCreateActivityCode() {
        return createActivityCode;
    }

    public void setCreateActivityCode(Integer createActivityCode) {
        this.createActivityCode = createActivityCode;
    }

    public Date getOrderUpdateTime() {
        return orderUpdateTime;
    }

    public void setOrderUpdateTime(Date orderUpdateTime) {
        this.orderUpdateTime = orderUpdateTime;
    }

    public String getVenueName() {
        return venueName;
    }

    public void setVenueName(String venueName) {
        this.venueName = venueName;
    }
    
    public String getVenueAddress() {
		return venueAddress;
	}

	public void setVenueAddress(String venueAddress) {
		this.venueAddress = venueAddress;
	}

	public String getEventDate() {
        return eventDate;
    }

    public void setEventDate(String eventDate) {
        this.eventDate = eventDate;
    }

    public String getEventTime() {
        return eventTime;
    }

    public void setEventTime(String eventTime) {
        this.eventTime = eventTime;
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

    public String getSysUserId() {
        return sysUserId;
    }

    public void setSysUserId(String sysUserId) {
        this.sysUserId = sysUserId;
    }
    private String sysNo;

    public Integer getOrderType() {
        return orderType;
    }

    public void setOrderType(Integer orderType) {
        this.orderType = orderType;
    }

    public Integer getOrderSms() {
        return orderSms;
    }

    public void setOrderSms(Integer orderSms) {
        this.orderSms = orderSms;
    }

    public String getVenueId() {
        return venueId;
    }

    public void setVenueId(String venueId) {
        this.venueId = venueId;
    }

    public String getActivityIconUrl() {
        return activityIconUrl;
    }

    public void setActivityIconUrl(String activityIconUrl) {
        this.activityIconUrl = activityIconUrl;
    }

    public String getActivityTime() {
        return activityTime;
    }

    public void setActivityTime(String activityTime) {
        this.activityTime = activityTime;
    }

    public String getActivityAddress() {
        return activityAddress;
    }

    public void setActivityAddress(String activityAddress) {
        this.activityAddress = activityAddress;
    }

    public String getActivityOrderId() {
        return activityOrderId;
    }

    public void setActivityOrderId(String activityOrderId) {
        this.activityOrderId = activityOrderId == null ? null : activityOrderId.trim();
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId == null ? null : activityId.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(String orderNumber) {
        this.orderNumber = orderNumber == null ? null : orderNumber.trim();
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
        this.orderName = orderName == null ? null : orderName.trim();
    }

    public String getOrderPhoneNo() {
        return orderPhoneNo;
    }

    public void setOrderPhoneNo(String orderPhoneNo) {
        this.orderPhoneNo = orderPhoneNo == null ? null : orderPhoneNo.trim();
    }

    public String getOrderSummary() {
        return orderSummary;
    }

    public void setOrderSummary(String orderSummary) {
        this.orderSummary = orderSummary == null ? null : orderSummary.trim();
    }

    public Short getOrderIsValid() {
        return orderIsValid;
    }

    public void setOrderIsValid(Short orderIsValid) {
        this.orderIsValid = orderIsValid;
    }

    public Date getOrderCreateTime() {
        return orderCreateTime;
    }

    public void setOrderCreateTime(Date orderCreateTime) {
        this.orderCreateTime = orderCreateTime;
    }

    public Short getOrderPayStatus() {
        return orderPayStatus;
    }

    public void setOrderPayStatus(Short orderPayStatus) {
        this.orderPayStatus = orderPayStatus;
    }

    public Short getOrderPayType() {
        return orderPayType;
    }

    public void setOrderPayType(Short orderPayType) {
        this.orderPayType = orderPayType;
    }

    public Date getOrderPayTime() {
        return orderPayTime;
    }

    public void setOrderPayTime(Date orderPayTime) {
        this.orderPayTime = orderPayTime;
    }

    public Integer getOrderVotes() {
        return orderVotes;
    }

    public void setOrderVotes(Integer orderVotes) {
        this.orderVotes = orderVotes;
    }



    public String getOrderValidateCode() {
        return orderValidateCode;
    }

    public void setOrderValidateCode(String orderValidateCode) {
        this.orderValidateCode = orderValidateCode == null ? null : orderValidateCode.trim();
    }

    public String getActivityIsFree() {
        return activityIsFree;
    }

    public void setActivityIsFree(String activityIsFree) {
        this.activityIsFree = activityIsFree;
    }

    public String getActivityArea() {
        return activityArea;
    }

    public void setActivityArea(String activityArea) {
        this.activityArea = activityArea;
    }

    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName;
    }

    public String getActivityState() {
        return activityState;
    }

    public void setActivityState(String activityState) {
        this.activityState = activityState;
    }

    public String getActivitySalesOnline() {
        return activitySalesOnline;
    }

    public void setActivitySalesOnline(String activitySalesOnline) {
        this.activitySalesOnline = activitySalesOnline;
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

	public String getEventEndDate() {
		return eventEndDate;
	}

	public void setEventEndDate(String eventEndDate) {
		this.eventEndDate = eventEndDate;
	}

	public Integer getDeductionCredit() {
		return deductionCredit;
	}

	public void setDeductionCredit(Integer deductionCredit) {
		this.deductionCredit = deductionCredit;
	}


    public Integer getSurplusCount() {
        return surplusCount;
    }

    public void setSurplusCount(Integer surplusCount) {
        this.surplusCount = surplusCount;
    }

	public Short getOrderPaymentStatus() {
		return orderPaymentStatus;
	}

	public void setOrderPaymentStatus(Short orderPaymentStatus) {
		this.orderPaymentStatus = orderPaymentStatus;
	}

	public String getOrderPayPreparId() {
		return orderPayPreparId;
	}

	public void setOrderPayPreparId(String orderPayPreparId) {
		this.orderPayPreparId = orderPayPreparId;
	}

	public Date getOrderApplyRefundTime() {
		return orderApplyRefundTime;
	}

	public void setOrderApplyRefundTime(Date orderApplyRefundTime) {
		this.orderApplyRefundTime = orderApplyRefundTime;
	}

	public Date getOrderRefundTime() {
		return orderRefundTime;
	}

	public void setOrderRefundTime(Date orderRefundTime) {
		this.orderRefundTime = orderRefundTime;
	}

	public Integer getPriceType() {
		return priceType;
	}

	public void setPriceType(Integer priceType) {
		this.priceType = priceType;
	}

	public String getOrderCustomInfo() {
		return orderCustomInfo;
	}

	public void setOrderCustomInfo(String orderCustomInfo) {
		this.orderCustomInfo = orderCustomInfo;
	}

	public Date getCancelEndTime() {
		return cancelEndTime;
	}

	public void setCancelEndTime(Date cancelEndTime) {
		this.cancelEndTime = cancelEndTime;
	}
	
	
    
}