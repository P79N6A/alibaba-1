package com.sun3d.why.controller;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.cnwd.CnwdEntryForm;
import com.sun3d.why.model.cnwd.CnwdEntryformCheck;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CnwdEntryFormService;
import com.sun3d.why.service.CnwdEntryformCheckService;
import com.sun3d.why.service.impl.CnwdEntryFormServiceImpl;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Controller
@RequestMapping(value="/cnwdEntryform")
public class CnwdEntryformController {
	  private Logger logger = Logger.getLogger(CnwdEntryformController.class);
	  @Autowired
	  private HttpSession session;
	  @Autowired
	  private CnwdEntryFormService cnwdEntryformService;
	  @Autowired
	  private CnwdEntryformCheckService cnwdEntryformCheckService;
	  /**
	   * 长宁舞蹈大赛报名列表
	   * @param cnwdEntryform
	   * @param page
	   * @return
	   */
	   @RequestMapping("/cnwdEntryformList")
	  public ModelAndView cnwdEntryformList( CnwdEntryForm cnwdEntryform,Pagination page) {
	        ModelAndView model = new ModelAndView();
	        try {
	            SysUser sysUser = (SysUser) session.getAttribute("user");
	            if(sysUser==null){
	            	model.setViewName("admin/user/userLogin");
	            	return model;
	            }
	            List<CnwdEntryForm> cnwdEntryformList=null;
	            if(sysUser!=null){
	             cnwdEntryformList = cnwdEntryformService.queryCnwdEntryformListByAdminCondition(cnwdEntryform, page, sysUser);
	           for (CnwdEntryForm cnwdEntryform2 : cnwdEntryformList) {
	             	//拒绝理由
	            	 if(null!=cnwdEntryform2&&cnwdEntryform2.getCheckStatus()==3){
	    				 CnwdEntryformCheck cnwdEntryformCheck= cnwdEntryformCheckService.queryEntryformCheckById(cnwdEntryform2.getEntryId());
	    				 if(null!=cnwdEntryformCheck){
	    					 cnwdEntryform2.setRefusalReason(cnwdEntryformCheck.getRefusalReason());
	    				 }
	    			 }
	     		}
	            }
	            model.addObject("cnwdEntryformList", cnwdEntryformList);
	            model.addObject("page", page);
	            model.addObject("cnwdEntryform", cnwdEntryform);
	            model.setViewName("admin/cnwd/cnwdEntryformList");
	        } catch (Exception e) {
	            logger.error("cnwdEntryformList error {}", e);
	        }
	        return model;
	    }
		/**
		 * 跳转到查看页面
		 * @param request
		 * @param entryId
		 * @return
		 */
		@RequestMapping(value="/viewCnwdEntryform")
		public String viewCnwdEntryform(HttpServletRequest request,@RequestParam String entryId){
			SysUser sysUser = (SysUser) session.getAttribute("user");  
			if(sysUser==null){
				return "admin/user/userLogin";
			}
			if (StringUtils.isNotBlank(entryId)) {
				CnwdEntryForm cnwdEntryform=cnwdEntryformService.selectByPrimaryKey(entryId);
				request.setAttribute("cnwdEntryform", cnwdEntryform);
			}
			return "admin/cnwd/viewCnwdEntryform";
		}
		/**
		 * 审核报名
		 * @param entryId
		 * @param status
		 * @param refusalReason
		 * @return
		 */
		@RequestMapping("/check")
		@ResponseBody
		public  String check(@RequestParam String entryId,@RequestParam Integer status,String refusalReason){
			try {
	    		
	  		  SysUser user = (SysUser) session.getAttribute("user");
	            if(user==null){
	                return "login";
	            }
	            CnwdEntryForm cnwdEntryform=new CnwdEntryForm();
	         cnwdEntryform.setEntryId(entryId);;
	         cnwdEntryform.setCheckStatus(status);
	         cnwdEntryform.setUpdateTime(new Date());
	         cnwdEntryform.setUpdateUser(user.getUserId());
	  	    int result= cnwdEntryformService.checkCnwdEntryform(cnwdEntryform);
	  	    if (result>=0) {
	  	    	CnwdEntryformCheck cnwdEntryformCheck=cnwdEntryformCheckService.queryEntryformCheckById(entryId);
				if (cnwdEntryformCheck==null) {
					CnwdEntryformCheck cnwdEntryformCheck1=new CnwdEntryformCheck();
					cnwdEntryformCheck1.setCheckId(UUIDUtils.createUUId());
					cnwdEntryformCheck1.setCheckEntryformId(entryId);
					cnwdEntryformCheck1.setCheckStatus(status);
					cnwdEntryformCheck1.setCheckTime(new Date());
					cnwdEntryformCheck1.setCheckSysUserId(user.getUserId());
					cnwdEntryformCheck1.setRefusalReason(refusalReason);
					cnwdEntryformCheckService.insert(cnwdEntryformCheck1);
				}else{
					cnwdEntryformCheck.setCheckStatus(status);
					cnwdEntryformCheck.setCheckSysUserId(user.getUserId());
					cnwdEntryformCheck.setCheckTime(new Date());
					cnwdEntryformCheck.setRefusalReason(refusalReason);
					cnwdEntryformCheckService.update(cnwdEntryformCheck);
				}
			}
	  		
			} catch (Exception e) {
				e.printStackTrace();
				return "failure";
			}
	  	
	  	return "success";
		}
		/**
		 * 跳转到拒绝理由页面
		 * @param request
		 * @param entryId
		 * @param status
		 * @return
		 */
		  @RequestMapping(value = "/preRefuse")
		  public String preRefuse(HttpServletRequest request, @RequestParam String entryId, @RequestParam Integer status) {
		        request.setAttribute("entryId", entryId);
		        request.setAttribute("status", status);
		        return "admin/cnwd/refuse";
		    }
		  /**
		   * 发送短信
		   * @param entryId
		   * @return
		   */
		@RequestMapping("/sendMessage")
		@ResponseBody
		public  String sendMessage(@RequestParam String entryId){
			try {
	    	CnwdEntryForm cnwdEntryForm=this.cnwdEntryformService.queryCnwdEntryFormById(entryId);
	    	if(null!=cnwdEntryForm){
	    		return this.cnwdEntryformService.sendMessage(cnwdEntryForm);
	    	}else{
	    		return "failure";
	    	}
	  		
			} catch (Exception e) {
				e.printStackTrace();
				return "failure";
			}
	  	
		}
		
	/*	public static void main(String[] args) {
			CnwdEntryFormServiceImpl cnwdEntryFormService=new CnwdEntryFormServiceImpl();
			CnwdEntryForm cnwdEntryForm=new CnwdEntryForm();
			cnwdEntryForm.setTelephone("18326453945");
			cnwdEntryForm.setTeamName("xiexie");
		    cnwdEntryForm.setProgramName("keqi");
		    cnwdEntryFormService.sendMessage(cnwdEntryForm);
		} */
}
