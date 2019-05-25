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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.annotation.EmojiInspect;
import com.sun3d.why.model.CmsGather;
import com.sun3d.why.service.CmsGatherService;
import com.sun3d.why.util.Pagination;

@RequestMapping("/gather")
@Controller
public class CmsGatherController {
    private Logger logger = LoggerFactory.getLogger(CmsGatherController.class);
    @Autowired
    private CmsGatherService cmsGatherService;
    @Autowired
    private HttpSession session;
    
    /**
     * 市场采集列表页
     * @param cmsGather
     * @param page
     * @return
     */
    @RequestMapping("/gatherIndex")
    public ModelAndView associationIndex(CmsGather cmsGather, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            List<CmsGather> list = cmsGatherService.queryGatherByCondition(cmsGather, page);
            model.addObject("list", list);
            model.addObject("page", page);
            model.addObject("gather", cmsGather);
            model.setViewName("admin/gather/gatherIndex");
        } catch (Exception e) {
            logger.error("gatherIndex error {}", e);
        }
        return model;
    }
    
    /**
     * 跳转至市场采集添加页面
     * @return
     */
    @RequestMapping(value = "/preAddGather")
    public String preAddGather(HttpServletRequest request) {
        return "admin/gather/addGather";
    }
    
    /**
     * 跳转至市场采集编辑页面
     * @return
     */
    @RequestMapping(value = "/preEditGather")
    public String preEditGather(HttpServletRequest request, String gatherId) {
        if (StringUtils.isNotBlank(gatherId)) {
        	CmsGather cmsGather = cmsGatherService.queryGatherByPrimaryKey(gatherId);
            request.setAttribute("gather", cmsGather);
        }
        return "admin/gather/editGather";
    }
    
    /**
     * 保存或更新市场采集信息
     * @param request
     * @return
     */
    @RequestMapping(value = "/saveOrUpdateGather")
    @ResponseBody
    @EmojiInspect
    public String saveOrUpdateGather(HttpServletRequest request,CmsGather cmsGather) {
        return cmsGatherService.saveOrUpdateGather(cmsGather);
    }
    
    /**
     * 删除市场采集信息
     * @param request
     * @return
     */
    @RequestMapping(value = "/deleteGather")
    @ResponseBody
    public String deleteGather(HttpServletRequest request,String gatherId) {
        return cmsGatherService.deleteGather(gatherId);
    }
}
