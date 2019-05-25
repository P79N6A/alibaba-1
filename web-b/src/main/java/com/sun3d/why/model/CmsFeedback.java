package com.sun3d.why.model;

import java.util.Date;

public class CmsFeedback {

    private String feedBackId;

    private String userId;

    private String feedContent;

    private String feedType;

    private Date feedTime;

    private String feedImgUrl;
    private  String userMobileNo;
    private String userName;
    private String userArea;
    private String replyId;

    public String getUserMobileNo() {
        return userMobileNo;
    }

    public void setUserMobileNo(String userMobileNo) {
        this.userMobileNo = userMobileNo;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getFeedBackId() {
        return feedBackId;
    }

    public void setFeedBackId(String feedBackId) {
        this.feedBackId = feedBackId == null ? null : feedBackId.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getFeedContent() {
        return feedContent;
    }

    public void setFeedContent(String feedContent) {
        this.feedContent = feedContent == null ? null : feedContent.trim();
    }

    public String getFeedType() {
        return feedType;
    }

    public void setFeedType(String feedType) {
        this.feedType = feedType == null ? null : feedType.trim();
    }

    public Date getFeedTime() {
        return feedTime;
    }

    public void setFeedTime(Date feedTime) {
        this.feedTime = feedTime;
    }

    public String getFeedImgUrl() {
        return feedImgUrl;
    }

    public void setFeedImgUrl(String feedImgUrl) {
        this.feedImgUrl = feedImgUrl == null ? null : feedImgUrl.trim();
    }

	public String getUserArea() {
		return userArea;
	}

	public void setUserArea(String userArea) {
		this.userArea = userArea;
	}

    public String getReplyId() {
        return replyId;
    }

    public void setReplyId(String replyId) {
        this.replyId = replyId;
    }
}