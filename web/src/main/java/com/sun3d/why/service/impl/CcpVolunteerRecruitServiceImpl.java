package com.sun3d.why.service.impl;

import com.culturecloud.model.bean.volunteer.CcpVolunteerRecruit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CcpVolunteerRecruitMapper;
import com.sun3d.why.service.CcpVolunteerRecruitService;
@Service
@Transactional
public class CcpVolunteerRecruitServiceImpl implements CcpVolunteerRecruitService {
	
	@Autowired
	private  CcpVolunteerRecruitMapper ccpVolunteerRecruitMapper;
 
	@Override
	public CcpVolunteerRecruit queryVolunteerRecruitById(String recruitId) {
		
		return ccpVolunteerRecruitMapper.queryVolunteerRecruitById(recruitId);
	}

}
