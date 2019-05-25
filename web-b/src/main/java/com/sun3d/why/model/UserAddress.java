package com.sun3d.why.model;

import java.util.Date;

public class UserAddress {
    private String addressId;

    private String userId;

    private String activityAddress;

    private String activitySite;

    private Double activityLon;

    private Double activityLat;

    private Integer addressState;

    private Integer defaultAddress;

    private String creatBy;

    private String updateBy;

    private Date createTime;

    private Date updateTime;

    public String getAddressId() {
        return addressId;
    }

    public void setAddressId(String addressId) {
        this.addressId = addressId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getActivityAddress() {
        return activityAddress;
    }

    public void setActivityAddress(String activityAddress) {
        this.activityAddress = activityAddress;
    }

    public String getActivitySite() {
        return activitySite;
    }

    public void setActivitySite(String activitySite) {
        this.activitySite = activitySite;
    }

    public Double getActivityLon() {
        return activityLon;
    }

    public void setActivityLon(Double activityLon) {
        this.activityLon = activityLon;
    }

    public Double getActivityLat() {
        return activityLat;
    }

    public void setActivityLat(Double activityLat) {
        this.activityLat = activityLat;
    }

    public Integer getAddressState() {
        return addressState;
    }

    public void setAddressState(Integer addressState) {
        this.addressState = addressState;
    }

    public Integer getDefaultAddress() {
        return defaultAddress;
    }

    public void setDefaultAddress(Integer defaultAddress) {
        this.defaultAddress = defaultAddress;
    }

    public String getCreatBy() {
        return creatBy;
    }

    public void setCreatBy(String creatBy) {
        this.creatBy = creatBy;
    }

    public String getUpdateBy() {
        return updateBy;
    }

    public void setUpdateBy(String updateBy) {
        this.updateBy = updateBy;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
}