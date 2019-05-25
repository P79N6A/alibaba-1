package com.sun3d.why.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.culturecloud.model.bean.brandact.CmsActivityBrand;
import com.sun3d.why.dao.CmsActivityBrandMapper;
import com.sun3d.why.service.CmsActivityBrandService;
@Service
public class CmsActivityBrandServiceImpl implements CmsActivityBrandService {

		@Autowired
		private CmsActivityBrandMapper  cmsActivityBrandMapper;
		
		@Override
		public List<CmsActivityBrand> queryActivityBrand(Integer actType) {
			return cmsActivityBrandMapper.queryActivityBrand(actType);
		}

}
