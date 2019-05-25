package com.sun3d.why.model;

import java.io.Serializable;
import java.util.Comparator;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class ActivityEditorial implements Serializable {
    private String activityId;

    private String activityName;

    private String activityIconUrl;

    private String activityAddress;

    private Integer activityIsFree;

    private String activityPrice;

    @DateTimeFormat(pattern="yyyy-MM-dd")
    private Date activityStartTime;

    @DateTimeFormat(pattern="yyyy-MM-dd")
    private Date activityEndTime;

    private Integer activityIsDel;

    private Integer activityState;

    @DateTimeFormat(pattern="yyyy-MM-dd")
    private Date activityCreateTime;

    @DateTimeFormat(pattern="yyyy-MM-dd")
    private Date activityUpdateTime;

    private String activityCreateUser;

    private String activityUpdateUser;

    private String activityTimeDes;

    private String activitySubject;

    private String ratingsInfo;
	   private String activityUrl;

    private String activityType;

    private String activityMemo;

    private String userAccount;

    private boolean isPublish;

    private String dictName;

    private String activityTel;

    private Integer type;

    private Integer isLike;

    private String tagName;

    private String eventTime;

    private Integer count;

    private Integer activityIsReservation;

    public Integer getActivityIsReservation() {
        return activityIsReservation;
    }

    public void setActivityIsReservation(Integer activityIsReservation) {
        this.activityIsReservation = activityIsReservation;
    }

    public Integer getIsLike() {
        return isLike;
    }

    public void setIsLike(Integer isLike) {
        this.isLike = isLike;
    }

    public Integer getCount() {
        return count;
    }

    public void setCount(Integer count) {
        this.count = count;
    }

    public String getEventTime() {
        return eventTime;
    }

    public void setEventTime(String eventTime) {
        this.eventTime = eventTime == null ? null : eventTime.trim();
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public String getTagName() {
        return tagName;
    }

    public void setTagName(String tagName) {
        this.tagName = tagName == null ? null : tagName.trim();
    }

    public String getActivityTel() {
        return activityTel;
    }

    public void setActivityTel(String activityTel) {
        this.activityTel = activityTel;
    }

    public String getDictName() {
        return dictName;
    }

    public void setDictName(String dictName) {
        this.dictName = dictName;
    }

    public boolean isPublish() {
        return isPublish;
    }

    public void setPublish(boolean isPublish) {
        this.isPublish = isPublish;
    }

    public String getUserAccount() {
        return userAccount;
    }

    public void setUserAccount(String userAccount) {
        this.userAccount = userAccount;
    }

    public String getActivityUrl() {
        return activityUrl;
    }

    public void setActivityUrl(String activityUrl) {
        this.activityUrl = activityUrl == null ? null : activityUrl.trim();
    }

    public String getActivityType() {
        return activityType;
    }

    public void setActivityType(String activityType) {
        this.activityType = activityType == null ? null : activityType.trim();
    }

    public String getActivityMemo() {
        return activityMemo;
    }

    public void setActivityMemo(String activityMemo) {
        this.activityMemo = activityMemo == null ? null : activityMemo.trim();
    }

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

    public String getActivityAddress() {
        return activityAddress;
    }

    public void setActivityAddress(String activityAddress) {
        this.activityAddress = activityAddress == null ? null : activityAddress.trim();
    }

    public Integer getActivityIsFree() {
        return activityIsFree;
    }

    public void setActivityIsFree(Integer activityIsFree) {
        this.activityIsFree = activityIsFree;
    }

    public String getActivityPrice() {
        return activityPrice;
    }

    public void setActivityPrice(String activityPrice) {
        this.activityPrice = activityPrice == null ? null : activityPrice.trim();
    }

    public Date getActivityStartTime() {
        return activityStartTime;
    }

    public void setActivityStartTime(Date activityStartTime) {
        this.activityStartTime = activityStartTime;
    }

    public Date getActivityEndTime() {
        return activityEndTime;
    }

    public void setActivityEndTime(Date activityEndTime) {
        this.activityEndTime = activityEndTime;
    }

    public Integer getActivityIsDel() {
        return activityIsDel;
    }

    public void setActivityIsDel(Integer activityIsDel) {
        this.activityIsDel = activityIsDel;
    }

    public Integer getActivityState() {
        return activityState;
    }

    public void setActivityState(Integer activityState) {
        this.activityState = activityState;
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

    public String getActivityTimeDes() {
        return activityTimeDes;
    }

    public void setActivityTimeDes(String activityTimeDes) {
        this.activityTimeDes = activityTimeDes == null ? null : activityTimeDes.trim();
    }

    public String getActivitySubject() {
        return activitySubject;
    }

    public void setActivitySubject(String activitySubject) {
        this.activitySubject = activitySubject == null ? null : activitySubject.trim();
    }

    public String getRatingsInfo() {
        return ratingsInfo;
    }

    public void setRatingsInfo(String ratingsInfo) {
        this.ratingsInfo = ratingsInfo == null ? null : ratingsInfo.trim();
    }
}