package com.culturecloud.service.local.analyse;

import java.util.List;

import com.culturecloud.dao.dto.analyse.SysParamsConfigDto;
import com.culturecloud.model.bean.analyse.SysParamsConfig;

public interface SysParamsConfigService {

	List<SysParamsConfigDto> queryParamsConfigByBusinessId(String businessName);
	
	int updateSelective(SysParamsConfig config);
}
