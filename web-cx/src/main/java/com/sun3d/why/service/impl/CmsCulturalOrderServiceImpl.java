package com.sun3d.why.service.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsCulturalOrderEventMapper;
import com.sun3d.why.dao.CmsCulturalOrderMapper;
import com.sun3d.why.model.CmsCulturalOrder;
import com.sun3d.why.model.CmsCulturalOrderEvent;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsCulturalOrderService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
@Service
@Transactional
public class CmsCulturalOrderServiceImpl implements CmsCulturalOrderService {
	@Autowired
	private CmsCulturalOrderMapper cmsCulturalOrderMapper;
	@Autowired
	private CmsCulturalOrderEventMapper cmsCulturalOrderEventMapper;
	@Override
	public List<CmsCulturalOrder> queryCulturalOrderList(CmsCulturalOrder cmsCulturalOrder, Pagination page,Integer orderType,String memberId) {
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("culturalOrderLargeType", cmsCulturalOrder.getCulturalOrderLargeType());
		if (StringUtils.isNotEmpty(cmsCulturalOrder.getCulturalOrderType())){
			params.put("culturalOrderType", cmsCulturalOrder.getCulturalOrderType());
		}
		if (StringUtils.isNotEmpty(cmsCulturalOrder.getCulturalOrderArea())){
			params.put("culturalOrderArea", cmsCulturalOrder.getCulturalOrderArea());
		}
		if (StringUtils.isNotEmpty(cmsCulturalOrder.getCulturalOrderTown())){
			params.put("culturalOrderTown", cmsCulturalOrder.getCulturalOrderTown());
		}
		if (cmsCulturalOrder.getCulturalOrderDemandLimit() != null){
			params.put("culturalOrderDemandLimit", cmsCulturalOrder.getCulturalOrderDemandLimit());
		}
		if (StringUtils.isNotEmpty(memberId)){
			params.put("memberId", memberId);
		}
		params.put("orderType", orderType);
		if (page !=null && page.getFirstResult() !=null && page.getRows() !=null){
			params.put("firstResult", page.getFirstResult());
			params.put("rows", page.getRows());
			int total = cmsCulturalOrderMapper.queryCulturalOrderListCount(params);
			page.setTotal(total);
		}
		List<CmsCulturalOrder> orderList = cmsCulturalOrderMapper.queryCulturalOrderList(params);
		return orderList;
	}

	@Override
	public CmsCulturalOrder queryCulturalOrderById(String culturalOrderId,Integer culturalOrderLargeType,String userId) {
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("culturalOrderId", culturalOrderId);
		params.put("culturalOrderLargeType", culturalOrderLargeType);
		if (StringUtils.isNotBlank(userId)){
			params.put("userId", userId);
		}
		CmsCulturalOrder order = cmsCulturalOrderMapper.queryCulturalOrderById(params);
		return order;
	}

}
