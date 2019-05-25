package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.CmsCulturalOrderOrder;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

public interface CmsCulturalOrderOrderService {

	public List<CmsCulturalOrderOrder> queryOrderListByCulturalOrderId(String culturalOrderId);

	public List<CmsCulturalOrderOrder> queryCulturalOrderOrderList(CmsCulturalOrderOrder cmsCulturalOrderOrder,
			Pagination page, SysUser sysUser);

	public int dealCulturalOrderOrderReply(String ids, Integer culturalOrderOrderStatus, String culturalOrderReply, SysUser sysUser) throws Exception;

	public CmsCulturalOrderOrder queryCulturalOrderOrderById(String culturalOrderOrderId);

	public int editCmsCulturalOrderOrder(CmsCulturalOrderOrder orderOrder);

}
