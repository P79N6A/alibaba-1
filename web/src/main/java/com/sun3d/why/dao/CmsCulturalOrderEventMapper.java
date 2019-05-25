package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsCulturalOrderEvent;

public interface CmsCulturalOrderEventMapper {

	public List<CmsCulturalOrderEvent> queryCulturalOrderEventByCulturalOrderId(Map<String, Object> params);

	public CmsCulturalOrderEvent queryCulturalOrderEventById(String culturalOrderEventId);


}
