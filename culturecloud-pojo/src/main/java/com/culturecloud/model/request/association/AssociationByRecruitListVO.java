package com.culturecloud.model.request.association;

import com.culturecloud.bean.BasePageRequest;

public class AssociationByRecruitListVO extends BasePageRequest {

	// 招募状态（1:招募中；2:招募结束）
	private Integer recruitStatus;

	public Integer getRecruitStatus() {
		return recruitStatus;
	}

	public void setRecruitStatus(Integer recruitStatus) {
		this.recruitStatus = recruitStatus;
	}

	// 社团名称
	private String assnName;

	public String getAssnName() {
		return assnName;
	}

	public void setAssnName(String assnName) {
		this.assnName = assnName;
	}
}
