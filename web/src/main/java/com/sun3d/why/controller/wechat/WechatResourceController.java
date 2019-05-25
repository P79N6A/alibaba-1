package com.sun3d.why.controller.wechat;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.service.CacheService;
import com.sun3d.why.util.BindWS;

@RequestMapping("/wechatResource")
@Controller
public class WechatResourceController {
	
	@Autowired
    private CacheService cacheService;
	
	/**
	 * 资源库首页
	 * @param request
	 * @return
	 */
	@RequestMapping("/wechatResourceIndex")
	public ModelAndView wechatResourceIndex(HttpServletRequest request){
		ModelAndView model=new ModelAndView();
		//微信权限验证配置
   	    String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);
		model.setViewName("wechat/resource/resourceIndex");
		return model;
	}

}
