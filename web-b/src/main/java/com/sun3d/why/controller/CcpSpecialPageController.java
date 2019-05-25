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

import com.culturecloud.model.bean.special.CcpSpecialPage;
import com.culturecloud.model.bean.special.CcpSpecialPageActivity;
import com.culturecloud.model.bean.special.CcpSpecialProject;
import com.sun3d.why.dao.dto.CcpSpecialPageDto;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.service.CcpSpecialPageService;
import com.sun3d.why.service.CmsActivityService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

@RequestMapping("/specialPage")
@Controller
public class CcpSpecialPageController {
	
	 @Autowired
	 private HttpSession session;
	 
	 @Autowired
	 private CcpSpecialPageService ccpSpecialPageService;
	 
	 @Autowired
	 private CmsActivityService activityService;
	
	/**
     * 专属页列表
     * @param CcpSpecialPage
     * @param page
     * @return
     */
    @RequestMapping("/index")
    public ModelAndView index(CcpSpecialPage entity, Pagination page) {
        ModelAndView model = new ModelAndView();
        List<CcpSpecialPageDto> list = ccpSpecialPageService.queryByCondition(entity, page);
        model.addObject("list", list);
        model.addObject("page", page);
        model.addObject("entity", entity);
        model.setViewName("admin/special/pageIndex");
        return model;
    }
    
    /**
     * 跳转至添加、修改专属页
     * @return
     */
    @RequestMapping(value = "/preAddSpecialPage")
    public String preAddHeritage(HttpServletRequest request,String pageId) {
    	CcpSpecialPage entity=new CcpSpecialPage();
    	if(StringUtils.isNotBlank(pageId)){
    		entity=ccpSpecialPageService.findById(pageId);
    	}
    	request.setAttribute("entity", entity);
        return "admin/special/pageEntity";
    }
    
    /**
     * 添加、修改、删除专属页
     * @return
     */
    @RequestMapping("/saveOrUpdatePage")
    @ResponseBody
    public String saveOrUpdatePage(CcpSpecialPage entity) {
        try {
        	int result = ccpSpecialPageService.saveOrUpdatePage(entity);
        	if(result>0){
        		return Constant.RESULT_STR_SUCCESS;
        	}else{
        		return Constant.RESULT_STR_FAILURE;
        	}
        } catch (Exception e) {
            return Constant.RESULT_STR_FAILURE;
        }
    }
    
    /**
     * 选择活动列表
     * @param activityName
     * @param pageId
     * @param tagSubName
     * @param selectType	(1：还未选活动；2：已选活动)
     * @param selectId 已选活动ID
     * @param page
     * @return
     */
    @RequestMapping("/preSelectActivityList")
    public ModelAndView preSelectActivityList(String activityName,String pageId,String tagSubName,String selectType,String selectId, Pagination page) {
        ModelAndView model = new ModelAndView();
        List<CmsActivity> list = activityService.queryActivityFromSpecialPage(activityName,pageId,tagSubName, selectType, page);
        model.addObject("list", list);
        model.addObject("page", page);
        model.addObject("activityName", activityName);
        model.addObject("tagSubName", tagSubName);
        model.addObject("pageId", pageId);
        model.addObject("selectType", selectType);
        model.addObject("selectId", selectId);
        model.setViewName("admin/special/pageSelectActivityIndex");
        return model;
    }
    
    @RequestMapping("/searchPageList")
    @ResponseBody
    public List<CcpSpecialPageDto> searchProjectList(CcpSpecialPage entity){
    	
    	List<CcpSpecialPageDto> list = ccpSpecialPageService.queryByCondition(entity, null);
    	
    	return list;
    }
    
    /**
     * 添加活动关联
     * @return
     */
    @RequestMapping("/savePageActivty")
    @ResponseBody
    public String savePageActivty(CcpSpecialPageActivity entity,String activityIds) {
        try {
        	int result = ccpSpecialPageService.savePageActivity(entity, activityIds);
        	if(result>0){
        		return Constant.RESULT_STR_SUCCESS;
        	}else{
        		return Constant.RESULT_STR_FAILURE;
        	}
        } catch (Exception e) {
            return Constant.RESULT_STR_FAILURE;
        }
    }
    
    /**
     * 删除活动关联
     * @return
     */
    @RequestMapping("/deletePageActivty")
    @ResponseBody
    public String deletePageActivty(CcpSpecialPageActivity entity) {
        try {
        	int result = ccpSpecialPageService.deletePageActivity(entity);
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
