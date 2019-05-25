package com.sun3d.why.controller.wechat;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.WxUserInfo;
import com.sun3d.why.model.extmodel.WxCallBack;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.util.CommonUtil;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.EmojiFilter;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpResponseText;

/**
 * 微信服务号微信登录--->与网站二维码授权一样  创建用户  保证该用户必须唯一
 */
@Controller
@RequestMapping("/wxUser")
public class WxUserController {

    @Autowired
    private CmsTerminalUserService terminalUserService;
    
    @Autowired
    private UserIntegralDetailService userIntegralDetailService;

    @Autowired
    private HttpSession session;

    //回调地址
    @Autowired
    private WxCallBack wxCallBack;

    /**
     * 静默调用
     * @param request
     * @param type	登录回调地址
     * @return
     * @throws UnsupportedEncodingException
     */
    @RequestMapping(value = "/silentInvoke")
    public ModelAndView silentInvoke(HttpServletRequest request,String type) throws UnsupportedEncodingException {
        ModelAndView modelAndView = new ModelAndView();
        CmsTerminalUser sessionUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
        if (StringUtils.isNotBlank(type)) {
        	modelAndView.setViewName("redirect:"+ type);
        }else{
        	modelAndView.setViewName("redirect:/wechat/index.do");
        }
        if(null!=sessionUser){
        	if(StringUtils.isNotBlank(sessionUser.getUserId())){
                return modelAndView;
        	}
        }
        StringBuffer sb = new StringBuffer("https://open.weixin.qq.com/connect/oauth2/authorize?appid=");
        //回调地址
        String redirectUri = wxCallBack.getWxSilentCallBack();
        if(StringUtils.isNotBlank(type)){
        	redirectUri = wxCallBack.getWxSilentCallBack()+"?type="+type;
        }
        sb.append(Constant.WX_APP_ID).append("&redirect_uri=")
          .append(URLEncoder.encode(redirectUri, "UTF-8"))
          .append("&response_type=code&scope=snsapi_base&state=").append(request.getContextPath())
          .append("#wechat_redirect");
/*        String reqUrl = "https://open.weixin.qq.com/connect/oauth2/authorize?appid="+Constant.WX_APP_ID+"&redirect_uri="+URLEncoder.encode(wxCallBack.getWxSilentCallBack(),"UTF-8")+"&response_type=code&scope=snsapi_base&state="+request.getContextPath()+"#wechat_redirect";*/
        modelAndView.setViewName("redirect:"+sb.toString());
        return  modelAndView;
    }


    /**
     * 静默调用回调 404--去授权   500--未正确获取信息 不做任何操作   200--已授权且注册成功
     * @param code
     * @param state
     * @param type	登录回调地址
     * @return
     */
    @RequestMapping(value = "/silentBack")
    public ModelAndView silentBack(String code,String state,String type){
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("wechat/user/silentBack");
        modelAndView.addObject("type", type);
        if(StringUtils.isBlank(code)){
            modelAndView.addObject("resCode", 500);
            return modelAndView;
        }
        modelAndView.addObject("state",state);
        //根据code获取openId
        StringBuffer sb = new StringBuffer("https://api.weixin.qq.com/sns/oauth2/access_token?appid=");
                     sb.append(Constant.WX_APP_ID).append("&secret=").append(Constant.WX_APP_SECRET)
                       .append("&code=").append(code).append("&grant_type=authorization_code");
/*        String _thisUrl = "https://api.weixin.qq.com/sns/oauth2/access_token?appid="+Constant.WX_APP_ID+"&secret="+Constant.WX_APP_SECRET+"&code="+code+"&grant_type=authorization_code";*/
        try{
            //先设置500
            modelAndView.addObject("resCode",500);
            HttpResponseText res =  CommonUtil.httpsRequest(sb.toString());
            //返回结果不为空
            if(res!=null && res.getData()!=null) {
                JSONObject jsonObject = JSON.parseObject(res.getData());
                //String access_token = (String) jsonObject.get("access_token");
                String openid = (String) jsonObject.get("openid");
                //根据openId查询当前用户 存在则直接取出该用户
                if(StringUtils.isNotBlank(openid)){
                    CmsTerminalUser user = terminalUserService.queryByWxOpenId(openid);
                    if(user==null){
                        modelAndView.addObject("resCode", 404);
                        return modelAndView;
                    }else{
                        session.setAttribute(Constant.terminalUser,user);
                        modelAndView.addObject("resCode", 200);
                        return modelAndView;
                    }
                }
            }
        }catch (Exception e){
            modelAndView.addObject("resCode", 500);
        }
        return  modelAndView;
    }


    /**
     * 授权页面
     * @param request
     * @param type	登录回调地址
     * @return
     * @throws UnsupportedEncodingException
     */
    @RequestMapping(value = "/authorize")
    public ModelAndView  authorize(HttpServletRequest request,String type) throws UnsupportedEncodingException {
        ModelAndView modelAndView = new ModelAndView();
        StringBuffer sb = new StringBuffer("https://open.weixin.qq.com/connect/oauth2/authorize?appid=");
      //回调地址
        String redirectUri = wxCallBack.getWxAuthorizeCallBack();
        if(StringUtils.isNotBlank(type)){
        	redirectUri = wxCallBack.getWxAuthorizeCallBack()+"?type="+type;
        }
        sb.append(Constant.WX_APP_ID).append("&redirect_uri=")
                .append(URLEncoder.encode(redirectUri,"UTF-8"))
                .append("&response_type=code&scope=snsapi_userinfo&state=")
                .append(request.getContextPath()).append("#wechat_redirect");
/*        String _thisUrl ="https://open.weixin.qq.com/connect/oauth2/authorize?appid="+Constant.WX_APP_ID+"&redirect_uri="+ URLEncoder.encode(wxCallBack.getWxAuthorizeCallBack(),"UTF-8")+"&response_type=code&scope=snsapi_userinfo&state="+request.getContextPath()+"#wechat_redirect";*/
        modelAndView.setViewName("redirect:"+sb.toString());
        return  modelAndView;
    }

    /**
     * 用户授权才能获取code否则code不存在（授权回调页面 401-->用户取消授权    200-->操作成功   500-->未正确获取用户信息或操作异常）
     * @param code
     * @param state
     * @param type	登录回调地址
     * @return
     */
    @RequestMapping("/wxCallBack")
    public ModelAndView wxCallBack (String code,String state,String type){
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("wechat/user/authorizeResult");
        modelAndView.addObject("type", type);
        modelAndView.addObject("state",state);
        //用户取消授权
        if(StringUtils.isBlank(code)){
            modelAndView.addObject("resCode",401);
            return modelAndView;
        }
        //先设置500
        modelAndView.addObject("resCode",500);
        try{
            StringBuffer tokenBuffer = new StringBuffer("https://api.weixin.qq.com/sns/oauth2/access_token?appid=");
            tokenBuffer.append(Constant.WX_APP_ID).append("&secret=").append(Constant.WX_APP_SECRET)
                       .append("&code=").append(code).append("&grant_type=authorization_code");
/*            String _thisUrl = "https://api.weixin.qq.com/sns/oauth2/access_token?appid="+Constant.WX_APP_ID+"&secret="+Constant.WX_APP_SECRET+"&code="+code+"&grant_type=authorization_code";*/
            HttpResponseText res =  CommonUtil.httpsRequest(tokenBuffer.toString());
            //返回结果不为空
            if(res!=null && res.getData()!=null){
                JSONObject jsonObject = JSON.parseObject(res.getData());
                String access_token = (String) jsonObject.get("access_token");
                String openid = (String) jsonObject.get("openid");
                //正确获取信息
                if(StringUtils.isNotBlank(access_token)&& StringUtils.isNotBlank(openid)){
/*                    String userInfoUrl = "https://api.weixin.qq.com/sns/userinfo?access_token="+access_token+"&openid="+openid+"&lang=zh_CN";*/

                    StringBuffer userInfoUrl = new StringBuffer("https://api.weixin.qq.com/sns/userinfo?access_token=");

                    userInfoUrl.append(access_token).append("&openid=").append(openid).append("&lang=zh_CN");

                    HttpResponseText userInfoRes = CommonUtil.httpsRequest(userInfoUrl.toString());

                    WxUserInfo wxUserInfo = null;

                    if(userInfoRes!=null&&userInfoRes.getData()!=null){
                        wxUserInfo= JSON.parseObject(userInfoRes.getData(),WxUserInfo.class);
                    }

                    if(wxUserInfo!=null){
                        String unionId =  wxUserInfo.getUnionid();
                        if(StringUtils.isBlank(unionId)){
                            throw  new RuntimeException();
                        }
                        //根据unionId查询当前用户是否存在
                        Map<String,Object> params = new HashMap<>();
                        params.put("openId",unionId);
                        CmsTerminalUser user =  terminalUserService.queryByWebOpenId(params);
                        if(user!=null){
                            //当前微信用户已存在(先在网站扫二维码登录的微信用户)
                            modelAndView.addObject("resCode",200);
                            //如果当前unionId用户存在 更新用户Imsi(即用户openId,并非unionId),便于静默调用使用
                            final CmsTerminalUser extUser = new CmsTerminalUser();
                            extUser.setUserId(user.getUserId());
                            extUser.setUserImsi(openid);
                            new Thread(new Runnable() {
                                @Override
                                public void run() {
                                    terminalUserService.updateTerminalUserById(extUser);
                                }
                            }).start();
                            //如果当前unionId用户存在 更新用户Imsi(即用户openId,并非unionId),便于静默调用使用
                            session.setAttribute(Constant.terminalUser,user);
                            return  modelAndView;
                        }else{
                            //新增用户
                            Date date =  new Date();
                            CmsTerminalUser insertUser = new CmsTerminalUser();
                            insertUser.setUserId(UUIDUtils.createUUId());
                            insertUser.setCreateTime(date);
                            insertUser.setRegisterOrigin(4);
                            insertUser.setLastSendSmsTime(date);
                            insertUser.setCommentStatus(1);
                            insertUser.setOperId(unionId);
                            insertUser.setUserName(EmojiFilter.filterEmoji(wxUserInfo.getNickname()));
                            insertUser.setUserHeadImgUrl(wxUserInfo.getHeadimgurl());
                            if(wxUserInfo.getSex()!=null){
                                insertUser.setUserSex(Integer.valueOf(wxUserInfo.getSex()));
                            }
                            insertUser.setUserType(1);
                            insertUser.setUserIsDisable(Constant.USER_IS_ACTIVATE);
                            insertUser.setUserImsi(openid);
                            terminalUserService.insertTerminalUser(insertUser);
                            modelAndView.addObject("resCode",200);
                            session.setAttribute(Constant.terminalUser,insertUser);
                            
                            userIntegralDetailService.registerAddIntegral(insertUser.getUserId());
                            
                            return  modelAndView;
                        }
                    }
                }

            }

        }catch (Exception e){
            modelAndView.addObject("resCode",500);
            e.printStackTrace();
        }

        return  modelAndView;
    }


}
