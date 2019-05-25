package com.sun3d.why.controller.front;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@RequestMapping("/cultureMap")
@Controller
public class FrontCultureMapController {
	
	/**
	 * 文化地图首页
	 * @return
	 */
	@RequestMapping("/cultureMapList")
	public ModelAndView cultureMapList(){
		ModelAndView model=new ModelAndView();
		model.setViewName("index/cultureMap/cultureMap");
		return model;
	}
	
	/**
	 * 场馆相关活动列表
	 * @return
	 */
	@RequestMapping("relativeActivityList")
	public ModelAndView relativeActivityList(String venueId,String venueName){
		ModelAndView model=new ModelAndView();
		model.addObject("venueId", venueId);
		model.addObject("venueName", venueName);
		model.setViewName("index/cultureMap/relativeAct");
		return model;
	}
	
	/**
	 * 场馆相关活动室
	 * @param venueId
	 * @return
	 */
    @RequestMapping("/relativeRoomList")
	public ModelAndView relativeRoomList(String venueId,String venueName){
		ModelAndView model=new ModelAndView();
		model.addObject("venueId", venueId);
		model.addObject("venueName", venueName);
		model.setViewName("index/cultureMap/relativeRoom");
		return model;
	}

}
