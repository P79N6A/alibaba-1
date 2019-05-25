package com.culturecloud.dao.dto.activity;

import com.culturecloud.model.bean.activity.CmsActivityEvent;

public class CmsActivityEventDto extends CmsActivityEvent{

	private Integer counts;

	public Integer getCounts() {
		return counts;
	}

	public void setCounts(Integer counts) {
		this.counts = counts;
	}
	
	
}
