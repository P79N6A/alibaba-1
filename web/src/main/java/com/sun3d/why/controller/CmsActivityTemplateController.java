package com.sun3d.why.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsActivityTemplate;
import com.sun3d.why.model.CmsFunction;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsActivityService;
import com.sun3d.why.service.CmsActivityTemplateService;
import com.sun3d.why.service.CmsFunctionService;
import com.sun3d.why.util.Pagination;

@RequestMapping("/activityTemplate")
@Controller
public class CmsActivityTemplateController {
    private Logger logger = LoggerFactory.getLogger(CmsActivityController.class);

    @Autowired
    private CmsActivityTemplateService cmsActivityTemplateService;
    @Autowired
    private CmsFunctionService cmsFunctionService;
    @Autowired
    private HttpSession session;
    @Autowired
    private CmsActivityService activityService;
    
    /**
	 * 活动模板列表
	 * @param activityTemplate
	 * @param page
	 * @return
	 */
    @RequestMapping("/activityTemplateIndex")
      public ModelAndView activityTemplateIndex(CmsActivityTemplate activityTemplate, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<CmsActivityTemplate> activityTemplateList = cmsActivityTemplateService.queryCmsActivityTemplateByCondition(activityTemplate, page, sysUser);

            model.addObject("list", activityTemplateList);
            model.addObject("page", page);
            model.addObject("activityTemplate", activityTemplate);
            model.setViewName("admin/activityTemplate/activityTemplateIndex");
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("activityTemplateIndex error {}", e);
        }
        return model;
    }
    
    /**
     * 跳转到模板添加页面
     * @return
     */
    @RequestMapping(value="/preActivityTemplateAdd" ,method= RequestMethod.GET)
    public String preActivityTemplateAdd(HttpServletRequest request){
    	List<CmsFunction> functionList = cmsFunctionService.queryCmsFunctionByCondition(null, null, null);
    	request.setAttribute("functionList", functionList);
        return "admin/activityTemplate/activityTemplateAdd";
    }

    /**
     * 添加活动模板
     * @param cmsActivityTemplate
     * @return
     */
    @RequestMapping("/activityTemplateAdd")
    @ResponseBody
    public String activityTemplateAdd(CmsActivityTemplate cmsActivityTemplate) {
    	String result = null;
    	try {
    		SysUser sysUser = (SysUser) session.getAttribute("user");
    		result = cmsActivityTemplateService.addActivityTemplate(cmsActivityTemplate,sysUser);
    	} catch (Exception e) {
            logger.error("addFunction error {}", e);
        }
        return result;
    }
    
    /**
     * 跳转到模板添加页面
     * @return
     */
    @RequestMapping(value="/preActivityTemplateEdit" ,method= RequestMethod.GET)
    public String preActivityTemplateEdit(HttpServletRequest request, String templId){
    	List<CmsFunction> functionList = cmsFunctionService.queryCmsFunctionByCondition(null, null, null);
    	CmsActivityTemplate cmsActivityTemplate = cmsActivityTemplateService.selectByPrimaryKey(templId);
    	request.setAttribute("functionList", functionList);
    	request.setAttribute("cmsActivityTemplate", cmsActivityTemplate);
        return "admin/activityTemplate/activityTemplateEdit";
    }

    /**
     * 编辑活动模板
     * @param cmsActivityTemplate
     * @return
     */
    @RequestMapping("/activityTemplateEdit")
    @ResponseBody
    public String activityTemplateEdit(CmsActivityTemplate cmsActivityTemplate) {
    	String result = null;
    	try {
    		SysUser sysUser = (SysUser) session.getAttribute("user");
    		result = cmsActivityTemplateService.editActivityTemplate(cmsActivityTemplate,sysUser);
    	} catch (Exception e) {
            logger.error("activityTemplateEdit error {}", e);
        }
        return result;
    }
    
    /**
     * 删除活动模板
     * @param templId     
     * return 是否删除成功 (成功：success；失败：false)
     */
    @RequestMapping(value = "/deleteActivityTemplate")
    @ResponseBody
    public String deleteActivityTemplate(String templId){
    	String result = null;
    	try {
    		if (StringUtils.isNotBlank(templId)) {
    			result = cmsActivityTemplateService.deleteActivityTemplate(templId);
    		}
    	} catch (Exception e) {
            logger.error("deleteActivityTemplate error {}", e);
        }
        return result;
    }

    /**
     * 添加活动时加载模板list
     * @param
     * @return List<CmsActivityTemplate>
     * @authours hucheng
     * @date 2016/2/18
     * @content add
     */
    @RequestMapping("/queryTemplateList")
    @ResponseBody
    public List queryTemplateList() {
        List<CmsActivityTemplate> list = new ArrayList<>();
        try {
            list = cmsActivityTemplateService.queryCmsActivityTemplateByCondition(null,null,null);
        } catch (Exception e) {
            logger.error("queryTemplateList error {}", e);
        }
        return list;
    }
    
    /**
     * 判断该模板是否有活动已使用
     * @param templId
     * @return
     */
    @RequestMapping("/hasActivity")
    @ResponseBody
    public String hasActivity(String templId,Pagination page) {
    	String result = "0";
    	try {
    		CmsActivity activity = new CmsActivity();
    		activity.setTemplId(templId);
    		List<CmsActivity> list = activityService.queryCmsActivityByCondition(activity, page, null);
    		if(list.size()>0){
    			result = "1";
    		}
    	} catch (Exception e) {
            logger.error("hasActivity error {}", e);
        }
        return result;
    }

    @RequestMapping(value = "/checkRepeat")
    @ResponseBody
    public String checkRepeat(String templateName){
        String result = "false";
        try {
            if (StringUtils.isNotBlank(templateName)) {
                boolean checkResult = cmsActivityTemplateService.checkRepeatByName(templateName);
                //如果true则代表可添加、false代表不可添加
                if(checkResult){
                    result = "success";
                }
            }
        } catch (Exception e) {
            logger.error("checkRepeat error {}", e);
        }
        return result;
    }
}
