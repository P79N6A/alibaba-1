package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;

public class CmsRoomBook extends Pagination implements Serializable{

    private String sId;

    private String bookId;

    private Date curDate;

    private String openPeriod;

    private Integer timeSort;

    private Integer dayOfWeek;

    private Integer bookStatus;

    private String tuserId;

    private String userId;

    private String userName;

    private String userTel;

    private Date createTime;

    private String orderNo;

    private Date updateTime;

    private String roomId;

    private Date curDateBegin;

    private Integer curDateOperator;
    private  String times;

    private String sysId;
    private String sysNo;
    private String bookIds;

    //团体名称 add by cj 2015-12-10
    private String tuserName;

    private String bookStatuStr;

    public String getBookIds() {
        return bookIds;
    }

    public void setBookIds(String bookIds) {
        this.bookIds = bookIds;
    }

    public String getTimes() {
        return times;
    }

    public void setTimes(String times) {
        this.times = times;
    }


    public String getsId() {
        return sId;
    }

    public void setsId(String sId) {
        this.sId = sId;
    }


    public String getBookId() {
        return bookId!=null ?bookId:"";
    }

    public void setBookId(String bookId) {
        this.bookId = bookId == null ? null : bookId.trim();
    }

    public Date getCurDate() {
        return curDate;
    }

    public void setCurDate(Date curDate) {
        this.curDate = curDate;
    }

    public String getOpenPeriod() {
        return openPeriod;
    }

    public void setOpenPeriod(String openPeriod) {
        this.openPeriod = openPeriod;
    }

    public Integer getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(Integer dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public Integer getBookStatus() {
        return bookStatus;
    }

    public void setBookStatus(Integer bookStatus) {
        this.bookStatus = bookStatus;
    }

    public String getTuserId() {
        return tuserId;
    }

    public void setTuserId(String tuserId) {
        this.tuserId = tuserId == null ? null : tuserId.trim();
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

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo == null ? null : orderNo.trim();
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId == null ? null : roomId.trim();
    }

    public Integer getCurDateOperator() {
        return curDateOperator;
    }

    public void setCurDateOperator(Integer curDateOperator) {
        this.curDateOperator = curDateOperator;
    }

    public Date getCurDateBegin() {
        return curDateBegin;
    }

    public void setCurDateBegin(Date curDateBegin) {
        this.curDateBegin = curDateBegin;
    }

    public Integer getTimeSort() {
        return timeSort;
    }

    public void setTimeSort(Integer timeSort) {
        this.timeSort = timeSort;
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

    public String getTuserName() {
        return tuserName;
    }

    public void setTuserName(String tuserName) {
        this.tuserName = tuserName;
    }

	public String getBookStatuStr() {
		return bookStatuStr;
	}

	public void setBookStatuStr(String bookStatuStr) {
		this.bookStatuStr = bookStatuStr;
	}
    
    
}