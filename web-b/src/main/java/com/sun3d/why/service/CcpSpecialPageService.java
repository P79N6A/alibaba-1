package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.special.CcpSpecialPage;
import com.culturecloud.model.bean.special.CcpSpecialPageActivity;
import com.sun3d.why.dao.dto.CcpSpecialPageDto;
import com.sun3d.why.util.Pagination;

public interface CcpSpecialPageService {

	List<CcpSpecialPageDto> queryByCondition(CcpSpecialPage entity, Pagination page);
	
	CcpSpecialPage findById(String pageId);
	
	int saveOrUpdatePage(CcpSpecialPage entity);
	
	int savePageActivity(CcpSpecialPageActivity entity,String activityIds);
	
	int deletePageActivity(CcpSpecialPageActivity entity);
}
