package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.CmsCulturalOrderOrder;
import com.sun3d.why.util.Pagination;

public interface CmsCulturalOrderOrderService {

	public List<CmsCulturalOrderOrder> queryOrderOrderListByCulturalOrderId(String culturalOrderId);

	public int addCulturalOrderOrder(CmsCulturalOrderOrder order);
	
	public List<CmsCulturalOrderOrder> queryOrderOrderListByUserId(Integer culturalOrderLargeType,String userId,Pagination page);

	public int cancelCulturalOrderOrder(String culturalOrderOrderId);

	public CmsCulturalOrderOrder queryOrderOrderById(String culturalOrderOrderId);

}
