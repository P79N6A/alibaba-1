package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.CmsCulturalOrder;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

public interface CmsCulturalOrderService {

	public List<CmsCulturalOrder> queryCulturalOrderList(CmsCulturalOrder cmsCulturalOrder, Pagination page, SysUser sysUser);

	public int saveCulturalOrderAttend(CmsCulturalOrder order, String startTime, String endTime, String startHour,
			String startMinute, String endHour, String endMinute, String ticketNum, SysUser sysUser) throws Exception;

	public int changeCulturalOrderStatus(String culturalOrderId, Integer status);

	public CmsCulturalOrder queryCulturalOrderById(String culturalOrderId);

	public int editCulturalOrderAttend(CmsCulturalOrder order, String startTime, String endTime, String startHour,
			String startMinute, String endHour, String endMinute, String ticketNum, SysUser sysUser) throws Exception;

	public int saveCulturalOrderInvite(CmsCulturalOrder order, String startTime, String endTime, SysUser sysUser) throws Exception;

	public int editCulturalOrderInvite(CmsCulturalOrder order, String startTime, String endTime, SysUser sysUser) throws Exception;


}
