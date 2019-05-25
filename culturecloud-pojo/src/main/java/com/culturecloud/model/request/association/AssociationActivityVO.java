package com.culturecloud.model.request.association;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BasePageRequest;
import com.culturecloud.bean.BaseRequest;

public class AssociationActivityVO  extends BasePageRequest {

	
	@NotNull(message = "社团ID不能为空")
    private String associationId;

	public String getAssociationId() {
		return associationId;
	}

	public void setAssociationId(String associationId) {
		this.associationId = associationId;
	}
	
	
	
	
}
