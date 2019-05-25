package com.sun3d.why.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.sun3d.why.model.UserIntegral;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.publicWebservice.service.InitSystemService;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.service.UserIntegralService;
import com.sun3d.why.util.Pagination;

/**
 * @author zhangshun
 *
 */
/**
 * @author zhangshun
 *
 */
@Controller
@RequestMapping("/userIntegral")
public class CmsUserIntegralController {
	
	 private Logger logger = LoggerFactory.getLogger(CmsUserIntegralController.class);
	 
	 @Autowired
	 private UserIntegralService userIntegralService;

	 @Autowired
	 private UserIntegralDetailService userIntegralDetailService;
	 
	 @Autowired
	 private CmsTerminalUserService terminalUserService;
	 
	 @Autowired
	 private InitSystemService initSystemService;
	 
	 /**
	  * 用户积分列表
	  * 
	 * @param userId
	 * @param page
	 * @return
	 */
	 @RequestMapping(value="/userIntegralIndex")
	 public ModelAndView userIntegralIndex(@RequestParam String userId, Pagination page){
		 
		 ModelAndView model = new ModelAndView();
		 
		 UserIntegral userIntegral = userIntegralService.selectUserIntegralByUserId(userId);
		 
		 List<UserIntegralDetail> userIntegralDetailList= userIntegralDetailService.queryUserIntegralDetailByIntegralId(userIntegral.getIntegralId(),page);		 
		 
		 for (UserIntegralDetail userIntegralDetail : userIntegralDetailList) {
			String description= IntegralTypeEnum.getIntegralType(userIntegralDetail.getIntegralType()).getDescription();
		
			userIntegralDetail.setIntegralFrom(description);
		 }
		 
		 model.addObject("userId", userId);
		 
		 model.addObject("integralNow", userIntegral.getIntegralNow());
		 model.addObject("userIntegralDetailList", userIntegralDetailList);
	     model.addObject("page", page);
	        	
	     model.setViewName("admin/userIntegral/userIntegralDetailIndex");
	     return model;
		 
	 }
	 
	 /**
	  * 云叔积分页面
	 * @param userId
	 * @return
	 */
	@RequestMapping(value="/cloudIntegral")
	public ModelAndView cloudIntegral(@RequestParam String userId){
		 
		 ModelAndView model = new ModelAndView();
		 
		 model.addObject("userId", userId);
		 
		 model.setViewName("admin/userIntegral/cloudIntegral");
	     return model;
	 }
	
	
	/**
	 * 保存云叔积分
	 * @param userId
	 * @param userIntegralDetail
	 * @return
	 */
	@RequestMapping("/saveCloudIntegral")
	    @ResponseBody
	    public int saveCloudIntegral(@RequestParam String []userId, UserIntegralDetail userIntegralDetail){
	    	
	    	int result=0;
	    	
	    	  try {  
	    		  
	    		 result= userIntegralDetailService.saveCloudIntegral(userId,userIntegralDetail);
	    		  
	    	  } catch (Exception e) {
	              logger.info("saveCloudIntegral error" + e);
	              
	              result=-1;
	          }
	    	return result;
	    }
	
	@RequestMapping("/initUserRegisterIntegral")
    @ResponseBody
    public int initUserRegisterIntegral(){
    	
		return initSystemService.initAllRegisterIntegral();
    }
	 
}
