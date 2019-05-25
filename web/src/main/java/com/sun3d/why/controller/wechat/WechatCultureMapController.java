package com.sun3d.why.controller.wechat;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.service.CacheService;
import com.sun3d.why.util.BindWS;

@RequestMapping("/wechatClutureMap")
@Controller
public class WechatCultureMapController {
	
	@Autowired
    private CacheService cacheService;

	/**
	 * 文化地图首页
	 * @param request
	 * @return
	 */
	@RequestMapping("/cultureMapIndex")
	public ModelAndView cultureMapIndex(HttpServletRequest request){
		ModelAndView model=new ModelAndView();
		 //微信权限验证配置
  	    String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);
        model.setViewName("wechat/cultureMap/cultureMapIndex");
        return model;
	}
	
	/**
	 * 场馆相关活动列表
	 * @return
	 */
	@RequestMapping("relativeActivityList")
	public ModelAndView relativeActivityList(HttpServletRequest request,String venueId){
		ModelAndView model=new ModelAndView();
		//微信权限验证配置
  	    String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);
		model.addObject("venueId", venueId);
		model.setViewName("wechat/cultureMap/relativeAct");
		return model;
	}
	
	/**
	 * 场馆相关活动列表
	 * @return
	 */
	@RequestMapping("relativeRoomList")
	public ModelAndView relativeRoomList(HttpServletRequest request,String venueId){
		ModelAndView model=new ModelAndView();
		//微信权限验证配置
  	    String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);
		model.addObject("venueId", venueId);
		model.setViewName("wechat/cultureMap/relativeRoom");
		return model;
	}
}
