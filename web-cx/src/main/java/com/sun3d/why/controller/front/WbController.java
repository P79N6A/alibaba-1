package com.sun3d.why.controller.front;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.SyncCmsTerminalUserService;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.EmojiFilter;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.TerminalUserConstant;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import weibo4j.Users;
import weibo4j.model.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by niu on 2015/10/15.
 * 微博登录
 */

@RequestMapping("/sina")
@Controller
public class WbController {

    @Autowired
    private HttpSession session;
    @Autowired
    private CmsTerminalUserService terminalUserService;

    @Autowired
    private StaticServer staticServer;

    @Autowired
    private SyncCmsTerminalUserService syncCmsTerminalUserService;
    
    @Autowired
    private UserIntegralDetailService userIntegralDetailService;

    @RequestMapping("/login")
    public ModelAndView qqLogin (HttpServletRequest request) {
    	ModelAndView modelAndView = new ModelAndView();
    	CmsTerminalUser sessionUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
    	
    	String callback = request.getParameter("callback");
        if (StringUtils.isNotBlank(callback)) {
        	modelAndView.setViewName("redirect:"+ callback);
        }else{
        	modelAndView.setViewName(Constant.IndexPage);
        }
    	
        if(null!=sessionUser){
        	if(StringUtils.isNotBlank(sessionUser.getUserId())){
        		if(StringUtils.isNotBlank(callback)){
        			if(callback.contains("?")){
        				modelAndView.setViewName("redirect:"+ callback+"&userId="+sessionUser.getUserId());
        			}else{
        				modelAndView.setViewName("redirect:"+ callback+"?userId="+sessionUser.getUserId());
        			}
            		return modelAndView;
        		}else{
        			return modelAndView;
        		}
        	}
        }
        try {
            // weibo4j.Oauth oauth = new weibo4j.Oauth();
            //url = oauth.authorize("code", "");
        	modelAndView.setViewName("redirect:"+new weibo4j.Oauth().authorizeBack("code", "", callback));
        } catch (Exception e) {
        	if(modelAndView.getViewName().contains("?")){
            	modelAndView.setViewName(modelAndView.getViewName()+"&error=loginFail");
            }else{
            	modelAndView.setViewName(modelAndView.getViewName()+"?error=loginFail");
            }
            e.printStackTrace();
        }
        return modelAndView;
    }


    /****
     * 窗口式打开使用该回调  请勿删除
     * @param request
     * @return
     */
   /* @RequestMapping(value = "/login-sina-weibo.do", method = RequestMethod.GET)
    public ModelAndView loginSinaWeibo(HttpServletRequest request)  {
        CmsTerminalUser sessionUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
        //当前已登录用户 不做任何处理
        if(null!=sessionUser){
            request.setAttribute("code","sessionUser");
            return new ModelAndView("index/sina/result");
            //return new ModelAndView(Constant.IndexPage);
        }
        String code = request.getParameter("code");
        if(StringUtils.isBlank(code)){
            request.setAttribute("code",500);
            return new ModelAndView("index/sina/result");
        }
        String openId = "";
        weibo4j.http.AccessToken accessToken = null;
        Users um = null;
        //捕获所有验证异常 避免重复为同一第三方账号注册
        try {
            weibo4j.Oauth oauth = new weibo4j.Oauth();
            accessToken = oauth.getAccessTokenByCode(code);
            openId = accessToken.getUserUid();
            //未正确获取openId
            if(StringUtils.isEmpty(openId)){
                request.setAttribute("code",500);
                return new ModelAndView("index/sina/result");
                //return new ModelAndView(Constant.IndexPage);
            }
            //根据openid查询用户 存在则直接登录返回
            Map<String,Object> params = new HashMap<String, Object>();
            params.put("openId",openId);
            CmsTerminalUser extUser =  terminalUserService.queryByWebOpenId(params);
            if(null!=extUser&&StringUtils.isNotBlank(extUser.getUserId())){
                if(extUser.getUserIsDisable()==1){
                    session.setAttribute(Constant.terminalUser,extUser);
                    request.setAttribute("code","extUser");
                    return new ModelAndView("index/sina/result");
                    //return new ModelAndView(Constant.IndexPage);
                }else{
                    request.setAttribute("code","badUser");
                    request.setAttribute("redUrl","/frontTerminalUser/userLogin.do?LoginType=3&code="+UUIDUtils.createUUId());
                    return new ModelAndView("index/sina/result");
                   // return new ModelAndView("redirect:/frontTerminalUser/userLogin.do?LoginType=3&code="+
                   //         UUIDUtils.createUUId());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("code",500);
            return new ModelAndView("index/sina/result");
           // return new ModelAndView(Constant.IndexPage);
        }

        CmsTerminalUser tuser = new CmsTerminalUser();

        String userId = UUIDUtils.createUUId();
        tuser.setUserId(userId);
        tuser.setCreateTime(new Date());
        tuser.setUserIsDisable(Constant.USER_IS_ACTIVATE);
        tuser.setUserType(1);
        tuser.setUserIsLogin(1);
        //账号来源 3 微博
        tuser.setRegisterOrigin(3);
        //评论状态正常
        tuser.setCommentStatus(1);
        //最后登陆时间
        tuser.setLastLoginTime(new Date());
        //生成用户名
        String userName = cacheService.genUserNumber();
        //避免redis连接错误 不能正确生成用户名
        if(StringUtils.isNotBlank(userName)){
            tuser.setUserName(userName);
        }else{
            tuser.setUserName("why_"+UUIDUtils.createUUId());
        }
        tuser.setUserName(userName);
        //最关键的一步 保存用户openid
        tuser.setOperId(openId);
        //捕获所有获取用户信息异常
        try {
            um = new Users(accessToken.getAccessToken());
            User user = um.showUserById(openId);
            if(StringUtils.isNotBlank(user.getAvatarLarge())){
                tuser.setUserHeadImgUrl(user.getAvatarLarge());
            }else if(StringUtils.isNotBlank(user.getProfileImageUrl())){
                tuser.setUserHeadImgUrl(user.getProfileImageUrl());
            }
            tuser.setUserNickName(user.getScreenName());
            if ("m".equals(user.getGender())) {
                tuser.setUserSex(1);
            } else if ("f".equals(user.getGender())) {
                tuser.setUserSex(2);
            } else {
                tuser.setUserSex(1);
            }
        } catch (Exception e) {
            tuser.setUserSex(1);
            e.printStackTrace();
        }
        //首次登录
        try{
            terminalUserService.insertTerminalUser(tuser);
            session.setAttribute(Constant.terminalUser, tuser);
            request.setAttribute("redUrl","/frontTerminalUser/completeInfo.do?code="+UUIDUtils.createUUId());
            request.setAttribute("code","reg");
            return new ModelAndView("index/sina/result");
            //return new ModelAndView("redirect:/frontTerminalUser/completeInfo.do?code="+UUIDUtils.createUUId());
        }catch (Exception e){
            e.printStackTrace();
        }
        //遇到所有异常 跳到首页
        request.setAttribute("code",500);
        return new ModelAndView("index/sina/result");
        //return new ModelAndView(Constant.IndexPage);
    }*/



    /**
     * 新浪微博登录成功后重定向
     * @param request
     * @return
     */
    @RequestMapping(value = "/login-sina-weibo.do", method = RequestMethod.GET)
    public ModelAndView loginSinaWeibo(HttpServletRequest request)  {
        CmsTerminalUser sessionUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
        ModelAndView modelAndView = new ModelAndView();

        String callback = request.getParameter("callback");
        if (StringUtils.isNotBlank(callback)) {
        	modelAndView.setViewName("redirect:"+ callback);
        }else{
        	modelAndView.setViewName(Constant.IndexPage);
        }
        
        //当前已登录用户 不做任何处理
        if(null!=sessionUser){
        	if(StringUtils.isNotBlank(sessionUser.getUserId())){
        		return modelAndView;
        	}
        }
        String code = request.getParameter("code");
        if(StringUtils.isBlank(code)){
        	if(modelAndView.getViewName().contains("?")){
            	modelAndView.setViewName(modelAndView.getViewName()+"&error=loginFail");
            }else{
            	modelAndView.setViewName(modelAndView.getViewName()+"?error=loginFail");
            }
            return modelAndView;
        }
        String openId = "";
        weibo4j.http.AccessToken accessToken = null;
        Users um = null;
        //捕获所有验证异常 避免重复为同一第三方账号注册 必须保证openId在数据库唯一
        try {
            weibo4j.Oauth oauth = new weibo4j.Oauth();
            accessToken = oauth.getAccessTokenByCode(code);
            openId = accessToken.getUserUid();
            //未正确获取openId
            if(StringUtils.isEmpty(openId)){
            	if(modelAndView.getViewName().contains("?")){
                	modelAndView.setViewName(modelAndView.getViewName()+"&error=loginFail");
                }else{
                	modelAndView.setViewName(modelAndView.getViewName()+"?error=loginFail");
                }
                return modelAndView;
            }
            //根据openid查询用户 存在则直接登录返回
            Map<String,Object> params = new HashMap<String, Object>();
            params.put("openId",openId);
            CmsTerminalUser extUser =  terminalUserService.queryByWebOpenId(params);
            if(null!=extUser&&StringUtils.isNotBlank(extUser.getUserId())){
                if(extUser.getUserIsDisable()==1){
                    session.setAttribute(Constant.terminalUser,extUser);
                    
                    userIntegralDetailService.checkDayIntegral(extUser.getUserId());
                    //判断跳转的页面是否存在
                    if (StringUtils.isNotBlank(callback)) {
                    	if(callback.contains("?")){
                    		modelAndView.setViewName("redirect:"+ callback + "&userName=" + extUser.getUserName() + "&userId=" + extUser.getUserId() + "&userMobileNo=" + extUser.getUserMobileNo() + "&userHeadImgUrl=" + extUser.getUserHeadImgUrl());
                    	}else{
                    		modelAndView.setViewName("redirect:"+ callback + "?userName=" + extUser.getUserName() + "&userId=" + extUser.getUserId() + "&userMobileNo=" + extUser.getUserMobileNo() + "&userHeadImgUrl=" + extUser.getUserHeadImgUrl());
                    	}
                    }
                    return modelAndView;
                }else{
                    modelAndView.setViewName("redirect:/frontTerminalUser/userLogin.do?LoginType=3&code="+
                            UUIDUtils.createUUId());
                    if(modelAndView.getViewName().contains("?")){
                    	modelAndView.setViewName(modelAndView.getViewName()+"&error=loginFail");
                    }else{
                    	modelAndView.setViewName(modelAndView.getViewName()+"?error=loginFail");
                    }
                    return modelAndView;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            if(modelAndView.getViewName().contains("?")){
            	modelAndView.setViewName(modelAndView.getViewName()+"&error=loginFail");
            }else{
            	modelAndView.setViewName(modelAndView.getViewName()+"?error=loginFail");
            }
            return modelAndView;
        }
        CmsTerminalUser insertUser = new CmsTerminalUser();
        insertUser.setUserId(UUIDUtils.createUUId());
        insertUser.setCreateTime(new Date());
        insertUser.setUserIsDisable(Constant.USER_IS_ACTIVATE);
        insertUser.setUserType(1);
        insertUser.setUserIsLogin(1);
        //账号来源 3 微博
        insertUser.setRegisterOrigin(3);
        //用户城市来源
		int endIndex = request.getServerName().indexOf(".wenhuayun.cn");
		insertUser.setUserSiteId(request.getServerName().substring(0, endIndex));
        //评论状态正常
        insertUser.setCommentStatus(1);
        //最后登陆时间
        insertUser.setLastLoginTime(new Date());
        //最关键的一步 保存用户openid
        insertUser.setOperId(openId);
        //捕获所有获取用户信息异常
        try {
            um = new Users(accessToken.getAccessToken());
            User user = um.showUserById(openId);
            if(StringUtils.isNotBlank(user.getAvatarLarge())){
                insertUser.setUserHeadImgUrl(user.getAvatarLarge());
            }else if(StringUtils.isNotBlank(user.getProfileImageUrl())){
                insertUser.setUserHeadImgUrl(user.getProfileImageUrl());
            }
            if(StringUtils.isNotBlank(user.getScreenName())){
                insertUser.setUserName(EmojiFilter.filterEmoji(user.getScreenName()));
            }else{
                insertUser.setUserName("why_"+UUIDUtils.createUUId());
            }
            if ("m".equals(user.getGender())) {
                insertUser.setUserSex(1);
             } else if ("f".equals(user.getGender())) {
                insertUser.setUserSex(2);
             } else {
                insertUser.setUserSex(1);
             }
        } catch (Exception e) {
            insertUser.setUserName("why_"+UUIDUtils.createUUId());
            insertUser.setUserSex(1);
            e.printStackTrace();
        }
        //首次登录
        try{
            terminalUserService.insertTerminalUser(insertUser);
            session.setAttribute(Constant.terminalUser, insertUser);
            
            userIntegralDetailService.registerAddIntegral(insertUser.getUserId());

            //判断跳转的页面是否存在
            if (StringUtils.isNotBlank(callback)) {
            	if(callback.contains("?")){
            		modelAndView.setViewName("redirect:"+ callback + "&userName=" + insertUser.getUserName() + "&userId=" + insertUser.getUserId() + "&userMobileNo=" + insertUser.getUserMobileNo() + "&userHeadImgUrl=" + insertUser.getUserHeadImgUrl());
            	}else{
            		modelAndView.setViewName("redirect:"+ callback + "?userName=" + insertUser.getUserName() + "&userId=" + insertUser.getUserId() + "&userMobileNo=" + insertUser.getUserMobileNo() + "&userHeadImgUrl=" + insertUser.getUserHeadImgUrl());
            	}
                return modelAndView;
            }
            //modelAndView.setViewName("redirect:/frontTerminalUser/completeInfo.do?code="+UUIDUtils.createUUId());
            return modelAndView;
        }catch (Exception e){
        	if(modelAndView.getViewName().contains("?")){
            	modelAndView.setViewName(modelAndView.getViewName()+"&error=loginFail");
            }else{
            	modelAndView.setViewName(modelAndView.getViewName()+"?error=loginFail");
            }
            e.printStackTrace();
        }
        return modelAndView;
    }


}
