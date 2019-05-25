package com.sun3d.why.filter;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.util.Base64;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.SpringContextUtil;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;

import javax.servlet.*;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLDecoder;


public class AutoLoginServlet implements Filter {


    private Logger logger = LoggerFactory.getLogger(AutoLoginServlet.class);

   // private  ApplicationContext   applicationContext;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {

       //applicationContext = (ApplicationContext) filterConfig.getServletContext().getAttribute(WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
 /*       SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this,
                filterConfig.getServletContext());*/
    }




    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpSession session = request.getSession();
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String reqURI = request.getRequestURI();
        //是否是前台请求
        if(reqURI!=null&&reqURI.indexOf("front")!=-1){
        //如果登陆用户为空
                if(session.getAttribute("terminalUser")==null){
                    //查找cookie自动登陆
                    Cookie[] cookie = request.getCookies();
                    if(cookie != null && cookie.length > 0){
                        String autoLogin =null;
                        String userName = null;
                        String userPwd = null;
                        for(Cookie c:cookie){
                            if(Constant.AutoLogin.equals(c.getName())){
                                autoLogin=c.getValue();
                                break;
                            }
                        }
                        //捕获自动登陆所有异常
                        if (StringUtils.isNotBlank(autoLogin)){
                            try{
                                autoLogin = URLDecoder.decode(autoLogin,"UTF-8");
                                autoLogin= Base64.decode(autoLogin);
                                String [] userArr = autoLogin.split(",");
                                if(userArr.length>1){
                                    CmsTerminalUser user = new CmsTerminalUser();
                                    user.setUserName(userArr[0]);
                                    user.setUserPwd(userArr[1]);
                                    CmsTerminalUserService userService = (CmsTerminalUserService)SpringContextUtil.getContext().getBean("terminalUserService");
                                        //WebApplicationContext wac= WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
                                        //CmsTerminalUserService userService = (CmsTerminalUserService) wac.getBean("cmsTerminalUserServiceImpl");
                                    userService.terminalLogin(user, session);
                                    }
                                }catch (Exception e){
                                    e.printStackTrace();
                                    logger.info("-----cookie自动登陆失败"+e);
                                }
                            }
                        }
                    }

            }

        //自动登陆完毕,继续doFilter
        filterChain.doFilter(request, response);
    }

    @Override
    public void destroy() {

    }



}
