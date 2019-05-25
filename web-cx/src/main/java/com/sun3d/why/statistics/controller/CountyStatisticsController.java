package com.sun3d.why.statistics.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sun3d.why.exception.UserReadableException;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.countyStatistics.CountyStatisticsDetail;
import com.sun3d.why.service.CmsDeptService;
import com.sun3d.why.statistics.service.CountyStatisticsService;
import com.sun3d.why.util.Constant;

/***
 * 区县 活动，活动室 数据统计
 * 
 * @author zengjin
 * 
 */
@Controller
@RequestMapping("countyStatistics")
public class CountyStatisticsController {

	@Autowired
	CountyStatisticsService countyStatisticsService;
	@Autowired
	private HttpSession session;

	@Autowired
	CmsDeptService deptService;

	@ExceptionHandler(UserReadableException.class)
	@ResponseBody
	public Object handleUserReadableException(HttpServletRequest request, UserReadableException e) {
		HashMap<String, Object> result = new HashMap<String, Object>();
		result.put("status", "error");
		result.put("msg", e.getMessage());
		return result;
	}

	@InitBinder
	public void initBinder(WebDataBinder binder) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		dateFormat.setLenient(false);
		binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
	}

	@RequestMapping(value = "/countyStatisticsPage", method = RequestMethod.GET)
	public String CountyStatistics() {
		SysUser sysUser = (SysUser) session.getAttribute("user");
		if (sysUser == null) {
			return "redirect:/admin.do";
		}
		if (countyStatisticsService.isUserRoleExist(Constant.SUPER_USER, sysUser.getUserId())) {
			// 管理员界面
			return "admin/countyStatistics/countyStatisticsAdminPage";
		}
		return "admin/countyStatistics/countyStatisticsPage";
	}

	/***
	 * 活动室数据统计的入口
	 * 
	 * @return
	 */
	@RequestMapping(value = "/countyRoomStatisticsPage", method = RequestMethod.GET)
	public String CountyRoomStatistics() {
		SysUser sysUser = (SysUser) session.getAttribute("user");
		if (sysUser == null) {
			return "redirect:/admin.do";
		}
		if (countyStatisticsService.isUserRoleExist(Constant.SUPER_USER, sysUser.getUserId())) {
			// 管理员界面
			return "admin/countyStatistics/countyRoomStatisticsAdminPage";
		}
		return "admin/countyStatistics/countyRoomStatisticsPage";
	}

	@RequestMapping(value = "/countyStatisticsDetail", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> CountyStatisticsDetail(Date startTime, Date endTime) {
		Map<String, Object> result = new HashMap<String, Object>();
		SysUser sysUser = (SysUser) session.getAttribute("user");
		if (sysUser == null) {
			throw new UserReadableException("登录超时，请重新登录");
		}
		// 查看用户是否拥有 区级管理员权限

		// 要查询的发布角色名称
		List<String> roleNames = new ArrayList<String>();
		String roleName = Constant.COUNTY_STATISTICS_ROLE_NAME;
		// 用户所在区县
		String userCounty = sysUser.getUserDeptId();
		// 是否是区级角色
		if (!countyStatisticsService.isUserRoleExist(Constant.VIEW_COUNTY_STATISTICS_ROLE_NAME, sysUser.getUserId())) {
			throw new UserReadableException("没有权限");
		}
		if (StringUtils.isEmpty(roleName)) {
			throw new UserReadableException("参数错误");
		}
		if (StringUtils.isEmpty(userCounty)) {
			throw new UserReadableException("参数错误");
		}
		roleNames.add(Constant.COUNTY_STATISTICS_ROLE_NAME);
		roleNames.add(Constant.VIEW_COUNTY_STATISTICS_ROLE_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("roleNames", roleNames);
		params.put("userCounty", userCounty);
		// 开始结束日期为 空 则 选择当天日期
		if (startTime != null) {
			params.put("startTime", startTime);
		}
		if (endTime != null) {
			params.put("endTime", endTime);
		}
		List<CountyStatisticsDetail> resultList = countyStatisticsService.getCountyActivityStatistics(params);
		result.put("data", resultList);
		result.put("status", "ok");
		return result;
	}

	@RequestMapping(value = "/countyStatisticsDetailByAdmin", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> CountyStatisticsDetailByAdmin(Date startTime, Date endTime, String carea) {
		Map<String, Object> result = new HashMap<String, Object>();
		SysUser sysUser = (SysUser) session.getAttribute("user");
		if (sysUser == null) {
			throw new UserReadableException("登录超时，请重新登录");
		}
		// 是否是超级管理员
		if (!countyStatisticsService.isUserRoleExist(Constant.SUPER_USER, sysUser.getUserId())) {
			throw new UserReadableException("没有权限");
		}
		// 非空判断
		if (StringUtils.isEmpty(carea)) {
			throw new UserReadableException("请选择区县");
		}
		try {
			carea = URLDecoder.decode(carea, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}

		if (carea.equals("0")) {
			throw new UserReadableException("请选择区县");
		}
		// 要查询的部门Id
		String userCounty = deptService.querySysDeptIdByDeptName(carea);
		// 非空判断
		if (StringUtils.isEmpty(userCounty)) {
			throw new UserReadableException("该区县不存在，或已被删除");
		}
		// 要查询的发布角色名称
		List<String> roleNames = new ArrayList<String>();

		// 场馆角色，区级角色所发布的活动，活动室
		roleNames.add(Constant.COUNTY_STATISTICS_ROLE_NAME);
		roleNames.add(Constant.VIEW_COUNTY_STATISTICS_ROLE_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("roleNames", roleNames);
		params.put("userCounty", userCounty);
		// 开始结束日期为 空 则 选择当天日期
		if (startTime != null) {
			params.put("startTime", startTime);
		}
		if (endTime != null) {
			params.put("endTime", endTime);
		}
		List<CountyStatisticsDetail> resultList = countyStatisticsService.getCountyActivityStatistics(params);
		result.put("data", resultList);
		result.put("status", "ok");
		return result;
	}
	/***
	 * 活动室数据统计
	 * @param startTime
	 * @param endTime
	 * @return
	 */
	@RequestMapping(value = "/countyRoomStatisticsDetail", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> CountyStatisticsDetail() {
		Map<String, Object> result = new HashMap<String, Object>();
		SysUser sysUser = (SysUser) session.getAttribute("user");
		if (sysUser == null) {
			throw new UserReadableException("登录超时，请重新登录");
		}
		// 查看用户是否拥有 区级管理员权限

		// 要查询的发布角色名称
		List<String> roleNames = new ArrayList<String>();
		String roleName = Constant.COUNTY_STATISTICS_ROLE_NAME;
		// 用户所在区县
		String userCounty = sysUser.getUserDeptId();
		// 是否是区级角色
		if (!countyStatisticsService.isUserRoleExist(Constant.VIEW_COUNTY_STATISTICS_ROLE_NAME, sysUser.getUserId())) {
			throw new UserReadableException("没有权限");
		}
		if (StringUtils.isEmpty(roleName)) {
			throw new UserReadableException("参数错误");
		}
		if (StringUtils.isEmpty(userCounty)) {
			throw new UserReadableException("参数错误");
		}
		roleNames.add(Constant.COUNTY_STATISTICS_ROLE_NAME);
		roleNames.add(Constant.VIEW_COUNTY_STATISTICS_ROLE_NAME);
		Map<String, Object> params = new HashMap<String, Object>();
 		params.put("userCounty", userCounty);
		List<CountyStatisticsDetail> resultList = countyStatisticsService.getCountyRoomStatistics(params);
		result.put("data", resultList);
		result.put("status", "ok");
		return result;
	}
	
	/****
	 * 
	 * @param startTime
	 * @param endTime
	 * @param carea
	 * @return
	 */
	@RequestMapping(value = "/countyRoomStatisticsDetailByAdmin", method = RequestMethod.GET)
	@ResponseBody
	public Map<String, Object> CountyRoomStatisticsDetailByAdmin(String carea) {
		Map<String, Object> result = new HashMap<String, Object>();
		SysUser sysUser = (SysUser) session.getAttribute("user");
		if (sysUser == null) {
			throw new UserReadableException("登录超时，请重新登录");
		}
		// 是否是超级管理员
		if (!countyStatisticsService.isUserRoleExist(Constant.SUPER_USER, sysUser.getUserId())) {
			throw new UserReadableException("没有权限");
		}
		// 非空判断
		if (StringUtils.isEmpty(carea)) {
			throw new UserReadableException("请选择区县");
		}
		try {
			carea = URLDecoder.decode(carea, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}

		if (carea.equals("0")) {
			throw new UserReadableException("请选择区县");
		}
		// 要查询的部门Id
		String userCounty = deptService.querySysDeptIdByDeptName(carea);
		// 非空判断
		if (StringUtils.isEmpty(userCounty)) {
			throw new UserReadableException("该区县不存在，或已被删除");
		}
		// 要查询的发布角色名称
		List<String> roleNames = new ArrayList<String>();

		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("userCounty", userCounty);
		// 开始结束日期为 空 则 选择当天日期
		
		List<CountyStatisticsDetail> resultList = countyStatisticsService.getCountyRoomStatistics(params);
		result.put("data", resultList);
		result.put("status", "ok");
		return result;
	}
	
}
