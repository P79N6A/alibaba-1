package com.sun3d.why.controller;

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

import com.sun3d.why.model.CmsFunction;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsFunctionService;
import com.sun3d.why.util.Pagination;

@RequestMapping("/function")
@Controller
public class CmsFunctionController {
    private Logger logger = LoggerFactory.getLogger(CmsFunctionController.class);

    @Autowired
    private CmsFunctionService cmsFunctionService;
    @Autowired
    private HttpSession session;
    
    /**
	 * 模板功能列表
	 * @param cmsFunction
	 * @param page
	 * @return
	 */
    @RequestMapping("/functionIndex")
    public ModelAndView functionIndex(CmsFunction cmsFunction, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<CmsFunction> functionList = cmsFunctionService.queryCmsFunctionByCondition(cmsFunction, page, sysUser);

            model.addObject("list", functionList);
            model.addObject("page", page);
            model.addObject("activityTemplate", cmsFunction);
            model.setViewName("admin/activityTemplate/functionIndex");
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("functionIndex error {}", e);
        }
        return model;
    }
    
    /**
     * 跳转到功能添加页面
     * @return
     */
    @RequestMapping(value="/preFuntionAdd" ,method= RequestMethod.GET)
    public String preFuntionAdd(){
        return "admin/activityTemplate/functionAdd";
    }
    
    /**
     * 跳转到功能编辑页面
     * @return
     */
    @RequestMapping(value="/preFuntionEdit" ,method= RequestMethod.GET)
    public String preFuntionEdit(HttpServletRequest request, String functionId){
    	CmsFunction cmsFunction = cmsFunctionService.selectByPrimaryKey(functionId);
    	request.setAttribute("cmsFunction", cmsFunction);
        return "admin/activityTemplate/functionEdit";
    }

    /**
     * 添加模板功能
     * @param cmsFunction     
     * return 是否添加成功 (成功：success；失败：false)
     */
    @RequestMapping(value = "/addFunction")
    @ResponseBody
    public String addFunction(CmsFunction cmsFunction) {
    	String result = null;
    	try {
    		SysUser sysUser = (SysUser) session.getAttribute("user");
    		result = cmsFunctionService.addFunction(cmsFunction,sysUser);
    	} catch (Exception e) {
            logger.error("addFunction error {}", e);
        }
        return result;
    }
    
    /**
     * 编辑模板功能
     * @param cmsFunction     
     * return 是否添加成功 (成功：success；失败：false)
     */
    @RequestMapping(value = "/editFunction")
    @ResponseBody
    public String editFunction(CmsFunction cmsFunction) {
    	String result = null;
    	try {
    		SysUser sysUser = (SysUser) session.getAttribute("user");
    		result = cmsFunctionService.editFunction(cmsFunction,sysUser);
    	} catch (Exception e) {
            logger.error("editFunction error {}", e);
        }
        return result;
    }
    
    /**
     * 删除模板功能
     * @param functionId     
     * return 是否删除成功 (成功：success；失败：false)
     */
    @RequestMapping(value = "/deleteFunction")
    @ResponseBody
    public String deleteFunction(String functionId){
    	String result = null;
    	try {
    		if (StringUtils.isNotBlank(functionId)) {
    			result = cmsFunctionService.deleteFunction(functionId);
    		}
    	} catch (Exception e) {
            logger.error("deleteFunction error {}", e);
        }
        return result;
    }


    @RequestMapping(value = "/checkRepeat")
    @ResponseBody
    public String checkRepeat(String functionName){
        String result = "false";
        try {
            if (StringUtils.isNotBlank(functionName)) {
                boolean checkResult = cmsFunctionService.checkRepeatByName(functionName);
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
