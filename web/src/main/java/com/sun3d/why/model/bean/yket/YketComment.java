package com.sun3d.why.model.bean.yket;

import java.util.Date;

public class YketComment {
    private String commentId;

    private String userId;

    private Integer commentType;

    private String objectId;

    private String content;

    private String commentImgUrls;

    private Integer checkStatus;

    private Byte topFlag;

    private Date createTime;

    private Date updateTime;

    private String updateUser;

    public String getCommentId() {
        return commentId;
    }

    public void setCommentId(String commentId) {
        this.commentId = commentId == null ? null : commentId.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public Integer getCommentType() {
        return commentType;
    }

    public void setCommentType(Integer commentType) {
        this.commentType = commentType;
    }

    public String getObjectId() {
        return objectId;
    }

    public void setObjectId(String objectId) {
        this.objectId = objectId == null ? null : objectId.trim();
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content == null ? null : content.trim();
    }

    public String getCommentImgUrls() {
        return commentImgUrls;
    }

    public void setCommentImgUrls(String commentImgUrls) {
        this.commentImgUrls = commentImgUrls == null ? null : commentImgUrls.trim();
    }

    public Integer getCheckStatus() {
        return checkStatus;
    }

    public void setCheckStatus(Integer checkStatus) {
        this.checkStatus = checkStatus;
    }

    public Byte getTopFlag() {
        return topFlag;
    }

    public void setTopFlag(Byte topFlag) {
        this.topFlag = topFlag;
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

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser == null ? null : updateUser.trim();
    }
}