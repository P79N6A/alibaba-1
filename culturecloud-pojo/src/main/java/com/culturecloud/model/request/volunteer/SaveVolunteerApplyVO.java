package com.culturecloud.model.request.volunteer;

import com.culturecloud.bean.BaseRequest;
import com.culturecloud.model.bean.volunteer.CcpVolunteerApply;

public class SaveVolunteerApplyVO extends BaseRequest{

	private CcpVolunteerApply acpVolunteerApply;
	
	private String []volunteerApplyPic;

	public CcpVolunteerApply getAcpVolunteerApply() {
		return acpVolunteerApply;
	}

	public void setAcpVolunteerApply(CcpVolunteerApply acpVolunteerApply) {
		this.acpVolunteerApply = acpVolunteerApply;
	}

	public String[] getVolunteerApplyPic() {
		return volunteerApplyPic;
	}

	public void setVolunteerApplyPic(String[] volunteerApplyPic) {
		this.volunteerApplyPic = volunteerApplyPic;
	}
	
	
}
