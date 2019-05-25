package com.sun3d.why.model;

import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

public class CmsVideo {
    /**活动名称 **/
    private String activityName;

    private String videoId;

    private String videoTitle;

    private Integer videoType;

    private String videoLink;

    private String referId;

    private String referName;

    private String videoImgUrl;

    private Integer videoSort;

    private Integer videoState;

    private String videoPublishUser;

    @DateTimeFormat(pattern="yyyy-MM-dd")
    private Date videoCreateTime;

    private String videoCreateUser;

    private Date videoUpdateTime;

    private String videoUpdateUser;

    @DateTimeFormat(pattern="yyyy-MM-dd")
    private Date startTime;

    @DateTimeFormat(pattern="yyyy-MM-dd")
    private Date endTime;
    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName;
    }
    public String getVideoId() {
        return videoId;
    }

    public void setVideoId(String videoId) {
        this.videoId = videoId == null ? null : videoId.trim();
    }

    public String getVideoTitle() {
        return videoTitle;
    }

    public void setVideoTitle(String videoTitle) {
        this.videoTitle = videoTitle == null ? null : videoTitle.trim();
    }

    public Integer getVideoType() {
        return videoType;
    }

    public void setVideoType(Integer videoType) {
        this.videoType = videoType;
    }

    public String getVideoLink() {
        return videoLink;
    }

    public void setVideoLink(String videoLink) {
        this.videoLink = videoLink == null ? null : videoLink.trim();
    }

    public String getReferId() {
        return referId;
    }

    public void setReferId(String referId) {
        this.referId = referId == null ? null : referId.trim();
    }

    public String getVideoImgUrl() {
        return videoImgUrl;
    }

    public void setVideoImgUrl(String videoImgUrl) {
        this.videoImgUrl = videoImgUrl == null ? null : videoImgUrl.trim();
    }

    public Integer getVideoSort() {
        return videoSort;
    }

    public void setVideoSort(Integer videoSort) {
        this.videoSort = videoSort;
    }

    public Integer getVideoState() {
        return videoState;
    }

    public void setVideoState(Integer videoState) {
        this.videoState = videoState;
    }

    public String getVideoPublishUser() {
        return videoPublishUser;
    }

    public void setVideoPublishUser(String videoPublishUser) {
        this.videoPublishUser = videoPublishUser == null ? null : videoPublishUser.trim();
    }

    public Date getVideoCreateTime() {
        return videoCreateTime;
    }

    public void setVideoCreateTime(Date videoCreateTime) {
        this.videoCreateTime = videoCreateTime;
    }

    public String getVideoCreateUser() {
        return videoCreateUser;
    }

    public void setVideoCreateUser(String videoCreateUser) {
        this.videoCreateUser = videoCreateUser == null ? null : videoCreateUser.trim();
    }

    public Date getVideoUpdateTime() {
        return videoUpdateTime;
    }

    public void setVideoUpdateTime(Date videoUpdateTime) {
        this.videoUpdateTime = videoUpdateTime;
    }

    public String getVideoUpdateUser() {
        return videoUpdateUser;
    }

    public void setVideoUpdateUser(String videoUpdateUser) {
        this.videoUpdateUser = videoUpdateUser == null ? null : videoUpdateUser.trim();
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public String getReferName() {
        return referName;
    }

    public void setReferName(String referName) {
        this.referName = referName;
    }
}