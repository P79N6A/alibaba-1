package com.sun3d.why.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.bean.special.CcpSpecialEnter;
import com.culturecloud.model.bean.special.CcpSpecialPage;
import com.sun3d.why.dao.dto.CcpSpecialEnterDto;
import com.sun3d.why.dao.dto.CcpSpecialPageDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpSpecialEnterService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;


@RequestMapping("/specialEnter")
@Controller
public class CcpSpecialEnterController {

	 @Autowired
	 private HttpSession session;
	 
	 @Autowired
	 private CcpSpecialEnterService ccpSpecialEnterService;
		
	@Autowired
	private StaticServer staticServer;

	
    @RequestMapping("/index")
    public ModelAndView index( CcpSpecialEnter entity, Pagination page) {
        ModelAndView model = new ModelAndView();
        
        List<CcpSpecialEnterDto> list = ccpSpecialEnterService.queryByCondition(entity, page);
        model.addObject("list", list);
        model.addObject("page", page);
        model.addObject("entity", entity);
        model.setViewName("admin/special/enterIndex");
      
        return model;
    }
    
    @RequestMapping("/searchEnterList")
    @ResponseBody
    public List<CcpSpecialEnterDto> searchEnterList(CcpSpecialEnter entity){
    	
    	List<CcpSpecialEnterDto> list = ccpSpecialEnterService.queryByCondition(entity, null);
    	
    	return list;
    }
    
    @RequestMapping(value = "/preSaveEnter")
    public String preSaveEnter(String enterId,HttpServletRequest request) {
    	
    	CcpSpecialEnter entity=new CcpSpecialEnter();
    	
    	if(StringUtils.isNotBlank(enterId)){
    		
    		entity=ccpSpecialEnterService.findById(enterId);
    	}
    	
    	String aliImgUrl=staticServer.getAliImgUrl();
    	
    	request.setAttribute("aliImgUrl", aliImgUrl);
    	
    	request.setAttribute("entity", entity);
    	
        return "admin/special/enterEntity";
    }

    @RequestMapping("/saveEnter")
    @ResponseBody
    public String saveEnter(CcpSpecialEnter entity) {
    	
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser!=null){
            	int result = ccpSpecialEnterService.saveEnter(entity, sysUser);
            	if(result>0){
            		return Constant.RESULT_STR_SUCCESS;
            	}else{
            		return Constant.RESULT_STR_FAILURE;
            	}
            }else{
            	return "login";
            }
        } catch (Exception e) {
            return Constant.RESULT_STR_FAILURE;
        }
    }
  
}
