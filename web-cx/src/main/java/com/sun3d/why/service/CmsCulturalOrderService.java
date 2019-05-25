package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.CmsCulturalOrder;
import com.sun3d.why.util.Pagination;

public interface CmsCulturalOrderService {
	
	public List<CmsCulturalOrder> queryCulturalOrderList(CmsCulturalOrder cmsCulturalOrder,Pagination page,Integer orderType,String memberId);

	public CmsCulturalOrder queryCulturalOrderById(String culturalOrderId,Integer culturalOrderLargeType, String userId);

}
