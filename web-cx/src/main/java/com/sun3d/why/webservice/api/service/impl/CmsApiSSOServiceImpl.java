package com.sun3d.why.webservice.api.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.dao.CmsTerminalUserMapper;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.SyncCmsTerminalUserService;
import com.sun3d.why.util.*;
import com.sun3d.why.util.StringUtils;
import com.sun3d.why.webservice.api.model.CmsApiData;
import com.sun3d.why.webservice.api.model.CmsApiFile;
import com.sun3d.why.webservice.api.model.CmsApiMessage;
import com.sun3d.why.webservice.api.model.CmsTerminalUserData;
import com.sun3d.why.webservice.api.service.CmsApiAttachmenetService;
import com.sun3d.why.webservice.api.service.CmsApiSSOService;
import com.sun3d.why.webservice.api.service.CmsApiTerminalUserService;
import com.sun3d.why.webservice.api.util.CmsApiStatusConstant;
import com.sun3d.why.webservice.api.util.CmsApiUtil;
import com.sun3d.why.webservice.api.util.TerminalUserConstant;
import org.apache.commons.lang3.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by chenjie on 2016/2/29.
 */
@Service
@Transactional
public class CmsApiSSOServiceImpl implements CmsApiSSOService {

    @Autowired
    private CmsTerminalUserMapper cmsTerminalUserMapper;

    @Autowired
    private CmsApiTerminalUserService cmsApiTerminalUserService;



    /**
     * 国家支撑平台单点登陆注册
     * 支撑平台发送用户名和校验码，查询数据库是否有对应用户信息，用户ID为用户名MD5加密码
     * @param CheckKey
     * @param LoginId
     */
    @Override
    public String appUserRegister(String CheckKey, String LoginId) {
        JSONObject jsonObject = new JSONObject(); //返回json数据
        try {
            CmsTerminalUser terminalUser = new CmsTerminalUser();
            if (org.apache.commons.lang3.StringUtils.isNotBlank(CheckKey) && CheckKey.equals("b4411d88d3cb7244b6c78209449fa81c")) {
                terminalUser.setUserId(MD5Util.toMd5(LoginId));
                terminalUser.setUserName("CSIP-" + LoginId);
                terminalUser.setUserPwd(MD5Util.toMd5(LoginId));
                String result = cmsApiTerminalUserService.addTerminalUser(terminalUser);
                if (Constant.RESULT_STR_SUCCESS.equals(result)) {
                    jsonObject.put("mode", "ok");
                    jsonObject.put("identity", MD5Util.toMd5(LoginId));
                } else if(Constant.RESULT_STR_REPEAT.equals(result)) {
                    terminalUser = cmsTerminalUserMapper.queryTerminalUserById(MD5Util.toMd5(LoginId));
                    jsonObject.put("mode", "ok");
                    jsonObject.put("identity", MD5Util.toMd5(LoginId));
                } else{
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
            e.printStackTrace();
        }
        System.out.println(jsonObject.toString());
        return jsonObject.toString();
    }
    /**
     * 国家支撑平台单点登陆校验
     * 支撑平台发送用户名和校验码，查询数据库是否有对应用户信息，用户ID为用户名MD5加密码
     * @param CheckKey
     * @param LoginId
     */
    @Override
    public int userInfoCheck(String CheckKey, String LoginId,String PassWord) {
        int result;
        try {
            CmsTerminalUser terminalUser = new CmsTerminalUser();
            if (org.apache.commons.lang3.StringUtils.isNotBlank(CheckKey) &&CheckKey.equals("b4411d88d3cb7244b6c78209449fa81c")) {
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("userName", LoginId);
                map.put("userPwd",MD5Util.toMd5(PassWord));
                terminalUser = cmsTerminalUserMapper.queryTerminalByMobileOrPwd(map);
                if (terminalUser!=null) {
                    result = 1;
                } else {
                    result = 0;
                }
            } else {
                result = -1;
            }
        } catch (Exception e) {
            result = 999;
            e.printStackTrace();
        }
        System.out.println(result);
        return result;
    }
}
