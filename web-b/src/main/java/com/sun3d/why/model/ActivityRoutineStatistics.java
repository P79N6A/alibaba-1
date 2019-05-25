package com.sun3d.why.model;

public class ActivityRoutineStatistics {

    //活动名称
    private String activityName;

    //活动场馆
    private String venueName;

    //活动开始时间
    private String startTime;

    //活动结束时间
    private String endTime;

    private String eventDateTime;

    //总票数
    private Integer tickets;

    //有效订单数
    private Integer validOrders;

    //有效票数
    private Integer validTickets;

    //验票数
    private Integer checkTickets;

    //验票订单数
    private Integer checkOrders;

    //未到场订单数
    private Integer deadTickets;

    //活动预订率
    private String bookPer;

    //活动到场率
    private String presentPer;

    //取票数
    private Integer takeTickets;

    //取票率
    private String takeTicketsPer;

    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName;
    }

    public String getVenueName() {
        return venueName;
    }

    public void setVenueName(String venueName) {
        this.venueName = venueName;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public Integer getTickets() {
        return tickets;
    }

    public void setTickets(Integer tickets) {
        this.tickets = tickets;
    }

    public Integer getValidOrders() {
        return validOrders;
    }

    public void setValidOrders(Integer validOrders) {
        this.validOrders = validOrders;
    }

    public Integer getValidTickets() {
        return validTickets;
    }

    public void setValidTickets(Integer validTickets) {
        this.validTickets = validTickets;
    }

    public Integer getCheckTickets() {
        return checkTickets;
    }

    public void setCheckTickets(Integer checkTickets) {
        this.checkTickets = checkTickets;
    }

    public Integer getCheckOrders() {
        return checkOrders;
    }

    public void setCheckOrders(Integer checkOrders) {
        this.checkOrders = checkOrders;
    }

    public Integer getDeadTickets() {
        return deadTickets;
    }

    public void setDeadTickets(Integer deadTickets) {
        this.deadTickets = deadTickets;
    }

    public String getBookPer() {
        return bookPer;
    }

    public void setBookPer(String bookPer) {
        this.bookPer = bookPer;
    }

    public String getPresentPer() {
        return presentPer;
    }

    public void setPresentPer(String presentPer) {
        this.presentPer = presentPer;
    }

    public Integer getTakeTickets() {
        return takeTickets;
    }

    public void setTakeTickets(Integer takeTickets) {
        this.takeTickets = takeTickets;
    }

    public String getTakeTicketsPer() {
        return takeTicketsPer;
    }

    public void setTakeTicketsPer(String takeTicketsPer) {
        this.takeTicketsPer = takeTicketsPer;
    }

    public String getEventDateTime() {
        return eventDateTime;
    }

    public void setEventDateTime(String eventDateTime) {
        this.eventDateTime = eventDateTime;
    }
}