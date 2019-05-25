package com.culturecloud.model.bean.common;

import java.io.Serializable;
import java.util.Date;

public class ProjectModule implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = -6092753162283454026L;

	private String moduleId;

    private String moduleName;

    private String moduleUrl;

    private String moduleParentId;

    private String moduleRemark;

    private Integer moduleState;

    private Integer moduleSort;

    private String moduleCreateUser;

    private Date moduleCreateTime;

    private String moduleUpdateUser;

    private Date moduleUpdateTime;

    private String projectName;

    public String getModuleId() {
        return moduleId;
    }

    public void setModuleId(String moduleId) {
        this.moduleId = moduleId == null ? null : moduleId.trim();
    }

    public String getModuleName() {
        return moduleName;
    }

    public void setModuleName(String moduleName) {
        this.moduleName = moduleName == null ? null : moduleName.trim();
    }

    public String getModuleUrl() {
        return moduleUrl;
    }

    public void setModuleUrl(String moduleUrl) {
        this.moduleUrl = moduleUrl == null ? null : moduleUrl.trim();
    }

    public String getModuleParentId() {
        return moduleParentId;
    }

    public void setModuleParentId(String moduleParentId) {
        this.moduleParentId = moduleParentId == null ? null : moduleParentId.trim();
    }

    public String getModuleRemark() {
        return moduleRemark;
    }

    public void setModuleRemark(String moduleRemark) {
        this.moduleRemark = moduleRemark == null ? null : moduleRemark.trim();
    }

    public Integer getModuleState() {
        return moduleState;
    }

    public void setModuleState(Integer moduleState) {
        this.moduleState = moduleState;
    }

    public Integer getModuleSort() {
        return moduleSort;
    }

    public void setModuleSort(Integer moduleSort) {
        this.moduleSort = moduleSort;
    }

    public String getModuleCreateUser() {
        return moduleCreateUser;
    }

    public void setModuleCreateUser(String moduleCreateUser) {
        this.moduleCreateUser = moduleCreateUser == null ? null : moduleCreateUser.trim();
    }

    public Date getModuleCreateTime() {
        return moduleCreateTime;
    }

    public void setModuleCreateTime(Date moduleCreateTime) {
        this.moduleCreateTime = moduleCreateTime;
    }

    public String getModuleUpdateUser() {
        return moduleUpdateUser;
    }

    public void setModuleUpdateUser(String moduleUpdateUser) {
        this.moduleUpdateUser = moduleUpdateUser == null ? null : moduleUpdateUser.trim();
    }

    public Date getModuleUpdateTime() {
        return moduleUpdateTime;
    }

    public void setModuleUpdateTime(Date moduleUpdateTime) {
        this.moduleUpdateTime = moduleUpdateTime;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName == null ? null : projectName.trim();
    }
}