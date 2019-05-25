package com.sun3d.why.dao;

import java.util.List;

import com.sun3d.why.model.CmsCulturalOrderEvent;

public interface CmsCulturalOrderEventMapper {

	public int addCulturalOrderEvent(CmsCulturalOrderEvent event);

	public List<CmsCulturalOrderEvent> queryCulturalOrderEventByCulturalOrderId(String culturalOrderId);

	public int delCulturalOrderEventByCulturalOrderId(String culturalOrderId);

}
