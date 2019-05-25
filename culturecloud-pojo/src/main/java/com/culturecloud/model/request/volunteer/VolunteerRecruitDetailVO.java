package com.culturecloud.model.request.volunteer;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class VolunteerRecruitDetailVO extends BaseRequest{

	@NotNull(message = "招募ID不能为空")
	private String recruitId;

	public String getRecruitId() {
		return recruitId;
	}

	public void setRecruitId(String recruitId) {
		this.recruitId = recruitId;
	}
	
	
}
