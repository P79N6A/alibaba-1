package com.culturecloud.service.local.volunteer;

import com.culturecloud.model.bean.volunteer.CcpVolunteerApply;

public interface CcpVolunteerApplyService {

	void saveVolunteerApply( CcpVolunteerApply acpVolunteerApply, String []volunteerApplyPic);
}
