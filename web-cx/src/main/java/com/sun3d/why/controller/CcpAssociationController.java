package com.sun3d.why.controller;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.bean.association.CcpAssociationApply;
import com.sun3d.why.annotation.SysBusinessLog;
import com.sun3d.why.model.CcpAssociation;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CcpAssociationService;
import com.sun3d.why.service.CmsActivityService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@RequestMapping("/association")
@Controller
public class CcpAssociationController {
    private Logger logger = LoggerFactory.getLogger(CcpAssociationController.class);
    @Autowired
    private CmsActivityService activityService;
    @Autowired
    private HttpSession session;
    @Autowired
    private CacheService cacheService;
    @Autowired
    private CcpAssociationService ccpAssociationService;
    
    /**
     * 社团列表页
     * @param ccpAssociation
     * @param page
     * @return
     */
    @RequestMapping("/associationIndex")
    @SysBusinessLog(remark = "社团列表页")
    public ModelAndView associationIndex(CcpAssociation ccpAssociation, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            List<CcpAssociation> associationList = ccpAssociationService.queryAssociationByCondition(ccpAssociation, page);
            model.addObject("associationList", associationList);
            model.addObject("page", page);
            model.addObject("association", ccpAssociation);
            model.setViewName("admin/association/associationIndex");
        } catch (Exception e) {
            logger.error("associationIndex error {}", e);
        }
        return model;
    }
    
    /**
     * 跳转到社团申请页面
     * @return
     */
    @RequestMapping("/preApplyAssn")
    @SysBusinessLog(remark = "跳转到社团申请页面")
    public String preApplyAssn() {
        return "admin/association/applyAssn";
    }
    
    /**
     * 申请社团
     * @param ccpAssociationApply
     * @return
     */
    @RequestMapping("/applyAssociation")
    @SysBusinessLog(remark = "申请社团")
    @ResponseBody
    public String applyAssociation(CcpAssociationApply ccpAssociationApply) {
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser!=null){
            	ccpAssociationApply.setAssnId(UUIDUtils.createUUId());
            	ccpAssociationApply.setAssnState(0);
            	ccpAssociationApply.setCreateSuser(sysUser.getUserId());
            	ccpAssociationApply.setUpdateSuser(sysUser.getUserId());
            	ccpAssociationApply.setCreateTime(new Date());
            	ccpAssociationApply.setUpdateTime(new Date());
            	boolean rsBoolean = ccpAssociationService.saveAssnApply(ccpAssociationApply);
            	if(rsBoolean){
            		return Constant.RESULT_STR_SUCCESS;
            	}else{
            		return Constant.RESULT_STR_FAILURE;
            	}
            }else{
            	return Constant.RESULT_STR_FAILURE;
            }
        } catch (Exception e) {
            logger.info("applyAssociation error {}", e);
            return Constant.RESULT_STR_FAILURE;
        }
    }
}
