package com.sun3d.why.controller;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.bean.association.CcpAssociationApply;
import com.culturecloud.model.bean.special.CcpSpecialProject;
import com.sun3d.why.model.CcpAssociation;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpSpecialProjectService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@RequestMapping("/specialProject")
@Controller
public class CcpSpecialProjectController {
	
	 @Autowired
	 private HttpSession session;
	 
	 @Autowired
	 private CcpSpecialProjectService ccpSpecialProjectService;
	
	 /**
     * 项目列表
     * @param ccpAssociation
     * @param page
     * @return
     */
    @RequestMapping("/index")
    public ModelAndView index(CcpSpecialProject entity, Pagination page) {
        ModelAndView model = new ModelAndView();
        
        List<CcpSpecialProject> list = ccpSpecialProjectService.queryByCondition(entity, page);
        model.addObject("list", list);
        model.addObject("page", page);
        model.addObject("entity", entity);
        model.setViewName("admin/special/projectIndex");
      
        return model;
    }
    
    @RequestMapping("/searchProjectList")
    @ResponseBody
    public List<CcpSpecialProject> searchProjectList(CcpSpecialProject entity){
    	
    	List<CcpSpecialProject> list = ccpSpecialProjectService.queryByCondition(entity, null);
    	
    	return list;
    }
    
    @RequestMapping(value = "/preSaveProject")
    public String preSaveProject(String projectId,HttpServletRequest request) {
    	
    	CcpSpecialProject entity=new CcpSpecialProject();
    	
    	if(StringUtils.isNotBlank(projectId)){
    		
    		entity=ccpSpecialProjectService.findById(projectId);
    	}
    	
    	request.setAttribute("entity", entity);
    	
        return "admin/special/projectEntity";
    }

    @RequestMapping("/saveProject")
    @ResponseBody
    public String saveProject(CcpSpecialProject entity) {
    	
        try {
            	
            	int result = ccpSpecialProjectService.saveProject(entity);
            	if(result>0){
            		return Constant.RESULT_STR_SUCCESS;
            	}else{
            		return Constant.RESULT_STR_FAILURE;
            	}
          
        } catch (Exception e) {
            return Constant.RESULT_STR_FAILURE;
        }
    }
  
}
