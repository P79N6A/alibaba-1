package com.sun3d.why.model;

import java.util.Date;

public class CmsUserTag {
    private String tagId;

    private String userId;

    private String userSelectTag;

    private Date tagCreateTime;

    private String tagCreateUser;

    private Date tagUpdateTime;

    private String tagUpdateUser;

    public String getTagId() {
        return tagId;
    }

    public void setTagId(String tagId) {
        this.tagId = tagId == null ? null : tagId.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getUserSelectTag() {
        return userSelectTag;
    }

    public void setUserSelectTag(String userSelectTag) {
        this.userSelectTag = userSelectTag == null ? null : userSelectTag.trim();
    }

    public Date getTagCreateTime() {
        return tagCreateTime;
    }

    public void setTagCreateTime(Date tagCreateTime) {
        this.tagCreateTime = tagCreateTime;
    }

    public String getTagCreateUser() {
        return tagCreateUser;
    }

    public void setTagCreateUser(String tagCreateUser) {
        this.tagCreateUser = tagCreateUser == null ? null : tagCreateUser.trim();
    }

    public Date getTagUpdateTime() {
        return tagUpdateTime;
    }

    public void setTagUpdateTime(Date tagUpdateTime) {
        this.tagUpdateTime = tagUpdateTime;
    }

    public String getTagUpdateUser() {
        return tagUpdateUser;
    }

    public void setTagUpdateUser(String tagUpdateUser) {
        this.tagUpdateUser = tagUpdateUser == null ? null : tagUpdateUser.trim();
    }
}