package com.culturecloud.model.bean.activity;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

import javax.persistence.Column;
import java.util.Date;
@Table(value="cms_activity_seat")
public class CmsActivitySeat implements BaseEntity {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column cms_activity_seat.ACTIVITY_SEAT_ID
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    @Id
    @Column(name="ACTIVITY_SEAT_ID")
    private String activitySeatId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column cms_activity_seat.SEAT_PRICE
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    @Column(name="SEAT_PRICE")
    private Long seatPrice;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column cms_activity_seat.SEAT_STATUS
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    @Column(name="SEAT_STATUS")
    private Integer seatStatus;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column cms_activity_seat.SEAT_IS_SOLD
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    @Column(name="SEAT_IS_SOLD")
    private Integer seatIsSold;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column cms_activity_seat.TICKET
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    @Column(name="TICKET")
    private Integer ticket;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column cms_activity_seat.ACTIVITY_ID
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    @Column(name="ACTIVITY_ID")
    private String activityId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column cms_activity_seat.EVENT_ID
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    @Column(name="EVENT_ID")
    private String eventId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column cms_activity_seat.SEAT_ROW
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    @Column(name="SEAT_ROW")
    private Integer seatRow;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column cms_activity_seat.SEAT_COLUMN
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    @Column(name="SEAT_COLUMN")
    private Integer seatColumn;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column cms_activity_seat.SEAT_AREA
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    @Column(name="SEAT_AREA")
    private String seatArea;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column cms_activity_seat.SEAT_CODE
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    @Column(name="SEAT_CODE")
    private String seatCode;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column cms_activity_seat.SEAT_CREATE_USER
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    @Column(name="SEAT_CREATE_USER")
    private String seatCreateUser;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column cms_activity_seat.SEAT_UPDATE_USER
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    @Column(name="SEAT_UPDATE_USER")
    private String seatUpdateUser;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column cms_activity_seat.SEAT_CREATE_TIME
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    @Column(name="SEAT_CREATE_TIME")
    private Date seatCreateTime;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column cms_activity_seat.SEAT_UPDATE_TIME
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    @Column(name="SEAT_UPDATE_TIME")
    private Date seatUpdateTime;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column cms_activity_seat.SEAT_ID
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    @Column(name="SEAT_ID")
    private String seatId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column cms_activity_seat.SEAT_VAL
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    @Column(name="SEAT_VAL")
    private String seatVal;

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column cms_activity_seat.ACTIVITY_SEAT_ID
     *
     * @return the value of cms_activity_seat.ACTIVITY_SEAT_ID
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public String getActivitySeatId() {
        return activitySeatId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column cms_activity_seat.ACTIVITY_SEAT_ID
     *
     * @param activitySeatId the value for cms_activity_seat.ACTIVITY_SEAT_ID
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public void setActivitySeatId(String activitySeatId) {
        this.activitySeatId = activitySeatId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column cms_activity_seat.SEAT_PRICE
     *
     * @return the value of cms_activity_seat.SEAT_PRICE
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public Long getSeatPrice() {
        return seatPrice;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column cms_activity_seat.SEAT_PRICE
     *
     * @param seatPrice the value for cms_activity_seat.SEAT_PRICE
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public void setSeatPrice(Long seatPrice) {
        this.seatPrice = seatPrice;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column cms_activity_seat.SEAT_STATUS
     *
     * @return the value of cms_activity_seat.SEAT_STATUS
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public Integer getSeatStatus() {
        return seatStatus;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column cms_activity_seat.SEAT_STATUS
     *
     * @param seatStatus the value for cms_activity_seat.SEAT_STATUS
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public void setSeatStatus(Integer seatStatus) {
        this.seatStatus = seatStatus;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column cms_activity_seat.SEAT_IS_SOLD
     *
     * @return the value of cms_activity_seat.SEAT_IS_SOLD
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public Integer getSeatIsSold() {
        return seatIsSold;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column cms_activity_seat.SEAT_IS_SOLD
     *
     * @param seatIsSold the value for cms_activity_seat.SEAT_IS_SOLD
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public void setSeatIsSold(Integer seatIsSold) {
        this.seatIsSold = seatIsSold;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column cms_activity_seat.TICKET
     *
     * @return the value of cms_activity_seat.TICKET
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public Integer getTicket() {
        return ticket;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column cms_activity_seat.TICKET
     *
     * @param ticket the value for cms_activity_seat.TICKET
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public void setTicket(Integer ticket) {
        this.ticket = ticket;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column cms_activity_seat.ACTIVITY_ID
     *
     * @return the value of cms_activity_seat.ACTIVITY_ID
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public String getActivityId() {
        return activityId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column cms_activity_seat.ACTIVITY_ID
     *
     * @param activityId the value for cms_activity_seat.ACTIVITY_ID
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column cms_activity_seat.EVENT_ID
     *
     * @return the value of cms_activity_seat.EVENT_ID
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public String getEventId() {
        return eventId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column cms_activity_seat.EVENT_ID
     *
     * @param eventId the value for cms_activity_seat.EVENT_ID
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public void setEventId(String eventId) {
        this.eventId = eventId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column cms_activity_seat.SEAT_ROW
     *
     * @return the value of cms_activity_seat.SEAT_ROW
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public Integer getSeatRow() {
        return seatRow;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column cms_activity_seat.SEAT_ROW
     *
     * @param seatRow the value for cms_activity_seat.SEAT_ROW
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public void setSeatRow(Integer seatRow) {
        this.seatRow = seatRow;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column cms_activity_seat.SEAT_COLUMN
     *
     * @return the value of cms_activity_seat.SEAT_COLUMN
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public Integer getSeatColumn() {
        return seatColumn;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column cms_activity_seat.SEAT_COLUMN
     *
     * @param seatColumn the value for cms_activity_seat.SEAT_COLUMN
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public void setSeatColumn(Integer seatColumn) {
        this.seatColumn = seatColumn;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column cms_activity_seat.SEAT_AREA
     *
     * @return the value of cms_activity_seat.SEAT_AREA
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public String getSeatArea() {
        return seatArea;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column cms_activity_seat.SEAT_AREA
     *
     * @param seatArea the value for cms_activity_seat.SEAT_AREA
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public void setSeatArea(String seatArea) {
        this.seatArea = seatArea;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column cms_activity_seat.SEAT_CODE
     *
     * @return the value of cms_activity_seat.SEAT_CODE
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public String getSeatCode() {
        return seatCode;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column cms_activity_seat.SEAT_CODE
     *
     * @param seatCode the value for cms_activity_seat.SEAT_CODE
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public void setSeatCode(String seatCode) {
        this.seatCode = seatCode;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column cms_activity_seat.SEAT_CREATE_USER
     *
     * @return the value of cms_activity_seat.SEAT_CREATE_USER
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public String getSeatCreateUser() {
        return seatCreateUser;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column cms_activity_seat.SEAT_CREATE_USER
     *
     * @param seatCreateUser the value for cms_activity_seat.SEAT_CREATE_USER
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public void setSeatCreateUser(String seatCreateUser) {
        this.seatCreateUser = seatCreateUser;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column cms_activity_seat.SEAT_UPDATE_USER
     *
     * @return the value of cms_activity_seat.SEAT_UPDATE_USER
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public String getSeatUpdateUser() {
        return seatUpdateUser;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column cms_activity_seat.SEAT_UPDATE_USER
     *
     * @param seatUpdateUser the value for cms_activity_seat.SEAT_UPDATE_USER
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public void setSeatUpdateUser(String seatUpdateUser) {
        this.seatUpdateUser = seatUpdateUser;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column cms_activity_seat.SEAT_CREATE_TIME
     *
     * @return the value of cms_activity_seat.SEAT_CREATE_TIME
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public Date getSeatCreateTime() {
        return seatCreateTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column cms_activity_seat.SEAT_CREATE_TIME
     *
     * @param seatCreateTime the value for cms_activity_seat.SEAT_CREATE_TIME
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public void setSeatCreateTime(Date seatCreateTime) {
        this.seatCreateTime = seatCreateTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column cms_activity_seat.SEAT_UPDATE_TIME
     *
     * @return the value of cms_activity_seat.SEAT_UPDATE_TIME
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public Date getSeatUpdateTime() {
        return seatUpdateTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column cms_activity_seat.SEAT_UPDATE_TIME
     *
     * @param seatUpdateTime the value for cms_activity_seat.SEAT_UPDATE_TIME
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public void setSeatUpdateTime(Date seatUpdateTime) {
        this.seatUpdateTime = seatUpdateTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column cms_activity_seat.SEAT_ID
     *
     * @return the value of cms_activity_seat.SEAT_ID
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public String getSeatId() {
        return seatId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column cms_activity_seat.SEAT_ID
     *
     * @param seatId the value for cms_activity_seat.SEAT_ID
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public void setSeatId(String seatId) {
        this.seatId = seatId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column cms_activity_seat.SEAT_VAL
     *
     * @return the value of cms_activity_seat.SEAT_VAL
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public String getSeatVal() {
        return seatVal;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column cms_activity_seat.SEAT_VAL
     *
     * @param seatVal the value for cms_activity_seat.SEAT_VAL
     *
     * @mbggenerated Mon Jul 25 14:56:35 CST 2016
     */
    public void setSeatVal(String seatVal) {
        this.seatVal = seatVal;
    }
}