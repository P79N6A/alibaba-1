package com.sun3d.why.controller.wechat;

import com.sun3d.why.model.CmsAdvert;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.webservice.service.AdvertService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * Created by hucheng on 2016/3/11.
 */
@RequestMapping(value="wechatAdvert")
@Controller
public class WechatAdvertController {

    private Logger logger = LoggerFactory.getLogger(WechatAdvertController.class);

    @Autowired
    private AdvertService  AdvertService;



    /**
     * 活动首页
     * @return
     */
    @RequestMapping("/advertSpread" )
    public String advertSpread(HttpServletRequest request,String advertId){
        CmsAdvert cmsAdvert = AdvertService.queryWcCmsAdvertById(advertId);
        request.setAttribute("cmsAdvert",cmsAdvert);
        return "wechat/advert/advertSpread";
    }



}
