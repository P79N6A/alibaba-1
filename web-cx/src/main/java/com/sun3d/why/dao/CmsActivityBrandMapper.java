package com.sun3d.why.dao;

import java.util.List;

import com.culturecloud.model.bean.brandact.CmsActivityBrand;

public interface CmsActivityBrandMapper {
	
	//查询活动列表信息
	List<CmsActivityBrand> queryActivityBrand(Integer actType);

}