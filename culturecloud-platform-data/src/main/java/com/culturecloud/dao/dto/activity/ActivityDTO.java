package com.culturecloud.dao.dto.activity;

import java.util.List;

public class ActivityDTO {

	List<ActivityVO> activitys;
	Integer total;
	public List<ActivityVO> getActivitys() {
		return activitys;
	}
	public void setActivitys(List<ActivityVO> activitys) {
		this.activitys = activitys;
	}
	public Integer getTotal() {
		return total;
	}
	public void setTotal(Integer total) {
		this.total = total;
	}
	
}
