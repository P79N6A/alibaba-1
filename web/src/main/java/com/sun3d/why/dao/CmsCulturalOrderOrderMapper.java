package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsCulturalOrderOrder;

public interface CmsCulturalOrderOrderMapper {

	public List<CmsCulturalOrderOrder> queryOrderOrderListByCulturalOrderId(String culturalOrderId);

	public int addCulturalOrderOrder(CmsCulturalOrderOrder order);

	public List<CmsCulturalOrderOrder> queryOrderOrderListByUserId(Map<String, Object> params);

	public int changeCulturalOrderOrderStatus(Map<String, Object> params);

	public int queryOrderOrderListCountByUserId(Map<String, Object> params);

	public CmsCulturalOrderOrder queryOrderOrderById(String culturalOrderOrderId);

}
