package com.sun3d.why.controller.front;

import com.qq.connect.api.OpenID;
import com.qq.connect.api.qzone.UserInfo;
import com.qq.connect.javabeans.AccessToken;
import com.qq.connect.javabeans.qzone.UserInfoBean;
import com.qq.connect.oauth.Oauth;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.model.tencent.TencentOauth;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.SyncCmsTerminalUserService;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.EmojiFilter;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.TerminalUserConstant;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;


/**
 * Created by niu on 2015/10/15.
 * qq登录
 */

@Controller
public class TencentController {

    private Logger logger = LoggerFactory.getLogger(WeChatController.class);
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

    @RequestMapping("/qq/login")
    public ModelAndView qqLogin (HttpServletRequest request,HttpServletResponse response){
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
                return modelAndView;
        	}
        }
        try {
            modelAndView.setViewName("redirect:"+new TencentOauth().getAuthorizeURL(request));
            //response.setContentType("text/html;charset=utf-8");
            //response.sendRedirect(new Oauth().getAuthorizeURL(request));
        } catch (Exception e) {
            e.printStackTrace();
            if(modelAndView.getViewName().contains("?")){
            	modelAndView.setViewName(modelAndView.getViewName()+"&error=loginFail");
            }else{
            	modelAndView.setViewName(modelAndView.getViewName()+"?error=loginFail");
            }
        }
        return modelAndView;
    }

    /******
     * 窗口式打开使用该回调 返回code 关闭子页面 刷新父页面 请勿删除
     * @param request
     * @return
     */
/*    @RequestMapping(value = "/index",method = RequestMethod.GET)
    public ModelAndView afterLogin(HttpServletRequest request){
        CmsTerminalUser sessionUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
        //当前已登录用户 不做任何处理
        if(null!=sessionUser){
            request.setAttribute("code","sessionUser");
            return new ModelAndView("index/qq/result");
            //return new ModelAndView(Constant.IndexPage);
        }
        AccessToken accessTokenObj = null;
        try {
            accessTokenObj = (new Oauth()).getAccessTokenByRequest(request);
        } catch (Exception e) {
            e.printStackTrace();
        }

        String accessToken = null;
        String openID = null;

        //网站被CSRF攻击了或者用户取消了授权
        if (accessTokenObj==null||StringUtils.isEmpty(accessTokenObj.getAccessToken())) {
            request.setAttribute("code",500);
            return new ModelAndView("index/qq/result");
            //return new ModelAndView(Constant.IndexPage);
        } else {
            //捕获所有异常 避免重复注册
            try {
                accessToken = accessTokenObj.getAccessToken();
                // 利用获取到的accessToken 去获取当前用的openid
                OpenID openIDObj = new OpenID(accessToken);
                openID = openIDObj.getUserOpenID();
                //未获取openId
                if (StringUtils.isEmpty(openID)){
                    return new ModelAndView(Constant.IndexPage);
                }
                //根据openid查询用户 存在则直接登录返回
                Map<String,Object> params = new HashMap<String, Object>();
                params.put("openId",openID);
                CmsTerminalUser extUser =  terminalUserService.queryByWebOpenId(params);
                if(null!=extUser&&StringUtils.isNotBlank(extUser.getUserId())){
                    if(extUser.getUserIsDisable()==1){
                        session.setAttribute(Constant.terminalUser,extUser);
                        request.setAttribute("code","extUser");
                        return new ModelAndView("index/qq/result");
                    }else{
                        request.setAttribute("code","badUser");
                        request.setAttribute("redUrl","/frontTerminalUser/userLogin.do?LoginType=2&code="+UUIDUtils.createUUId());
                        return new ModelAndView("index/qq/result");
                        *//*return new ModelAndView("redirect:/frontTerminalUser/userLogin.do?LoginType=2&code="+
                                UUIDUtils.createUUId());*//*
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("code",500);
                return new ModelAndView("index/qq/result");
                //return new ModelAndView(Constant.IndexPage);
            }
            if(StringUtils.isBlank(openID)){
                request.setAttribute("code",500);
                return new ModelAndView("index/qq/result");
                //return new ModelAndView(Constant.IndexPage);
            }
            //正确获取openid
            CmsTerminalUser tuser = new CmsTerminalUser();
            String userId = UUIDUtils.createUUId();

            tuser.setUserId(userId);
            tuser.setCreateTime(new Date());
            tuser.setLastLoginTime(new Date());
            tuser.setCommentStatus(1);
            tuser.setUserIsLogin(1);
            tuser.setUserIsDisable(Constant.USER_IS_ACTIVATE);
            tuser.setRegisterOrigin(2);//2为QQ登录

            String userName = cacheService.genUserNumber();
            //避免redis连接错误 不能正确生成用户名
            if(StringUtils.isNotBlank(userName)){
                tuser.setUserName(userName);
            }else{
                tuser.setUserName("why_"+UUIDUtils.createUUId());
            }
            tuser.setUserType(1);
            //最重要的一步
            tuser.setOperId(openID);
            //捕获获取所有用户信息异常
            try{
                UserInfo qzoneUserInfo = new UserInfo(accessToken, openID);
                UserInfoBean userInfoBean = null;
                userInfoBean = qzoneUserInfo.getUserInfo();
                if (userInfoBean!=null && userInfoBean.getRet() == 0) {
                    if("男".equals(userInfoBean.getGender())){
                        tuser.setUserSex(1);
                    }else if("女".equals(userInfoBean.getGender())){
                        tuser.setUserSex(2);
                    }else{
                        tuser.setUserSex(1);
                    }
                    tuser.setUserNickName(userInfoBean.getNickname());
                    //头像
                    if(StringUtils.isNotBlank(userInfoBean.getAvatar().getAvatarURL100())){
                        tuser.setUserHeadImgUrl(userInfoBean.getAvatar().getAvatarURL100());
                    }
                }
            }catch (Exception e){
                tuser.setUserSex(1);
                e.printStackTrace();
            }
            try{
                terminalUserService.insertTerminalUser(tuser);
                session.setAttribute(Constant.terminalUser,tuser);
                request.setAttribute("code","reg");
                request.setAttribute("redUrl","/frontTerminalUser/completeInfo.do?code="+UUIDUtils.createUUId());
                return new ModelAndView("index/qq/result");
                //return new ModelAndView("redirect:/frontTerminalUser/completeInfo.do?code="+UUIDUtils.createUUId());
            }catch (Exception e){
                e.printStackTrace();
            }
        }
        request.setAttribute("code",500);
        return new ModelAndView("index/qq/result");
        //return new ModelAndView(Constant.IndexPage);
    }*/


    //登录成功回调地址
    @RequestMapping(value = "/index",method = RequestMethod.GET)
    public ModelAndView afterLogin(HttpServletRequest request){
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
        AccessToken accessTokenObj = null;
        try {
            accessTokenObj = (new Oauth()).getAccessTokenByRequest(request);
        } catch (Exception e) {
        	if(modelAndView.getViewName().contains("?")){
            	modelAndView.setViewName(modelAndView.getViewName()+"&error=loginFail");
            }else{
            	modelAndView.setViewName(modelAndView.getViewName()+"?error=loginFail");
            }
            e.printStackTrace();
        }
        String accessToken = null;
        String openID = null;
        //网站被CSRF攻击了或者用户取消了授权
        if (accessTokenObj==null || StringUtils.isEmpty(accessTokenObj.getAccessToken())) {
        	if(modelAndView.getViewName().contains("?")){
            	modelAndView.setViewName(modelAndView.getViewName()+"&error=loginFail");
            }else{
            	modelAndView.setViewName(modelAndView.getViewName()+"?error=loginFail");
            }
            return modelAndView;
        } else {
            //捕获所有异常 避免重复注册 必须保证openId在数据库唯一
            try {
                accessToken = accessTokenObj.getAccessToken();
                // 利用获取到的accessToken 去获取当前用的openid
                OpenID openIDObj = new OpenID(accessToken);
                openID = openIDObj.getUserOpenID();
                if (StringUtils.isEmpty(openID)){
                	if(modelAndView.getViewName().contains("?")){
                    	modelAndView.setViewName(modelAndView.getViewName()+"&error=loginFail");
                    }else{
                    	modelAndView.setViewName(modelAndView.getViewName()+"?error=loginFail");
                    }
                    return modelAndView;
                }
                //根据openid查询用户 存在则直接登录返回
                Map<String,Object> params = new HashMap<String, Object>();
                params.put("openId",openID);
                CmsTerminalUser extUser =  terminalUserService.queryByWebOpenId(params);
                if(null!=extUser&&StringUtils.isNotEmpty(extUser.getUserId())){
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
                        modelAndView.setViewName("redirect:/frontTerminalUser/userLogin.do?LoginType=2&code=" +
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
            if(StringUtils.isBlank(openID)){
            	if(modelAndView.getViewName().contains("?")){
                	modelAndView.setViewName(modelAndView.getViewName()+"&error=loginFail");
                }else{
                	modelAndView.setViewName(modelAndView.getViewName()+"?error=loginFail");
                }
                return modelAndView;
            }
            //正确获取openid
            CmsTerminalUser insertUser = new CmsTerminalUser();
            insertUser.setUserId(UUIDUtils.createUUId());
            insertUser.setCreateTime(new Date());
            insertUser.setLastLoginTime(new Date());
            insertUser.setCommentStatus(1);
            insertUser.setUserIsLogin(1);
            insertUser.setUserIsDisable(Constant.USER_IS_ACTIVATE);
            //2为QQ登录
            insertUser.setRegisterOrigin(2);
            //用户城市来源
    		int endIndex = request.getServerName().indexOf(".wenhuayun.cn");
    		insertUser.setUserSiteId(request.getServerName().substring(0, endIndex));
            insertUser.setUserType(1);
            //最重要的一步 设置opendId
            insertUser.setOperId(openID);
            //捕获获取所有用户信息异常
            try{
                UserInfo qzoneUserInfo = new UserInfo(accessToken, openID);
                UserInfoBean userInfoBean = null;
                userInfoBean = qzoneUserInfo.getUserInfo();
                if (userInfoBean!=null && userInfoBean.getRet() == 0) {
                    if("男".equals(userInfoBean.getGender())){
                        insertUser.setUserSex(1);
                    }else if("女".equals(userInfoBean.getGender())){
                        insertUser.setUserSex(2);
                    }else{
                        insertUser.setUserSex(1);
                    }
                    if(StringUtils.isNotBlank(userInfoBean.getNickname())){
                        insertUser.setUserName(EmojiFilter.filterEmoji(userInfoBean.getNickname()));
                    }else{
                        insertUser.setUserName("why_"+UUIDUtils.createUUId());
                    }
                    //头像
                    if(StringUtils.isNotBlank(userInfoBean.getAvatar().getAvatarURL100())){
                        insertUser.setUserHeadImgUrl(userInfoBean.getAvatar().getAvatarURL100());
                    }
                }
            }catch (Exception e){
                insertUser.setUserName("why_"+UUIDUtils.createUUId());
                insertUser.setUserSex(1);
                e.printStackTrace();
            }
            try{
                terminalUserService.insertTerminalUser(insertUser);
                session.setAttribute(Constant.terminalUser,insertUser);
                
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
                //modelAndView.setViewName("redirect:/frontTerminalUser/completeInfo.do?code=" + UUIDUtils.createUUId());
                return modelAndView;
            }catch (Exception e){
            	if(modelAndView.getViewName().contains("?")){
                	modelAndView.setViewName(modelAndView.getViewName()+"&error=loginFail");
                }else{
                	modelAndView.setViewName(modelAndView.getViewName()+"?error=loginFail");
                }
                e.printStackTrace();
            }
        }
        return  modelAndView;
    }

    /**
     * 因目前回调地址限制 只能用index.do  备用回调地址 当index.do被占用时  替换回调地址  修改配置文件的回调地址  复制上面逻辑即可
     * @param request
     * @return
     */
    @RequestMapping("/qq-login")
    public ModelAndView qqLogin(HttpServletRequest request){
        return null;
    }


}
