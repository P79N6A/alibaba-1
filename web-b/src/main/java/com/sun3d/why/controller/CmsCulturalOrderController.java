package com.sun3d.why.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.CmsCulturalOrder;
import com.sun3d.why.model.CmsCulturalOrderEvent;
import com.sun3d.why.model.CmsCulturalOrderOrder;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsCulturalOrderEventService;
import com.sun3d.why.service.CmsCulturalOrderOrderService;
import com.sun3d.why.service.CmsCulturalOrderService;
import com.sun3d.why.service.CmsVenueService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

@RequestMapping("/culturalOrder")
@Controller
public class CmsCulturalOrderController {
	@Autowired
	private CmsCulturalOrderService cmsCulturalOrderService;
	@Autowired
	private CmsCulturalOrderEventService cmsCulturalOrderEventService;
	@Autowired
	private CmsCulturalOrderOrderService cmsCulturalOrderOrderService;
	@Autowired
	private CmsVenueService cmsVenueService;
	@Autowired
	private HttpSession session;
	/**
	 * 列表页
	 * @param cmsCulturalOrder
	 * @param page
	 * @return
	 */
	@RequestMapping(value="/culturalOrderList")
	public ModelAndView culturalOrderList(CmsCulturalOrder cmsCulturalOrder,Pagination page){
		ModelAndView model = new ModelAndView();
		try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if (sysUser != null && StringUtils.isNotBlank(sysUser.getUserId()) && cmsCulturalOrder.getCulturalOrderLargeType() != null){
				List<CmsCulturalOrder> orderList = cmsCulturalOrderService.queryCulturalOrderList(cmsCulturalOrder,page,sysUser);
				model.addObject("orderList", orderList);
				model.addObject("cmsCulturalOrder",cmsCulturalOrder);
				model.addObject("page",page);
				model.setViewName("admin/culturalOrder/culturalOrderList");
			}
		} catch (Exception e){
			e.printStackTrace();
		}
		return model;
	}
	/**
	 * 跳转添加页
	 * @param culturalOrderLargeType
	 * @return
	 */
	@RequestMapping(value="/toAddCulturalOrder")
	public ModelAndView toAddCulturalOrder(Integer culturalOrderLargeType){
		ModelAndView model = new ModelAndView();
		try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if (sysUser != null && StringUtils.isNotBlank(sysUser.getUserId()) && culturalOrderLargeType != null){
				CmsCulturalOrder order = new CmsCulturalOrder();
				order.setCulturalOrderLargeType(culturalOrderLargeType);
				model.addObject("order",order);
				if (culturalOrderLargeType == 1){
					model.setViewName("admin/culturalOrder/addCulturalOrderAttend");
				} else if (culturalOrderLargeType == 2){
					model.setViewName("admin/culturalOrder/addCulturalOrderInvite");
				}
			}
		} catch (Exception e){
			e.printStackTrace();
		}
		return model;
	}
	@RequestMapping(value="/toEditCulturalOrder")
	public ModelAndView toEditCulturalOrder(String culturalOrderId){
		ModelAndView model = new ModelAndView();
		try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if (sysUser != null && StringUtils.isNotBlank(sysUser.getUserId()) && StringUtils.isNotEmpty(culturalOrderId)){
				CmsCulturalOrder order = cmsCulturalOrderService.queryCulturalOrderById(culturalOrderId);
				if (order.getCulturalOrderLargeType() == 1){
					List<CmsCulturalOrderEvent> eventList = cmsCulturalOrderEventService.queryCulturalOrderEventByCulturalOrderId(culturalOrderId);
					model.addObject("order", order);
					model.addObject("eventList", eventList);
					model.setViewName("admin/culturalOrder/editCulturalOrderAttend");
				} else if (order.getCulturalOrderLargeType() == 2){
					model.addObject("order", order);
					model.setViewName("admin/culturalOrder/editCulturalOrderInvite");
				}
			}
		} catch (Exception e){
			e.printStackTrace();
		}
		return model;
	}
	/**
	 * 获得场馆列表
	 * @param area
	 * @param type
	 * @return
	 */
	@RequestMapping(value="/getVenueListByAreaAndType")
	@ResponseBody
	public List<CmsVenue> getVenueListByAreaAndType(String area,String type){
		CmsVenue venue = new CmsVenue();
		venue.setVenueArea(area);
		venue.setVenueType(type);
		venue.setVenueState(Constant.PUBLISH);
		venue.setVenueIsDel(1);
		List<CmsVenue> venueList = cmsVenueService.queryVenueByConditionFromCulturalOrder(venue);
		return venueList;
	}
	/**
	 * 保存
	 * @param order
	 * @param startTime
	 * @param endTime
	 * @param startHour
	 * @param startMinute
	 * @param endHour
	 * @param endMinute
	 * @param ticketNum
	 * @return
	 */
	@RequestMapping(value="/saveCulturalOrder")
	@ResponseBody
	public String saveCulturalOrder(CmsCulturalOrder order,String startTime,String endTime,String startHour,String startMinute,
			String endHour,String endMinute,String ticketNum){
		try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if(sysUser != null && StringUtils.isNotBlank(sysUser.getUserId())){
				if (order.getCulturalOrderLargeType() == 1){
					if (StringUtils.isNotBlank(order.getCulturalOrderId())){
						List<CmsCulturalOrderOrder> orderList = cmsCulturalOrderOrderService.queryOrderListByCulturalOrderId(order.getCulturalOrderId());
						if (orderList != null && orderList.size()>0){
							return "hasOrder";
						}
						int result = cmsCulturalOrderService.editCulturalOrderAttend(order,startTime,endTime,startHour,startMinute,endHour,endMinute,ticketNum,sysUser);
						if (result > 0){
							return Constant.RESULT_STR_SUCCESS;
						} else {
							return Constant.RESULT_STR_FAILURE;
						}
					} else {
						int result = cmsCulturalOrderService.saveCulturalOrderAttend(order,startTime,endTime,startHour,startMinute,endHour,endMinute,ticketNum,sysUser);
						if (result > 0){
							return Constant.RESULT_STR_SUCCESS;
						} else {
							return Constant.RESULT_STR_FAILURE;
						}
					}
				} else if (order.getCulturalOrderLargeType() == 2){
					if (StringUtils.isNotBlank(order.getCulturalOrderId())){
						List<CmsCulturalOrderOrder> orderList = cmsCulturalOrderOrderService.queryOrderListByCulturalOrderId(order.getCulturalOrderId());
						if (orderList != null && orderList.size()>0){
							return "hasOrder";
						} else {
							int result = cmsCulturalOrderService.editCulturalOrderInvite(order,startTime,endTime,sysUser);
							if (result > 0){
								return Constant.RESULT_STR_SUCCESS;
							} else {
								return Constant.RESULT_STR_FAILURE;
							}
						}
					} else {
						int result = cmsCulturalOrderService.saveCulturalOrderInvite(order,startTime,endTime,sysUser);
						if (result > 0){
							return Constant.RESULT_STR_SUCCESS;
						} else {
							return Constant.RESULT_STR_FAILURE;
						}
					}
				}
			} else {
				return Constant.RESULT_STR_NOACTIVE;
			}
		}  catch (Exception e){
			e.printStackTrace();
			return Constant.RESULT_STR_FAILURE;
		}
		return null;
	}
	@RequestMapping(value="/setCulturalOrderStatus")
	@ResponseBody
	public String setCulturalOrderStatus(String culturalOrderId,Integer status){
		if (StringUtils.isBlank(culturalOrderId) || (status != 0 && status != 1)){
			return Constant.RESULT_STR_FAILURE;
		}
		try{
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if(sysUser != null && StringUtils.isNotBlank(sysUser.getUserId())){
				int result = cmsCulturalOrderService.changeCulturalOrderStatus(culturalOrderId,status);
				if (result > 0){
					return Constant.RESULT_STR_SUCCESS;
				} else {
					return Constant.RESULT_STR_FAILURE;
				}
			} else {
				return Constant.RESULT_STR_NOACTIVE;
			}
		}  catch (Exception e){
			e.printStackTrace();
			return Constant.RESULT_STR_FAILURE;
		}
	}
	@RequestMapping(value="/delCulturalOrder")
	@ResponseBody
	public String delCulturalOrder(String culturalOrderId){
		if (StringUtils.isBlank(culturalOrderId)){
			return Constant.RESULT_STR_FAILURE;
		}
		List<CmsCulturalOrderOrder> orderList = cmsCulturalOrderOrderService.queryOrderListByCulturalOrderId(culturalOrderId);
		if (orderList != null && orderList.size()>0){
			return "hasOrder";
		}
		try{
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if(sysUser != null && StringUtils.isNotBlank(sysUser.getUserId())){
				int result = cmsCulturalOrderService.changeCulturalOrderStatus(culturalOrderId,2);
				if (result > 0){
					return Constant.RESULT_STR_SUCCESS;
				} else {
					return Constant.RESULT_STR_FAILURE;
				}
			} else {
				return Constant.RESULT_STR_NOACTIVE;
			}
		}  catch (Exception e){
			e.printStackTrace();
			return Constant.RESULT_STR_FAILURE;
		}
	}
}
