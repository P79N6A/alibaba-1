package com.culturecloud.model.bean.common;

import java.util.Date;

public class CcpInformationModule {
    private String informationModuleId;

    private String informationModuleName;

    private Integer informationModuleStatus;

    private Date createTime;

    private String createUser;

    private Date updateTime;

    private String updateUser;

    public String getInformationModuleId() {
        return informationModuleId;
    }

    public void setInformationModuleId(String informationModuleId) {
        this.informationModuleId = informationModuleId == null ? null : informationModuleId.trim();
    }

    public String getInformationModuleName() {
        return informationModuleName;
    }

    public void setInformationModuleName(String informationModuleName) {
        this.informationModuleName = informationModuleName == null ? null : informationModuleName.trim();
    }

    public Integer getInformationModuleStatus() {
        return informationModuleStatus;
    }

    public void setInformationModuleStatus(Integer informationModuleStatus) {
        this.informationModuleStatus = informationModuleStatus;
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