package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsCulturalOrderOrder;

public interface CmsCulturalOrderOrderMapper {

	public List<CmsCulturalOrderOrder> queryOrderListByCulturalOrderId(String culturalOrderId);

	public List<CmsCulturalOrderOrder> queryCulturalOrderOrderList(Map<String, Object> params);

	public int queryCulturalOrderOrderListCount(Map<String, Object> params);

	public int updateCulturalOrderOrder(CmsCulturalOrderOrder order);

	public CmsCulturalOrderOrder queryCulturalOrderOrderById(String id);

}
