package com.sun3d.why.webservice.api.controller;


import bingo.sso.client.web.AbstractSingleSignOnServlet;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.util.Constant;
import com.sun3d.why.webservice.api.service.CmsApiTerminalUserService;
import org.apache.commons.lang3.StringUtils;
import org.eclipse.jetty.server.Authentication;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class SingleSignOnServlet extends AbstractSingleSignOnServlet {
    private static final long serialVersionUID = 1L;
    private static final String AUTH_KEY = SingleSignOnServlet.class.getName() + "$AUTHENTICATION";
    @Override
    protected void onSetupNeeded(HttpServletRequest req,
                                 HttpServletResponse response, String returnUrl) throws Exception {

    }

    @Override
    protected void onSuccessSignIn(HttpServletRequest req,
                                   HttpServletResponse response, bingo.sso.client.web.Authentication auth) throws Exception {
//        req.getSession().setAttribute(AUTH_KEY, auth);//简单的把SSO成功返回的auth用户授权信息，保存在Session中
        CmsTerminalUser user = new CmsTerminalUser();
        if(StringUtils.isNotBlank(auth.getIdentity())){
            System.out.println("51 onSuccessSignIn:"+auth.getIdentity());
            try {
                WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(req.getSession().getServletContext());
                CmsApiTerminalUserService cmsApiTerminalUserService= (CmsApiTerminalUserService) wac.getBean("cmsApiTerminalUserServiceImpl");
                CmsTerminalUser result = cmsApiTerminalUserService.webLogin(auth.getIdentity());
                req.getSession().setAttribute(Constant.terminalUser, result);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }


    public static Authentication getAuthentication(HttpServletRequest req) {
        return (Authentication) req.getSession().getAttribute(AUTH_KEY);
    }
}
