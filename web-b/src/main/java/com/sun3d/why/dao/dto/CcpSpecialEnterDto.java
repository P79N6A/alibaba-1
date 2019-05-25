package com.sun3d.why.dao.dto;

import com.culturecloud.model.bean.special.CcpSpecialEnter;

public class CcpSpecialEnterDto extends CcpSpecialEnter{

	private static final long serialVersionUID = -8085044613078290582L;
	// 项目名称
	private String projectName;


	public String getProjectName() {
		return projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}
}
