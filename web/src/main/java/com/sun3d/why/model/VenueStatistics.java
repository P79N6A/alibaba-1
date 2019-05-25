package com.sun3d.why.model;

import java.io.Serializable;
import java.util.Date;

public class VenueStatistics implements Serializable {
    private String venueArea;

    private Integer todayLook;

    private Integer weekLook;

    private Integer monthLook;

    private Integer quarterLook;

    private Integer yearLook;

    private Integer weekBook;

    private Integer monthBook;

    private Integer quarterBook;

    private Integer yearBook;

    private Integer numRoom;

    private Integer usedRoom;

    private Integer bookRoom;

    private String preRoom;

    private String tagName;

    private Integer numVenue;

    private Integer numLook;

    private Integer venueMessage;

    private String  venueName;

    private String  venueId;

    private String  numMessage;

    /**
     * 活动开始时间
     */
    private String activityStartTime;

    /**
     * 活动结束时间
     */
    private String activityEndTime;

    private String commentRkId;

    private String commentRemark;

    private Date commentTime;
    //评论人昵称
    private  String commentUserNickName;

    private String commentImgUrl;

    private Integer commentCount;

    public String getVenueArea() {
        return venueArea;
    }

    public void setVenueArea(String venueArea) {
        this.venueArea = venueArea;
    }

    public Integer getTodayLook() {
        return todayLook;
    }

    public void setTodayLook(Integer todayLook) {
        this.todayLook = todayLook;
    }

    public Integer getWeekLook() {
        return weekLook;
    }

    public void setWeekLook(Integer weekLook) {
        this.weekLook = weekLook;
    }

    public Integer getMonthLook() {
        return monthLook;
    }

    public void setMonthLook(Integer monthLook) {
        this.monthLook = monthLook;
    }

    public Integer getQuarterLook() {
        return quarterLook;
    }

    public void setQuarterLook(Integer quarterLook) {
        this.quarterLook = quarterLook;
    }

    public Integer getYearLook() {
        return yearLook;
    }

    public void setYearLook(Integer yearLook) {
        this.yearLook = yearLook;
    }

    public Integer getWeekBook() {
        return weekBook;
    }

    public void setWeekBook(Integer weekBook) {
        this.weekBook = weekBook;
    }

    public Integer getMonthBook() {
        return monthBook;
    }

    public void setMonthBook(Integer monthBook) {
        this.monthBook = monthBook;
    }

    public Integer getQuarterBook() {
        return quarterBook;
    }

    public void setQuarterBook(Integer quarterBook) {
        this.quarterBook = quarterBook;
    }

    public Integer getYearBook() {
        return yearBook;
    }

    public void setYearBook(Integer yearBook) {
        this.yearBook = yearBook;
    }

    public Integer getUsedRoom() {
        return usedRoom;
    }

    public void setUsedRoom(Integer usedRoom) {
        this.usedRoom = usedRoom;
    }

    public Integer getBookRoom() {
        return bookRoom;
    }

    public void setBookRoom(Integer bookRoom) {
        this.bookRoom = bookRoom;
    }




    public Integer getNumVenue() {
        return numVenue;
    }

    public void setNumVenue(Integer numVenue) {
        this.numVenue = numVenue;
    }

    public Integer getNumLook() {
        return numLook;
    }

    public void setNumLook(Integer numLook) {
        this.numLook = numLook;
    }

    public Integer getVenueMessage() {
        return venueMessage;
    }

    public void setVenueMessage(Integer venueMessage) {
        this.venueMessage = venueMessage;
    }

    public String getTagName() {
        return tagName;
    }

    public void setTagName(String tagName) {
        this.tagName = tagName;
    }

    public Integer getNumRoom() {
        return numRoom;
    }

    public void setNumRoom(Integer numRoom) {
        this.numRoom = numRoom;
    }

    public String getVenueName() {
        return venueName;
    }

    public void setVenueName(String venueName) {
        this.venueName = venueName;
    }

    public String getVenueId() {
        return venueId;
    }

    public void setVenueId(String venueId) {
        this.venueId = venueId;
    }

    public String getNumMessage() {
        return numMessage;
    }

    public void setNumMessage(String numMessage) {
        this.numMessage = numMessage;
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

    public String getCommentRkId() {
        return commentRkId;
    }

    public void setCommentRkId(String commentRkId) {
        this.commentRkId = commentRkId;
    }

    public String getCommentRemark() {
        return commentRemark;
    }

    public void setCommentRemark(String commentRemark) {
        this.commentRemark = commentRemark;
    }

    public Date getCommentTime() {
        return commentTime;
    }

    public void setCommentTime(Date commentTime) {
        this.commentTime = commentTime;
    }

    public String getCommentUserNickName() {
        return commentUserNickName;
    }

    public void setCommentUserNickName(String commentUserNickName) {
        this.commentUserNickName = commentUserNickName;
    }

    public String getCommentImgUrl() {
        return commentImgUrl;
    }

    public void setCommentImgUrl(String commentImgUrl) {
        this.commentImgUrl = commentImgUrl;
    }

    public Integer getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(Integer commentCount) {
        this.commentCount = commentCount;
    }

    public String getPreRoom() {
        return preRoom;
    }

    public void setPreRoom(String preRoom) {
        this.preRoom = preRoom;
    }
}
