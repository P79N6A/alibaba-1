package com.culturecloud.service.local.impl.analyse;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.dao.analyse.SysParamsConfigMapper;
import com.culturecloud.dao.dto.analyse.SysParamsConfigDto;
import com.culturecloud.model.bean.analyse.SysParamsConfig;
import com.culturecloud.service.local.analyse.SysParamsConfigService;

@Service
@Transactional
public class SysParamsConfigServiceImpl implements SysParamsConfigService {


	@Autowired
	private SysParamsConfigMapper sysParamsConfigMapper;

	@Override

	public List<SysParamsConfigDto> queryParamsConfigByBusinessId(String businessName) {
	
		return sysParamsConfigMapper.queryParamsConfigByBusinessId(businessName);
	}

	@Override

	public int updateSelective(SysParamsConfig config) {
	
		return sysParamsConfigMapper.updateSelective(config);
	}
}
