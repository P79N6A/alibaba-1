package com.sun3d.why.model;

import java.util.Date;

public class CcpAssociationRecruit {
    private String recruitId;

    private String assnId;

    private Integer recruitNumber;

    private Integer applyNumber;

    private Date createTime;

    private String createUser;

    private Date updateTime;

    private String updateUser;

    private Date recruitStartTime;

    private Date recruitEndTime;

    private String recruitRequirment;

    private Integer recruitStatus;
    
    private String recruitEndTimeString;

    public String getRecruitId() {
        return recruitId;
    }

    public void setRecruitId(String recruitId) {
        this.recruitId = recruitId;
    }

    public String getAssnId() {
        return assnId;
    }

    public void setAssnId(String assnId) {
        this.assnId = assnId;
    }

    public Integer getRecruitNumber() {
        return recruitNumber;
    }

    public void setRecruitNumber(Integer recruitNumber) {
        this.recruitNumber = recruitNumber;
    }

    public Integer getApplyNumber() {
        return applyNumber;
    }

    public void setApplyNumber(Integer applyNumber) {
        this.applyNumber = applyNumber;
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
        this.createUser = createUser;
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
        this.updateUser = updateUser;
    }

    public Date getRecruitStartTime() {
        return recruitStartTime;
    }

    public void setRecruitStartTime(Date recruitStartTime) {
        this.recruitStartTime = recruitStartTime;
    }

    public Date getRecruitEndTime() {
        return recruitEndTime;
    }

    public void setRecruitEndTime(Date recruitEndTime) {
        this.recruitEndTime = recruitEndTime;
    }

    public String getRecruitRequirment() {
        return recruitRequirment;
    }

    public void setRecruitRequirment(String recruitRequirment) {
        this.recruitRequirment = recruitRequirment;
    }

    public Integer getRecruitStatus() {
        return recruitStatus;
    }

    public void setRecruitStatus(Integer recruitStatus) {
        this.recruitStatus = recruitStatus;
    }

	public String getRecruitEndTimeString() {
		return recruitEndTimeString;
	}

	public void setRecruitEndTimeString(String recruitEndTimeString) {
		this.recruitEndTimeString = recruitEndTimeString;
	}
}