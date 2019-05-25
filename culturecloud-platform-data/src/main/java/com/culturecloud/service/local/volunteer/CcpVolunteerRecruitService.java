package com.culturecloud.service.local.volunteer;

import java.util.List;

import com.culturecloud.model.response.volunteer.CcpVolunteerRecruitVO;

public interface CcpVolunteerRecruitService {

	
	List<CcpVolunteerRecruitVO> queryVolunteerRecruitList();
	
	CcpVolunteerRecruitVO queryVolunteerRecruitDetail(String recruitId);
}
