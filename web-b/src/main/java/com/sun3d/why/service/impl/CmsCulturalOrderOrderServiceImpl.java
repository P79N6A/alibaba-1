package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsCulturalOrderOrderMapper;
import com.sun3d.why.model.CmsCulturalOrderOrder;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsCulturalOrderOrderService;
import com.sun3d.why.util.Pagination;
@Service
@Transactional
public class CmsCulturalOrderOrderServiceImpl implements CmsCulturalOrderOrderService {
	@Autowired
	private CmsCulturalOrderOrderMapper cmsCulturalOrderOrderMapper;

	@Override
	public List<CmsCulturalOrderOrder> queryOrderListByCulturalOrderId(String culturalOrderId) {
		return cmsCulturalOrderOrderMapper.queryOrderListByCulturalOrderId(culturalOrderId);
	}

	@Override
	public List<CmsCulturalOrderOrder> queryCulturalOrderOrderList(CmsCulturalOrderOrder cmsCulturalOrderOrder,
			Pagination page, SysUser sysUser) {
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("culturalOrderLargeType", cmsCulturalOrderOrder.getCulturalOrderLargeType());
		if (StringUtils.isNotEmpty(cmsCulturalOrderOrder.getCulturalOrderName())){
			if ("请输入标题".equals(cmsCulturalOrderOrder.getCulturalOrderName())){
				
			} else {
				params.put("culturalOrderName", cmsCulturalOrderOrder.getCulturalOrderName());
			}
		}
		if (cmsCulturalOrderOrder.getCulturalOrderOrderStatus() != null){
			params.put("culturalOrderOrderStatus", cmsCulturalOrderOrder.getCulturalOrderOrderStatus());
		}
		if (StringUtils.isNotEmpty(cmsCulturalOrderOrder.getCulturalOrderType())){
			params.put("culturalOrderType", cmsCulturalOrderOrder.getCulturalOrderType());
		}
		params.put("userDeptPath", sysUser.getUserDeptPath());
		if (page !=null && page.getFirstResult() !=null && page.getRows() !=null){
			params.put("firstResult", page.getFirstResult());
			params.put("rows", page.getRows());
			int total = cmsCulturalOrderOrderMapper.queryCulturalOrderOrderListCount(params);
			page.setTotal(total);
		}
		return cmsCulturalOrderOrderMapper.queryCulturalOrderOrderList(params);
	}

	@Override
	public int dealCulturalOrderOrderReply(String ids, Integer culturalOrderOrderStatus, String culturalOrderReply,
			SysUser sysUser) throws Exception{
		String[] idArr = ids.split(",");
		for (String id : idArr){
			CmsCulturalOrderOrder order = cmsCulturalOrderOrderMapper.queryCulturalOrderOrderById(id);
			if (order != null){
				order.setCulturalOrderOrderStatus(culturalOrderOrderStatus);
				order.setCulturalOrderReply(culturalOrderReply);
				order.setCulturalOrderAuditTime(new Date());
				order.setCulturalOrderAuditUser(sysUser.getUserId());
				cmsCulturalOrderOrderMapper.updateCulturalOrderOrder(order);
			}
		}
		return 1;
	}

	@Override
	public CmsCulturalOrderOrder queryCulturalOrderOrderById(String culturalOrderOrderId) {
		return cmsCulturalOrderOrderMapper.queryCulturalOrderOrderById(culturalOrderOrderId);
	}

	@Override
	public int editCmsCulturalOrderOrder(CmsCulturalOrderOrder orderOrder) {
		return cmsCulturalOrderOrderMapper.updateCulturalOrderOrder(orderOrder);
	}
}
