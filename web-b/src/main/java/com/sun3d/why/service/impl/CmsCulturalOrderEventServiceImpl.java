package com.sun3d.why.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsCulturalOrderEventMapper;
import com.sun3d.why.model.CmsCulturalOrderEvent;
import com.sun3d.why.service.CmsCulturalOrderEventService;

@Service
@Transactional
public class CmsCulturalOrderEventServiceImpl implements CmsCulturalOrderEventService{
	@Autowired
	private CmsCulturalOrderEventMapper cmsCulturalOrderEventMapper;

	@Override
	public List<CmsCulturalOrderEvent> queryCulturalOrderEventByCulturalOrderId(String culturalOrderId) {
		return cmsCulturalOrderEventMapper.queryCulturalOrderEventByCulturalOrderId(culturalOrderId);
	}
}
