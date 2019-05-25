package com.sun3d.why.controller;

import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.CmsCulturalOrder;
import com.sun3d.why.model.CmsCulturalOrderOrder;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsCulturalOrderOrderService;
import com.sun3d.why.service.CmsCulturalOrderService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

@RequestMapping("/culturalOrderOrder")
@Controller
public class CmsCulturalOrderOrderController {
	@Autowired
	private CmsCulturalOrderOrderService cmsCulturalOrderOrderService;
	@Autowired
	private CmsCulturalOrderService cmsCulturalOrderService;
	@Autowired
	private HttpSession session;
	
	@RequestMapping(value="/culturalOrderOrderList")
	public ModelAndView culturalOrderOrderList(CmsCulturalOrderOrder cmsCulturalOrderOrder,Pagination page){
		ModelAndView model = new ModelAndView();
		try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if (sysUser != null && StringUtils.isNotBlank(sysUser.getUserId()) && cmsCulturalOrderOrder.getCulturalOrderLargeType() != null){
				List<CmsCulturalOrderOrder> orderOrderList = cmsCulturalOrderOrderService.queryCulturalOrderOrderList(cmsCulturalOrderOrder,page,sysUser);
				model.addObject("orderOrderList", orderOrderList);
				model.addObject("page",page);
				model.addObject("cmsCulturalOrderOrder",cmsCulturalOrderOrder);
				model.setViewName("admin/culturalOrder/culturalOrderOrderList");
			}
		} catch (Exception e){
			e.printStackTrace();
		}
		return model;
	}
	
	@RequestMapping(value="/dealCulturalOrderOrder")
	public ModelAndView dealCulturalOrderOrder(String ids){
		ModelAndView model = new ModelAndView();
		if (StringUtils.isNotEmpty(ids)){
			model.addObject("ids", ids);
			model.setViewName("admin/culturalOrder/dealCulturalOrderOrder");
		}
		return model;
	}
	
	@RequestMapping(value="/saveCulturalOrderOrderReply")
	@ResponseBody
	public String saveCulturalOrderOrderReply(String ids,Integer culturalOrderOrderStatus,String culturalOrderReply){
		if (StringUtils.isBlank(ids) || culturalOrderOrderStatus == null){
			return Constant.RESULT_STR_FAILURE;
		}
		try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if(sysUser != null && StringUtils.isNotBlank(sysUser.getUserId())){
				int result = cmsCulturalOrderOrderService.dealCulturalOrderOrderReply(ids,culturalOrderOrderStatus,culturalOrderReply,sysUser);
				if (result > 0){
					return Constant.RESULT_STR_SUCCESS;
				} else {
					return Constant.RESULT_STR_FAILURE;
				}
			} else {
				return Constant.RESULT_STR_NOACTIVE;
			}
		} catch (Exception e){
			e.printStackTrace();
			return Constant.RESULT_STR_FAILURE;
		}
	}
	
	@RequestMapping(value="/editCulturalOrderOrder")
	public ModelAndView editCulturalOrderOrder(String culturalOrderOrderId){
		ModelAndView model = new ModelAndView();
		CmsCulturalOrderOrder orderOrder = cmsCulturalOrderOrderService.queryCulturalOrderOrderById(culturalOrderOrderId);
		CmsCulturalOrder order = cmsCulturalOrderService.queryCulturalOrderById(orderOrder.getCulturalOrderId());
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if (order.getCulturalOrderLargeType() == 2){
			model.addObject("orderOrder", orderOrder);
			model.addObject("startDate", sdf.format(order.getCulturalOrderStartDate()));
			model.addObject("endDate",sdf.format(order.getCulturalOrderEndDate()));
			model.addObject("culturalOrderAreaLimit",order.getCulturalOrderAreaLimit());
			model.addObject("culturalOrderLargeType",order.getCulturalOrderLargeType());
			model.setViewName("admin/culturalOrder/editCulturalOrderOrder");
		}
		return model;
	}
	
	@RequestMapping(value="/saveCulturalOrderOrder")
	@ResponseBody
	public String saveCulturalOrderOrder(CmsCulturalOrderOrder orderOrder,String orderDate){
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			orderOrder.setCulturalOrderOrderDate(sdf.parse(orderDate));
			int result = cmsCulturalOrderOrderService.editCmsCulturalOrderOrder(orderOrder);
			if (result > 0){
				return Constant.RESULT_STR_SUCCESS;
			} else {
				return Constant.RESULT_STR_FAILURE;
			}
		} catch (Exception e){
			e.printStackTrace();
			return Constant.RESULT_STR_FAILURE;
		}
		
	}
}
