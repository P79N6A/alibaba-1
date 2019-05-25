package com.sun3d.why.service;

import com.culturecloud.model.bean.common.CcpInformationType;

import java.util.List;

public interface CcpInformationTypeService {

	
	
	/**
	 * 查询所有分类
	 * @return
	 */
	List<CcpInformationType> queryAllInformationType(String informationModuleId, String shopPath);
	
}
