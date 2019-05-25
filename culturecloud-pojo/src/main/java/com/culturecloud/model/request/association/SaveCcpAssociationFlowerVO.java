package com.culturecloud.model.request.association;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class SaveCcpAssociationFlowerVO  extends BaseRequest {

	@NotNull(message = "社团ID不能为空")
    private String associationId;
	
	@NotNull(message = "用户ID不能为空")
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
