package com.sun3d.why.controller;

import com.sun3d.why.model.CmsCultureInheritor;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsCultureInheritorService;
import com.sun3d.why.service.SysDictService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

@RequestMapping("/inheritor")
@Controller
public class CmsCultureInheritorController {
    private Logger logger = LoggerFactory.getLogger(CmsCultureInheritorController.class);

    @Autowired
    private CmsCultureInheritorService cultureInheritorService;

    @Autowired
    private SysDictService dictService;

    @Autowired
    private HttpSession session;

    /**
     * 非遗传承人列表
     * @return
     */
    @RequestMapping(value="/inheritorIndex")
    public ModelAndView inheritorIndex(CmsCultureInheritor inheritor,Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            List<CmsCultureInheritor> inheritorList = cultureInheritorService.queryCultureInheritorByCondition(inheritor,page);
            model.setViewName("admin/inheritor/inheritorIndex");
            model.addObject("inheritorList", inheritorList);
            model.addObject("page", page);
            model.addObject("inheritor", inheritor);
        }catch (Exception e){
            e.printStackTrace();
            logger.info("inheritorIndex error" + e);
        }
        return model;
    }

    /**
     * 去新增页面
     * @return
     */
    @RequestMapping(value="/preAddInheritor")
    public String preAddInheritor(CmsCultureInheritor inheritor,HttpServletRequest request) {
        request.setAttribute("inheritor", inheritor);
        return "admin/inheritor/addInheritor";
    }

    /**
     * 新增非遗传承人
     * @return
     */
    @RequestMapping(value="/addInheritor")
    @ResponseBody
    public String addInheritor(CmsCultureInheritor inheritor) {
        try{
            if (inheritor != null) {
                SysUser sysUser = (SysUser) session.getAttribute("user");
                return cultureInheritorService.addCultureInheritor(inheritor, sysUser);
            }
        }catch (Exception e){
            logger.info("addInheritor", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 去编辑页面
     * @return
     */
    @RequestMapping(value="/preEditInheritor")
    public String preEditInheritor(String inheritorId,HttpServletRequest request) {
        CmsCultureInheritor inheritor = cultureInheritorService.queryCultureInheritorById(inheritorId);
        request.setAttribute("inheritor", inheritor);
        return "admin/inheritor/editInheritor";
    }

    /**
     * 编辑非遗传承人
     * @return
     */
    @RequestMapping(value="/editInheritor")
    @ResponseBody
    public String editInheritor(CmsCultureInheritor inheritor) {
        try{
            if (inheritor != null) {
                SysUser sysUser = (SysUser) session.getAttribute("user");
                return cultureInheritorService.editCultureInheritor(inheritor, sysUser);
            }
        }catch (Exception e){
            e.printStackTrace();
            logger.info("editInheritor", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 删除角色
     * @param inheritorId
     * @return
     */
    @RequestMapping(value = "/deleteInheritor", method = RequestMethod.POST)
    @ResponseBody
    public String deleteInheritor(String inheritorId) {
        try {
            if (StringUtils.isNotBlank(inheritorId)) {
                cultureInheritorService.deleteCultureInheritorById(inheritorId);
                return Constant.RESULT_STR_SUCCESS;
            }
        } catch (Exception e) {
            logger.info("deleteInheritor error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 传承人详情
     * @return
     */
    @RequestMapping(value="/viewInheritor")
    public String viewInheritor(String inheritorId,HttpServletRequest request) {
        CmsCultureInheritor inheritor = cultureInheritorService.queryCultureInheritorById(inheritorId);
        request.setAttribute("inheritor", inheritor);
        return "admin/inheritor/viewInheritor";
    }

    @RequestMapping(value = "/queryDictNameByDictId")
    @ResponseBody
    public SysDict queryDictNameByDictId(String dictId) {
        return dictService.querySysDictByDictId(dictId);
    }
}
