package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsCulturalOrder;

public interface CmsCulturalOrderMapper {

	public List<CmsCulturalOrder> queryCulturalOrderList(Map<String, Object> params);

	public CmsCulturalOrder queryCulturalOrderById(Map<String, Object> params);

	public int queryCulturalOrderListCount(Map<String, Object> params);


}
