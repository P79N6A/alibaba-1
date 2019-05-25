package com.sun3d.why.model;

import java.util.Date;

public class CmsActivityOrderDetail extends CmsActivityOrderDetailKey {
    private Date updateTime;

    private String updateUser;

    private String seatCode;

    private String seatVal;

    private Integer seatStatus;

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser == null ? null : updateUser.trim();
    }

    public String getSeatCode() {
        return seatCode;
    }

    public void setSeatCode(String seatCode) {
        this.seatCode = seatCode == null ? null : seatCode.trim();
    }

    public String getSeatVal() {
        return seatVal;
    }

    public void setSeatVal(String seatVal) {
        this.seatVal = seatVal == null ? null : seatVal.trim();
    }

    public Integer getSeatStatus() {
        return seatStatus;
    }

    public void setSeatStatus(Integer seatStatus) {
        this.seatStatus = seatStatus;
    }
}