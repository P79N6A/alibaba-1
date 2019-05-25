package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.volunteer.CcpVolunteerRecruit;
import com.sun3d.why.util.Pagination;

public interface CcpVolunteerRecruitService {

	List<CcpVolunteerRecruit> queryVolunteerRecruitByCondition(
			CcpVolunteerRecruit volunteerRecruit, Pagination page);

	int save(CcpVolunteerRecruit volunteerRecruit);

	CcpVolunteerRecruit queryVolunteerRecruitById(String recruitId);

	int deleteVolunteer(CcpVolunteerRecruit volunteerRecruit);

	int editVolunteer(CcpVolunteerRecruit vt, String recruitId);

}
