package com.sun3d.why.dao.dto;

import com.culturecloud.model.bean.common.CcpInformation;

public class CcpInformationDto extends CcpInformation {

	
	private String createUserName;
	
	private String updateUserName;
	
	private String informationTypeName;
	
	private Integer isPersonalizeRecommend;

	public String getCreateUserName() {
		return createUserName;
	}

	public void setCreateUserName(String createUserName) {
		this.createUserName = createUserName;
	}

	public String getInformationTypeName() {
		return informationTypeName;
	}

	public void setInformationTypeName(String informationTypeName) {
		this.informationTypeName = informationTypeName;
	}

	public String getUpdateUserName() {
		return updateUserName;
	}

	public void setUpdateUserName(String updateUserName) {
		this.updateUserName = updateUserName;
	}

	public Integer getIsPersonalizeRecommend() {
		return isPersonalizeRecommend;
	}

	public void setIsPersonalizeRecommend(Integer isPersonalizeRecommend) {
		this.isPersonalizeRecommend = isPersonalizeRecommend;
	}
	
	
}
