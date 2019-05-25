package com.sun3d.why.controller;

import com.sun3d.why.model.CmsAndroidVersion;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsAndroidVersionService;
import com.sun3d.why.util.Pagination;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * Created by yujinbing on 2015/6/9.
 */
@Controller
@RequestMapping(value = "/androidVersion")
public class CmsAndroidVersionController {
    /**
     * 导入log4j日志管理，记录错误信息
     */
    private Logger logger = Logger.getLogger(CmsAndroidVersionController.class);

    /**
     * 自动注入安卓版本服务
     */
    @Autowired
    private CmsAndroidVersionService cmsAndroidVersionService;

    @Autowired
    private HttpSession session;

    /**
     * 后台手机首页列表页
     * @param record
     * @param page
     * @return
     */
    @RequestMapping(value = "/androidVersionIndex")
    public ModelAndView androidVersionIndex(CmsAndroidVersion record, Pagination page) {
        List<CmsAndroidVersion> list = null;
        try {
            ModelAndView model = new ModelAndView();
            page.setTotal(cmsAndroidVersionService.queryPageCount(record));
            list = cmsAndroidVersionService.queryPageList(record,page);
            model.setViewName("admin/phoneVersion/androidVersionIndex");
            model.addObject("list", list);
            model.addObject("page", page);
            model.addObject("record",record);
            return model;
        } catch (Exception ex) {
            ex.printStackTrace();
            logger.error("androidVersionIndex action error {}", ex);
            return null;
        }
    }


    /**
     * 进入新建手机版本页面
     * @return
     */
    @RequestMapping(value = "/preAddAndroidVersion")
    public String preAddAndroidVersion(){
        return "admin/phoneVersion/addAndroidVersion";
    }


    /**
     * 保存版本信息
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/addAndroidVersion")
    public String addAndroidVersion(CmsAndroidVersion record){
        try {
            SysUser loginUser = (SysUser)session.getAttribute("user");
            return cmsAndroidVersionService.addAndroidVersion(record, loginUser);
        } catch (Exception ex) {
            logger.error("addAndroidVersion action error {}", ex);
            ex.printStackTrace();
            return "error:"+ ex.toString();
        }
    }




    /**
     * 进入编辑手机版本页面
     * @return
     */
    @RequestMapping(value = "/preEditAndroidVersion")
    public String preEditAndroidVersion(HttpServletRequest request,String vId){
        CmsAndroidVersion cmsAndroidVersion = cmsAndroidVersionService.queryCmsAndroidVersionByVid(vId);
        request.setAttribute("cmsAndroidVersion",cmsAndroidVersion);
        return "admin/phoneVersion/editAndroidVersion";
    }

    /**
     * 保存更新的版本信息
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/editAndroidVersion")
    public String editAndroidVersion(CmsAndroidVersion record){
        try {
            SysUser loginUser = (SysUser)session.getAttribute("user");
            return cmsAndroidVersionService.editAndroidVersion(record, loginUser);
        } catch (Exception ex) {
            logger.error("addAndroidVersion action error {}", ex);
            ex.printStackTrace();
            return "error:"+ ex.toString();
        }
    }

}
