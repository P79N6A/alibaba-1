package com.sun3d.why.webservice.api.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONException;
import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.dao.CmsTerminalUserMapper;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CacheConstant;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.MD5Util;
import com.sun3d.why.webservice.api.model.CmsApiData;
import com.sun3d.why.webservice.api.model.CmsApiMessage;
import com.sun3d.why.webservice.api.model.CmsTerminalUserData;
import com.sun3d.why.webservice.api.service.CmsApiTerminalUserService;
import com.sun3d.why.webservice.api.util.CmsApiStatusConstant;
import com.sun3d.why.webservice.api.util.TerminalUserConstant;
import com.sun3d.why.webservice.api.util.TimeCounter;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by chenjie on 2016/2/29.
 * 用户数据对接
 */
@RequestMapping("/api/terminalUser")
@Controller
public class CmsApiTerminalUserController {

    private Logger logger = Logger.getLogger(getClass());

    @Autowired
    private CmsApiTerminalUserService cmsApiTerminalUserService;
    @Autowired
    private CmsTerminalUserMapper cmsTerminalUserMapper;

    /**
     * 添加用户信息
     *
     * @param json
     * @return
     */
    @RequestMapping(value = "/add.do", method = RequestMethod.POST)
    @ResponseBody
    public String add(@RequestBody String json) {

        System.out.println("==================json数据=================>" + json);
        CmsApiData<CmsTerminalUserData> apiData = new CmsApiData<CmsTerminalUserData>();
        JSONObject jsonObject = new JSONObject(); //返回json数据
        try {
            TimeCounter.logTime("CmsApiTerminalUserController", true, this.getClass());
            JSONObject data = JSON.parseObject(json);//解析数据为json
            String sysNo = data.getString("sysno");
            String token = data.getString("token");
            apiData.setSysno(sysNo);
            apiData.setToken(token);
            CmsTerminalUserData model = data.getObject("data", CmsTerminalUserData.class);//把data数据解析成对象
            apiData.setData(model);
            CmsApiMessage msg = this.cmsApiTerminalUserService.save(apiData);
            jsonObject.put("status", msg.getStatus());
            jsonObject.put("msg", msg.getText());
            jsonObject.put("code", msg.getCode());
        } catch (JSONException je) {
            String msg = "数据传输的格式不是JSON格式，请确认系统格式" + je.toString();
            jsonObject.put("status", false);
            jsonObject.put("msg", msg);
            jsonObject.put("code", CmsApiStatusConstant.ERROR);
            logger.error(msg);
        } catch (Exception e) {
            e.printStackTrace();
            String msg = "未知错误" + e.toString();
            jsonObject.put("status", false);
            jsonObject.put("msg", msg);
            jsonObject.put("code", CmsApiStatusConstant.ERROR);
            logger.error(msg);
        } finally {
            TimeCounter.logTime("CmsApiTerminalUserController", false, this.getClass());
        }
        return jsonObject.toString();
    }

    /**
     * 修改用户信息
     *
     * @param json
     * @return
     */
    @RequestMapping(value = "/update.do", method = RequestMethod.POST)
    @ResponseBody
    public String update(@RequestBody String json) {

        System.out.println("==================json数据=================>" + json);
        CmsApiData<CmsTerminalUserData> apiData = new CmsApiData<CmsTerminalUserData>();
        JSONObject jsonObject = new JSONObject(); //返回json数据
        try {

            JSONObject data = JSON.parseObject(json);//解析数据为json
            String sysNo = data.getString("sysno");
            String token = data.getString("token");

            apiData.setSysno(sysNo);
            apiData.setToken(token);

            CmsTerminalUserData model = data.getObject("data", CmsTerminalUserData.class);//把data数据解析成对象
            apiData.setData(model);

            CmsApiMessage msg = this.cmsApiTerminalUserService.update(apiData, null);

            jsonObject.put("status", msg.getStatus());
            jsonObject.put("msg", msg.getText());
            jsonObject.put("code", msg.getCode());
        } catch (JSONException je) {
            String msg = "数据传输的格式不是JSON格式，请确认系统格式";
            jsonObject.put("status", false);
            jsonObject.put("msg", msg);
            jsonObject.put("code", CmsApiStatusConstant.ERROR);
        } catch (Exception e) {
            e.printStackTrace();
            String msg = "未知错误" + e.toString();
            jsonObject.put("status", false);
            jsonObject.put("msg", msg);
            jsonObject.put("code", CmsApiStatusConstant.ERROR);
            logger.error(msg);
        }
        return jsonObject.toString();
    }


    /**
     * 国家支撑平台单点登陆校验
     * 支撑平台发送用户名和校验码，查询数据库是否有对应用户信息，用户ID为用户名MD5加密码
     *
     * @param CheckKey
     * @param LoginId
     * @param request
     * @param response
     */
    @RequestMapping(value = "/userInfoCheck", method = RequestMethod.GET)
    @ResponseBody
    public int userInfoCheck(String CheckKey, String LoginId, HttpServletRequest request, HttpServletResponse response) {
        int result;
        try {
            CmsTerminalUser terminalUser = new CmsTerminalUser();
            if (StringUtils.isNotBlank(CheckKey) && CheckKey == "b4411d88d3cb7244b6c78209449fa81c") {
                terminalUser = cmsTerminalUserMapper.queryTerminalUserById(MD5Util.toMd5(LoginId));
                if (StringUtils.isNotBlank(terminalUser.getUserName())) {
                    result = 1;
                } else {
                    result = 0;
                }
            } else {
                result = -1;
            }
        } catch (Exception e) {
            result = 999;
        }
        return result;
    }

    /**
     * 国家支撑平台单点登陆注册
     * 支撑平台发送用户名和校验码，查询数据库是否有对应用户信息，用户ID为用户名MD5加密码
     *
     * @param CheckKey
     * @param LoginId
     * @param request
     * @param response
     */
    @RequestMapping(value = "/appUserRegister", method = RequestMethod.GET)
    @ResponseBody
    public String appUserRegister(String CheckKey, String LoginId, HttpServletRequest request, HttpServletResponse response) {
        JSONObject jsonObject = new JSONObject(); //返回json数据
        try {
            CmsTerminalUser terminalUser = new CmsTerminalUser();
            if (StringUtils.isNotBlank(CheckKey) && CheckKey == "b4411d88d3cb7244b6c78209449fa81c") {
                terminalUser.setUserId(MD5Util.toMd5(LoginId));
                terminalUser.setUserName("CSIP-" + LoginId);
                terminalUser.setUserPwd(MD5Util.toMd5(LoginId));
                String result = cmsApiTerminalUserService.addTerminalUser(terminalUser);
                if (Constant.RESULT_STR_SUCCESS.equals(result)) {
                    jsonObject.put("mode", "ok");
                    jsonObject.put("identity", MD5Util.toMd5(LoginId));
                } else if (Constant.RESULT_STR_REPEAT.equals(result)) {
                    jsonObject.put("mode", "fail");
                    jsonObject.put("identity", "此用户名已注册过！");
                } else {
                    jsonObject.put("mode", "fail");
                    jsonObject.put("identity", "信息完整，由于服务器原因，用户信息注册失败！");
                }
            } else {
                jsonObject.put("mode", "fail");
                jsonObject.put("identity", "安全码错误，请检查后重新请求！");
            }
        } catch (Exception e) {
            jsonObject.put("mode", "fail");
            jsonObject.put("identity", "插入数据失败！");
        }
        return jsonObject.toString();
    }
}
