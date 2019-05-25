package com.sun3d.why.model;

import java.util.Date;

public class CcpAssociationRes {
    private String resId;

    private String assnId;

    private String assnResUrl;

    private String assnResCover;

    private String assnResName;

    private Integer resType;

    private Date createTime;

    private String createUser;

    private Date updateTime;

    private String updateUser;

    public String getResId() {
        return resId;
    }

    public void setResId(String resId) {
        this.resId = resId == null ? null : resId.trim();
    }

    public String getAssnId() {
        return assnId;
    }

    public void setAssnId(String assnId) {
        this.assnId = assnId == null ? null : assnId.trim();
    }

    public String getAssnResUrl() {
        return assnResUrl;
    }

    public void setAssnResUrl(String assnResUrl) {
        this.assnResUrl = assnResUrl == null ? null : assnResUrl.trim();
    }

    public String getAssnResCover() {
        return assnResCover;
    }

    public void setAssnResCover(String assnResCover) {
        this.assnResCover = assnResCover == null ? null : assnResCover.trim();
    }

    public String getAssnResName() {
        return assnResName;
    }

    public void setAssnResName(String assnResName) {
        this.assnResName = assnResName == null ? null : assnResName.trim();
    }

    public Integer getResType() {
        return resType;
    }

    public void setResType(Integer resType) {
        this.resType = resType;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser == null ? null : createUser.trim();
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