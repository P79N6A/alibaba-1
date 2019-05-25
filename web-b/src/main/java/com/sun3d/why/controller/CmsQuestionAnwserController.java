package com.sun3d.why.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.CmsQuestionAnwser;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsQuestionAnwserService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

@RequestMapping(value = "/questionAnwser")
@Controller
public class CmsQuestionAnwserController {

    private Logger logger = Logger.getLogger(CmsQuestionAnwserController.class);
    
    @Autowired
    private HttpSession session;
    
    @Autowired
    private CmsQuestionAnwserService cmsQuestionAnwserService;
    
    /**
     * 互动管理列表页
     * @param cmsQuestionAnwser
     * @param searchKey
     * @param page
     * @return
     */
    @RequestMapping("/questionAnwserIndex")
    public ModelAndView questionAnwserIndex(Pagination page,CmsQuestionAnwser cmsQuestionAnwser,String searchKey) {
        ModelAndView model = new ModelAndView();
        List<CmsQuestionAnwser> list = null;
        try {
        	if(session.getAttribute("user") != null){
        		if(StringUtils.isNotBlank(searchKey)){
        			cmsQuestionAnwser.setAnwserQuestion(searchKey);
                }
                list = cmsQuestionAnwserService.queryQuestionAnwserByCondition(cmsQuestionAnwser,page);
        	}
            model.addObject("page", page);
            model.addObject("list", list);
            model.addObject("searchKey", searchKey);
            model.setViewName("admin/anwser/questionAnwserIndex");
        } catch (Exception e) {
            logger.error("questionAnwserIndex error {}", e);
        }
        return model;
    }
    
    /**
     * 跳转至互动添加页面
     * @param request
     * @return
     */
    @RequestMapping(value = "/preAddQuestionAnwser")
    public String preAddQuestionAnwser(HttpServletRequest request) {
        return "admin/anwser/addQuestionAnwser";
    }
    
    /**
     * 跳转至互动编辑页面
     * @param request
     * @param anwserId
     * @return
     */
    @RequestMapping(value = "/preEditQuestionAnwser")
    public String preEditQuestionAnwser(HttpServletRequest request,String anwserId) {
    	if (StringUtils.isNotBlank(anwserId)) {
    		CmsQuestionAnwser cmsQuestionAnwser = cmsQuestionAnwserService.queryQuestionAnwserById(anwserId);
            request.setAttribute("cmsQuestionAnwser", cmsQuestionAnwser);
        }
        return "admin/anwser/editQuestionAnwser";
    }
    
    /**
     * 删除互动
     * @param anwserId     
     * return 是否删除成功 (成功：success；失败：false)
     */
    @RequestMapping(value = "/deleteQuestionAnwser")
    @ResponseBody
    public String deleteQuestionAnwser(String anwserId) throws Exception {
    	String result = null;
    	try {
    		result = cmsQuestionAnwserService.deleteQuestionAnwser(anwserId);
    	} catch (Exception e) {
            logger.error("deleteQuestionAnwser error {}", e);
        }
        return result;
    }
    
    /**
     * 添加互动
     * @param cmsQuestionAnwser     
     * return 是否添加成功 (成功：success；失败：false)
     */
    @RequestMapping(value = "/addQuestionAnwser")
    @ResponseBody
    public String addQuestionAnwser(CmsQuestionAnwser cmsQuestionAnwser) throws Exception {
    	String result = null;
    	try {
    		SysUser sysUser = (SysUser) session.getAttribute("user");
    		result = cmsQuestionAnwserService.addQuestionAnwser(cmsQuestionAnwser,sysUser);
    	} catch (Exception e) {
            logger.error("addQuestionAnwser error {}", e);
        }
        return result;
    }
    
    /**
     * 编辑互动
     * @param cmsQuestionAnwser     
     * return 是否保存成功 (成功：success；失败：false)
     */
    @RequestMapping(value = "/editQuestionAnwser")
    @ResponseBody
    public String editQuestionAnwser(CmsQuestionAnwser cmsQuestionAnwser) throws Exception {
    	String result = null;
    	try {
    		SysUser sysUser = (SysUser) session.getAttribute("user");
    		result = cmsQuestionAnwserService.editQuestionAnwser(cmsQuestionAnwser,sysUser);
    	} catch (Exception e) {
            logger.error("editQuestionAnwser error {}", e);
        }
        return result;
    }
}
