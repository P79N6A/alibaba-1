package com.sun3d.why.filter;

import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.webservice.api.token.TokenHelper;
import org.apache.commons.lang3.StringUtils;

import javax.servlet.*;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 *
 * 文化云app验证用户Token的过滤器
 *
 */
public class TokenProvingFilter implements Filter {

	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		System.out.println("过滤器销毁。。。。。。。。。。。");
	}

	@Override
	public void doFilter(ServletRequest servletRequest, ServletResponse response, FilterChain filterChain) throws IOException,
			ServletException {
		String json="";
		HttpServletRequest request = (HttpServletRequest) servletRequest;
		HttpSession session = request.getSession();
		String token="";
		token = request.getParameter("token");
		//查找cookies自动登录
		Cookie[] cookies = ((HttpServletRequest)request).getCookies();
		if(cookies!=null&&cookies.length>0){
			for (Cookie cookie : cookies) {
			if(cookie.getName().equals("anonymous")){
				 token=cookie.getValue();
			    }
			}
		}
		if (null == token || token.length() <= 0) {
		     // 没有Token
			json = JSONResponse.commonResultFormat(101110, "没有权限访问!", null);
			response.getWriter().print(json);
			return ;
		} else {
		    // 有Token,验证Token
            session.setAttribute("token",token);
            if(session.getAttribute("token")!=null){
				     String userToken=(String)session.getAttribute("token");
				     if(StringUtils.isNotBlank(userToken) && userToken.equals("anonymous")){
						 System.out.println("游客登录!");
					 }
				     else if(StringUtils.isNotBlank(userToken) && !TokenHelper.valid(userToken)){
						 //用户已失效
						 json = JSONResponse.commonResultFormat(101111, "用户已失效,请重新登录!", null);
						 response.getWriter().print(json);
						 return ;
					 }
			   }
		}
		            filterChain.doFilter(request, response);
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		// TODO Auto-generated method stub
		System.out.println("过滤器初始化。。。。。。。。。。。");
	}
}
