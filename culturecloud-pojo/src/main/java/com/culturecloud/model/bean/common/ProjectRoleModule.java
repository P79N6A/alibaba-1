package com.culturecloud.model.bean.common;

import java.io.Serializable;

public class ProjectRoleModule implements Serializable{
    /**
	 * 
	 */
	private static final long serialVersionUID = 8966741410057122511L;

	private String roleId;

    private String moduleId;

    private String projectName;

    public String getRoleId() {
        return roleId;
    }

    public void setRoleId(String roleId) {
        this.roleId = roleId == null ? null : roleId.trim();
    }

    public String getModuleId() {
        return moduleId;
    }

    public void setModuleId(String moduleId) {
        this.moduleId = moduleId == null ? null : moduleId.trim();
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName == null ? null : projectName.trim();
    }
}