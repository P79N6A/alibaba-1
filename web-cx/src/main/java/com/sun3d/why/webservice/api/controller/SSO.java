package com.sun3d.why.webservice.api.controller;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.util.Constant;
import com.sun3d.why.webservice.api.service.CmsApiTerminalUserService;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class SSO extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) {
            try {
                CmsTerminalUser user = new CmsTerminalUser();
                WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(req.getSession().getServletContext());
                CmsApiTerminalUserService cmsApiTerminalUserService= (CmsApiTerminalUserService) wac.getBean("cmsApiTerminalUserServiceImpl");
                System.out.println("51 onSuccessSignIn:21232f297a57a5a743894a0e4a801fc3");
                CmsTerminalUser result = cmsApiTerminalUserService.webLogin("21232f297a57a5a743894a0e4a801fc3");
                req.getSession().setAttribute(Constant.terminalUser, result);
                System.out.println(result);
            } catch (Exception e) {
                e.printStackTrace();
            }
    }

}
