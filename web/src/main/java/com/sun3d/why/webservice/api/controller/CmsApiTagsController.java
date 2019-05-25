/*
@author lijing
@version 1.0 2015年8月4日 下午9:42:01
显示标签列表
*/
package com.sun3d.why.webservice.api.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sun3d.why.webservice.api.service.CmsApiTagsService;

@RequestMapping("/api/tags")
@Controller
public class CmsApiTagsController {
	@Autowired
	private CmsApiTagsService cmsApiTagsService;
	
	// 获取区地区
	@RequestMapping(value = "/area.do", method = RequestMethod.GET)
	@ResponseBody
	public String area(HttpServletRequest request, HttpServletResponse response) {
		
		return null;
	}

	// 获取场馆类型
	@RequestMapping(value = "/venuetype.do", method = RequestMethod.GET)
	@ResponseBody
	public List venueType(HttpServletRequest request, HttpServletResponse response) {
		//VENUE_TYPE
		String dictCode="VENUE_TYPE";
		List list=this.cmsApiTagsService.getChildTagByType(dictCode);
		return list;
	}

	// 获取场馆人群
	@RequestMapping(value = "/venuecrowd.do", method = RequestMethod.GET)
	@ResponseBody
	public List venueCrowd(HttpServletRequest request, HttpServletResponse response) {
		// VENUE_CROWD
		String dictCode="VENUE_CROWD";
		List list=this.cmsApiTagsService.getChildTagByType(dictCode);
		return list;
	}

	// 藏品类别
	@RequestMapping(value = "/antiquecategory.do", method = RequestMethod.GET)
	@ResponseBody
	public List antiqueCategory(HttpServletRequest request, HttpServletResponse response) {
		// ANTIQUE
		String dictCode="ANTIQUE";
		List list=this.cmsApiTagsService.getChildDictByCode(dictCode);
		return list;
	}

	// 所属朝代
	@RequestMapping(value = "/dynasty.do", method = RequestMethod.GET)
	@ResponseBody
	public List dynasty(HttpServletRequest request, HttpServletResponse response) {
		// DYNASTY
		String dictCode="DYNASTY";
		List list=this.cmsApiTagsService.getChildDictByCode(dictCode);
		return list;
	}

	// 活动人群
	@RequestMapping(value = "/activitycrowd.do", method = RequestMethod.GET)
	@ResponseBody
	public List activityCrowd(HttpServletRequest request, HttpServletResponse response) {
		// ACTIVITY_CROWD
		String dictCode="ACTIVITY_CROWD";
		List list=this.cmsApiTagsService.getChildTagByType(dictCode);
		return list;
	}

	// 活动心情
	@RequestMapping(value = "/activitymood.do", method = RequestMethod.GET)
	@ResponseBody
	public List activityMood(HttpServletRequest request, HttpServletResponse response) {
		// ACTIVITY_MOOD
		String dictCode="ACTIVITY_MOOD";
		List list=this.cmsApiTagsService.getChildTagByType(dictCode);
		return list;
	}

	// 活动主题
	@RequestMapping(value = "/activitytheme.do", method = RequestMethod.GET)
	@ResponseBody
	public List activityTheme(HttpServletRequest request, HttpServletResponse response) {
		// ACTIVITY_THEME
		String dictCode="ACTIVITY_THEME";
		List list=this.cmsApiTagsService.getChildTagByType(dictCode);
		return list;
	}

	// 活动位置
	@RequestMapping(value = "/activitylocation.do", method = RequestMethod.GET)
	@ResponseBody
	public List activityLocation(HttpServletRequest request, HttpServletResponse response) {
		//根据区域编号查询数据
		String dictCode=request.getParameter("area");
		List list=this.cmsApiTagsService.getChildDictByCode(dictCode);
		return list;
	}

	//活动类型
	@RequestMapping(value = "/activitytype.do", method = RequestMethod.GET)
	@ResponseBody
	public List activityType(HttpServletRequest request, HttpServletResponse response) {
		//ACTIVITY_TYPE
		String dictCode="ACTIVITY_TYPE";
		List list=this.cmsApiTagsService.getChildTagByType(dictCode);
		return list;
	}

}
