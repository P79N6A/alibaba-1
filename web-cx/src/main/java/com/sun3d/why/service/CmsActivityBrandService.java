package com.sun3d.why.service;

import java.util.List;
import com.culturecloud.model.bean.brandact.CmsActivityBrand;
public interface CmsActivityBrandService {
	
	//查询活动列表
	List<CmsActivityBrand> queryActivityBrand(Integer actType);

}
