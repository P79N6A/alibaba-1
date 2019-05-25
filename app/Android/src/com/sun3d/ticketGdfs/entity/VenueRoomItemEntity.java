package com.sun3d.ticketGdfs.entity;

/**
 * Created by wangmingming on 2015/10/29.
 */
public class VenueRoomItemEntity {

    /**
     * curDate : 2015-10-29,2015-10-29,2015-10-29,2015-10-29,2015-10-29,2015-10-29,
     * openPeriod : 15:30-17:30,18:00-20:00,15:30-17:30,13:00-15:00,13:00-15:00,13:00-15:00,
     * bookStatus : 1,1,1,1,1,1,
     * roomName : 333333333333333333,rrr,333,333333333333333333,rrr,333,
     * orderIds : 2f605fec8abc40f09333af37a3232994,4989cff94c624fc59696c21227ac54ab,5648ee234106439797af1c5fd717480d,db382b956f7f4be8ae1f994169e0b2a6,e09235c1db7047d0958572dba94d3976,fab9a01df3a9408a911acb7a4421e51b,
     */

    private String curDate;
    private String bookStatus;
    private String openPeriod;
    private String roomName;
    private String orderIds;

    public String getOpenPeriod() {
        return openPeriod;
    }

    public void setOpenPeriod(String openPeriod) {
        this.openPeriod = openPeriod;
    }

    public void setCurDate(String curDate) {
        this.curDate = curDate;
    }

    public void setBookStatus(String bookStatus) {
        this.bookStatus = bookStatus;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public void setOrderIds(String orderIds) {
        this.orderIds = orderIds;
    }

    public String getCurDate() {
        return curDate;
    }

    public String getBookStatus() {
        return bookStatus;
    }

    public String getRoomName() {
        return roomName;
    }

    public String getOrderIds() {
        return orderIds;
    }
}
