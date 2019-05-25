package com.sun3d.why.dao.dto;

import com.culturecloud.model.bean.special.CcpSpecialPage;

public class CcpSpecialPageDto extends CcpSpecialPage {

	private String projectName;

	private Integer activityCount;

	public String getProjectName() {
		return projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}

	public Integer getActivityCount() {
		return activityCount;
	}

	public void setActivityCount(Integer activityCount) {
		this.activityCount = activityCount;
	}

}
