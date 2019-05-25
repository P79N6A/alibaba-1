package com.culturecloud.service.local.impl.volunteer;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.culturecloud.dao.dto.volunteer.CcpVolunteerRecruitDto;
import com.culturecloud.dao.volunteer.CcpVolunteerRecruitMapper;
import com.culturecloud.model.bean.volunteer.CcpVolunteerRecruit;
import com.culturecloud.model.response.volunteer.CcpVolunteerRecruitVO;
import com.culturecloud.service.local.volunteer.CcpVolunteerRecruitService;

@Service
public class CcpVolunteerRecruitServiceImpl implements CcpVolunteerRecruitService {
	
	@Autowired
	private CcpVolunteerRecruitMapper ccpVolunteerRecruitMapper;

	@Override
	public List<CcpVolunteerRecruitVO> queryVolunteerRecruitList() {
		
		List<CcpVolunteerRecruitVO> result=new ArrayList<CcpVolunteerRecruitVO>();
		
		List<CcpVolunteerRecruitDto> list= ccpVolunteerRecruitMapper.queryVolunteerRecruitList();
		
		for (CcpVolunteerRecruitDto ccpVolunteerRecruitDto : list) {
			
			result.add(new CcpVolunteerRecruitVO(ccpVolunteerRecruitDto));
		}
		return result;
	}

	@Override
	public CcpVolunteerRecruitVO queryVolunteerRecruitDetail(String recruitId) {

		CcpVolunteerRecruit recruit=ccpVolunteerRecruitMapper.selectByPrimaryKey(recruitId);
		
		return new CcpVolunteerRecruitVO(recruit);
	}

}
