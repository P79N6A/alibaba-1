package com.sun3d.why.service.impl;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsCulturalOrderEventMapper;
import com.sun3d.why.dao.CmsCulturalOrderMapper;
import com.sun3d.why.dao.CmsCulturalOrderOrderMapper;
import com.sun3d.why.model.CmsCulturalOrder;
import com.sun3d.why.model.CmsCulturalOrderEvent;
import com.sun3d.why.model.CmsCulturalOrderOrder;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsCulturalOrderOrderService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
@Service
@Transactional
public class CmsCulturalOrderOrderServiceImpl implements CmsCulturalOrderOrderService {
	@Autowired
	private CmsCulturalOrderOrderMapper cmsCulturalOrderOrderMapper;
	@Autowired
	private CmsCulturalOrderMapper cmsCulturalOrderMapper;
	@Autowired
	private CmsCulturalOrderEventMapper cmsCulturalOrderEventMapper;
	@Override
	public List<CmsCulturalOrderOrder> queryOrderOrderListByCulturalOrderId(String culturalOrderId) {
		List<CmsCulturalOrderOrder> orderOrderList = cmsCulturalOrderOrderMapper.queryOrderOrderListByCulturalOrderId(culturalOrderId);
		return orderOrderList;
	}

	@Override
	@Transactional(isolation=Isolation.SERIALIZABLE)
	public int addCulturalOrderOrder(CmsCulturalOrderOrder orderOrder) {
		Map<String,Object> orderMap = new HashMap<String,Object>();
		orderMap.put("culturalOrderId", orderOrder.getCulturalOrderId());
		CmsCulturalOrder order = cmsCulturalOrderMapper.queryCulturalOrderById(orderMap);
		//判断是否超过上限
		if (order.getCulturalOrderLargeType() == 1){
			CmsCulturalOrderEvent event = cmsCulturalOrderEventMapper.queryCulturalOrderEventById(orderOrder.getCulturalOrderEventId());
			if (event.getUsedTicketNum() >= event.getEventTicketNum()){
				return -1;
			}
		}
		orderOrder.setCulturalOrderOrderId(UUIDUtils.createUUId());
		orderOrder.setCreateTime(new Date());
		orderOrder.setCulturalOrderOrderStatus(0);
		return cmsCulturalOrderOrderMapper.addCulturalOrderOrder(orderOrder);
	}

	@Override
	public List<CmsCulturalOrderOrder> queryOrderOrderListByUserId(Integer culturalOrderLargeType,String userId,Pagination page) {
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("culturalOrderLargeType",culturalOrderLargeType);
		params.put("userId", userId);
		if (page !=null && page.getFirstResult() !=null && page.getRows() !=null){
			params.put("firstResult", page.getFirstResult());
			params.put("rows", page.getRows());
			int total = cmsCulturalOrderOrderMapper.queryOrderOrderListCountByUserId(params);
			page.setTotal(total);
		}
		List<CmsCulturalOrderOrder> orderOrderList = cmsCulturalOrderOrderMapper.queryOrderOrderListByUserId(params);
		return orderOrderList;
	}
	
	@Override
	public int cancelCulturalOrderOrder(String culturalOrderOrderId){
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("culturalOrderOrderId", culturalOrderOrderId);
		params.put("culturalOrderOrderStatus", 3);
		return cmsCulturalOrderOrderMapper.changeCulturalOrderOrderStatus(params);
	}
	
	@Override
	public CmsCulturalOrderOrder queryOrderOrderById(String culturalOrderOrderId){
		return cmsCulturalOrderOrderMapper.queryOrderOrderById(culturalOrderOrderId);
	}
	
}
