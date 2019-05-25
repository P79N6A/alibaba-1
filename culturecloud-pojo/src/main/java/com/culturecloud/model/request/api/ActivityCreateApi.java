package com.culturecloud.model.request.api;

import com.culturecloud.model.bean.activity.CmsActivityEvent;

import java.util.List;

/**
 * 子平台上传活动VO
 */
public class ActivityCreateApi  {


    /**
     * 活动名称
     */
    private String activityName;

    /**
     * 活动ID
     */
    private String activityId;

    /**
     * 活动封面页
     */
    private String activityIconUrl;

    /**
     * 省份
     */
    private String activityProvince;


    /**
     * 省份
     */
    private String activityCity;

    /**
     * 区域
     */
    private String activityArea;

    /**
     * 场馆ID
     */
    private String venueId;

    /**
     * 详细地址
     */
    private String activityAddress;

    /**
     * 经度
     */
    private Double activityLon;

    /**
     * 纬度
     */
    private Double activityLat;

    /**
     * 活动详情
     */
    private String activityMemo;

    /**
     * 活动开始时间
     */
    private String activityStartTime;

    /**
     * 活动结束时间
     */
    private String activityEndTime;

    /**
     * 活动状态
     */
    private Integer activityState;


    private String activityType;

    private Integer activityIsReservation;

    private String SysUrl;


    /**
     * 场次信息
     */
    private List<CmsActivityEvent> eventList;


    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    public String getActivityIconUrl() {
        return activityIconUrl;
    }

    public void setActivityIconUrl(String activityIconUrl) {
        this.activityIconUrl = activityIconUrl;
    }

    public String getActivityProvince() {
        return activityProvince;
    }

    public void setActivityProvince(String activityProvince) {
        this.activityProvince = activityProvince;
    }

    public String getActivityCity() {
        return activityCity;
    }

    public void setActivityCity(String activityCity) {
        this.activityCity = activityCity;
    }

    public String getActivityArea() {
        return activityArea;
    }

    public void setActivityArea(String activityArea) {
        this.activityArea = activityArea;
    }

    public String getVenueId() {
        return venueId;
    }

    public void setVenueId(String venueId) {
        this.venueId = venueId;
    }

    public String getActivityAddress() {
        return activityAddress;
    }

    public void setActivityAddress(String activityAddress) {
        this.activityAddress = activityAddress;
    }


    public String getActivityMemo() {
        return activityMemo;
    }

    public void setActivityMemo(String activityMemo) {
        this.activityMemo = activityMemo;
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




    public List<CmsActivityEvent> getEventList() {
        return eventList;
    }

    public void setEventList(List<CmsActivityEvent> eventList) {
        this.eventList = eventList;
    }

    public String getActivityType() {
        return activityType;
    }

    public void setActivityType(String activityType) {
        this.activityType = activityType;
    }

    public Integer getActivityIsReservation() {
        return activityIsReservation;
    }

    public void setActivityIsReservation(Integer activityIsReservation) {
        this.activityIsReservation = activityIsReservation;
    }

    public String getSysUrl() {
        return SysUrl;
    }

    public void setSysUrl(String sysUrl) {
        SysUrl = sysUrl;
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

    public Integer getActivityState() {
        return activityState;
    }

    public void setActivityState(Integer activityState) {
        this.activityState = activityState;
    }
}
