package com.sun3d.why.aop;

import java.util.Date;

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

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsUserService;

@Aspect
@Component
public class OpenControllerAop {
	
	@Autowired
    private HttpSession session;

	/**
	 * 子站跳转传递参数
	 * @param joinPoint
	 */
	@Before("(execution(* com.sun3d.why.controller.wechat.WechatActivityController.preActivityDetail(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatActivityController.preActivityList(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatActivityController.preActivityOrder(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatActivityController.wcOrderList(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatActivityController.wcOrderSeat(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatActivityController.finishSeat(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatActivityController.preMap(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatActivityController.preActivityOrderDetail(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatVenueController.venueDetailIndex(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatVenueController.roomBookOrder(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatVenueController.roomOrderComplete(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatRoomController.preRoomList(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatRoomController.preRoomDetail(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatRoomController.roomOrderDetail(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatRoomController.authTeamUser(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatUserController.auth(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatController.preAddWcComment(..)) ||"
			+ " execution(* com.sun3d.why.controller.wechat.WechatChuanzhouController.chuanzhouDetail(..)))")
	public void shopBefore(JoinPoint joinPoint) {
		try {
			HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest();
			String userId = request.getParameter("userId");
			String callback = request.getParameter("callback");
			String sourceCode = request.getParameter("sourceCode");
			
			request.setAttribute("userId", userId);
			request.setAttribute("callback", callback);
			request.setAttribute("sourceCode", sourceCode);
	        
		} catch (Throwable e) {
			e.printStackTrace();
		}
	}
}
