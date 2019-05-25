package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;

public class CmsAntiqueType extends Pagination implements Serializable {


    private String antiqueTypeId;

    private String venueId;

    private String antiqueTypeName;

    private String createUser;

    private Date createTime;

    private String updateUser;

    private Date updateTime;

    private Integer antiqueTypeState;


    public String getVenueName() {
        return venueName;
    }

    public void setVenueName(String venueName) {
        this.venueName = venueName;
    }

    private  String venueName;


    public String getAntiqueTypeId() {
        return antiqueTypeId;
    }

    public void setAntiqueTypeId(String antiqueTypeId) {
        this.antiqueTypeId = antiqueTypeId == null ? null : antiqueTypeId.trim();
    }

    public String getVenueId() {
        return venueId;
    }

    public void setVenueId(String venueId) {
        this.venueId = venueId == null ? null : venueId.trim();
    }

    public String getAntiqueTypeName() {
        return antiqueTypeName;
    }

    public void setAntiqueTypeName(String antiqueTypeName) {
        this.antiqueTypeName = antiqueTypeName == null ? null : antiqueTypeName.trim();
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser == null ? null : createUser.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser == null ? null : updateUser.trim();
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public Integer getAntiqueTypeState() {
        return antiqueTypeState;
    }

    public void setAntiqueTypeState(Integer antiqueTypeState) {
        this.antiqueTypeState = antiqueTypeState;
    }
}