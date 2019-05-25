package com.sun3d.why.webservice.api.service.impl;

import com.sun3d.why.dao.CmsTerminalUserMapper;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.SyncCmsTerminalUserService;
import com.sun3d.why.util.*;
import com.sun3d.why.webservice.api.model.CmsApiData;
import com.sun3d.why.webservice.api.model.CmsApiFile;
import com.sun3d.why.webservice.api.model.CmsApiMessage;
import com.sun3d.why.webservice.api.model.CmsTerminalUserData;
import com.sun3d.why.webservice.api.service.CmsApiAttachmenetService;
import com.sun3d.why.webservice.api.service.CmsApiTerminalUserService;
import com.sun3d.why.webservice.api.util.CmsApiStatusConstant;
import com.sun3d.why.webservice.api.util.CmsApiUtil;
import com.sun3d.why.webservice.api.util.TerminalUserConstant;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
public class CmsApiTerminalUserServiceImpl implements CmsApiTerminalUserService {

    @Autowired
    private CmsTerminalUserMapper cmsTerminalUserMapper;

    @Autowired
    private CmsApiAttachmenetService cmsApiAttachmenetService;

    @Autowired
    private SyncCmsTerminalUserService syncCmsTerminalUserService;

    @Autowired
    private StaticServer staticServer;

    @Autowired
    private HttpSession session;

    @Autowired
	private SmsUtil SmsUtil;
    /**
     * 添加用户信息
     *
     * @param apiData 用户数据
     * @return
     * @throws Exception
     */
    @Override
    public CmsApiMessage save(CmsApiData<CmsTerminalUserData> apiData) throws Exception {
        CmsApiMessage cmsApiMessage = this.check(apiData);
        boolean bool = cmsApiMessage.getStatus();
        if (bool) {
            CmsTerminalUserData terminalUserData = apiData.getData();
            Integer functionCode = terminalUserData.getFunctionCode();
            Integer sourceCode = terminalUserData.getSourceCode();

            //根据手机号校验数据是否存在
            Map<String, Object> paramMap = new HashMap<String, Object>();
            paramMap.put("userMobileNo", terminalUserData.getUserMobileNo());
            int checkExist = cmsTerminalUserMapper.queryTerminalUserIsExists(paramMap);
            String userId = cmsTerminalUserMapper.getTerminalUserIdBySysId(terminalUserData.getUserId());
            //如果checkExist等于零则代表存在手机号但不存在于系统中，用户ID如若不存在则直接添加
            //如果userMobileNo等于空则代表第三方登录添加，用户ID如若不存在则直接添加
            if ((checkExist == 0 || org.apache.commons.lang3.StringUtils.isBlank(terminalUserData.getUserMobileNo())) && org.apache.commons.lang3.StringUtils.isBlank(userId)) {
                CmsTerminalUser cmsTerminalUser = getCmsTerminalUser(terminalUserData);

                //赋予基础默认值
                cmsTerminalUser.setCreateTime(new Date());
                cmsTerminalUser.setLastLoginTime(new Date());
                //sysId代表第三方用户ID、userId代表文化云ID、sourceCode代表第三方来源
                cmsTerminalUser.setSourceCode(sourceCode);
                cmsTerminalUser.setSysId(terminalUserData.getUserId());
                cmsTerminalUser.setUserId(UUIDUtils.createUUId());



                //上传子系统图片至文化云------------start
                String userHeadImgUrl = terminalUserData.getUserHeadImgUrl();
                if (org.apache.commons.lang3.StringUtils.isNotBlank(userHeadImgUrl)) {
                    CmsApiFile apiFile = this.cmsApiAttachmenetService.checkImage(userHeadImgUrl);
                    if (apiFile.getSuccess() == 0) {
                        cmsApiMessage.setStatus(false);
                        cmsApiMessage.setCode(CmsApiStatusConstant.DATA_ERROR);
                        cmsApiMessage.setText("上传图片时发生错误：" + apiFile.getMsg());
                        return cmsApiMessage;
                    }
                    SysUser sysUser = new SysUser();
                    sysUser.setUserCounty("57,嘉定区");
                    String imageUrl = this.cmsApiAttachmenetService.uploadImage(userHeadImgUrl, sysUser, "2");
                    if (org.apache.commons.lang3.StringUtils.isNotBlank(imageUrl)) {
                        cmsTerminalUser.setUserHeadImgUrl(imageUrl);
                    }
                }

                //上传子系统图片至文化云------------end

                //如果为文化云注册用户，添加相应数据
                //如果为第三方登录生成用户，添加相应数据
                if (functionCode.equals(TerminalUserConstant.INSERT_USER_INFO)) {
                    //不做任何操作，直接将嘉定数据入库
                } else if (functionCode.equals(TerminalUserConstant.INSERT_THIRD_LOGIN)) {
                    //不做任何操作，直接将嘉定数据入库
                } else {
                    cmsApiMessage.setStatus(false);
                    cmsApiMessage.setCode(CmsApiStatusConstant.DATA_ERROR);
                    cmsApiMessage.setText("添加失败，执行操作不明确");
                    return cmsApiMessage;
                }

                int count = cmsTerminalUserMapper.addTerminalUser(cmsTerminalUser);
                if (count > 0) {
                    cmsApiMessage.setStatus(true);
                    cmsApiMessage.setCode(-1);
                    cmsApiMessage.setText("添加成功");
                } else {
                    cmsApiMessage.setStatus(false);
                    cmsApiMessage.setCode(CmsApiStatusConstant.ERROR);
                    cmsApiMessage.setText("添加失败");
                }
            } else {
                //根据ID更新用户信息
                return this.update(apiData, TerminalUserConstant.UPDATE_USER_INFO);
            }
        }
        return cmsApiMessage;
    }

    /**
     * 修改用户信息
     * 添加用户时，如果用户已存在则执行修改操作
     * 修改用户时，functionType赋值为null
     *
     * @param apiData 用户数据
     * @return
     * @throws Exception
     */
    @Override
    public CmsApiMessage update(CmsApiData<CmsTerminalUserData> apiData, Integer functionCode) throws Exception {
        CmsApiMessage cmsApiMessage = this.check(apiData);
        boolean bool = cmsApiMessage.getStatus();
        if (bool) {
            CmsTerminalUserData terminalUserData = apiData.getData();
            //默认以接口传递的操作编号为准，赋值后以赋值操作执行
            if (functionCode == null) {
                functionCode = terminalUserData.getFunctionCode();
            }
            String userId = "";
            if (terminalUserData.getSourceCode().equals(TerminalUserConstant.SOURCE_CODE_SHANGHAI)) {
                //根据第三方系统用户ID查询文化云系统用户ID
                CmsTerminalUser tempTerminalUser = cmsTerminalUserMapper.queryTerminalUserById(terminalUserData.getUserId());
                if (tempTerminalUser != null) {
                    userId = tempTerminalUser.getUserId();
                }
            } else {
                //根据第三方系统用户ID查询文化云系统用户ID
                userId = cmsTerminalUserMapper.getTerminalUserIdBySysId(terminalUserData.getUserId());
            }
            //如果不存在则修改终止
            //如果存在则执行修改
            if (org.apache.commons.lang3.StringUtils.isNotBlank(userId)) {
                //更新的用户数据载体
                CmsTerminalUser updateData = new CmsTerminalUser();
                //默认修改失败
                int resultCount = 0;
                //根据功能进行差异赋值
                if (functionCode.equals(TerminalUserConstant.UPDATE_USER_INFO)) {
                    //修改所有信息
                    updateData = getCmsTerminalUser(terminalUserData);

                    //上传子系统图片至文化云------------start
                    String userHeadImgUrl = terminalUserData.getUserHeadImgUrl();
                    if (userHeadImgUrl != null && !userHeadImgUrl.equals("")) {
                        CmsApiFile apiFile = this.cmsApiAttachmenetService.checkImage(userHeadImgUrl);
                        if (apiFile.getSuccess() == 0) {
                            cmsApiMessage.setStatus(false);
                            cmsApiMessage.setCode(CmsApiStatusConstant.DATA_ERROR);
                            cmsApiMessage.setText("上传图片时发生错误：" + apiFile.getMsg());
                            return cmsApiMessage;
                        }
                        SysUser sysUser = new SysUser();
                        sysUser.setUserCounty("57,嘉定区");
                        String imageUrl = this.cmsApiAttachmenetService.uploadImage(userHeadImgUrl, sysUser, "2");
                        if (org.apache.commons.lang3.StringUtils.isNotBlank(imageUrl)) {
                            updateData.setUserHeadImgUrl(imageUrl);
                        }
                    }
                    //上传子系统图片至文化云------------end
                } else if (functionCode.equals(TerminalUserConstant.UPDATE_USER_PASSWORD)) {
                    //修改用户密码
                    updateData.setUserPwd(terminalUserData.getUserPwd());
                } else if (functionCode.equals(TerminalUserConstant.UPDATE_USER_ACTIVE)) {
                    //激活用户
                    updateData.setUserIsDisable(Constant.USER_IS_ACTIVATE);
                } else if (functionCode.equals(TerminalUserConstant.UPDATE_USER_FREEZE)) {
                    //冻结用户
                    updateData.setUserIsDisable(Constant.USER_IS_FREEZE);
                } else if (functionCode.equals(TerminalUserConstant.UPDATE_USER_COMMENT_ACTIVE)) {
                    //激活用户评论
                    updateData.setCommentStatus(Constant.NO_DISABLE_TERMINAL_USER_COMMENT);
                } else if (functionCode.equals(TerminalUserConstant.UPDATE_USER_COMMENT_DISABLE)) {
                    //冻结用户评论
                    updateData.setCommentStatus(Constant.DISABLE_TERMINAL_USER_COMMENT);
                } else if (functionCode.equals(TerminalUserConstant.UPDATE_USER_MOBILE_NO)) {
                    //修改用户手机号
                    updateData.setUserMobileNo(terminalUserData.getUserMobileNo());
                } else {
                    cmsApiMessage.setStatus(false);
                    cmsApiMessage.setCode(CmsApiStatusConstant.DATA_ERROR);
                    cmsApiMessage.setText("修改失败，执行操作不明确");
                    return cmsApiMessage;
                }

                //赋予基础默认值
                updateData.setUserId(userId);
                updateData.setCreateTime(new Date());
                updateData.setLastLoginTime(new Date());

                //返回修改结果
                resultCount = cmsTerminalUserMapper.editTerminalUserById(updateData);
                if (resultCount > 0) {
                    cmsApiMessage.setStatus(true);
                    cmsApiMessage.setCode(-1);
                    cmsApiMessage.setText("修改成功");
                } else {
                    cmsApiMessage.setStatus(false);
                    cmsApiMessage.setCode(CmsApiStatusConstant.ERROR);
                    cmsApiMessage.setText("修改失败");
                }
            } else {
                //操作终止，原因：数据为空
                cmsApiMessage.setStatus(false);
                cmsApiMessage.setCode(CmsApiStatusConstant.DATA_ERROR);
                cmsApiMessage.setText("修改失败,当前用户不存在！");
            }
        }
        return cmsApiMessage;
    }

    /**
     * 删除用户信息【此方法暂不可用】
     *
     * @param apiData 用户数据
     * @return
     * @throws Exception
     */
    @Override
    public CmsApiMessage delete(CmsApiData<CmsTerminalUserData> apiData) throws Exception {
        CmsApiMessage cmsApiMessage = this.check(apiData);
        boolean bool = cmsApiMessage.getStatus();
        if (bool) {
            CmsTerminalUserData terminalUserData = apiData.getData();
            Integer functionCode = terminalUserData.getFunctionCode();

            //根据手机号校验数据是否存在
            Map<String, Object> paramMap = new HashMap<String, Object>();
            paramMap.put("userMobileNo", terminalUserData.getUserMobileNo());
            int checkExist = cmsTerminalUserMapper.queryTerminalUserIsExists(paramMap);
            //如果不存在则执行添加操作
            //如果存在则执行添加操作
            if (checkExist > 0) {
                //赋予基础默认值
                terminalUserData.setCreateTime(new Date());
                terminalUserData.setLastLoginTime(new Date());

                int resultCount = 0;

                if (functionCode.equals(TerminalUserConstant.DELETE_USER_LOGIC)) {
                    //逻辑删除即为冻结，这里不做任何操作
                } else if (functionCode.equals(TerminalUserConstant.DELETE_USER_PHYSICAL)) {
                    //用户暂不做物理删除操作
                } else {
                    cmsApiMessage.setStatus(false);
                    cmsApiMessage.setCode(CmsApiStatusConstant.DATA_ERROR);
                    cmsApiMessage.setText("删除失败，执行操作不明确");
                    return cmsApiMessage;
                }

                if (resultCount > 0) {
                    cmsApiMessage.setStatus(true);
                    cmsApiMessage.setCode(-1);
                    cmsApiMessage.setText("删除成功");
                } else {
                    cmsApiMessage.setStatus(false);
                    cmsApiMessage.setCode(CmsApiStatusConstant.ERROR);
                    cmsApiMessage.setText("删除失败");
                }
            } else {
                //操作终止，原因：数据为空
                cmsApiMessage.setStatus(false);
                cmsApiMessage.setCode(CmsApiStatusConstant.DATA_ERROR);
                cmsApiMessage.setText("修改失败");
            }
        }
        return cmsApiMessage;
    }


    //校验系统数据，校验系统编号，token是否有效
    private CmsApiMessage check(CmsApiData<CmsTerminalUserData> apiData) throws Exception {
        String sysNo = apiData.getSysno();
        String token = apiData.getToken();

        CmsApiMessage msg = CmsApiUtil.checkToken(sysNo, token);
        if (msg.getStatus()) {
            CmsTerminalUserData model = apiData.getData();

            if (model == null) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                msg.setText("数据不能为空");
                return msg;
            }
            if (model.getSourceCode() == null) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                msg.setText("数据来源不明确");
                return msg;
            }
            if (model.getFunctionCode() == null) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                msg.setText("数据操作不明确");
                return msg;
            }
            if (StringUtils.isNull(model.getUserId())) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                msg.setText("用户ID不能为空");
                return msg;
            }
//            if(StringUtils.isNull(model.getUserName())){
//                msg.setStatus(false);
//                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
//                msg.setText("用户昵称不能为空");
//                return msg;
//            }
            if (StringUtils.isNull(model.getUserPwd()) && model.getFunctionCode().equals(TerminalUserConstant.UPDATE_USER_PASSWORD)) {
                msg.setStatus(false);
                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
                msg.setText("用户密码不能为空");
                return msg;
            }
//            if(StringUtils.isNull(model.getUserMobileNo()) && !model.getFunctionCode().equals(TerminalUserConstant.INSERT_THIRD_LOGIN)){
//                msg.setStatus(false);
//                msg.setCode(CmsApiStatusConstant.DATA_ERROR);
//                msg.setText("手机号码不能为空");
//                return msg;
//            }
            //赋予默认值
            msg.setStatus(true);
            msg.setCode(CmsApiStatusConstant.SUCCESS);
            msg.setText("数据校验成功");
        }
        return msg;
    }

    /**
     * 将传输的用户数据转化为SQL对应的实体对象数据
     *
     * @param cmsTerminalUserData
     * @return
     */
    public CmsTerminalUser getCmsTerminalUser(CmsTerminalUserData cmsTerminalUserData) {
        CmsTerminalUser cmsTerminalUser = new CmsTerminalUser();
        if (cmsTerminalUserData != null) {
            cmsTerminalUser.setUserId(cmsTerminalUserData.getUserId());
            cmsTerminalUser.setUserName(cmsTerminalUserData.getUserName());
            cmsTerminalUser.setUserPwd(cmsTerminalUserData.getUserPwd());
            cmsTerminalUser.setUserNickName(cmsTerminalUserData.getUserNickName());
            cmsTerminalUser.setUserEmail(cmsTerminalUserData.getUserEmail());
            cmsTerminalUser.setUserSex(cmsTerminalUserData.getUserSex());
            cmsTerminalUser.setUserAge(cmsTerminalUserData.getUserAge());
            cmsTerminalUser.setUseAddress(cmsTerminalUserData.getUseAddress());
            cmsTerminalUser.setUserHeadImgUrl(cmsTerminalUserData.getUserHeadImgUrl());
            cmsTerminalUser.setUserImei(cmsTerminalUserData.getUserImei());
            cmsTerminalUser.setUserImsi(cmsTerminalUserData.getUserImsi());
            cmsTerminalUser.setUserEquipmentId(cmsTerminalUserData.getUserEquipmentId());
            cmsTerminalUser.setUserGps(cmsTerminalUserData.getUserGps());
            cmsTerminalUser.setUserIp(cmsTerminalUserData.getUserIp());
            cmsTerminalUser.setUserMac(cmsTerminalUserData.getUserMac());
            cmsTerminalUser.setUserMobileType(cmsTerminalUserData.getUserMobileType());
            cmsTerminalUser.setUserInternetway(cmsTerminalUserData.getUserInternetway());
            cmsTerminalUser.setUserSiteId(cmsTerminalUserData.getUserSiteId());
            cmsTerminalUser.setSnstype(cmsTerminalUserData.getSnstype());
            cmsTerminalUser.setOperId(cmsTerminalUserData.getOperId());
            cmsTerminalUser.setAccessToken(cmsTerminalUserData.getAccessToken());
            cmsTerminalUser.setCreateTime(cmsTerminalUserData.getCreateTime());
            cmsTerminalUser.setUserDeviceToken(cmsTerminalUserData.getUserDeviceToken());
            cmsTerminalUser.setUserIsLogin(cmsTerminalUserData.getUserIsLogin());
            cmsTerminalUser.setUserMobileNo(cmsTerminalUserData.getUserMobileNo());
            cmsTerminalUser.setUserQq(cmsTerminalUserData.getUserQq());
            cmsTerminalUser.setUserRemark(cmsTerminalUserData.getUserRemark());
            cmsTerminalUser.setRegisterCode(cmsTerminalUserData.getRegisterCode());
            cmsTerminalUser.setRegisterCount(cmsTerminalUserData.getRegisterCount());
            cmsTerminalUser.setUserProvince(cmsTerminalUserData.getUserProvince());
            cmsTerminalUser.setUserCity(cmsTerminalUserData.getUserCity());
            cmsTerminalUser.setUserArea(cmsTerminalUserData.getUserArea());
            cmsTerminalUser.setUserType(cmsTerminalUserData.getUserType());
            cmsTerminalUser.setUserCardNo(cmsTerminalUserData.getUserCardNo());
            cmsTerminalUser.setCommentStatus(cmsTerminalUserData.getCommentStatus());
            cmsTerminalUser.setLastLoginTime(cmsTerminalUserData.getLastLoginTime());
            cmsTerminalUser.setLoginType(cmsTerminalUserData.getLoginType());
            cmsTerminalUser.setLastSendSmsTime(cmsTerminalUserData.getLastSendSmsTime());
            cmsTerminalUser.setUserIsDisable(cmsTerminalUserData.getUserIsDisable());
            cmsTerminalUser.setUserBirth(cmsTerminalUserData.getUserBirth());
            cmsTerminalUser.setSourceCode(cmsTerminalUserData.getSourceCode());
            cmsTerminalUser.setFunctionCode(cmsTerminalUserData.getFunctionCode());
            //将第三方传输的用户ID置于SysID字段
            cmsTerminalUser.setSysId(cmsTerminalUserData.getUserId());
        }
        return cmsTerminalUser;
    }

    /***
     * 优化登录 只查询需要用的字段
     *
     * @param userId
     * @return
     */
    @Override
    public CmsTerminalUser webLogin(String userId) {
        try {//只查询一次
            CmsTerminalUser terminalUser = new CmsTerminalUser();
            if (userId.length()>11) {
                terminalUser = cmsTerminalUserMapper.queryTerminalUserById(userId);
            } else {
                terminalUser = cmsTerminalUserMapper.getCmsTerminalUserByMobile(userId);
            }
            if (terminalUser != null) {
                return terminalUser;
            } else {
                return null;
            }
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 新增会员
     *
     * @param user
     * @return success:成功 failure:失败 repeat:重复 mobileRepeat:手机重复 disPwd:密码不一致
     */
    public String addTerminalUser(CmsTerminalUser user) {
        try {
            if (user != null) {
                Map<String, Object> map = new HashMap<String, Object>();
                if (org.apache.commons.lang3.StringUtils.isNotBlank(user.getUserMobileNo())) {
                    map.put("userMobileNo", user.getUserMobileNo());
                    int exit = cmsTerminalUserMapper.queryTerminalUserIsExists(map);
                    if (exit > 0) {
                        return Constant.RESULT_STR_MOBILE_REPEAT;
                    }
                }
                if (org.apache.commons.lang3.StringUtils.isNotBlank(user.getUserName())) {
                    map.put("userName", user.getUserName());
                    int exit = cmsTerminalUserMapper.queryTerminalUserIsExists(map);
                    if (exit > 0) {
                        return Constant.RESULT_STR_REPEAT;
                    }
                }
                if (org.apache.commons.lang3.StringUtils.isNotBlank(user.getUserBirthStr())) {
                    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                    user.setUserBirth(format.parse(user.getUserBirthStr()));
                }
                user.setCreateTime(new Timestamp(System.currentTimeMillis()));
                user.setCommentStatus(1);
                int count = cmsTerminalUserMapper.addTerminalUser(user);
                if (count > 0) {
                    return Constant.RESULT_STR_SUCCESS;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    private void sendPasswordToMobil(final CmsTerminalUser user, final String userPwd, final String userMobileNo) {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("userName", user.getUserName());
                map.put("userPassWord", userPwd);
                //String smsContent = userMessageService.getSmsTemplate(Constant.ADD_TERMINAL_USER_MESSAGE, map);
                //String smsContent = "您的文化云用户已注册成功，密码 123456789 请登录修改密码！";
                //sendSmsMessage(user.getUserMobileNo(), smsContent);
                SmsUtil.sendUserInfoCode(userMobileNo, map);
            }
        };
        Thread thread = new Thread(runnable);
        thread.start();
    }
}
