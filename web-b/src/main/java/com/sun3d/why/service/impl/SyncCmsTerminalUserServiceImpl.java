package com.sun3d.why.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.SyncCmsTerminalUserService;
import com.sun3d.why.webservice.api.model.CmsTerminalUserData;
import com.sun3d.why.webservice.api.token.TokenHelper;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import com.sun3d.why.webservice.api.util.TerminalUserConstant;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.ParseException;
import java.text.SimpleDateFormat;

/**
 * Created by chenjie on 2016/2/29.
 */
@Service
@Transactional
public class SyncCmsTerminalUserServiceImpl implements SyncCmsTerminalUserService {

    @Autowired
    private StaticServer staticServer;

    /**
     * 添加用户
     *
     * @param terminalUser
     * @return
     */
    @Override
    public void addTerminalUser(final CmsTerminalUser terminalUser) {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                //1.生成accessToken，以便于能够有权限对文化云直接写入操作。
                String accessToken=TokenHelper.generateToken("admin");
                TokenHelper.valid(accessToken);

                CmsTerminalUserData model = getCmsTerminalUserData(terminalUser);

                JSONObject json=new JSONObject();
                JSONObject datajson=(JSONObject) JSON.toJSON(model);
                json.put("sysno", TerminalUserConstant.SOURCE_CODE_SHANGHAI);//系统编号为必填
                json.put("token", accessToken);//accesstoken，系统根据用户名称创建 ,token，系统提供的密钥请保存
                json.put("data", datajson);//子系统与文化对接的数据接口，详细请参考接口文档
                HttpResponseText httpResponseText = HttpClientConnection.post(staticServer.getSyncServerUrl() + "/api/terminalUser/add.do", json);
                System.out.println("返回：" + httpResponseText.getData());
            }
        };
        Thread thread = new Thread(runnable);
        thread.start();
    }

    /**
     * 修改用户
     *
     * @param terminalUser
     * @return
     */
    @Override
    public void editTerminalUser(final CmsTerminalUser terminalUser) {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                //1.生成accessToken，以便于能够有权限对文化云直接写入操作。
                String accessToken=TokenHelper.generateToken("admin");
                TokenHelper.valid(accessToken);

                CmsTerminalUserData model = getCmsTerminalUserData(terminalUser);

                JSONObject json=new JSONObject();
                JSONObject datajson=(JSONObject) JSON.toJSON(model);
                json.put("sysno", TerminalUserConstant.SOURCE_CODE_SHANGHAI);//系统编号为必填
                json.put("token", accessToken);//accesstoken，系统根据用户名称创建 ,token，系统提供的密钥请保存
                json.put("data", datajson);//子系统与文化对接的数据接口，详细请参考接口文档
                HttpResponseText httpResponseText = HttpClientConnection.post(staticServer.getSyncServerUrl() + "/api/terminalUser/update.do", json);
                System.out.println("返回：" + httpResponseText.getData());
            }
        };
        Thread thread = new Thread(runnable);
        thread.start();
    }

    /**
     * 将添加的用户转换成传输所用的数据
     * @param cmsTerminalUser
     * @return
     */
    public CmsTerminalUserData getCmsTerminalUserData(CmsTerminalUser cmsTerminalUser){
        CmsTerminalUserData terminalUserData = new CmsTerminalUserData();
        if(cmsTerminalUser != null){
            //根据sourceCode确定传输的用户主键以便子系统查询
            if(cmsTerminalUser.getSourceCode().equals(TerminalUserConstant.SOURCE_CODE_SHANGHAI)){
                terminalUserData.setUserId(cmsTerminalUser.getUserId());
            }else {
                terminalUserData.setUserId(cmsTerminalUser.getSysId());
            }
            terminalUserData.setUserName(cmsTerminalUser.getUserName());
            terminalUserData.setUserPwd(cmsTerminalUser.getUserPwd());
            terminalUserData.setUserNickName(cmsTerminalUser.getUserNickName());
            terminalUserData.setUserEmail(cmsTerminalUser.getUserEmail());
            terminalUserData.setUserSex(cmsTerminalUser.getUserSex());
            terminalUserData.setUserAge(cmsTerminalUser.getUserAge());
            terminalUserData.setUseAddress(cmsTerminalUser.getUseAddress());
            terminalUserData.setUserHeadImgUrl(cmsTerminalUser.getUserHeadImgUrl());
            terminalUserData.setUserImei(cmsTerminalUser.getUserImei());
            terminalUserData.setUserImsi(cmsTerminalUser.getUserImsi());
            terminalUserData.setUserEquipmentId(cmsTerminalUser.getUserEquipmentId());
            terminalUserData.setUserGps(cmsTerminalUser.getUserGps());
            terminalUserData.setUserIp(cmsTerminalUser.getUserIp());
            terminalUserData.setUserMac(cmsTerminalUser.getUserMac());
            terminalUserData.setUserMobileType(cmsTerminalUser.getUserMobileType());
            terminalUserData.setUserInternetway(cmsTerminalUser.getUserInternetway());
            terminalUserData.setUserSiteId(cmsTerminalUser.getUserSiteId());
            terminalUserData.setSnstype(cmsTerminalUser.getSnstype());
            terminalUserData.setOperId(cmsTerminalUser.getOperId());
            terminalUserData.setAccessToken(cmsTerminalUser.getAccessToken());
            terminalUserData.setCreateTime(cmsTerminalUser.getCreateTime());
            terminalUserData.setUserDeviceToken(cmsTerminalUser.getUserDeviceToken());
            terminalUserData.setUserIsLogin(cmsTerminalUser.getUserIsLogin());
            terminalUserData.setUserMobileNo(cmsTerminalUser.getUserMobileNo());
            terminalUserData.setUserQq(cmsTerminalUser.getUserQq());
            terminalUserData.setUserRemark(cmsTerminalUser.getUserRemark());
            terminalUserData.setRegisterCode(cmsTerminalUser.getRegisterCode());
            terminalUserData.setRegisterCount(cmsTerminalUser.getRegisterCount());
            terminalUserData.setUserProvince(cmsTerminalUser.getUserProvince());
            terminalUserData.setUserCity(cmsTerminalUser.getUserCity());
            terminalUserData.setUserArea(cmsTerminalUser.getUserArea());
            terminalUserData.setUserType(cmsTerminalUser.getUserType());
            terminalUserData.setUserCardNo(cmsTerminalUser.getUserCardNo());
            terminalUserData.setCommentStatus(cmsTerminalUser.getCommentStatus());
            terminalUserData.setLastLoginTime(cmsTerminalUser.getLastLoginTime());
            terminalUserData.setLoginType(cmsTerminalUser.getLoginType());
            terminalUserData.setLastSendSmsTime(cmsTerminalUser.getLastSendSmsTime());
            terminalUserData.setUserIsDisable(cmsTerminalUser.getUserIsDisable());
            try {
                if(StringUtils.isNotBlank(cmsTerminalUser.getUserBirthStr())){
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    terminalUserData.setUserBirth(sdf.parse(cmsTerminalUser.getUserBirthStr()));
                }
            } catch (ParseException e) {
                e.printStackTrace();
            }
            terminalUserData.setSourceCode(cmsTerminalUser.getSourceCode());
            terminalUserData.setFunctionCode(cmsTerminalUser.getFunctionCode());
        }
        return terminalUserData;
    }

    public static void main(String[] args) {
        CmsTerminalUser cmsTerminalUser = new CmsTerminalUser();
        cmsTerminalUser.setSourceCode(TerminalUserConstant.SOURCE_CODE_JIADING);
        cmsTerminalUser.setFunctionCode(TerminalUserConstant.INSERT_THIRD_LOGIN);
        cmsTerminalUser.setUserId("test201603101");
        cmsTerminalUser.setUserName("test20160310");
        cmsTerminalUser.setUserPwd("ebebac9be2ce02a03393df17e6b4b959");
        cmsTerminalUser.setUserNickName("小试一下");
        cmsTerminalUser.setOperId("冇得");
        cmsTerminalUser.setUserSex(1);
        cmsTerminalUser.setUserHeadImgUrl("http://ww1.sinaimg.cn/crop.35.0.195.195.1024/006aX9EYjw8eucjstzd6nj307g085mxo.jpg");
        cmsTerminalUser.setUserMobileNo("15601919631");
        cmsTerminalUser.setUserIsDisable(1);
        cmsTerminalUser.setCommentStatus(1);
        SyncCmsTerminalUserServiceImpl syncCmsTerminalUserService = new SyncCmsTerminalUserServiceImpl();
        syncCmsTerminalUserService.addTerminalUser(cmsTerminalUser);
//        syncCmsTerminalUserService.editTerminalUser(cmsTerminalUser);
    }

}
