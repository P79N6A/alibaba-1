package com.sun3d.why.service.impl;

import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsCulturalOrderEventMapper;
import com.sun3d.why.model.CmsCulturalOrder;
import com.sun3d.why.model.CmsCulturalOrderEvent;
import com.sun3d.why.service.CmsCulturalOrderEventService;

@Service
@Transactional
public class CmsCulturalOrderEventServiceImpl implements CmsCulturalOrderEventService{
	@Autowired
	private CmsCulturalOrderEventMapper cmsCulturalOrderEventMapper;
	
	@Override
	public List<CmsCulturalOrderEvent> queryCulturalOrderEventByCulturalOrderId(String culturalOrderId,String userId) {
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("culturalOrderId", culturalOrderId);
		if (StringUtils.isNotBlank(userId)){
			params.put("userId", userId);
		}
		List<CmsCulturalOrderEvent> eventList = cmsCulturalOrderEventMapper.queryCulturalOrderEventByCulturalOrderId(params);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		for (CmsCulturalOrderEvent event : eventList){
			event.setCulturalOrderEventDateStr(sdf.format(event.getCulturalOrderEventDate()));
		}
		return eventList;
	}
}
