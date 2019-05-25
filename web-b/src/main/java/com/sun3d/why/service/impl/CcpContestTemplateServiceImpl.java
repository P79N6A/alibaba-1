package com.sun3d.why.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.model.bean.contest.CcpContestTemplate;
import com.sun3d.why.dao.CcpContestTemplateMapper;
import com.sun3d.why.dao.dto.CcpContestTemplateDto;
import com.sun3d.why.service.CcpContestTemplateService;

@Transactional
@Service
public class CcpContestTemplateServiceImpl implements CcpContestTemplateService {
	
	@Autowired
	private CcpContestTemplateMapper ccpContestTemplateMapper;

	@Override
	public List<CcpContestTemplateDto> selectTemplate() {
		
		Map<String,Object> map=new HashMap<String,Object>();
		
		map.put("templateIsSystem", "1");
		
		return ccpContestTemplateMapper.selectTemplate(map);
	}

	@Override
	public CcpContestTemplate selectContestTemplateById(String templateId) {
		
		return ccpContestTemplateMapper.selectByPrimaryKey(templateId);
	}

}
