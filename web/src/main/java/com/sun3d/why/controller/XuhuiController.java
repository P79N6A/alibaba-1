package com.sun3d.why.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sun3d.why.service.CacheService;
import com.sun3d.why.util.BindWS;

/**
 * 徐汇366
 * @author demonkb
 */
@RequestMapping("/xuhui")
@Controller
public class XuhuiController {

    @Autowired
    private CacheService cacheService;

    /**
     * 跳转PC获奖页
     * @param request
     * @return
     */
    @RequestMapping(value = "/webAward")
    public String webAward(HttpServletRequest request) {
        return "366/webAward";
    }
    
    /**
     * 跳转移动获奖页
     * @param request
     * @return
     */
    @RequestMapping(value = "/wapAward")
    public String wapAward(HttpServletRequest request) {
    	//微信权限验证配置
    	String url = BindWS.getUrl(request);
    	Map<String, String> sign = BindWS.sign(url, cacheService);
    	request.setAttribute("sign", sign);
    	return "366/wapAward";
    }
}
