package com.sun3d.why.model.temp;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;

public class CmsActivityTemp   extends Pagination implements Serializable {
    private String activityId;

    private String activityName;

    private String activityIconUrl;

    private String activityDetailUrl;

    private String activityArea;

    private String activityAddress;

    private String activityTime;

    private Date activityCreateTime;

    private Date activityUpdateTime;

    private String activityCreateUser;

    private String activityUpdateUser;

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId == null ? null : activityId.trim();
    }

    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName == null ? null : activityName.trim();
    }

    public String getActivityIconUrl() {
        return activityIconUrl;
    }

    public void setActivityIconUrl(String activityIconUrl) {
        this.activityIconUrl = activityIconUrl == null ? null : activityIconUrl.trim();
    }

    public String getActivityDetailUrl() {
        return activityDetailUrl;
    }

    public void setActivityDetailUrl(String activityDetailUrl) {
        this.activityDetailUrl = activityDetailUrl == null ? null : activityDetailUrl.trim();
    }

    public String getActivityArea() {
        return activityArea;
    }

    public void setActivityArea(String activityArea) {
        this.activityArea = activityArea == null ? null : activityArea.trim();
    }

    public String getActivityAddress() {
        return activityAddress;
    }

    public void setActivityAddress(String activityAddress) {
        this.activityAddress = activityAddress == null ? null : activityAddress.trim();
    }

    public String getActivityTime() {
        return activityTime;
    }

    public void setActivityTime(String activityTime) {
        this.activityTime = activityTime == null ? null : activityTime.trim();
    }

    public Date getActivityCreateTime() {
        return activityCreateTime;
    }

    public void setActivityCreateTime(Date activityCreateTime) {
        this.activityCreateTime = activityCreateTime;
    }

    public Date getActivityUpdateTime() {
        return activityUpdateTime;
    }

    public void setActivityUpdateTime(Date activityUpdateTime) {
        this.activityUpdateTime = activityUpdateTime;
    }

    public String getActivityCreateUser() {
        return activityCreateUser;
    }

    public void setActivityCreateUser(String activityCreateUser) {
        this.activityCreateUser = activityCreateUser == null ? null : activityCreateUser.trim();
    }

    public String getActivityUpdateUser() {
        return activityUpdateUser;
    }

    public void setActivityUpdateUser(String activityUpdateUser) {
        this.activityUpdateUser = activityUpdateUser == null ? null : activityUpdateUser.trim();
    }
}