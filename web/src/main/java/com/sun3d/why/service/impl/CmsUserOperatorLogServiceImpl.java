package com.sun3d.why.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsUserOperatorLogMapper;
import com.sun3d.why.model.CmsUserOperatorLog;
import com.sun3d.why.service.CmsUserOperatorLogService;

@Service
public class CmsUserOperatorLogServiceImpl implements CmsUserOperatorLogService {
	
	@Autowired
	private CmsUserOperatorLogMapper cmsUserOperatorLogMapper;

	@Override
	@Transactional
	public List<CmsUserOperatorLog> queryCmsUserOperatorLogByModel(CmsUserOperatorLog model) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		if(StringUtils.isNotBlank(model.getUserId())){
			map.put("userId", model.getUserId());
		}
		
		if(StringUtils.isNotBlank(model.getTuserId())){
			map.put("tuserId", model.getTuserId());
		}
		
		if(StringUtils.isNotBlank(model.getOrderId())){
			map.put("orderId", model.getOrderId());
		}
		
		return cmsUserOperatorLogMapper.queryCmsUserOperatorLogByModel(map);
	}

	@Override
	public int insert(CmsUserOperatorLog record) {
		
		return cmsUserOperatorLogMapper.insert(record);
	}

}
