package com.culturecloud.dao.analyse;

import java.util.List;

import com.culturecloud.dao.dto.analyse.SysParamsConfigDto;
import com.culturecloud.model.bean.analyse.SysParamsConfig;

public interface SysParamsConfigMapper {

	
	int updateSelective(SysParamsConfig record);
	
	// 查询某个方法配置
	List<SysParamsConfigDto> queryParamsConfigByBusinessId(String businessId);
}
