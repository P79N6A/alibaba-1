package com.culturecloud.model.bean.special;

import java.util.Date;

public class CcpSpecialPage {
    private String pageId;

    private String pageName;

    private Integer pageIsDel;

    private String projectId;

    private Date pageCreateTime;

    private String pageCreateUser;
    
    public String getPageId() {
        return pageId;
    }

    public void setPageId(String pageId) {
        this.pageId = pageId == null ? null : pageId.trim();
    }

    public String getPageName() {
        return pageName;
    }

    public void setPageName(String pageName) {
        this.pageName = pageName == null ? null : pageName.trim();
    }

    public Integer getPageIsDel() {
        return pageIsDel;
    }

    public void setPageIsDel(Integer pageIsDel) {
        this.pageIsDel = pageIsDel;
    }

    public String getProjectId() {
        return projectId;
    }

    public void setProjectId(String projectId) {
        this.projectId = projectId == null ? null : projectId.trim();
    }

    public Date getPageCreateTime() {
        return pageCreateTime;
    }

    public void setPageCreateTime(Date pageCreateTime) {
        this.pageCreateTime = pageCreateTime;
    }

    public String getPageCreateUser() {
        return pageCreateUser;
    }

    public void setPageCreateUser(String pageCreateUser) {
        this.pageCreateUser = pageCreateUser == null ? null : pageCreateUser.trim();
    }


}