package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.contest.CcpContestTemplate;
import com.sun3d.why.dao.dto.CcpContestTemplateDto;

public interface CcpContestTemplateService {

	public List<CcpContestTemplateDto> selectTemplate();
	
	public CcpContestTemplate selectContestTemplateById(String templateId);
}
