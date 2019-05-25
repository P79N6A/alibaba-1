package com.sun3d.why.model;

import java.util.Date;

public class CmsRoomOrder {
    /**截取后的展馆市 **/
    private String city;
    /**截取后的展馆区 **/
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

    /**活动室开放日期 **/
    private String curDates;

    public String getCurDates() {
        return curDates;
    }

    public void setCurDates(String curDates) {
        this.curDates = curDates;
    }

    /**活动室区域 **/
    private String dictName;

    public String getDictName() {
        return dictName;
    }

    public void setDictName(String dictName) {
        this.dictName = dictName;
    }

    /**评论数 **/
    private Integer commentNums;

    public Integer getCommentNums() {
        return commentNums;
    }

    public void setCommentNums(Integer commentNums) {
        this.commentNums = commentNums;
    }

    private String roomOrderId;

    private String userId;

    private String userName;

    private String userTel;

    private String tuserId;

    private String orderNo;

    private String venueId;

    private String roomId;

    private Integer bookStatus;

    private String bookId;

    private String validCode;

    private Date orderCreateTime;

    private Date orderUpdateTime;

    private String roomOpenTime;

    private String venueName;

    private String venueCity;

    private String venueArea;

    private String venueAddress;

    private String roomName;

    private String tuserTeamName;

    private Integer roomIsFree;

    private String roomPicUrl;

    private String orderUpdateUser;

    private String openPeriod;
    private  String roomNo;
    private  String roomArea;
    private  String roomCapacity;
    private String orderNum;

    private Date curDate;
    private  String roomFee;
    
    private String sysNo;
    private String sysId;
    
    /**验证人Id*/
    private String sysUserId;
    /**验证人Name*/
    private String sysUserName;
    
    // 用途
    private String purpose;
    
    // 审核状态
    private Integer checkStatus;
    
    // 团体名称
    private String tuserName;
    
    private Integer dayOfWeek;
   
    
    private Integer userType;
    
    private Integer tuserIsDisplay;
    
    public String getRoomFee() {
        return roomFee;
    }

    public void setRoomFee(String roomFee) {
        this.roomFee = roomFee;
    }

    public String getOrderNum() {
        return orderNum;
    }

    public void setOrderNum(String orderNum) {
        this.orderNum = orderNum;
    }

    public String getRoomCapacity() {
        return roomCapacity;
    }

    public void setRoomCapacity(String roomCapacity) {
        this.roomCapacity = roomCapacity;
    }

    public String getRoomArea() {
        return roomArea;
    }

    public void setRoomArea(String roomArea) {
        this.roomArea = roomArea;
    }

    public String getRoomNo() {
        return roomNo;
    }

    public void setRoomNo(String roomNo) {
        this.roomNo = roomNo;
    }

    public String getRoomPicUrl() {
        return roomPicUrl;
    }

    public void setRoomPicUrl(String roomPicUrl) {
        this.roomPicUrl = roomPicUrl;
    }

    public String getRoomOrderId() {
        return roomOrderId;
    }

    public void setRoomOrderId(String roomOrderId) {
        this.roomOrderId = roomOrderId;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public String getBookId() {
        return bookId;
    }

    public void setBookId(String bookId) {
        this.bookId = bookId;
    }

    public String getValidCode() {
        return validCode;
    }

    public void setValidCode(String validCode) {
        this.validCode = validCode;
    }

    public Date getOrderCreateTime() {
        return orderCreateTime;
    }

    public void setOrderCreateTime(Date orderCreateTime) {
        this.orderCreateTime = orderCreateTime;
    }

    public Date getOrderUpdateTime() {
        return orderUpdateTime;
    }

    public void setOrderUpdateTime(Date orderUpdateTime) {
        this.orderUpdateTime = orderUpdateTime;
    }

    public String getRoomOpenTime() {
        return roomOpenTime;
    }

    public void setRoomOpenTime(String roomOpenTime) {
        this.roomOpenTime = roomOpenTime;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName == null ? null : userName.trim();
    }

    public String getUserTel() {
        return userTel;
    }

    public void setUserTel(String userTel) {
        this.userTel = userTel == null ? null : userTel.trim();
    }

    public String getTuserId() {
        return tuserId;
    }

    public void setTuserId(String tuserId) {
        this.tuserId = tuserId == null ? null : tuserId.trim();
    }

    public String getVenueId() {
        return venueId;
    }

    public void setVenueId(String venueId) {
        this.venueId = venueId == null ? null : venueId.trim();
    }

    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId == null ? null : roomId.trim();
    }

    public Integer getBookStatus() {
        return bookStatus;
    }

    public void setBookStatus(Integer bookStatus) {
        this.bookStatus = bookStatus;
    }

    public String getVenueName() {
        return venueName;
    }

    public void setVenueName(String venueName) {
        this.venueName = venueName;
    }

    public String getVenueCity() {
        return venueCity;
    }

    public void setVenueCity(String venueCity) {
        this.venueCity = venueCity == null ? null : venueCity.trim();
    }

    public String getVenueArea() {
        return venueArea;
    }

    public void setVenueArea(String venueArea) {
        this.venueArea = venueArea == null ? null : venueArea.trim();
    }

    public String getVenueAddress() {
        return venueAddress;
    }

    public void setVenueAddress(String venueAddress) {
        this.venueAddress = venueAddress;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public String getTuserTeamName() {
        return tuserTeamName;
    }

    public void setTuserTeamName(String tuserTeamName) {
        this.tuserTeamName = tuserTeamName;
    }

    public Integer getRoomIsFree() {
        return roomIsFree;
    }

    public void setRoomIsFree(Integer roomIsFree) {
        this.roomIsFree = roomIsFree;
    }

    public String getOrderUpdateUser() {
        return orderUpdateUser;
    }

    public void setOrderUpdateUser(String orderUpdateUser) {
        this.orderUpdateUser = orderUpdateUser;
    }

    public String getOpenPeriod() {
        return openPeriod;
    }

    public void setOpenPeriod(String openPeriod) {
        this.openPeriod = openPeriod;
    }

    public Date getCurDate() {
        return curDate;
    }

    public void setCurDate(Date curDate) {
        this.curDate = curDate;
    }

	public String getSysNo() {
		return sysNo;
	}

	public void setSysNo(String sysNo) {
		this.sysNo = sysNo;
	}

	public String getSysId() {
		return sysId;
	}

	public void setSysId(String sysId) {
		this.sysId = sysId;
	}

	public String getSysUserId() {
		return sysUserId;
	}

	public void setSysUserId(String sysUserId) {
		this.sysUserId = sysUserId;
	}

	public String getSysUserName() {
		return sysUserName;
	}

	public void setSysUserName(String sysUserName) {
		this.sysUserName = sysUserName;
	}

	public String getPurpose() {
		return purpose;
	}

	public void setPurpose(String purpose) {
		this.purpose = purpose;
	}

	public Integer getCheckStatus() {
		return checkStatus;
	}

	public void setCheckStatus(Integer checkStatus) {
		this.checkStatus = checkStatus;
	}

	public String getTuserName() {
		return tuserName;
	}

	public void setTuserName(String tuserName) {
		this.tuserName = tuserName;
	}

	public Integer getDayOfWeek() {
		return dayOfWeek;
	}

	public void setDayOfWeek(Integer dayOfWeek) {
		this.dayOfWeek = dayOfWeek;
	}

	public Integer getUserType() {
		return userType;
	}

	public void setUserType(Integer userType) {
		this.userType = userType;
	}

	public Integer getTuserIsDisplay() {
		return tuserIsDisplay;
	}

	public void setTuserIsDisplay(Integer tuserIsDisplay) {
		this.tuserIsDisplay = tuserIsDisplay;
	}

	
	
	
}