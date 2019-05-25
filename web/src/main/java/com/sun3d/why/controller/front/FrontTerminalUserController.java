package com.sun3d.why.controller.front;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.*;
import com.sun3d.why.util.*;
import com.sun3d.why.webservice.api.util.TerminalUserConstant;

import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.sun3d.why.util.Constant.RESULT_STR_FAILURE;

@RequestMapping("/frontTerminalUser")
@Controller
public class FrontTerminalUserController {
    private Logger logger = LoggerFactory.getLogger(FrontTerminalUserController.class);

    @Autowired
    private CmsTerminalUserService terminalUserService;

    @Autowired
    private CmsUserMessageService userMessageService;

    @Autowired
    private CacheService cacheService;

    @Autowired
    private HttpSession session;

    @Autowired
    private StaticServer staticServer;

    @Autowired
    private SyncCmsTerminalUserService syncCmsTerminalUserService;

    /**
     * 登陆
     *
     * @param user
     * @param rememberUser
     * @param request
     * @param response
     *String str = Base64.encode(user.getUserName() + "," + user.getUserPwd());
     * autoLogin.setMaxAge(cookieInfo.getCookieTime());
     */
    // 前端2.0登录
    @RequestMapping(value = "/terminalLogin",method = RequestMethod.POST)
    public void terminalLogin(CmsTerminalUser user,String rememberUser, HttpServletRequest request, HttpServletResponse response) {
        JSONObject jsonObject = new JSONObject();
        try {
            if(user==null||StringUtils.isEmpty(user.getUserName())||StringUtils.isEmpty(user.getUserPwd())){
                return;
            }
            String result = terminalUserService.webLogin(user, request.getSession());
            if (Constant.RESULT_STR_SUCCESS.equals(result)) {
                if (StringUtils.isNotEmpty(rememberUser) && "on".equals(rememberUser)) {
                    response.setContentType("text/html;charset=utf-8");
                    Cookie userName = new Cookie("userName",URLEncoder.encode(user.getUserName(),"UTF-8") );
                    userName.setPath("/");
                    userName.setMaxAge(Integer.MAX_VALUE);
                    response.addCookie(userName);
                }

                jsonObject.put("status",Constant.RESULT_STR_SUCCESS);
                user = (CmsTerminalUser)session.getAttribute(Constant.terminalUser);
                jsonObject.put("user",user);
                response.getWriter().write(jsonObject.toString());
            } else {
                final String  userCode =new SimpleDateFormat("yyyy-MM-dd").format(new Date())+user.getUserName();
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        cacheService.setLoginErr(userCode,"0");
                    }
                }).start();
                jsonObject.put("status",result);
                response.getWriter().write(jsonObject.toString());
            }
        }catch (Exception e) {
            try {
                jsonObject.put("status",Constant.RESULT_STR_FAILURE);
                response.getWriter().write(jsonObject.toString());
            } catch (IOException el) {
            }
        }
    }

    /**
     * 用户去修改信息
     *
     * @return
     */
    @RequestMapping(value = "/userInfo")
    public ModelAndView userInfo(HttpServletRequest request) {
        ModelAndView model = new ModelAndView();
        CmsTerminalUser user = (CmsTerminalUser) request.getSession().getAttribute(Constant.terminalUser);
        try {
            if (user == null) {
                return new ModelAndView("redirect:/frontTerminalUser/userLogin.do");
            }

/*            if(StringUtils.isEmpty(user.getUserMobileNo())&&StringUtils.isEmpty(user.getUserTelephone())){
                return new ModelAndView("redirect:/frontTerminalUser/completeInfo.do?code="+UUIDUtils.createUUId());
            }*/

            CmsTerminalUser sessionUser = terminalUserService.queryTerminalUserById(user.getUserId());
            if (null != sessionUser.getUserBirth()) {
                sessionUser.setUserBirthStr(new SimpleDateFormat("yyyy-MM-dd").format(sessionUser.getUserBirth()));
            }
            model.setViewName("index/userCenter/userInfo");
            model.addObject("user", sessionUser);
        }catch (Exception e){
            e.printStackTrace();
        }
        return model;
    }

    //用户编辑信息 保存信息
    @RequestMapping(value = "/editTerminalUser", method = RequestMethod.POST)
    @ResponseBody
    public String editTerminalUser(CmsTerminalUser user,HttpServletRequest request) {
        try {
            CmsTerminalUser sessionUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
            if(sessionUser==null||user==null){
                return "timeOut";
            }else{
                user.setUserId(sessionUser.getUserId());
            }
            CmsTerminalUser tuser = terminalUserService.queryTerminalUserById(user.getUserId());

            //非第三方登录
            if(StringUtils.isNotBlank(tuser.getUserMobileNo())){
                if (user.getUserMobileNo().equals(tuser.getUserMobileNo())){
                    //将更新过的user 放入会话
                    if (Constant.RESULT_STR_SUCCESS.equals(terminalUserService.editTerminalUserById(user))) {
                        request.getSession().setAttribute(Constant.terminalUser, terminalUserService.queryTerminalUserById(user.getUserId()));
                        return Constant.RESULT_STR_SUCCESS;
                    }
                }else{
                    //修改了手机 验证code
                    if (user.getRegisterCode().equals(tuser.getRegisterCode())) {
                        //将更新过的user 放入会话
                        if (Constant.RESULT_STR_SUCCESS.equals(terminalUserService.editTerminalUserById(user))) {
                            request.getSession().setAttribute(Constant.terminalUser,terminalUserService.queryTerminalUserById(user.getUserId()));

                            return Constant.RESULT_STR_SUCCESS;
                        }
                    }else {
                        return Constant.SmsCodeErr;
                    }
                }
            }else{
                if(StringUtils.isNotBlank(tuser.getUserTelephone())){
                    if (tuser.getUserTelephone().equals(user.getUserMobileNo())){
                        user.setUserMobileNo(null);
                        //将更新过的user 放入会话
                        if (Constant.RESULT_STR_SUCCESS.equals(terminalUserService.editTerminalUserById(user))) {
                            request.getSession().setAttribute(Constant.terminalUser,
                                    terminalUserService.queryTerminalUserById(user.getUserId()));
                            return Constant.RESULT_STR_SUCCESS;
                        }
                    }
                }else{
                        user.setUserMobileNo(null);
                        //将更新过的user 放入会话
                        if (Constant.RESULT_STR_SUCCESS.equals(terminalUserService.editTerminalUserById(user))) {
                            request.getSession().setAttribute(Constant.terminalUser,
                                    terminalUserService.queryTerminalUserById(user.getUserId()));
                            return Constant.RESULT_STR_SUCCESS;
                        }
                }
                /*else{
                    if (user.getRegisterCode().equals(tuser.getRegisterCode())) {
                        user.setUserTelephone(user.getUserMobileNo());
                        user.setUserMobileNo(null);
                        //将更新过的user 放入会话
                        if (Constant.RESULT_STR_SUCCESS.equals(terminalUserService.editTerminalUserById(user))) {
                            request.getSession().setAttribute(Constant.terminalUser,
                                    terminalUserService.queryTerminalUserById(user.getUserId()));
                            return Constant.RESULT_STR_SUCCESS;
                        }
                    }else {
                        return Constant.SmsCodeErr;
                    }
                }*/
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return RESULT_STR_FAILURE;
    }

    /**
     * 去注册页面
     * @return
     */
    @RequestMapping(value = "/userRegister")
    public ModelAndView userRegister(HttpServletRequest request) {
        //如果当前登录用户不为空 不能去注册
        ModelAndView model = new ModelAndView();
        if(null!=request.getSession().getAttribute(Constant.terminalUser)){
            model.setViewName("redirect:/frontIndex/index.do");
            return model;
        }
        model.addObject("callback",request.getParameter("callback"));
        model.setViewName("index/userCenter/userRegister");
        return model;
    }



    //注册验证用户名
    @RequestMapping(value = "/userNameVal")
    @ResponseBody
    public String userNameVal(String userName,String userMobileNo) {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("userName", userName);
        try {
            CmsTerminalUser user = terminalUserService.queryFrontTerminalUser(params);
            /**
             * 首次验证
             */
            if (user==null){
                return Constant.RESULT_STR_SUCCESS;
            }
            /**
             * 二次发送验证码
             */
            if (userMobileNo.equals(user.getUserMobileNo()) && String.valueOf(Constant.USER_NOT_ACTIVATE).equals(String.valueOf(user.getUserIsDisable()))){
                return Constant.RESULT_STR_SUCCESS;
            } else {
                return RESULT_STR_FAILURE;
            }
        } catch (Exception e) {
            logger.info("terminalLogin error", e);
        }
        return RESULT_STR_FAILURE;
    }


    /**
     *查看手机号是否注册
     * @param params
     * @return
     */
    private List<CmsTerminalUser> getCmsTerminalUserList(Map<String, Object> params) {
        return terminalUserService.getCmsTerminalUserList(params);

    }

    //注册发送手机验证码
    @RequestMapping(value = "/sendSmsCode",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> sendCode(HttpServletRequest request,String userMobileNo,String userName,String userPwd,Integer userSex) {
        try {
            return terminalUserService.sendSmsCode(userMobileNo,userName,userPwd,userSex,request);
        } catch (Exception e) {
            logger.info("sendCode error", e);
        }
        Map<String,Object> map = new HashMap<String, Object>();
        return map;
    }

    /**
     * 保存用户信息
     * @param user
     * @param confirmPassword
     * @param code
     * @return
     */
    @RequestMapping(value = "/saveUser")
    @ResponseBody
    public Map saveUser(CmsTerminalUser user, String confirmPassword, String code,String birth,HttpServletRequest request) {
        Map map = new HashMap();
        try {
            //保存默认生日
              if(StringUtils.isNotBlank(birth)){
                 String value =  getBirth(birth);
                 if (StringUtils.isNotBlank(value)){
                     user.setUserBirth(new SimpleDateFormat("yyyy-MM-dd").parse(value));
                 }
              }
            String rs = terminalUserService.saveRegUser(user,code,request.getSession());
            if (Constant.RESULT_STR_SUCCESS.equals(rs)) {
                map.put("status",Constant.RESULT_STR_SUCCESS);
                map.put("user",request.getSession().getAttribute(Constant.terminalUser));
                return map;
            } else {
                map.put("status",rs);
                return map;
            }

        } catch (Exception e) {
            e.printStackTrace();
            logger.info("saveUser error", e);
        }
        map.put("status",Constant.RESULT_STR_FAILURE);
        return map;
    }

    //注册成功
    @RequestMapping(value = "/userRegisterSuc")
    public String userRegisterSuc(HttpServletRequest request) {
        CmsTerminalUser user = (CmsTerminalUser) request.getSession().getAttribute(Constant.terminalUser);
        if(null==user){
            //未注册成功不能直接进入该页面
            return "index/userCenter/userRegister";
        }
        Map<String,Object> params = new HashMap<String, Object>();
        params.put("userName",user.getUserName());
        userMessageService.sendSystemMessage(Constant.SYSTEM_NOTICE, params, user.getUserId());
        return "index/userCenter/registerSuc";
    }





    /*private String sendSmsMessage(String userMobileNo, String registerCode){
        String code = "";
        try{
            SmsSend send = new SmsSend();
            code = send.sendSmsMessage(smsConfig.getSmsUrl(),smsConfig.getuId(),smsConfig.getPwd(),userMobileNo, "文化云注册激活码"+registerCode+"请及时输入");
            return code;
        }catch (Exception e){
            logger.info("sendSms error", e);
        }
        return code;
    }*/




    private void updateTerminalUser(CmsTerminalUser user,Integer registerCount,String registerCode,Date date,String userMobileNo){
        user.setRegisterCount(registerCount);
        user.setRegisterCode(registerCode);
        user.setCreateTime(date);
        user.setUserMobileNo(userMobileNo);
        terminalUserService.updateTerminalUserById(user);
    }



    //修改手机 发送验证码
    @RequestMapping(value = "/updateSendCode")
    @ResponseBody
    public String updateSendCode(String userId,String userMobileNo) {
        try {
            CmsTerminalUser user = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);

            if(user==null){
                return "timeOut";
            }else{
                return terminalUserService.modifyInfoSendCode(user.getUserId(),userMobileNo);
            }
        } catch (Exception e) {
            logger.info("updateSendCode error", e);
        }
        return RESULT_STR_FAILURE;
    }


    @RequestMapping(value = "/userModifyPwd",method = RequestMethod.GET)
    public ModelAndView userModifyPwd(HttpServletRequest request){
        ModelAndView model = new ModelAndView();
        CmsTerminalUser user = (CmsTerminalUser)request.getSession().getAttribute(Constant.terminalUser);
        if (user == null) {
            return new ModelAndView("redirect:/frontTerminalUser/userLogin.do");
        }
        //第三方账号 不能进入该页面
        if(StringUtils.isEmpty(user.getUserMobileNo())){
            return null;
        }
/*        if(StringUtils.isEmpty(user.getUserMobileNo())&&StringUtils.isEmpty(user.getUserTelephone())){
            return new ModelAndView("redirect:/frontTerminalUser/completeInfo.do?code="+UUIDUtils.createUUId());
        }*/
        model.addObject("user",user);
        model.setViewName("index/userCenter/userModifyPwd");
        return model;

    }
    //修改密码
    @RequestMapping(value = "/userModifyPwd",method = RequestMethod.POST)
    @ResponseBody
    public String userModifyPwd(CmsTerminalUser user){

        CmsTerminalUser sessionUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
        if(sessionUser==null||user==null){
            return "timeOut";
        }else{
            user.setUserId(sessionUser.getUserId());
        }
        try{
            user.setUserPwd(MD5Util.toMd5(user.getUserPwd()));
            terminalUserService.updateTerminalUserById(user);

            return Constant.RESULT_STR_SUCCESS;
        }catch (Exception e){
            logger.error("userModifyPwd"+e);
            e.printStackTrace();
        }
        return RESULT_STR_FAILURE;
    }

    //注册用户出生时时间
    private static   String  getBirth(String key){
        Map<String,String > map = new HashMap<String, String>();
        map.put("00","2000-01-01");
        map.put("90","1990-01-01");
        map.put("80","1980-01-01");
        map.put("70","1970-01-01");
        map.put("60","1960-01-01");
        return map.get(key);
    }

    //去登录
    @RequestMapping(value = "/userLogin",method =RequestMethod.GET)
    public ModelAndView userLogin(HttpServletRequest request){
        if (null!=request.getSession().getAttribute(Constant.terminalUser)) {
            return new ModelAndView("redirect:/frontIndex/index.do ");
        }
        String LoginType  = request.getParameter("LoginType");
        if(StringUtils.isNotEmpty(LoginType)){
            request.setAttribute("LoginType",LoginType);
        }
        Cookie[] cookies =  request.getCookies();
        if(cookies!=null&&cookies.length>0){
            for (Cookie c : cookies){
                if("userName".equals(c.getName())){
                    try {
                        request.setAttribute("userName", URLDecoder.decode(c.getValue(),"UTF-8"));
                    } catch (UnsupportedEncodingException e) {
                    }
                    break;
                }
            }
        }
        ModelAndView model = new ModelAndView();
        model.addObject("callback",request.getParameter("callback"));
        model.setViewName("index/userCenter/userLogin");
        return model;
    }

    //清除cookie 退出登录
    @RequestMapping("/outLogin")
    public void outLogin(HttpServletRequest request,HttpServletResponse response){
        try{

            /*********2015.11.05 by niu*********/
/*            Cookie[] cookies =  request.getCookies();
            if(cookies!=null&&cookies.length>0){
                for (Cookie c : cookies){
                    if(Constant.AutoLogin.equals(c.getName())){
                        c.setMaxAge(0);
                        c.setPath("/");
                        response.addCookie(c);
                        break;
                    }
                }
            }*/
//            request.getSession().invalidate();
            request.getSession().removeAttribute(Constant.terminalUser);
            response.getWriter().write(Constant.RESULT_STR_SUCCESS);
            return;
        }catch (Exception e){
            e.printStackTrace();
        }
        try {
            response.getWriter().write(RESULT_STR_FAILURE);
        } catch (IOException e) {
        }
    }

    //获取第三代登录用户的opendId 查到则放入session
    @RequestMapping(value = "/getOpenUser",method = RequestMethod.POST)
    @ResponseBody
    public  Map<String,Object>  getOpenUser(String openId){
        Map<String,Object> result = new HashMap<String, Object>();
        try{
            Map<String,Object> params = new HashMap<String, Object>();
            params.put("openId",openId);
            CmsTerminalUser user =  terminalUserService.queryByOpenId(params);
            if(user!=null&&null!=user.getUserId()){
                result.put("code",200);
                result.put("userId", user.getUserId());
                return result;
            }
        }catch (Exception e){
            e.printStackTrace();
            result.put("code",500);
            return result;
        }
        result.put("code",404);
        return result;

    }

//    /*************该方法已废弃******************/
//    //第三方登陆成功 保存到数据库
//    @RequestMapping(value = "/saveThirdUser",method =RequestMethod.POST)
//    @ResponseBody
//    public  Map<String,Object>  saveThirdUser(CmsTerminalUser user,String type,HttpServletRequest request){
//        Map<String,Object> result = new HashMap<String, Object>();
//        try{
//            String ip =  IpUtil.getIpAddress(request);
//            if(StringUtils.isNotBlank(ip)){
//                //第三方登陆注册做ip限制 同ip不能多次注册
//                Map<String,Object> params = new HashMap<String, Object>();
//                params.put("createTime",new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
//                params.put("userIp",ip);
//                int count =  terminalUserService.queryByIp(params);
//
//                if(count>=5){
//                    result.put("code",502);
//                    return result;
//                }
//                user.setUserIp(ip);
//            }
//
//         /*   String openId,String token,String nickName,String headImgUrl*/
//            //CmsTerminalUser user = new CmsTerminalUser();
//            String userId = UUIDUtils.createUUId();
//            user.setUserId(userId);
//            user.setCreateTime(new Date());
//            user.setUserIsDisable(Constant.USER_IS_ACTIVATE);
//            user.setUserType(1);
//            user.setUserBirth(new Date());
//            //账号来源
//            user.setRegisterOrigin(Integer.valueOf(type));
//            //评论状态
//            user.setCommentStatus(1);
//            //最后登陆时间
//            user.setLastLoginTime(new Date());
//            if(StringUtils.isNotBlank(user.getUserBirthStr())){
//                //捕获类型转换异常
//                try{
//                    user.setUserBirth(new SimpleDateFormat("yyyy-MM-dd").parse(user.getUserBirthStr()));
//                }catch (Exception e){
//                }
//            }else{
//                user.setUserBirth(new Date());
//            }
//            //QQ登陆
//            user.setUserName(cacheService.genUserNumber());
//            terminalUserService.insertTerminalUser(user);
//
//            request.getSession().setAttribute(Constant.terminalUser, user);
//            result.put("code",200);
//            result.put("userId",userId);
//            return result;
//        }catch (Exception e){
//            e.printStackTrace();
//        }
//        result.put("code",500);
//        return result;
//    }
//
//
//    /*************该方法已废弃******************/
    //第三方登陆成功  opendId在数据库存在 保存到session
    @RequestMapping(value = "/setUserSession")
    @ResponseBody
    public  String  saveThirdUser(String openId,HttpServletRequest request){
        Map<String,Object> params = new HashMap<String, Object>();
        try{
            params.put("openId",openId);
            CmsTerminalUser user =  terminalUserService.queryByOpenId(params);
            if (user!=null){
                //必须是激活状态的用户才放入session
                if(!user.getUserIsDisable().equals(Constant.USER_IS_ACTIVATE)){
                    return RESULT_STR_FAILURE;
                }
                request.getSession().setAttribute(Constant.terminalUser, user);
                return Constant.RESULT_STR_SUCCESS;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return RESULT_STR_FAILURE;
    }

    //完善信息时发送短信验证码
    @RequestMapping(value = "/completeInfoSendCode",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> completeInfoSendCode(String userId,String userMobileNo){
        try{
            return terminalUserService.completeInfoSendCode(userId,userMobileNo);
        }catch (Exception e){
            e.printStackTrace();
        }
        Map<String,Object> result = new HashMap<String, Object>();
        result.put("result", RESULT_STR_FAILURE);
        return  result;
    }

    //绑定用户 验证手机账号 完善个人信息
    @RequestMapping(value = "/completeInfo",method = RequestMethod.GET)
    public  ModelAndView  completeInfo(HttpServletRequest request){
        CmsTerminalUser sessionUser = (CmsTerminalUser) request.getSession().getAttribute(Constant.terminalUser);
        if(null==sessionUser){
            return new ModelAndView("redirect:/frontTerminalUser/userLogin.do");
        }
        //非第三方用户不能进入此页面
        if(StringUtils.isNotBlank(sessionUser.getUserMobileNo())||StringUtils.isNotBlank(sessionUser.getUserTelephone())){
            return new ModelAndView("redirect:/frontIndex/index.do");
        }
        ModelAndView model = new ModelAndView();
        model.addObject("userId",sessionUser.getUserId());
        model.setViewName("index/userCenter/completeInfo");
        return model;

    }

    //完善信息
    @RequestMapping(value = "/completeInfo",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> completeInfo(CmsTerminalUser user,HttpServletRequest request){
        Map<String,Object>  result =  new HashMap<String, Object>();
        try{
            if(StringUtils.isBlank(user.getUserId())){
                result.put("code",500);
                return  result;
            }
            CmsTerminalUser tuser = terminalUserService.queryTerminalUserById(user.getUserId());
            //非数据库存在的数据
            if(!user.getRegisterCode().equals(tuser.getRegisterCode())){
                result.put("code",404);
                return result;
            }
            //更新第三方用户的telephone
            user.setUserTelephone(user.getUserMobileNo());

            tuser.setUserTelephone(user.getUserMobileNo());

            user.setUserMobileNo(null);
            user.setUserPwd(MD5Util.toMd5(user.getUserPwd()));
            user.setLastLoginTime(new Date());
            terminalUserService.updateTerminalUserById(user);

            //更新session中的第三方用户电话
            tuser.setUserPwd(MD5Util.toMd5(user.getUserPwd()));

            //更新成功 更新session中的user
            request.getSession().setAttribute(Constant.terminalUser,tuser);
            result.put("code", 200);
            return result;
        }catch (Exception e){
            e.printStackTrace();
        }
        result.put("code",500);
        return  result;
    }


    //预定活动完善信息时发送短信验证码
    @RequestMapping(value = "/completeOrderSendCode",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> completeOrderInfoSendCode(HttpServletRequest request){

        Map<String,Object> result = new HashMap<String, Object>();
        CmsTerminalUser user = (CmsTerminalUser) request.getSession().getAttribute(Constant.terminalUser);
        if(user==null){
            result.put("result","timeOut");
            return  result;
        }
        String userMobileNo = request.getParameter("userMobileNo");
        if(StringUtils.isEmpty(userMobileNo)){
            result.put("result","Error");
            return  result;
        }
        try{
            return terminalUserService.completeInfoSendCode2(user.getUserId(), userMobileNo);
        }catch (Exception e){
            e.printStackTrace();
        }
        result.put("result", RESULT_STR_FAILURE);
        return  result;
    }

    //预定活动完善信息
    @RequestMapping(value = "/completeOrderInfo",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> completeOrderInfo(String code,HttpServletRequest request){

        Map<String,Object>  result =  new HashMap<String, Object>();

        final String userMobileNo = request.getParameter("userMobileNo");

        if(StringUtils.isBlank(code)||!CommonUtil.isMobile(userMobileNo)){
            result.put("data","Error");
            return result;
        }

        CmsTerminalUser sessionUser = (CmsTerminalUser) request.getSession().getAttribute(Constant.terminalUser);

        try{
            if(null==sessionUser){
                result.put("data","timeOut");
                return result;
            }
            CmsTerminalUser extUser = terminalUserService.queryTerminalUserById(sessionUser.getUserId());
            //非数据库存在的数据
            if(!code.equals(extUser.getRegisterCode())){
                result.put("data","codeError");
                return result;
            }
            //更新成功 更新session中的user
            request.getSession().setAttribute(Constant.terminalUser,sessionUser);
            result.put("data", Constant.RESULT_STR_SUCCESS);
            return result;
        }catch (Exception e){
            e.printStackTrace();
        }
        result.put("data", RESULT_STR_FAILURE);
        return  result;
    }



    /**
     * 忘记密码
     */
    @RequestMapping("/forget")
    public ModelAndView forget(){
        return new ModelAndView("index/userCenter/forget");
    }

    @RequestMapping("/sendForgetCode")
    @ResponseBody
    public Map<String,Object> sendForgetCode(CmsTerminalUser user){
        Map<String,Object> result = new HashMap<String, Object>();
        if(user==null||StringUtils.isBlank(user.getUserMobileNo())){
            result.put("result","NotFound");
            return result;
        }
        try{
            return  terminalUserService.sendForgetSmsCode(user.getUserMobileNo(),null,session);
        }catch (Exception e){
            e.printStackTrace();
        }
        result.put("result", RESULT_STR_FAILURE);
        return result;
    }


    /**
     * 验证验证码
     */
    @RequestMapping(value = "/valForgetCode",method =RequestMethod.POST)
    @ResponseBody
    public String valForgetCode(String code, String userId){
        if(StringUtils.isBlank(code)){
            return RESULT_STR_FAILURE;
        }
        
        if(StringUtils.isBlank(userId)){
        	userId = (String) session.getAttribute(Constant.SESSION_USER_ID);
        }
        
        if(StringUtils.isBlank(userId)){
            return "timeOut";
        }
        try {
            CmsTerminalUser user = terminalUserService.queryTerminalUserById(userId);
            if(user==null){
                return RESULT_STR_FAILURE;
            }
            //SmsCodeErr
            if (!code.equals(user.getRegisterCode())){
                return Constant.SmsCodeErr;
            }else{
                return Constant.RESULT_STR_SUCCESS;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return RESULT_STR_FAILURE;
    }


    /**
     * 设置密码页面
     * @return
     */
    @RequestMapping(value = "/setPass",method =RequestMethod.POST)
    public ModelAndView setPass(String resCode){
        String userId = (String) session.getAttribute(Constant.SESSION_USER_ID);
        String sessionUserCode = (String) session.getAttribute(Constant.SESSION_USER_CODE);
        try{
            if(StringUtils.isBlank(userId)||StringUtils.isBlank(resCode)||!resCode.equals(sessionUserCode)){
                return new ModelAndView("redirect:/frontIndex/index.do");
            }
            CmsTerminalUser user = terminalUserService.queryTerminalUserById(userId);
            if(!Constant.USER_IS_ACTIVATE.equals(user.getUserIsDisable())){
                return new ModelAndView("redirect:/frontIndex/index.do");
            }
            ModelAndView model = new ModelAndView();
            model.setViewName("index/userCenter/setpass");
            String reqCode = UUIDUtils.createUUId();
            model.addObject("reqCode",reqCode);
            session.setAttribute(Constant.SESSION_USER_CODE,reqCode);
            return model;
        }catch (Exception e){
            return new ModelAndView("redirect:/frontIndex/index.do");
        }
    }

    @RequestMapping(value = "/setNewPass",method =RequestMethod.POST)
    @ResponseBody
    public String setNewPass(CmsTerminalUser user,String reqCode){

        String userId = (String) session.getAttribute(Constant.SESSION_USER_ID);
        String sessionUserCode = (String) session.getAttribute(Constant.SESSION_USER_CODE);
        if(null==user){
            return RESULT_STR_FAILURE;
        }
        if(StringUtils.isBlank(userId)||StringUtils.isBlank(reqCode)||!reqCode.equals(sessionUserCode)){
            return "timeOut";
        }
        try{
            CmsTerminalUser extUser = terminalUserService.queryTerminalUserById(userId);
            if(!Constant.USER_IS_ACTIVATE.equals(extUser.getUserIsDisable())){
                return RESULT_STR_FAILURE;
            }
            user.setUserId(userId);
            user.setUserPwd(MD5Util.toMd5(user.getUserPwd()));
            terminalUserService.updateTerminalUserById(user);

            return  Constant.RESULT_STR_SUCCESS;
        }catch (Exception e){
            e.printStackTrace();
        }
        return RESULT_STR_FAILURE;
    }

    @RequestMapping("/setPassSuc")
    public ModelAndView setPassSuc(){
        return new ModelAndView("index/userCenter/setPassResult");
    }

    @RequestMapping(value = "/setUserNewPass",method =RequestMethod.POST)
    @ResponseBody
    public String setUserNewPass(CmsTerminalUser user){

        if(null==user){
            return RESULT_STR_FAILURE;
        }
        String userId = user.getUserId();
        if(StringUtils.isBlank(userId)){
            return "timeOut";
        }
        try{
        	CmsTerminalUser extUser = terminalUserService.queryTerminalUserById(userId);
            if(!Constant.USER_IS_ACTIVATE.equals(extUser.getUserIsDisable())){
                return RESULT_STR_FAILURE;
            }
            user.setUserId(extUser.getUserId());
//            user.setUserMobileNo(userMobileNo);
            user.setUserPwd(MD5Util.toMd5(user.getUserPwd()));
            terminalUserService.updateTerminalUserById(user);

            return  Constant.RESULT_STR_SUCCESS;
        }catch (Exception e){
            e.printStackTrace();
        }
        return RESULT_STR_FAILURE;
    }
}
