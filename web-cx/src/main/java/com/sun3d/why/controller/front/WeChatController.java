package com.sun3d.why.controller.front;

import com.alibaba.fastjson.JSON;
import com.sun3d.why.model.AccessToken;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.WxUserInfo;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.model.extmodel.WxConfig;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.SyncCmsTerminalUserService;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.util.CommonUtil;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.EmojiFilter;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import com.sun3d.why.webservice.api.util.TerminalUserConstant;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by niu on 2015/8/28.
 */
@RequestMapping("/wechat")
@Controller
public class WeChatController {

    private Logger logger = LoggerFactory.getLogger(WeChatController.class);
    @Autowired
    private HttpSession session;

    @Autowired
    private WxConfig wxConfig;

    @Autowired
    private CmsTerminalUserService terminalUserService;

    @Autowired
    private StaticServer staticServer;

    @Autowired
    private SyncCmsTerminalUserService syncCmsTerminalUserService;
    
    @Autowired
    private UserIntegralDetailService userIntegralDetailService;

    @RequestMapping("/login")
    public  ModelAndView  wxLogin (HttpServletRequest request){

        ModelAndView model = new ModelAndView();
        if(session.getAttribute(Constant.terminalUser)!=null){
            model.setViewName(Constant.IndexPage);
            return  model;
        }
        try {
            //String basePath = request.getScheme() + "://" + request.getServerName() + request.getContextPath()+"/wechat/login-weChat.do";
            String basePath=wxConfig.getWxCallBackUrl();
            String callback = request.getParameter("callback");
            //判断是否进行跳转到xh365首页
            if (StringUtils.isNotBlank(callback)) {
                basePath += "?callback=" +callback;
            }else{
                //basePath += "?reqSource="+request.getScheme() + "://" + request.getServerName() + request.getContextPath();
            }
            //必须编码回调地址
            String redUrl= URLEncoder.encode(basePath,"UTF-8");
            //String  wxState=UUIDUtils.createUUId();
            String  wxState=request.getScheme() + "://" + request.getServerName() + request.getContextPath();
            //session.setAttribute("wxState",wxState);
            model.setViewName("redirect:https://open.weixin.qq.com/connect/qrconnect?appid=wx4f0874059d0a25cd&redirect_uri="+redUrl+"&response_type=code&scope=snsapi_login&state="+wxState+"#wechat_redirect");
            return model;
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        model.setViewName("redirect:/frontActivity/frontActivityIndex.do");
        return  model;
    }



    /*        logger.info("--------------->getAccess_token---"+accessToken.getAccess_token());
        logger.info("--------------->getOpenid----"+accessToken.getOpenid());*/
    /*        logger.error("data-------------->"+data);
        request.setAttribute("redata",data);*/


/*        request.setAttribute("userInfo",userInfo);

        request.setAttribute("userData",httpResponseText2.getData());*/
/*    request.setAttribute("code", code);
    request.setAttribute("state",state);*/

    /***  登录成功后回调
     * @param request
     * @param code
     * @param state
     * @return
     */
    //消息在服务端中转 保证在任何环境都可登陆
    @RequestMapping("/login-weChat")
    public ModelAndView loginweChat(HttpServletRequest request,String code,String state){
        String callback = request.getParameter("callback");
        String redUrl="";

        if(StringUtils.isEmpty(state)||StringUtils.isEmpty(code)){
            return new ModelAndView(Constant.IndexPage);
        }

        if(StringUtils.isNotBlank(callback)){
            redUrl = state+"/wechat/loginWeChat.do?callback="+callback+"&code="+code;
        }else{
            redUrl = state+"/wechat/loginWeChat.do?code="+code;
        }
        return new ModelAndView("redirect:"+redUrl);
    }

    /*@RequestMapping("/loginWeChat")
    public ModelAndView login(String callback,String code,String state){

        ModelAndView model  =new ModelAndView();
        model.setViewName("index/wx/result");

        if(StringUtils.isEmpty(code)){
            model.addObject("serverBusy","1");
            return model;
        }
        try{
            //获取回调code 换取openid,accessToken
            String url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=wx4f0874059d0a25cd&secret=0a1909c4f5ab43690a7b9ea4c250842d&code="+code+"&grant_type=authorization_code";
            HttpResponseText accessTokenText =  CommonUtil.httpsRequest(url);
            AccessToken accessToken = JSON.parseObject(accessTokenText.getData(),AccessToken.class);
            try{
                //已存在用户直接返回
                if(accessToken!=null&&StringUtils.isNotBlank(accessToken.getOpenid())){
                    Map<String,Object> params = new HashMap<String, Object>();
                    params.put("openId",accessToken.getOpenid());
                    CmsTerminalUser extUser = terminalUserService.queryByWebOpenId(params);
                    if(extUser!=null&&StringUtils.isNotBlank(extUser.getUserId())){
                        if(extUser.getUserIsDisable()==1){
                            session.setAttribute(Constant.terminalUser,extUser);
                            model.addObject("extUser",1);
                            //判断跳转的页面是否存在
                            if (StringUtils.isNotBlank(callback)) {
                                model.setViewName("redirect:"+ callback + "?userName=" + extUser.getUserName() + "&userId=" + extUser.getUserId() + "&userMobileNo=" + extUser.getUserMobileNo() + "&userHeadImgUrl=" + extUser.getUserHeadImgUrl());
                                return model;
                            }
                            return model;
                        }else{
                            return new ModelAndView("redirect:/frontTerminalUser/userLogin.do?LoginType=4&code="+
                                    UUIDUtils.createUUId());
                        }
                    }
                }else{
                    //未能正确获取openid 直接返回
                    model.addObject("serverBusy","2");
                    return model;
                }
            }catch (Exception e){
                e.printStackTrace();
                //任何异常都不向下执行  避免微信系统或本系统繁忙 造成重复注册 必须保证openId在数据库唯一
                model.addObject("serverBusy","1");
                return model;
            }
            //正确获取accessToken后获取用户信息
            String userInfoUrl = "https://api.weixin.qq.com/sns/userinfo?access_token="+accessToken.getAccess_token()+"&openid="+accessToken.getOpenid();
            WxUserInfo userInfo = null;
            try{
                HttpResponseText userInfoText =CommonUtil.httpsRequest(userInfoUrl);
                userInfo = JSON.parseObject(userInfoText.getData(),WxUserInfo.class);
            }catch (Exception userInfoException){
                userInfoException.printStackTrace();
            }
            CmsTerminalUser user = new CmsTerminalUser();
            user.setUserId(UUIDUtils.createUUId());
            //最关键的一步  设置openId
            user.setOperId(accessToken.getOpenid());
            //捕获所有获取用户信息异常 避免因获取信息失败造成用户注册失败
            try{
                if(StringUtils.isNotBlank(userInfo.getNickname())){
                    user.setUserName(userInfo.getNickname());
                }else{
                    user.setUserName("why_"+UUIDUtils.createUUId());
                }
                if(StringUtils.isNotBlank(userInfo.getHeadimgurl())){
                    user.setUserHeadImgUrl(userInfo.getHeadimgurl());
                }
                if(userInfo.getSex()!=null){
                    user.setUserSex(Integer.valueOf(userInfo.getSex()));
                }
            }catch (Exception userSexException){
                userSexException.printStackTrace();
                user.setUserName("why_"+UUIDUtils.createUUId());
                user.setUserSex(1);
            }
            user.setCreateTime(new Date());
            user.setUserIsDisable(Constant.USER_IS_ACTIVATE);
            user.setUserType(1);
            //账号来源 微信 4
            user.setRegisterOrigin(4);
            user.setCommentStatus(1);
            user.setLastLoginTime(new Date());

            try{
                terminalUserService.insertTerminalUser(user);
                session.setAttribute(Constant.terminalUser, user);
                model.addObject("code",UUIDUtils.createUUId());
                //判断跳转的页面是否存在
                if (StringUtils.isNotBlank(callback)) {
                    model.setViewName("redirect:"+ callback + "?userName=" + user.getUserName() + "&userId=" + user.getUserId() + "&userMobileNo=" + user.getUserMobileNo() + "&userHeadImgUrl=" + user.getUserHeadImgUrl());
                    return model;
                }
            }catch (Exception saveException){
                saveException.printStackTrace();
                model.addObject("serverBusy","3");
            }
            //所有数据处理异常
        }catch (Exception dataHandleException){
            dataHandleException.printStackTrace();
            model.addObject("serverBusy","4");
        }
        return  model;
    }*/
//2015.1.20 统一拿用户的unionId
    @RequestMapping("/loginWeChat")
    public ModelAndView loginWeChat(HttpServletRequest request,String callback,String code,String state){

        ModelAndView model  =new ModelAndView();
        model.setViewName("index/wx/result");
        if(StringUtils.isEmpty(code)){
            model.addObject("serverBusy","1");
            return model;
        }
        WxUserInfo userInfo = null;
        try{
            //获取回调code 换取openid,accessToken
            String url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=wx4f0874059d0a25cd&secret=0a1909c4f5ab43690a7b9ea4c250842d&code="+code+"&grant_type=authorization_code";
            HttpResponseText accessTokenText =  CommonUtil.httpsRequest(url);
            AccessToken accessToken = JSON.parseObject(accessTokenText.getData(),AccessToken.class);
            try{
                //已存在用户直接返回
                if(accessToken!=null&&StringUtils.isNotBlank(accessToken.getOpenid())){
                    //正确获取accessToken后获取用户信息
                    String userInfoUrl = "https://api.weixin.qq.com/sns/userinfo?access_token="+accessToken.getAccess_token()+"&openid="+accessToken.getOpenid();
                    try{
                        HttpResponseText userInfoText =CommonUtil.httpsRequest(userInfoUrl);
                        userInfo = JSON.parseObject(userInfoText.getData(),WxUserInfo.class);
                    }catch (Exception userInfoException){
                        userInfoException.printStackTrace();
                        //获取用户信息异常
                        model.addObject("serverBusy","5");
                        return model;
                    }

                    if(StringUtils.isEmpty(userInfo.getUnionid())){
                        //未能获取用户unionId 不能确定用户
                        model.addObject("serverBusy","6");
                        return model;
                    }

                    Map<String,Object> params = new HashMap<String, Object>();
                    params.put("openId",userInfo.getUnionid());
                    CmsTerminalUser extUser = terminalUserService.queryByWebOpenId(params);
                    if(extUser!=null&&StringUtils.isNotBlank(extUser.getUserId())){
                        if(extUser.getUserIsDisable()==1){
                            session.setAttribute(Constant.terminalUser,extUser);
                            
                            userIntegralDetailService.checkDayIntegral(extUser.getUserId());
                            
                            model.addObject("extUser",1);
                            //判断跳转的页面是否存在
                            if (StringUtils.isNotBlank(callback)) {
                                model.setViewName("redirect:"+ callback + "?userName=" + extUser.getUserName() + "&userId=" + extUser.getUserId() + "&userMobileNo=" + extUser.getUserMobileNo() + "&userHeadImgUrl=" + extUser.getUserHeadImgUrl());
                                return model;
                            }
                            return model;
                        }else{
                            return new ModelAndView("redirect:/frontTerminalUser/userLogin.do?LoginType=4&code="+
                                    UUIDUtils.createUUId());
                        }
                    }
                }else{
                    //未能正确获取openid 直接返回
                    model.addObject("serverBusy","2");
                    return model;
                }
            }catch (Exception e){
                e.printStackTrace();
                //任何异常都不向下执行  避免微信系统或本系统繁忙 造成重复注册 必须保证openId在数据库唯一
                model.addObject("serverBusy","1");
                return model;
            }

            CmsTerminalUser user = new CmsTerminalUser();
            user.setUserId(UUIDUtils.createUUId());
            //最关键的一步  设置openId
            user.setOperId(userInfo.getUnionid());
            //捕获所有获取用户信息异常 避免因获取信息失败造成用户注册失败
            try{
                if(StringUtils.isNotBlank(userInfo.getNickname())){
                    user.setUserName(EmojiFilter.filterEmoji(userInfo.getNickname()));
                }else{
                    user.setUserName("why_"+UUIDUtils.createUUId());
                }
                if(StringUtils.isNotBlank(userInfo.getHeadimgurl())){
                    user.setUserHeadImgUrl(userInfo.getHeadimgurl());
                }
                if(userInfo.getSex()!=null){
                    user.setUserSex(Integer.valueOf(userInfo.getSex()));
                }
            }catch (Exception userSexException){
                userSexException.printStackTrace();
                user.setUserName("why_"+UUIDUtils.createUUId());
                user.setUserSex(1);
            }
            user.setCreateTime(new Date());
            user.setUserIsDisable(Constant.USER_IS_ACTIVATE);
            user.setUserType(1);
            //账号来源 微信 4
            user.setRegisterOrigin(4);
            //用户城市来源
    		int endIndex = request.getServerName().indexOf(".wenhuayun.cn");
    		user.setUserSiteId(request.getServerName().substring(0, endIndex));
            user.setCommentStatus(1);
            user.setLastLoginTime(new Date());

            try{
                terminalUserService.insertTerminalUser(user);
                session.setAttribute(Constant.terminalUser, user);
                
                userIntegralDetailService.registerAddIntegral(user.getUserId());

                model.addObject("code",UUIDUtils.createUUId());
                //判断跳转的页面是否存在
                if (StringUtils.isNotBlank(callback)) {
                    model.setViewName("redirect:"+ callback + "?userName=" + user.getUserName() + "&userId=" + user.getUserId() + "&userMobileNo=" + user.getUserMobileNo() + "&userHeadImgUrl=" + user.getUserHeadImgUrl());
                    return model;
                }
            }catch (Exception saveException){
                saveException.printStackTrace();
                model.addObject("serverBusy","3");
            }
            //所有数据处理异常
        }catch (Exception dataHandleException){
            dataHandleException.printStackTrace();
            model.addObject("serverBusy","4");
        }
        return  model;
    }



}
