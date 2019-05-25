package com.culturecloud.model.request.common;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class QueryRelateTagSubListVO extends BaseRequest{

	@NotNull(message = "关联实体ID不能为空")
    private String relateId;

	public String getRelateId() {
		return relateId;
	}

	public void setRelateId(String relateId) {
		this.relateId = relateId;
	}
	
	
}
