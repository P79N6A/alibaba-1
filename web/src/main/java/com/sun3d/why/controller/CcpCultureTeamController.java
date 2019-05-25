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
import com.sun3d.why.model.CmsUserAnswer;
import com.sun3d.why.model.ccp.CcpCultureTeam;
import com.sun3d.why.model.ccp.CcpCultureTeamWorks;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CcpCultureTeamService;
import com.sun3d.why.util.Pagination;

@RequestMapping("/cultureTeam")
@Controller
public class CcpCultureTeamController {
    private Logger logger = LoggerFactory.getLogger(CcpCultureTeamController.class);
    @Autowired
    private CcpCultureTeamService ccpCultureTeamService;
    @Autowired
    private HttpSession session;
    @Autowired
    private CacheService cacheService;
    
    /**
     * 浦东文化社团评选列表页
     * @param ccpAssociation
     * @param page
     * @return
     */
    @RequestMapping("/cultureTeamIndex")
    public ModelAndView associationIndex(CcpCultureTeam ccpCultureTeam, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            List<CcpCultureTeam> list = ccpCultureTeamService.queryCultureTeamByCondition(ccpCultureTeam, page);
            model.addObject("list", list);
            model.addObject("page", page);
            model.addObject("cultureTeam", ccpCultureTeam);
            model.setViewName("admin/cultureTeam/cultureTeamIndex");
        } catch (Exception e) {
            logger.error("cultureTeamIndex error {}", e);
        }
        return model;
    }
    
    /**
     * 跳转至团体添加页面
     * @return
     */
    @RequestMapping(value = "/preAddCultureTeam")
    public String preAddCultureTeam(HttpServletRequest request) {
        return "admin/cultureTeam/addCultureTeam";
    }
    
    /**
     * 跳转至团体编辑页面
     * @return
     */
    @RequestMapping(value = "/preEditCultureTeam")
    public String preEditCultureTeam(HttpServletRequest request, String cultureTeamId) {
        if (StringUtils.isNotBlank(cultureTeamId)) {
        	CcpCultureTeam ccpCultureTeam = ccpCultureTeamService.queryCultureTeamByPrimaryKey(cultureTeamId);
            request.setAttribute("cultureTeam", ccpCultureTeam);
            
            List<CcpCultureTeamWorks> worksList = ccpCultureTeamService.queryCultureTeamWorksByCondition(cultureTeamId);
            request.setAttribute("worksList", worksList);
        }
        return "admin/cultureTeam/editCultureTeam";
    }
    
    /**
     * 保存或更新团体信息
     * @param request
     * @return
     */
    @RequestMapping(value = "/saveOrUpdateCultureTeam")
    @ResponseBody
    @EmojiInspect
    public String saveOrUpdateCultureTeam(HttpServletRequest request,CcpCultureTeam ccpCultureTeam) {
        return ccpCultureTeamService.saveOrUpdateCultureTeam(ccpCultureTeam);
    }
    
    /**
     * 保存或更新团体信息
     * @param request
     * @return
     */
    @RequestMapping(value = "/deleteCultureTeam")
    @ResponseBody
    public String deleteCultureTeam(HttpServletRequest request,String cultureTeamId) {
        return ccpCultureTeamService.deleteCultureTeam(cultureTeamId);
    }
}
