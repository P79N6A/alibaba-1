package com.sun3d.why.webservice.controller;
import com.alibaba.druid.util.StringUtils;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CmsAndroidVersionService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.webservice.service.TerminalUserAppService;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.ParseException;
/**
 * 手机app接口 用户注册 登录
 *
 */
@RequestMapping("/login")
@Controller
public class LoginAppController {
    private Logger logger = Logger.getLogger(LoginAppController.class);
    @Autowired
    private CmsAndroidVersionService cmsAndroidVersionService;
    @Autowired
    private TerminalUserAppService terminalUserAppService;
    /**
     * app用户注册
     * @param user       用户对象
     * @param code       手机验证码
     * return json 13102验证码错误 14101短信发送失败
     */
    @RequestMapping(value = "/doRegister")
    public String doRegister(CmsTerminalUser user,HttpServletResponse response,String code) throws Exception {
        String json = "";
        if (user!=null && StringUtils.isEmpty(user.getUserName())) {
            json = JSONResponse.commonResultFormat(10101, "昵称不能为空!", null);
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().print(json);
            return null;
        }
        if (user!=null && StringUtils.isEmpty(user.getUserPwd())) {
            json = JSONResponse.commonResultFormat(10102, "密码不能为空!", null);
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().print(json);
            return null;
        }
        if (user!=null && StringUtils.isEmpty(user.getUserMobileNo())) {
            json = JSONResponse.commonResultFormat(13104, "手机号码不能为空!", null);
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().print(json);
            return null;
        }
        if (code!=null && StringUtils.isEmpty(code)) {
            json = JSONResponse.commonResultFormat(13103, "验证码不能为空!", null);
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().print(json);
            return null;
        }
        try {
            json=terminalUserAppService.queryTerminalUserMobileExist(code,user);
        }catch (Exception e){
            e.printStackTrace();
            logger.info("user register error!"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        return null;
    }

    /**
     * app手机号码获取验证码
     * @param userMobileNo 手机号码
     */
    @RequestMapping(value = "/userCode")
    public String userCode(HttpServletResponse response,String userMobileNo) throws Exception {
        String json = "";
        try {
            if (userMobileNo != null && StringUtils.isEmpty(userMobileNo)) {
                json = JSONResponse.commonResultFormat(13104, "手机号码为空!", null);
            } else {
                if (Constant.isMobile(userMobileNo)) {
                    json = terminalUserAppService.sendTerminUserCode(userMobileNo);
                } else {
                    json = JSONResponse.commonResultFormat(10222, "手机号码不规范!", null);
                }
            }
        }catch (Exception e){
            e.printStackTrace();
            logger.error("get code error!"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        return null;
    }

    /**
     * app 用户登录
     * @return json格式数据
     */
    @RequestMapping(value = "/doLogin")
    public String indexLogin(CmsTerminalUser user,HttpServletResponse response) throws IOException {
        String json = "";
        try {
            if (StringUtils.isEmpty(user.getUserMobileNo())) {
                json = JSONResponse.commonResultFormat(11101, "手机号码为空!", null);
            }
            if ( StringUtils.isEmpty(user.getUserPwd())) {
                json = JSONResponse.commonResultFormat(11103, "密码为空!", null);
            }
            json=terminalUserAppService.terminalLogin(user);
        }catch (Exception e){
            e.printStackTrace();
            logger.error("错误信息:"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().print(json);
        return null;
    }

    /**
     * app版本更新
     * @return json
     * @throws java.io.IOException
     */
    @RequestMapping(value = "/appAndroidVersion")
    public String appAndroidVersion( HttpServletResponse response) throws IOException {
        String json="";
        try {
             json=cmsAndroidVersionService.queryAppAndroidVersionList();
        }catch (Exception e){
              e.printStackTrace();
              logger.error("query androidVersion error!"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app第三方登录文化云平台
     * @param terminalUser 用户对象
     */
    @RequestMapping(value = "/appOpenUser")
    public String appOpenUser(HttpServletResponse response, CmsTerminalUser terminalUser) throws IOException  {
        String json = "";
        try {
			json=terminalUserAppService.queryTerminalUserByOpenId(terminalUser);
		} catch (ParseException e) {
            e.printStackTrace();
			logger.info("login openUser error"+e.getMessage());
		}
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * app产品介绍
     */
    @RequestMapping(value = "/productInfornation")
    public String productInfornation(HttpServletResponse response) throws IOException {
        String json = "";
        String productInfornation = Constant.productInfornation;
        json = JSONResponse.commonResultFormat(0, productInfornation, null);
        response.getWriter().write(json);
        return null;
    }
}


