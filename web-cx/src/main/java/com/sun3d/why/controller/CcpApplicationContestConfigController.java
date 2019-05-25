package com.sun3d.why.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.SysParamsConfig;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.SysParamsConfigService;

@RequestMapping("/applicationContestConfig")
@Controller
public class CcpApplicationContestConfigController {
	
	@Autowired
	private SysParamsConfigService sysParamsConfigService;
	@Resource
	private StaticServer staticServer;
	@Autowired
	private HttpSession session;
	
	private String businessName ="applicationContest";
	
	@RequestMapping("/index")
    public ModelAndView index() {
        ModelAndView model = new ModelAndView();
        try {
        	
        	List<SysParamsConfig> list=sysParamsConfigService.queryParamsConfigByBusinessId(businessName);
        	
        	Map<String,String>configMap=new HashMap<String,String>();
        	
        	if(list.size()>0){
        	
        		for (SysParamsConfig sysParamsConfig : list) {
					
        			configMap.put(sysParamsConfig.getConfigName(), sysParamsConfig.getConfigValue());
				}
        	}
        	model.addObject("aliImgUrl", staticServer.getAliImgUrl());
            model.addObject("configMap", configMap);
            model.setViewName("admin/applicationContest/configIndex");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return model;
    }

	@RequestMapping("/saveParamConfig")
	@ResponseBody
	public String saveParamConfig(String logo){
		
		int result=0;
		
		if(logo==null)
			logo="";
		
		try {
			SysUser loginUser = (SysUser) session.getAttribute("user");

			if (loginUser == null) {
				return "user";
			}
			
			List<SysParamsConfig> list=sysParamsConfigService.queryParamsConfigByBusinessId(businessName);
			
			if(list.size()>0){
				for (SysParamsConfig sysParamsConfig : list) {
					
					String congfiName=sysParamsConfig.getConfigName();
				
					if("logo".equals(congfiName)){
						SysParamsConfig config=sysParamsConfig;
						
						config.setConfigName("logo");
						config.setConfigValue(logo);
						config.setBusinessId(businessName);
						result=sysParamsConfigService.updateSelective(config);
						
						return "success";
					}
				}
			}
			else{
				
				SysParamsConfig config=new SysParamsConfig();
				
				config.setConfigName("logo");
				config.setConfigValue(logo);
				config.setBusinessId(businessName);
				result=sysParamsConfigService.insert(config);
			}
				
			if (result > 0)
				return "success";
			else
				return "error";
		} catch (Exception ex) {
			ex.printStackTrace();
			return "error";
		}
		
	}
}
