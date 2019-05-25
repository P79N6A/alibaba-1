package com.sun3d.why.region.cd.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.region.cd.model.CdTrainingSign;
import com.sun3d.why.region.cd.service.CdTrainingSignService;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.util.BindWS;

/**
 * 2017年常德市文化馆-公益培训招生在线报名
 * @author demonkb
 */
@RequestMapping("/trainingSign")
@Controller
public class CdTrainingSignController {

    @Autowired
    private HttpSession session;
    @Autowired
    private CacheService cacheService;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private CdTrainingSignService cdTrainingSignService;

    private Logger logger = LoggerFactory.getLogger(CdTrainingSignController.class);

    /**
     * 跳转到首页
     * @return
     * @throws ParseException 
     */
    @RequestMapping(value = "/index")
    public String index(HttpServletRequest request) throws ParseException {
    	//微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date startTime = df.parse("2017-02-28 10:00:00");
		Date endTime = df.parse("2017-03-01 17:00:00");
		if(startTime.after(new Date())){
			//return "region/cd/trainingSign/comingSoon";
			request.setAttribute("noControl", 2);
		}
		if(endTime.before(new Date())) {
			request.setAttribute("noControl", 1);
        }
        return "region/cd/trainingSign/index";
    }
    
    /**
     * 预判断报名是否已满
     * @param request
     * @return
     */
    @RequestMapping(value = "/checkSignLimit")
    @ResponseBody
    public String checkSignLimit(CdTrainingSign vo) {
         return cdTrainingSignService.checkSignLimit(vo);
    }
    
    /**
     * 报名
     * @param request
     * @return
     * @throws ParseException 
     */
    @RequestMapping(value = "/addSign")
    @ResponseBody
    public String addSign(CdTrainingSign vo) throws ParseException {
    	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date startTime = df.parse("2017-02-28 10:00:00");
		Date endTime = df.parse("2017-03-01 17:00:00");
		if(startTime.after(new Date()) || endTime.before(new Date())){
			return "500";
		}
        return cdTrainingSignService.addSign(vo);
    }
}