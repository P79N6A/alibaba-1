package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpPoemLector {
    private String lectorId;

    private String lectorName;

    private String lectorHeadImg;

    private String lectorJob;

    private String lectorIntro;

    private Date createTime;

    private String createUser;

    public String getLectorId() {
        return lectorId;
    }

    public void setLectorId(String lectorId) {
        this.lectorId = lectorId == null ? null : lectorId.trim();
    }

    public String getLectorName() {
        return lectorName;
    }

    public void setLectorName(String lectorName) {
        this.lectorName = lectorName == null ? null : lectorName.trim();
    }

    public String getLectorHeadImg() {
        return lectorHeadImg;
    }

    public void setLectorHeadImg(String lectorHeadImg) {
        this.lectorHeadImg = lectorHeadImg == null ? null : lectorHeadImg.trim();
    }

    public String getLectorJob() {
        return lectorJob;
    }

    public void setLectorJob(String lectorJob) {
        this.lectorJob = lectorJob == null ? null : lectorJob.trim();
    }

    public String getLectorIntro() {
        return lectorIntro;
    }

    public void setLectorIntro(String lectorIntro) {
        this.lectorIntro = lectorIntro == null ? null : lectorIntro.trim();
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
}