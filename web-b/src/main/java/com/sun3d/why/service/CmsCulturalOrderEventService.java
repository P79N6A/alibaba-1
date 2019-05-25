package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.CmsCulturalOrderEvent;

public interface CmsCulturalOrderEventService {

	public List<CmsCulturalOrderEvent> queryCulturalOrderEventByCulturalOrderId(String culturalOrderId);

}
