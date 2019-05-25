package com.culturecloud.model.request.association;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BasePageRequest;

public class AssociationResourceListVO extends BasePageRequest {

	@NotNull(message = "社团ID不能为空")
	private String associationId;

	// 资源类型（1:图片；2:视频）
	private Integer resType=1;

	public String getAssociationId() {
		return associationId;
	}

	public void setAssociationId(String associationId) {
		this.associationId = associationId;
	}

	public Integer getResType() {
		return resType;
	}

	public void setResType(Integer resType) {
		this.resType = resType;
	}



}
