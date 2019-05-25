package com.sun3d.why.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.SysParamsConfigMapper;
import com.sun3d.why.model.SysParamsConfig;
import com.sun3d.why.service.SysParamsConfigService;

@Service
@Transactional
public class SysParamsConfigServiceImpl implements SysParamsConfigService {
	
	@Autowired
	private SysParamsConfigMapper sysParamsConfigMapper;

	@Override
	public List<SysParamsConfig> queryParamsConfigByBusinessId(String businessName) {
	
		return sysParamsConfigMapper.queryParamsConfigByBusinessId(businessName);
	}

	@Override
	public int updateSelective(SysParamsConfig config) {
	
		return sysParamsConfigMapper.updateSelective(config);
	}

	@Override
	public int insert(SysParamsConfig record) {
		return sysParamsConfigMapper.insert(record);
	}

}
