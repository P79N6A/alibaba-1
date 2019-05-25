package com.sun3d.why.aop;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsUserService;

@Aspect
@Component
public class UserSessionAop {
	
	@Autowired
    private HttpSession session;
	@Autowired
    private CmsUserService cmsUserService; 

	/**
	 * 子站SSO，通过userAccount创建session
	 * @param joinPoint
	 */
	@Before("(execution(* com.sun3d.why.controller.CmsActivityController.preAddActivity(..)) ||"
			+ " execution(* com.sun3d.why.controller.CmsActivityController.preEditActivity(..)) ||"
			+ " execution(* com.sun3d.why.controller.CmsActivityController.activityExamineIndex(..)) ||"
			+ " execution(* com.sun3d.why.controller.CmsVenueController.preAddVenue(..)) ||"
			+ " execution(* com.sun3d.why.controller.CmsVenueController.preEditVenue(..)) ||"
			+ " execution(* com.sun3d.why.controller.BpInfoController.addPage(..)) ||"
			+ " execution(* com.sun3d.why.controller.BpInfoController.preEditInfo(..)))")
	public void userBefore(JoinPoint joinPoint) {
		try {
			HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest();
			String userAccount = request.getParameter("userAccount");
			String backPath = request.getParameter("backPath");
			String inStore = request.getParameter("inStore");
			
			if(StringUtils.isNotBlank(inStore)){
				request.setAttribute("inStore", 1);
			}
			
	        if(StringUtils.isNotBlank(userAccount)){
	        	SysUser sysUser  = cmsUserService.loginCheckUserAccount(userAccount);
	        	if (sysUser != null) {
	        		session.setAttribute("user", sysUser);
	        		if(StringUtils.isNotBlank(backPath)){
	        			request.setAttribute("backPath", backPath);
	        		}else{
	        			request.setAttribute("inStore", 1);
	        		}
	        	}else{
	        		request.setAttribute("error", "noUser");
	        	}
	        }
	        
		} catch (Throwable e) {
			e.printStackTrace();
		}
	}
}
