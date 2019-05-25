package com.sun3d.why.model;

import java.util.Date;

public class CmsAndroidVersion {
    private String vId;

    private String externalVnumber;

    private Float buildVnumber;

    private String updateUrl;

    private Date versionCreateTime;

    private Date versionUpdateTime;

    private String versionCreateUser;

    private String versionUpdateUser;

    private String updateDescr;

    private String userAccount;
    /*是否强制更新 0 不强制更新  1 强制更新*/
    private String versionUpdateStatus;

    private Float oldBuildVnumber;

    public Float getOldBuildVnumber() {
        return oldBuildVnumber;
    }

    public void setOldBuildVnumber(Float oldBuildVnumber) {
        this.oldBuildVnumber = oldBuildVnumber;
    }

    public String getUserAccount() {
        return userAccount;
    }

    public void setUserAccount(String userAccount) {
        this.userAccount = userAccount;
    }

    public String getvId() {
        return vId;
    }

    public void setvId(String vId) {
        this.vId = vId == null ? null : vId.trim();
    }

    public String getExternalVnumber() {
        return externalVnumber;
    }

    public void setExternalVnumber(String externalVnumber) {
        this.externalVnumber = externalVnumber == null ? null : externalVnumber.trim();
    }

    public Float getBuildVnumber() {
        return buildVnumber;
    }

    public void setBuildVnumber(Float buildVnumber) {
        this.buildVnumber = buildVnumber;
    }

    public String getUpdateUrl() {
        return updateUrl;
    }

    public void setUpdateUrl(String updateUrl) {
        this.updateUrl = updateUrl == null ? null : updateUrl.trim();
    }

    public String getVersionUpdateStatus() {
        return versionUpdateStatus;
    }

    public void setVersionUpdateStatus(String versionUpdateStatus) {
        this.versionUpdateStatus = versionUpdateStatus;
    }

    public Date getVersionCreateTime() {
        return versionCreateTime;
    }

    public void setVersionCreateTime(Date versionCreateTime) {
        this.versionCreateTime = versionCreateTime;
    }

    public Date getVersionUpdateTime() {
        return versionUpdateTime;
    }

    public void setVersionUpdateTime(Date versionUpdateTime) {
        this.versionUpdateTime = versionUpdateTime;
    }

    public String getVersionCreateUser() {
        return versionCreateUser;
    }

    public void setVersionCreateUser(String versionCreateUser) {
        this.versionCreateUser = versionCreateUser == null ? null : versionCreateUser.trim();
    }

    public String getVersionUpdateUser() {
        return versionUpdateUser;
    }

    public void setVersionUpdateUser(String versionUpdateUser) {
        this.versionUpdateUser = versionUpdateUser == null ? null : versionUpdateUser.trim();
    }

    public String getUpdateDescr() {
        return updateDescr;
    }

    public void setUpdateDescr(String updateDescr) {
        this.updateDescr = updateDescr == null ? null : updateDescr.trim();
    }


}