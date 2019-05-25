package com.sun3d.why.model;

import java.io.Serializable;
import java.util.Date;

public class CmsActivitySeat implements Serializable{
    /**
	 * 
	 */
	private static final long serialVersionUID = -6531590648305211143L;

	private String activitySeatId;

    private Long seatPrice;

    private Integer seatStatus;

    private Integer seatIsSold;

    private Integer ticket;

    private String activityId;

    private String eventId;

    private Integer seatRow;

    private Integer seatColumn;

    private String seatArea;

    private String seatCode;

    private String seatCreateUser;

    private String seatUpdateUser;

    private Date seatCreateTime;

    private Date seatUpdateTime;

    private String seatId;

    //总票数
    private Integer totalTicket;

    private String seatVal;

    public String getSeatVal() {
        return seatVal;
    }

    public void setSeatVal(String seatVal) {
        this.seatVal = seatVal;
    }

    public void setTotalTicket(Integer totalTicket) {
        this.totalTicket = totalTicket;
    }

    public Integer getTotalTicket() {
        return totalTicket;
    }

    public String getActivitySeatId() {
        return activitySeatId;
    }

    public void setActivitySeatId(String activitySeatId) {
        this.activitySeatId = activitySeatId == null ? null : activitySeatId.trim();
    }

    public Long getSeatPrice() {
        return seatPrice;
    }

    public void setSeatPrice(Long seatPrice) {
        this.seatPrice = seatPrice;
    }

    public Integer getSeatStatus() {
        return seatStatus;
    }

    public void setSeatStatus(Integer seatStatus) {
        this.seatStatus = seatStatus;
    }

    public Integer getSeatIsSold() {
        return seatIsSold;
    }

    public void setSeatIsSold(Integer seatIsSold) {
        this.seatIsSold = seatIsSold;
    }

    public Integer getTicket() {
        return ticket;
    }

    public void setTicket(Integer ticket) {
        this.ticket = ticket;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId == null ? null : activityId.trim();
    }

    public Integer getSeatRow() {
        return seatRow;
    }

    public void setSeatRow(Integer seatRow) {
        this.seatRow = seatRow == null ? null : seatRow;
    }

    public Integer getSeatColumn() {
        return seatColumn;
    }

    public void setSeatColumn(Integer seatColumn) {
        this.seatColumn = seatColumn == null ? null : seatColumn;
    }

    public String getSeatArea() {
        return seatArea;
    }

    public void setSeatArea(String seatArea) {
        this.seatArea = seatArea == null ? null : seatArea.trim();
    }

    public String getSeatCode() {
        return seatCode;
    }

    public void setSeatCode(String seatCode) {
        this.seatCode = seatCode == null ? null : seatCode.trim();
    }

    public String getSeatCreateUser() {
        return seatCreateUser;
    }

    public void setSeatCreateUser(String seatCreateUser) {
        this.seatCreateUser = seatCreateUser == null ? null : seatCreateUser.trim();
    }

    public String getSeatUpdateUser() {
        return seatUpdateUser;
    }

    public void setSeatUpdateUser(String seatUpdateUser) {
        this.seatUpdateUser = seatUpdateUser == null ? null : seatUpdateUser.trim();
    }

    public Date getSeatCreateTime() {
        return seatCreateTime;
    }

    public void setSeatCreateTime(Date seatCreateTime) {
        this.seatCreateTime = seatCreateTime;
    }

    public Date getSeatUpdateTime() {
        return seatUpdateTime;
    }

    public void setSeatUpdateTime(Date seatUpdateTime) {
        this.seatUpdateTime = seatUpdateTime;
    }

    public String getSeatId() {
        return seatId;
    }

    public void setSeatId(String seatId) {
        this.seatId = seatId == null ? null : seatId.trim();
    }

    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }
}