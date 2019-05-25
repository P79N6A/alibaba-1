package com.culturecloud.service.local.common;

import java.util.List;

import com.culturecloud.model.response.common.CmsTagSubVO;

public interface CmsTagSubService {

	public List<CmsTagSubVO> queryRelateTagSubList(String relateId);
}
