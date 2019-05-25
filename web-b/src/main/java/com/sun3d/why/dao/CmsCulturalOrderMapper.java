package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsCulturalOrder;

public interface CmsCulturalOrderMapper {

	public int queryCulturalOrderListCount(Map<String, Object> params);

	public List<CmsCulturalOrder> queryCulturalOrderList(Map<String, Object> params);

	public int addCulturalOrder(CmsCulturalOrder order);

	public int changeCulturalOrderStatus(Map<String, Object> params);

	public CmsCulturalOrder queryCulturalOrderById(String culturalOrderId);

	public int updateCulturalOrder(CmsCulturalOrder order);

}
