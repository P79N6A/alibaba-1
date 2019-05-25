package com.culturecloud.model.request.association;

import com.culturecloud.bean.BaseRequest;

import javax.validation.constraints.NotNull;

public class GetAssociationDetailVO extends BaseRequest  {

	@NotNull(message = "社团ID不能为空")
	private String associationId;

	private String userId;

	public String getAssociationId() {
		return associationId;
	}

	public void setAssociationId(String associationId) {
		this.associationId = associationId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}



}
