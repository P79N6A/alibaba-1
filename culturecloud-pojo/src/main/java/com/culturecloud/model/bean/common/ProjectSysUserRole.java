package com.culturecloud.model.bean.common;

import java.io.Serializable;

public class ProjectSysUserRole implements Serializable{
    /**
	 * 
	 */
	private static final long serialVersionUID = 5206024826199950423L;

	private String userId;

    private String roleId;

    private String projectName;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId == null ? null : roleId.trim();
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName == null ? null : projectName.trim();
    }
}