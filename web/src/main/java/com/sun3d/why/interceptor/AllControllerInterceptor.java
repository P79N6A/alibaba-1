package com.sun3d.why.interceptor;

import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.enumeration.redis.IntegralRedisKeyEnum;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.redis.RedisDAO;
import com.sun3d.why.redis.vo.UserIntergralRedisVO;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.util.redis.ListTranscoder;

/**
 * 所有业务处理请求拦截器
 * @author zhangshun
 *
 */
@Component("allControllerInterceptor")
public class AllControllerInterceptor  implements HandlerInterceptor{
	
    private Logger logger = Logger.getLogger(this.getClass());

    @Autowired
	private StaticServer staticServer;
    
    @Autowired
    private UserIntegralDetailService userIntegralDetailService;
    
    @Autowired
	private RedisDAO<String> redisDAO;
	
	
	/**
	 * 初始化方法 
	 */
	public void init() {
		
		logger.info("AllControllerInterceptor 拦截器初始化！");
	}
	
	/**
	 * 销毁方法
	 */
	public void destroy(){

	}
	
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
	
//		String headerResult=request.getHeader("version");
		try {
			
			String userId="";
			
			String u1=request.getParameter("userId");
			
			if(StringUtils.isNotBlank(u1))
			{
				userId=u1;
			}
			else
			{
				userId = (String) request.getAttribute("userId");
			}
			
		
			if(StringUtils.isBlank(userId))
			{
				CmsTerminalUser terminalUser = (CmsTerminalUser) request.getSession().getAttribute("terminalUser");
				
				if(terminalUser!=null&&StringUtils.isNotBlank(terminalUser.getUserId()))
					userId=terminalUser.getUserId();
			}
	
		
			if(StringUtils.isNotBlank(userId))
			{
				userIntegralDetailService.checkDayIntegral(userId);
			}
				
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			
		}
		
		return true;
	}
	
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		// TODO Auto-generated method stub
		
	}

}
