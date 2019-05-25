//package com.sun3d.why.webservice.api.controller;
//
//import bingo.sso.client.web.AbstractSingleSignOnServlet;
//import com.sun3d.why.model.CmsTerminalUser;
//import com.sun3d.why.webservice.api.service.CmsApiTerminalUserService;
//import org.apache.commons.lang3.StringUtils;
//import org.eclipse.jetty.server.Authentication;
//import org.springframework.beans.factory.annotation.Autowired;
//
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//
//
///**
// * <code>{@link SingleSignOnServlet}</code>
// *
// * @author Leon
// */
//public class SingleSignOnServlet extends AbstractSingleSignOnServlet {
//    private static final long serialVersionUID = 1L;
//    private static final String AUTH_KEY = SingleSignOnServlet.class.getName() + "$AUTHENTICATION";
//    @Autowired
//    private CmsApiTerminalUserService cmsApiTerminalUserService;
//    @Override
//    protected void onSetupNeeded(HttpServletRequest req,
//                                 HttpServletResponse response, String returnUrl) throws Exception {
//    }
//
//    @Override
//    protected void onSuccessSignIn(HttpServletRequest req,
//                                   HttpServletResponse response, bingo.sso.client.web.Authentication auth) throws Exception {
////        req.getSession().setAttribute(AUTH_KEY, auth);//简单的把SSO成功返回的auth用户授权信息，保存在Session中
//        CmsTerminalUser user = new CmsTerminalUser();
//        if(StringUtils.isNotBlank(auth.getIdentity())){
//            user.setUserName("CSIP-"+auth.getIdentity());
//            try {
//                String result = cmsApiTerminalUserService.webLogin(user);
//            } catch (Exception e) {
//            }
//        }
//    }
//
//    public static Authentication getAuthentication(HttpServletRequest req) {
//        return (Authentication) req.getSession().getAttribute(AUTH_KEY);
//    }
//}
