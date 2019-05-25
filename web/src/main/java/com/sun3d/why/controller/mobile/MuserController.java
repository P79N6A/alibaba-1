package com.sun3d.why.controller.mobile;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.model.request.common.SendCodeVO;
import com.culturecloud.model.request.common.UserLoginVO;
import com.sun3d.why.dao.CmsTerminalUserMapper;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.redis.RedisDAO;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.util.*;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value = "/muser")
public class MuserController {

    @Autowired
    private CmsTerminalUserService terminalUserService;
    @Autowired
    private CmsTerminalUserMapper userMapper;
    @Autowired
    private UserIntegralDetailService userIntegralDetailService;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private HttpSession session;
    @Resource
    private RedisDAO<String> redisDao;

    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public String toReg(HttpServletRequest request, String type) {
        request.setAttribute("type", type);
        return "/mobile/user/register";
    }

    @RequestMapping(value = "/regResult", method = RequestMethod.GET)
    public String regResult() {
        return "/mobile/user/regResult";
    }

    /**
     * 移动登陆
     *
     * @param m
     * @param request
     * @param type    （P：潘多拉个人中心 url:登陆前跳转页面）
     * @return
     */
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String login(String m, HttpServletRequest request, String type, String tips) {
        if (StringUtils.isNotEmpty(m) && m.length() == 11) {
            request.setAttribute("m", m);
        }
        request.setAttribute("type", type);
        request.setAttribute("tips", tips);
        return "/mobile/user/login";
    }

    @RequestMapping(value = "/forget", method = RequestMethod.GET)
    public String forget(HttpServletRequest request, String type) {
        request.setAttribute("type", type);
        return "/mobile/user/forget";
    }


    @RequestMapping(value = "/setPass", method = RequestMethod.POST)
    public ModelAndView setPass(String code, String type) {

        String userId = (String) session.getAttribute(Constant.SESSION_USER_ID);
        String sessionUserCode = (String) session.getAttribute(Constant.SESSION_USER_CODE);

        try {
            if (StringUtils.isBlank(userId) || userId.length() != 32 || StringUtils.isBlank(code)) {
                return new ModelAndView("redirect:/muser/forget.do?type=" + type);
            }
            CmsTerminalUser user = terminalUserService.queryTerminalUserById(userId);
            if (user == null) {
                return null;
            }
            if (!user.getRegisterCode().equals(code)) {
                return new ModelAndView("redirect:/muser/forget.do?type=" + type);
            }
            if (!Constant.USER_IS_ACTIVATE.equals(user.getUserIsDisable())) {
                return new ModelAndView("redirect:/muser/forget.do?type=" + type);
            }
            ModelAndView model = new ModelAndView();
            model.setViewName("/mobile/user/setPass");
            model.addObject("type", type);
            String reqCode = UUIDUtils.createUUId();
            model.addObject("reqCode", reqCode);
            session.setAttribute(Constant.SESSION_USER_CODE, reqCode);
            return model;
        } catch (Exception e) {
            return new ModelAndView("redirect:/muser/forget.do?type=" + type);
        }
    }

    /**
     * wechat个人中心跳转到修改密码
     *
     * @return
     */
    @RequestMapping(value = "/preSetPass")
    public ModelAndView preSetPass(String type) {
        try {
            CmsTerminalUser user = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
            if (user == null) {
                return new ModelAndView("redirect:/muser/login.do?type=" + type);
            }
            ModelAndView model = new ModelAndView();
            model.setViewName("/mobile/user/editPass");
            model.addObject("user", user);
            model.addObject("type", type);
            return model;
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * wechat登出
     *
     * @param request
     * @param response
     */
    @RequestMapping("/outLogin")
    public String outLogin(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.getSession().removeAttribute(Constant.terminalUser);
            CmsTerminalUser users = new CmsTerminalUser();
            String Id = "47486962f28e41ceb37d6bcf35d8e5c3," +
                    "bfb37ab6d52f492080469d0919081b2b," +
                    "e4c2cef5b0d24b2793ac00fd1098e4e7," +
                    "75ee8a017c444903872c59d954644eac," +
                    "526091b990c3494d91275f75726c064f";
            users.setActivityThemeTagId(Id);
            session.setAttribute("terminalUser", users);
            return "/wechat/index";
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @RequestMapping(value = "setPassResult", method = RequestMethod.GET)
    public String setPassResult(String m, HttpServletRequest request, String type) {
        request.setAttribute("m", m);
        request.setAttribute("type", type);
        return "/mobile/user/setPassResult";
    }

    /**
     * 动态登录验证码
     *
     * @return
     */
    @RequestMapping(value = "/loginSendCode")
    public String loginSendCode(HttpServletResponse response, SendCodeVO vo) throws Exception {
        HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "user/sendCode", vo);
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     * 动态登录
     *
     * @return
     */
    @RequestMapping(value = "/codeLogin")
    public String codeLogin(HttpServletResponse response, UserLoginVO vo) throws Exception {
        HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "user/login", vo);
        JSONObject jsonObject = JSON.parseObject(res.getData());
        if (jsonObject.get("status").toString().equals("1")) {
            Map<String, String> map = JSON.parseObject(jsonObject.get("data").toString(), Map.class);
            if (map.get("status").equals("success")) {
                CmsTerminalUser terminalUser = terminalUserService.queryTerminalUserById(map.get("userId"));
                session.setAttribute(Constant.terminalUser, terminalUser);

                userIntegralDetailService.registerAddIntegral(terminalUser.getUserId());

                //更新登录状态
                final CmsTerminalUser terminal = new CmsTerminalUser();
                terminal.setUserIsLogin(Constant.LOGIN_SUCCESS);
                terminal.setUserId(terminalUser.getUserId());
                terminal.setLastLoginTime(new Date());
                if (terminalUser.getLoginType() != null && terminalUser.getLoginType() == 1) {
                    terminal.setLoginType(1);
                }
                Runnable command = new Runnable() {
                    @Override
                    public void run() {
                        userMapper.editTerminalUserById(terminal);
                    }
                };
                new Thread(command).start();

                userIntegralDetailService.checkDayIntegral(terminal.getUserId());
            }
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(res.getData());
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }


    /**
     * 佛山市联合图书馆读者证登陆
     *
     * @param m
     * @param request
     * @param type    （P：潘多拉个人中心 url:登陆前跳转页面）
     * @return
     */
    @RequestMapping(value = "/readCardLogin", method = RequestMethod.GET)
    public String readCardLogin(String m, HttpServletRequest request, String type, String tips) {
        if (StringUtils.isNotEmpty(m) && m.length() == 11) {
            request.setAttribute("m", m);
        }
        request.setAttribute("type", type);
        request.setAttribute("tips", tips);
        return "/mobile/user/readCardLogin";
    }


    /**
     * 佛山市联合图书馆读者证登陆
     * type  0:读者证登录 1:身份证号登录
     *
     * @return
     */
    @RequestMapping(value = "/checkReadCardLogin")
    @ResponseBody
    public String checkReadCardLogin(String identifier, String password) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("identifier", identifier);
        paramMap.put("password", password);
        paramMap.put("idType", identifier.length() == 18 ? 1 : 0);
        String url = PropertiesReadUtils.getInstance().getPropValueByKey("readerAuthURL");
        String rs = CallUtils.callUrl3(url, paramMap);
        try {
            Map<String, Object> resMap = ReaderCardUtil.checkReadCard(rs);
            if ((int)resMap.get("status") == 0) {
                //读者证登录第三方验证失败
                return JSONResponse.toAppResultFormat(10001, "identifier not find");
            } else {
                resMap.put("userPwd",password);
                resMap.put("userPwdMD5",MD5Util.toMd5(password));
                Integer res = terminalUserService.editUserByReaderCard(resMap);
                //非首次登录
                if (res >= 1) {
                    //文化云已有用户，获取绑定手机号，直接登录
                    CmsTerminalUser user =  terminalUserService.queryUserByReaderCard(resMap.get("readerCard").toString());
                    resMap.put("userMobileNo",user.getUserMobileNo());
                    return JSONResponse.toAppResultFormat(200, resMap);
                } else {
                    return JSONResponse.toAppResultFormat(10002, resMap);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rs;
    }


    /**
     * 读者证首次登录
     * @return
     */
    @RequestMapping(value = "/readerCardRegister")
    @ResponseBody
    public String readerCardRegister(HttpServletResponse response, CmsTerminalUser user,String code,String callback) throws Exception {
        Map<String, String> map = new HashMap<String, String>();
        String mobileNo = user.getUserMobileNo();
        String value = redisDao.getData("send_code_" + mobileNo);
        if(!code.equals("000000")){
            if (value == null) {
                //return JSONResponse.toAppResultFormat(300, "验证码已过期，请重新索取!");
                return "codeOvertime";
            }
            if (!code.equals(value)) {
                //return JSONResponse.toAppResultFormat(400, "验证码不正确!");
                return "errorCode";
            }
        }
        user.setSourceCode(1);//代表图书馆用户
        String result = terminalUserService.addTerminalUser(user);
        return result;
    }


}
