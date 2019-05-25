package com.sun3d.why.webservice.api.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONException;
import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CacheConstant;
import com.sun3d.why.util.Constant;
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
     * 单点登陆校验
     *
     * @param userName
     * @param request
     * @param response
     */
    @RequestMapping(value = "/login")
//    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String terminalLogin(String userName, String userMobileNo, HttpServletRequest request, HttpServletResponse response) {
        CmsTerminalUser user = new CmsTerminalUser();
        if(StringUtils.isNotBlank(userName)){
            user.setUserName("CSIP-"+userName);
            user.setUserMobileNo(userMobileNo);
            try {
                String result = cmsApiTerminalUserService.webLogin(user);
            } catch (Exception e) {
            }
        }

        return "index/index/index";
    }

}
