package com.sun3d.why.controller;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.sun3d.why.model.CcpAssociationRecruitApply;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.bean.association.CcpAssociationApply;
import com.sun3d.why.model.CcpAssociation;
import com.sun3d.why.model.CcpAssociationRes;
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
    @RequestMapping("/assnIndex")
    public ModelAndView assnIndex(CcpAssociation ccpAssociation, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            List<CcpAssociation> associationList = ccpAssociationService.queryAssociationByCondition(ccpAssociation, page);
            model.addObject("associationList", associationList);
            model.addObject("page", page);
            model.addObject("association", ccpAssociation);
            model.setViewName("admin/association/assnIndex");
        } catch (Exception e) {
            logger.error("assnIndex error {}", e);
        }
        return model;
    }
    
    /**
     * 社团列表页（活动添加页内嵌）
     * @param ccpAssociation
     * @param page
     * @return
     */
    @RequestMapping("/associationIndex")
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
     * 跳转到社团添加页面
     * @return
     */
    @RequestMapping("/preAddAssn")
    public String preAddAssn() {
        return "admin/association/addAssn";
    }
    
    /**
     * 跳转到社团编辑页面
     * @return
     */
    @RequestMapping("/preEditAssn")
    public String preEditAssn(HttpServletRequest request, String assnId) {
    	if (StringUtils.isNotBlank(assnId)) {
    		CcpAssociation ccpAssociation = ccpAssociationService.queryAssnByPrimaryKey(assnId);
            request.setAttribute("assn", ccpAssociation);
            
            List<CcpAssociationRes> resList = ccpAssociationService.queryAssnResByAssnId(assnId);
            request.setAttribute("resList", resList);
        }
    	return "admin/association/editAssn";
    }
    
    /**
     * 保存或更新社团信息
     * @param request
     * @return
     */
    @RequestMapping(value = "/saveOrUpdateAssn")
    @ResponseBody
    public String saveOrUpdateAssn(HttpServletRequest request,CcpAssociation ccpAssociation) {
        return ccpAssociationService.saveOrUpdateAssn(ccpAssociation);
    }
    
    /**
     * 删除社团
     * @param request
     * @return
     */
    @RequestMapping(value = "/deleteAssn")
    @ResponseBody
    public String deleteAssn(HttpServletRequest request,String assnId) {
        return ccpAssociationService.deleteAssn(assnId);
    }
    
    /************************************************社团申请***********************************************************************/
    
    /**
     * 社团申请列表页
     * @param ccpAssociation
     * @param page
     * @return
     */
    @RequestMapping("/associationApplyIndex")
    public ModelAndView associationApplyIndex(CcpAssociation ccpAssociation, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
        	ccpAssociation.setAssnState(0);	//申请中
            List<CcpAssociation> assnApplyList = ccpAssociationService.queryAssociationApplyByCondition(ccpAssociation, page);
            model.addObject("assnApplyList", assnApplyList);
            model.addObject("page", page);
            model.addObject("association", ccpAssociation);
            model.setViewName("admin/association/associationApplyIndex");
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
    public String preApplyAssn() {
        return "admin/association/applyAssn";
    }
    
    /**
     * 申请社团
     * @param ccpAssociationApply
     * @return
     */
    @RequestMapping("/applyAssociation")
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

    /**
     * 社团审核列表
     * @param ccpAssociation
     * @param page
     * @return
     */
    @RequestMapping(value = "/examine",method = {RequestMethod.POST,RequestMethod.GET})
    public ModelAndView examine(CcpAssociation ccpAssociation, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            List<CcpAssociation> associationList = ccpAssociationService.queryAssociationByCondition(ccpAssociation, page);
            model.addObject("associationList", associationList);
            model.addObject("page", page);
            model.addObject("association", ccpAssociation);
            model.setViewName("admin/association/examine");
        } catch (Exception e) {
            logger.error("assnIndex error {}", e);
        }
        return model;
    }

    /**
     * 社团招募列表
     * @param ccpAssociation
     * @param page
     * @return
     */
    @RequestMapping("/recruitApplyIndex")
    public ModelAndView recruitApplyIndex(CcpAssociationRecruitApply recruitApply, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            List<CcpAssociationRecruitApply> recruitApplyList = ccpAssociationService.queryRecruitApplyByCondition(recruitApply, page);
            model.addObject("recruitApplyList", recruitApplyList);
            //查询所有的社团
            List<CcpAssociation> assnlist = ccpAssociationService.selectAllAssn();
            model.addObject("assnlist", assnlist);

            model.addObject("page", page);
            model.addObject("recruitApply", recruitApply);
            model.setViewName("admin/association/recruitApplyIndex");
        } catch (Exception e) {
            logger.error("recruitApplyIndex error {}", e);
        }
        return model;
    }
}
