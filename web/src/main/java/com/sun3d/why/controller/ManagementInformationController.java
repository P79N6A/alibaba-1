package com.sun3d.why.controller;


import com.sun3d.why.model.ManagementInformation;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.ManagementInformationService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.activemq.leveldb.replicated.MasterLevelDBStore;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@RequestMapping("/information")
@Controller
public class ManagementInformationController {
    private Logger logger = LoggerFactory.getLogger(ManagementInformationController.class);
    @Autowired
    private ManagementInformationService managementInformationService;

    @Autowired
    private HttpSession session;

    @Autowired
    private CacheService cacheService;

    /**
     * 资讯列表页
     *
     * @param information
     * @param page
     * @return
     */
    @RequestMapping("/informationIndex")
    public ModelAndView informationIndex(ManagementInformation information, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<ManagementInformation> informationList = managementInformationService.informationList(information, page, sysUser);
            model.addObject("information", information);
            model.addObject("informationList", informationList);
            model.addObject("page", page);
            model.setViewName("admin/managementInformation/informationIndex");
        } catch (Exception e) {
            logger.error("informationIndex error {}", e);
        }
        return model;
    }


    /**
     * 资讯内容编辑页
     *
     * @return
     */
    @RequestMapping("/preAddInformation")
    public ModelAndView preAddInformation(String informationId) {
        ModelAndView model = new ModelAndView();
        try {
            model.addObject("informationId", informationId);
            model.setViewName("admin/managementInformation/addInformation");
        } catch (Exception e) {
            logger.error("informationIndex error {}", e);
        }
        return model;
    }

    /**
     * 添加资讯
     *
     * @return
     */
    @RequestMapping(value = "/addInformation")
    @ResponseBody
    public String addInformation(ManagementInformation information) {
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            String result;
            if(sysUser!=null){
                result=managementInformationService.addInformation(information, sysUser);
                return result;
            }else{
                result="noLogin";
                return result;
            }
        } catch (Exception e) {
            logger.info("addActivityEditorial error {}", e);
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 根据id读取咨询
     *
     * @return
     */
    @RequestMapping(value = "/getInformation")
    @ResponseBody
    public ManagementInformation getInformation(String informationId) {
        try {
            return managementInformationService.getInformation(informationId);
        } catch (Exception e) {
            logger.info("addActivityEditorial error {}", e);
        }
        return null;
    }

    /**
     * 资讯展示页
     *
     * @return
     */
    @RequestMapping("/preInfo")
    public ModelAndView preInfo(String informationId,HttpServletRequest request) {
        ModelAndView model = new ModelAndView();
        try {
            //微信权限验证配置
            String url = BindWS.getUrl(request);
            Map<String, String> sign = BindWS.sign(url, cacheService);
            ManagementInformation managementInformation=managementInformationService.getInformation(informationId);
            request.setAttribute("sign", sign);
            model.addObject("managementInformation", managementInformation);
            model.setViewName("index/managementInformation/information");
        } catch (Exception e) {
            logger.error("informationIndex error {}", e);
        }
        return model;
    }
    /**
     * 根据id读取咨询
     *
     * @return
     */
    @RequestMapping(value = "/getInformationSQL")
    @ResponseBody
    public ManagementInformation getInformationSQL(String informationId) {
        try {
            return managementInformationService.getInformationSQL(informationId);
        } catch (Exception e) {
            logger.info("addActivityEditorial error {}", e);
        }
        return null;
    }
}
