package com.culturecloud.open.req;

import com.culturecloud.bean.BaseRequest;

public class ActivitysRequest extends BaseRequest{
	
	private String createUserId;
	private String firstResult;
	private String rows;
	
	public String getCreateUserId() {
		return createUserId;
	}

	public void setCreateUserId(String createUserId) {
		this.createUserId = createUserId;
	}

	public String getFirstResult() {
		return firstResult;
	}

	public void setFirstResult(String firstResult) {
		this.firstResult = firstResult;
	}

	public String getRows() {
		return rows;
	}

	public void setRows(String rows) {
		this.rows = rows;
	}
	
}
