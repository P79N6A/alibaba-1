package com.culturecloud.dao.dto.activity;

import com.culturecloud.model.bean.activity.CmsActivityOrder;

public class CmsActivityOrderDto extends CmsActivityOrder {

	// 没有核销将扣除的积分
	private Integer deductionCredit;

	// 活动开始时间
	private String activityStartTime;

	// 活动名称
	private String activityName;

	public Integer getDeductionCredit() {
		return deductionCredit;
	}

	public void setDeductionCredit(Integer deductionCredit) {
		this.deductionCredit = deductionCredit;
	}

	public String getActivityStartTime() {
		return activityStartTime;
	}

	public void setActivityStartTime(String activityStartTime) {
		this.activityStartTime = activityStartTime;
	}

	public String getActivityName() {
		return activityName;
	}

	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}

}
