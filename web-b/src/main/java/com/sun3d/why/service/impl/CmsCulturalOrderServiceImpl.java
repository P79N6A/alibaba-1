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
	public List<CmsCulturalOrder> queryCulturalOrderList(CmsCulturalOrder cmsCulturalOrder, Pagination page,
			SysUser sysUser) {
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("culturalOrderLargeType", cmsCulturalOrder.getCulturalOrderLargeType());
		if (StringUtils.isNotEmpty(cmsCulturalOrder.getCulturalOrderName())){
			if ("请输入标题".equals(cmsCulturalOrder.getCulturalOrderName())){
				
			} else {
				params.put("culturalOrderName", cmsCulturalOrder.getCulturalOrderName());
			}
		}
		if (StringUtils.isNotEmpty(cmsCulturalOrder.getCulturalOrderType())){
			params.put("culturalOrderType", cmsCulturalOrder.getCulturalOrderType());
		}
		if (StringUtils.isNotEmpty(cmsCulturalOrder.getCulturalOrderArea())){
			params.put("culturalOrderArea", cmsCulturalOrder.getCulturalOrderArea());
		}
		if (cmsCulturalOrder.getCulturalOrderStatus() != null){
			params.put("culturalOrderStatus", cmsCulturalOrder.getCulturalOrderStatus());
		}
		params.put("userDeptPath", sysUser.getUserDeptPath());
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
	public int saveCulturalOrderAttend(CmsCulturalOrder order, String startTime,String endTime,
			String startHour, String startMinute, String endHour,
			String endMinute, String ticketNum, SysUser sysUser) throws Exception {
		order.setCulturalOrderId(UUIDUtils.createUUId());
		order.setUserDeptPath(sysUser.getUserDeptPath());
		order.setCreateTime(new Date());
		order.setCreateUser(sysUser.getUserId());
		order.setUpdateTime(new Date());
		order.setUpdateUser(sysUser.getUserId());
		order.setCulturalOrderStatus(0);
		int result = cmsCulturalOrderMapper.addCulturalOrder(order);
		if (result > 0){
			String[] startTimeArr = startTime.split(",");
			String[] endTimeArr = endTime.split(",");
			String[] startHourArr = startHour.split(",");
			String[] startMinuteArr = startMinute.split(",");
			String[] endHourArr = endHour.split(",");
			String[] endMinuteArr = endMinute.split(",");
			String[] ticketNumArr = ticketNum.split(",");
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			for (int i=0;i<startTimeArr.length;i++){
				String startTimeStr = startTimeArr[i];
				String endTimeStr = endTimeArr[i];
				String startHourStr = startHourArr[i];
				String startMinuteStr = startMinuteArr[i];
				String endHourStr = endHourArr[i];
				String endMinuteStr = endMinuteArr[i];
				String ticketNumStr = ticketNumArr[i];
				Date startDate = sdf.parse(startTimeStr);
				Date endDate = sdf.parse(endTimeStr);
				if (startDate.compareTo(endDate)>0){
					continue;
				}
				if (Integer.parseInt(startHourStr)<10){
					startHourStr = "0" + Integer.valueOf(startHourStr).toString();
				}
				if (Integer.parseInt(startMinuteStr)<10){
					startMinuteStr = "0" + Integer.valueOf(startMinuteStr).toString();
				}
				if (Integer.parseInt(endHourStr)<10){
					endHourStr = "0" + Integer.valueOf(endHourStr).toString();
				}
				if (Integer.parseInt(endMinuteStr)<10){
					endMinuteStr = "0" + Integer.valueOf(endMinuteStr).toString();
				}
				String eventTime = startHourStr+":"+startMinuteStr+"-"+endHourStr+":"+endMinuteStr;
				while (startDate.compareTo(endDate)<=0){
					CmsCulturalOrderEvent event = new CmsCulturalOrderEvent();
					event.setCulturalOrderEventId(UUIDUtils.createUUId());
					event.setCulturalOrderId(order.getCulturalOrderId());
					event.setCulturalOrderEventDate(startDate);
					event.setCulturalOrderEventTime(eventTime);
					event.setEventTicketNum(Integer.parseInt(ticketNumStr));
					cmsCulturalOrderEventMapper.addCulturalOrderEvent(event);
					startDate = DateUtils.addDays(startDate, 1);
				}
			}
		}
		return result;
	}

	@Override
	public int changeCulturalOrderStatus(String culturalOrderId, Integer status) {
		Map<String,Object> params = new HashMap<String,Object>();
		params.put("culturalOrderId", culturalOrderId);
		params.put("culturalOrderStatus", status);
		return cmsCulturalOrderMapper.changeCulturalOrderStatus(params);
	}

	@Override
	public CmsCulturalOrder queryCulturalOrderById(String culturalOrderId) {
		return cmsCulturalOrderMapper.queryCulturalOrderById(culturalOrderId);
	}

	@Override
	public int editCulturalOrderAttend(CmsCulturalOrder order, String startTime, String endTime, String startHour,
			String startMinute, String endHour, String endMinute, String ticketNum, SysUser sysUser) throws Exception {
		order.setUpdateTime(new Date());
		order.setUpdateUser(sysUser.getUserId());
		int result = cmsCulturalOrderMapper.updateCulturalOrder(order);
		if (result > 0){
			cmsCulturalOrderEventMapper.delCulturalOrderEventByCulturalOrderId(order.getCulturalOrderId());
			String[] startTimeArr = startTime.split(",");
			String[] endTimeArr = endTime.split(",");
			String[] startHourArr = startHour.split(",");
			String[] startMinuteArr = startMinute.split(",");
			String[] endHourArr = endHour.split(",");
			String[] endMinuteArr = endMinute.split(",");
			String[] ticketNumArr = ticketNum.split(",");
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			for (int i=0;i<startTimeArr.length;i++){
				String startTimeStr = startTimeArr[i];
				String endTimeStr = endTimeArr[i];
				String startHourStr = startHourArr[i];
				String startMinuteStr = startMinuteArr[i];
				String endHourStr = endHourArr[i];
				String endMinuteStr = endMinuteArr[i];
				String ticketNumStr = ticketNumArr[i];
				Date startDate = sdf.parse(startTimeStr);
				Date endDate = sdf.parse(endTimeStr);
				if (startDate.compareTo(endDate)>0){
					continue;
				}
				if (Integer.parseInt(startHourStr)<10){
					startHourStr = "0" + Integer.valueOf(startHourStr).toString();
				}
				if (Integer.parseInt(startMinuteStr)<10){
					startMinuteStr = "0" + Integer.valueOf(startMinuteStr).toString();
				}
				if (Integer.parseInt(endHourStr)<10){
					endHourStr = "0" + Integer.valueOf(endHourStr).toString();
				}
				if (Integer.parseInt(endMinuteStr)<10){
					endMinuteStr = "0" + Integer.valueOf(endMinuteStr).toString();
				}
				String eventTime = startHourStr+":"+startMinuteStr+"-"+endHourStr+":"+endMinuteStr;
				while (startDate.compareTo(endDate)<=0){
					CmsCulturalOrderEvent event = new CmsCulturalOrderEvent();
					event.setCulturalOrderEventId(UUIDUtils.createUUId());
					event.setCulturalOrderId(order.getCulturalOrderId());
					event.setCulturalOrderEventDate(startDate);
					event.setCulturalOrderEventTime(eventTime);
					event.setEventTicketNum(Integer.parseInt(ticketNumStr));
					cmsCulturalOrderEventMapper.addCulturalOrderEvent(event);
					startDate = DateUtils.addDays(startDate, 1);
				}
			}
		}
		return result;
	}

	@Override
	public int saveCulturalOrderInvite(CmsCulturalOrder order, String startTime, String endTime, SysUser sysUser) throws ParseException {
		order.setCulturalOrderId(UUIDUtils.createUUId());
		order.setUserDeptPath(sysUser.getUserDeptPath());
		order.setCreateTime(new Date());
		order.setCreateUser(sysUser.getUserId());
		order.setUpdateTime(new Date());
		order.setUpdateUser(sysUser.getUserId());
		order.setCulturalOrderStatus(0);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = sdf.parse(startTime);
		Date endDate = sdf.parse(endTime);
		order.setCulturalOrderStartDate(startDate);
		order.setCulturalOrderEndDate(endDate);
		return cmsCulturalOrderMapper.addCulturalOrder(order);
	}

	@Override
	public int editCulturalOrderInvite(CmsCulturalOrder order, String startTime, String endTime, SysUser sysUser)
			throws Exception {
		order.setUpdateTime(new Date());
		order.setUpdateUser(sysUser.getUserId());
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate = sdf.parse(startTime);
		Date endDate = sdf.parse(endTime);
		order.setCulturalOrderStartDate(startDate);
		order.setCulturalOrderEndDate(endDate);
		return cmsCulturalOrderMapper.updateCulturalOrder(order);
	}
	
}
