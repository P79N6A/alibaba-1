package com.sun3d.why.model;

import java.util.Date;

public class CmsActivityPublisher {
    private String publisherId;

    private String activityId;

    private Date templateCreateTime;

    private String templateCreateUser;

    private String templateContent;

    public String getPublisherId() {
        return publisherId;
    }

    public void setPublisherId(String publisherId) {
        this.publisherId = publisherId == null ? null : publisherId.trim();
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId == null ? null : activityId.trim();
    }

    public Date getTemplateCreateTime() {
        return templateCreateTime;
    }

    public void setTemplateCreateTime(Date templateCreateTime) {
        this.templateCreateTime = templateCreateTime;
    }

    public String getTemplateCreateUser() {
        return templateCreateUser;
    }

    public void setTemplateCreateUser(String templateCreateUser) {
        this.templateCreateUser = templateCreateUser == null ? null : templateCreateUser.trim();
    }

    public String getTemplateContent() {
        return templateContent;
    }

    public void setTemplateContent(String templateContent) {
        this.templateContent = templateContent == null ? null : templateContent.trim();
    }
}