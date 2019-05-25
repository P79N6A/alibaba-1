package com.sun3d.why.service.impl;

import com.culturecloud.model.bean.common.CcpInformationType;
import com.sun3d.why.dao.CcpInformationTypeMapper;
import com.sun3d.why.service.CcpInformationTypeService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Transactional
@Service
public class CcpInformationTypeServiceImpl implements CcpInformationTypeService {
	
	@Autowired
	private CcpInformationTypeMapper ccpInformationTypeMapper;

	@Override
	public List<CcpInformationType> queryAllInformationType(String informationModuleId, String shopPath) {
		Map<String, Object> map = new HashMap<>();
		if(StringUtils.isNotBlank(informationModuleId)){
			map.put("informationModuleId", informationModuleId);
		}
		return ccpInformationTypeMapper.queryInformationTypeByCondition(map);
	}

}
