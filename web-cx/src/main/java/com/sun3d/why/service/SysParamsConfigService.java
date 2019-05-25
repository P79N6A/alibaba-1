package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.SysParamsConfig;

public interface SysParamsConfigService {

	List<SysParamsConfig> queryParamsConfigByBusinessId(String businessName);
	
	int updateSelective(SysParamsConfig config);
	
	int insert(SysParamsConfig record);
}
