package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;

public class CmsVenueSeat extends Pagination implements Serializable{


    private String seatId;

    private String seatArea;

    private Integer seatRow;

    private Integer seatColumn;

    private String seatCode;

    private Integer seatStatus;

    private Date seatCreateTime;

    private String seatCreateUser;

    private Date seatUpdateTime;

    private String seatUpdateUser;

    private String templateId;

    private String seatVal;

    public String getSeatId() {
        return seatId;
    }

    public void setSeatId(String seatId) {
        this.seatId = seatId == null ? null : seatId.trim();
    }

    public String getSeatArea() {
        return seatArea;
    }

    public void setSeatArea(String seatArea) {
        this.seatArea = seatArea == null ? null : seatArea.trim();
    }

    public Integer getSeatRow() {
        return seatRow;
    }

    public void setSeatRow(Integer seatRow) {
        this.seatRow = seatRow;
    }

    public Integer getSeatColumn() {
        return seatColumn;
    }

    public void setSeatColumn(Integer seatColumn) {
        this.seatColumn = seatColumn;
    }

    public String getSeatCode() {
        return seatCode;
    }

    public void setSeatCode(String seatCode) {
        this.seatCode = seatCode == null ? null : seatCode.trim();
    }

    public Integer getSeatStatus() {
        return seatStatus;
    }

    public void setSeatStatus(Integer seatStatus) {
        this.seatStatus = seatStatus;
    }

    public Date getSeatCreateTime() {
        return seatCreateTime;
    }

    public void setSeatCreateTime(Date seatCreateTime) {
        this.seatCreateTime = seatCreateTime;
    }

    public String getSeatCreateUser() {
        return seatCreateUser;
    }

    public void setSeatCreateUser(String seatCreateUser) {
        this.seatCreateUser = seatCreateUser == null ? null : seatCreateUser.trim();
    }

    public Date getSeatUpdateTime() {
        return seatUpdateTime;
    }

    public void setSeatUpdateTime(Date seatUpdateTime) {
        this.seatUpdateTime = seatUpdateTime;
    }

    public String getSeatUpdateUser() {
        return seatUpdateUser;
    }

    public void setSeatUpdateUser(String seatUpdateUser) {
        this.seatUpdateUser = seatUpdateUser == null ? null : seatUpdateUser.trim();
    }

    public String getTemplateId() {
        return templateId;
    }

    public void setTemplateId(String templateId) {
        this.templateId = templateId;
    }

    public String getSeatVal() {
        return seatVal;
    }

    public void setSeatVal(String seatVal) {
        this.seatVal = seatVal;
    }
}