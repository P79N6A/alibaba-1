package com.culturecloud.dao.dto.assonciation;

import com.culturecloud.model.bean.association.CcpAssociation;

public class CcpAssociationDto extends CcpAssociation{

	private static final long serialVersionUID = 2075375700730883613L;
	
	private Integer flowerCount;
	
	private Integer activityCount;

	private Integer recruitStatus;

	public Integer getRecruitStatus() {
		return recruitStatus;
	}

	public void setRecruitStatus(Integer recruitStatus) {
		this.recruitStatus = recruitStatus;
	}
	
	public Integer getFlowerCount() {
		return flowerCount;
	}

	public void setFlowerCount(Integer flowerCount) {
		this.flowerCount = flowerCount;
	}

	public Integer getActivityCount() {
		return activityCount;
	}

	public void setActivityCount(Integer activityCount) {
		this.activityCount = activityCount;
	}

}