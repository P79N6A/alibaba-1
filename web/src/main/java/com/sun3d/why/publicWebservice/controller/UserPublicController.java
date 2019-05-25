package com.sun3d.why.publicWebservice.controller;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.BasePath;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.publicWebservice.model.HttpRes;
import com.sun3d.why.publicWebservice.model.User;
import com.sun3d.why.publicWebservice.service.UserPublicService;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.util.Constant;

import net.sf.json.JSONObject;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by yujinbing on 2015/12/21.
 */
@RequestMapping("/public/user")
@Controller
public class UserPublicController {

    private Logger logger = LoggerFactory.getLogger(UserPublicController.class);

    @Autowired
    private UserPublicService userPublicService;

    @Autowired
    private CmsTerminalUserService terminalUserService;

    @Autowired
    private BasePath basePath;

    @Autowired
    private StaticServer staticServer;
    /**
     * 公共接口
     * 保存前台注册用户信息
     * status :0 代表失败   status : 1代表成功
     * @param user
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = "/saveUser")
    public void saveUser(CmsTerminalUser user,HttpServletResponse response)  throws Exception{
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject = userPublicService.saveUser(user);
        } catch (Exception ex) {
            logger.error("/public/user saveUser error {} ", ex);
            jsonObject.put("status",0);
            jsonObject.put("msg",ex.toString());
            ex.printStackTrace();
        } finally {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write(jsonObject.toString());
            response.getWriter().flush();
            response.getWriter().close();
        }
    }

    /**
     * 公共接口
     * 验证前台用户登录信息 能否继续登录
     * status :0 代表失败   status : 1代表成功
     * @param user
     * @param response
     * @throws Exception
     */
    @RequestMapping(value = "/userLogin")
    public void userLogin(CmsTerminalUser user,HttpServletResponse response)  throws Exception{
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject = userPublicService.checkUserLogin(user);
        } catch (Exception ex) {
            logger.error("/public/user userLogin error {} ", ex);
            jsonObject.put("status",0);
            jsonObject.put("msg",ex.toString());
            ex.printStackTrace();
        } finally {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write(jsonObject.toString());
            response.getWriter().flush();
            response.getWriter().close();
        }
    }

    /***
     * 书法机器 图片上传接口
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/uploadFile",method = RequestMethod.POST)
    public void uploadFile(@RequestParam("file") MultipartFile mulFile, String userId,HttpServletResponse response) throws ServletException, IOException {

        logger.info("进入前台上传文件方法");
        //返回前台页面json格式
        String json = null;
        try {
            json=userPublicService.uploadFile(userId,mulFile);
        }
         catch (Exception e) {
            logger.error("文件上传出错!", e);
        }
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
    }
    /***
     * 书法机器 图片列表
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/imgList")
    public void imgList(String userId,HttpServletResponse response) throws ServletException, IOException {
        //返回前台页面json格式
        JSONObject json = null;
        try {
            json=userPublicService.imgList(userId);
        }
        catch (Exception e) {
            logger.error("文件上传出错!", e);
        }
        response.getWriter().print(json);
        response.getWriter().flush();
        response.getWriter().close();
    }
    /***
     * 书法机器 登录接口
     *
     * @param user
     * @return
     */
    @RequestMapping(value = "/login",method = RequestMethod.POST)
    @ResponseBody
    public HttpRes login(CmsTerminalUser user){
        HttpRes httpRes = new HttpRes();
        if(user==null || StringUtils.isBlank(user.getUserMobileNo()) || StringUtils.isBlank(user.getUserPwd())){
            httpRes.setCode(400);
            httpRes.setResDesc("参数缺失");
            return  httpRes;
        }
        try {
            CmsTerminalUser extUser = terminalUserService.publicLogin(user);
            if(extUser!=null){
                if(Constant.USER_IS_ACTIVATE.equals(extUser.getUserIsDisable())){
                    User resUser = new User();
                    BeanUtils.copyProperties(resUser,extUser);
                    if(StringUtils.isNotBlank(resUser.getUserHeadImgUrl())){
                        resUser.setUserHeadImgUrl(staticServer.getStaticServerUrl()+resUser.getUserHeadImgUrl());
                    }
                    httpRes.setCode(200);
                    httpRes.setData(resUser);
                    httpRes.setResDesc("登录成功");
                    return  httpRes;
                }else if (Constant.USER_IS_FREEZE.equals(extUser.getUserIsDisable())){
                    httpRes.setCode(401);
                    httpRes.setResDesc("用户已冻结");
                }else{
                    httpRes.setCode(403);
                    httpRes.setResDesc("用户未注册完成");
                }
            }else{
                httpRes.setCode(404);
                httpRes.setResDesc("用户名或密码错误");
            }
        }catch (Exception e){
            httpRes.setCode(500);
            httpRes.setResDesc("服务器响应失败");
            e.printStackTrace();
        }
        return  httpRes;
    }

    /**
     * 书法机器	注册发送手机验证码接口
     * @param userMobileNo
     * @param userName
     * @param userPwd
     * @param userSex
     * @return
     */
    @RequestMapping(value = "/sendSmsCode",method = RequestMethod.POST)
    @ResponseBody
    public HttpRes sendCode(HttpServletRequest request,String userMobileNo,String userName,String userPwd,Integer userSex) {
    	HttpRes httpRes = new HttpRes();
    	if(StringUtils.isBlank(userMobileNo) || StringUtils.isBlank(userName) || StringUtils.isBlank(userPwd) || userSex==null){
            httpRes.setCode(400);
            httpRes.setResDesc("参数缺失");
            return  httpRes;
        }
        try {
        	Map<String,Object> map = terminalUserService.sendSmsCode(userMobileNo,userName,userPwd,userSex,request);
        	if(Constant.RESULT_STR_FAILURE.equals(map.get("result"))){
        		httpRes.setCode(500);
                httpRes.setResDesc("服务器响应失败");
        	}else if(Constant.RESULT_STR_REPEAT.equals(map.get("result"))){
        		httpRes.setCode(400);
                httpRes.setResDesc("该手机号码已注册过");
        	}else if("third".equals(map.get("result"))){
        		httpRes.setCode(403);
                httpRes.setResDesc("最多可每天发送3次");
        	}else if(Constant.RESULT_STR_SUCCESS.equals(map.get("result"))){
        		httpRes.setCode(200);
        		httpRes.setData(map.get("userId"));
                httpRes.setResDesc("发送成功");
        	}
        } catch (Exception e) {
        	httpRes.setCode(500);
            httpRes.setResDesc("服务器响应失败");
            e.printStackTrace();
        }
        return httpRes;
    }

    /**
     * 书法机器	用户注册接口
     * @param user
     * @param code
     * @param birth
     * @param request
     * @return
     */
    @RequestMapping(value = "/registerUser",method = RequestMethod.POST)
    @ResponseBody
    public HttpRes saveUser(CmsTerminalUser user, String code,String birth,HttpServletRequest request) {
    	HttpRes httpRes = new HttpRes();
    	if(user==null || StringUtils.isBlank(code) || StringUtils.isBlank(birth) || StringUtils.isBlank(user.getUserName()) || 
    			StringUtils.isBlank(user.getUserPwd()) || user.getUserSex()==null || StringUtils.isBlank(user.getUserMobileNo())){
            httpRes.setCode(400);
            httpRes.setResDesc("参数缺失");
            return  httpRes;
        }
        try {
            //保存默认生日
			if(StringUtils.isNotBlank(birth)){
			    String value =  getBirth(birth);
			    if (StringUtils.isNotBlank(value)){
			        user.setUserBirth(new SimpleDateFormat("yyyy-MM-dd").parse(value));
			    }
			}
            String rs = terminalUserService.saveRegUser(user,code,request.getSession());
            if("NoValMobile".equals(rs)){
            	httpRes.setCode(400);
                httpRes.setResDesc("未获取验证码");
            }else if(Constant.SmsCodeErr.equals(rs)){
            	httpRes.setCode(400);
                httpRes.setResDesc("验证码验证失败,请确认验证码是否正确");
            }else if(Constant.RESULT_STR_FAILURE.equals(rs)){
            	httpRes.setCode(400);
                httpRes.setResDesc("手机号码不一致");
            }else if("NoUser".equals(rs)){
            	httpRes.setCode(400);
                httpRes.setResDesc("参数userId有误");
            }else if (Constant.RESULT_STR_SUCCESS.equals(rs)) {
                httpRes.setCode(200);
                httpRes.setResDesc("注册成功");
            } 
        } catch (Exception e) {
        	httpRes.setCode(500);
            httpRes.setResDesc("服务器响应失败");
            e.printStackTrace();
        }
        return httpRes;
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
}
