package com.sun3d.why.dao.dto;

import com.culturecloud.model.bean.special.CcpSpecialYcode;

public class CcpSpecialYcodeDto extends CcpSpecialYcode{

	private static final long serialVersionUID = 3567588059898407083L;
	
	// 兑换Y码用户
	private String userName;
	
	// 兑换活动
	private String useActivityName;

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUseActivityName() {
		return useActivityName;
	}

	public void setUseActivityName(String useActivityName) {
		this.useActivityName = useActivityName;
	}
	
	

}
