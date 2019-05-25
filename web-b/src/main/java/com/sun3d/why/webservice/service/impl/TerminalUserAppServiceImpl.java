package com.sun3d.why.webservice.service.impl;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.sun3d.why.dao.CmsTeamUserMapper;
import com.sun3d.why.dao.CmsTerminalUserMapper;
import com.sun3d.why.dao.CmsUserMessageMapper;
import com.sun3d.why.dao.CmsUserOperatorLogMapper;
import com.sun3d.why.dao.UserIntegralDetailMapper;
import com.sun3d.why.dao.UserIntegralMapper;
import com.sun3d.why.enumeration.UserOperationEnum;
import com.sun3d.why.model.CmsTeamUser;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsUserOperatorLog;
import com.sun3d.why.model.UserIntegral;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.extmodel.BasePath;
import com.sun3d.why.model.extmodel.SmsConfig;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CmsTeamUserService;
import com.sun3d.why.service.CmsUserMessageService;
import com.sun3d.why.service.SyncCmsTerminalUserService;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.EmojiFilter;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.MD5Util;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.SmsUtil;
import com.sun3d.why.util.TimeUtil;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.util.UploadFile;
import com.sun3d.why.webservice.api.token.TokenHelper;
import com.sun3d.why.webservice.api.util.TerminalUserConstant;
import com.sun3d.why.webservice.service.TerminalUserAppService;
@Service
@Transactional
public class TerminalUserAppServiceImpl implements TerminalUserAppService {
    private Logger logger = Logger.getLogger(TerminalUserAppServiceImpl.class);
    @Autowired
    private CmsTerminalUserMapper userMapper;
    @Autowired
    private CmsUserMessageService userMessageService;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private BasePath basePath;
    @Autowired
    private CmsTeamUserMapper cmsTeamUserMapper;
    @Autowired
    private SmsConfig smsConfig;
    @Autowired
    private HttpSession session;
    @Autowired
    private CmsUserMessageMapper cmsUserMessageMapper;

    @Autowired
    private SyncCmsTerminalUserService syncCmsTerminalUserService;
    
    @Autowired
    private UserIntegralMapper userIntegralMapper;
    
    @Autowired
    private UserIntegralDetailMapper userIntegralDetailMapper;
    
    @Autowired
    private CmsTeamUserService cmsTeamUserService;
    
    @Autowired
    private UserIntegralDetailService userIntegralDetailService;
    
    @Autowired
    private CmsUserOperatorLogMapper cmsUserOperatorLogMapper;

    /**
     * app上传文件根据用户id获取用户信息
     * @param userId 用户id
     * @param teamUserId 团体id
     * @parma mulFile 文件流对象
     * @param uploadType  上传类型 1.多文件 2.用户头像 3.团体用户 4.玩家秀
     * @param modelType  模块类型类型 1.活动 2.个人头像 3.多图片(评论) 4.首页轮播
     * @return
     */
    @Override
    public String queryTerminalUserFilesById(String userId,String teamUserId,MultipartFile mulFile,String uploadType,String modelType) throws Exception{
        //处理文件
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        //返回信息
        String dirPath = null;
        //返回前台页面json格式
        String json = "";
        //状态
        int status=0;
        try {
            CmsTerminalUser terminalUser = userMapper.queryTerminalUserById(userId);
            if (terminalUser == null) {
                json = UploadFile.toResultFormat(10111, "用户不存在!");
                return  json;
            }
            if (mulFile == null) {
                json = UploadFile.toResultFormat(10112, "不能匹配正在上传的文件,上传处理终止!");
            } else {
                // 获取文件后缀
                String imgSuffix = UploadFile.getImgSuffix(mulFile);
                String newImgName = "";
                if (StringUtils.isNotBlank("uploadType")) {
                    newImgName = Constant.IMG + UUIDUtils.createUUId();
                }
                // String newImgName ="Img" + sdf.format(new Date()) + RandomStringUtils.random(3, false, true);
                sdf.applyPattern("yyyyMM");
                StringBuffer uploadCode=new StringBuffer();//拼接图片路径
                uploadCode.append(Constant.type_front + "/");
                if(terminalUser!=null && StringUtils.isNotBlank(terminalUser.getUserMobileNo())){
                    uploadCode.append(terminalUser.getUserMobileNo().substring(0, 7)+"/");
                }else {
                    uploadCode.append("0000000"+"/");
                }
                uploadCode.append(sdf.format(new Date()));
                //   String uploadCode = Constant.type_front + "/" + terminalUser.getUserMobileNo().substring(0, 7) + "/" + sdf.format(new Date());
                StringBuffer fileUrl = new StringBuffer();
                fileUrl.append(uploadCode.toString() + "/" + Constant.IMG);
                /***********位置请不要挪动*************/
                dirPath = fileUrl.toString();
                //处理原文件
                UploadFile.uploadFile(mulFile, newImgName, imgSuffix, dirPath, basePath);
                /***********位置请不要挪动*************/
                /***************新添加代码*******************/
                fileUrl.append("/");
                fileUrl.append(newImgName);
                String imagePath = basePath.getBasePath() + fileUrl.toString();
                //处理上传图片进行缩放,其他的格式不进行处理
                if (imgSuffix.equalsIgnoreCase(".jpg") || imgSuffix.equalsIgnoreCase(".JPG") || imgSuffix.equalsIgnoreCase(".png") || imgSuffix.equalsIgnoreCase(".PNG") ||
                        imgSuffix.equalsIgnoreCase(".bmp") || imgSuffix.equalsIgnoreCase(".BMP") || imgSuffix.equalsIgnoreCase(".gif") || imgSuffix.equalsIgnoreCase(".GIF") ||
                        imgSuffix.equalsIgnoreCase(".jpeg") || imgSuffix.equalsIgnoreCase(".JPEG")) {
                       UploadFile.zoomFile(mulFile, imagePath, imgSuffix, "7",modelType);
                }
                //添加图片格式后缀
                fileUrl.append(imgSuffix);
                //app绝对路径
                String appFileUrl = staticServer.getStaticServerUrl() + fileUrl.toString();
                if(Integer.valueOf(uploadType)==1 || Integer.valueOf(uploadType)==4) {
                    json = UploadFile.toResultFormat(0,appFileUrl);
                }
                if(StringUtils.isNotBlank(uploadType) && Integer.valueOf(uploadType)==2) {
                    terminalUser.setUserHeadImgUrl(fileUrl.toString());
                    //进行编辑用户头像url
                    status = userMapper.editTerminalUserById(terminalUser);
                }else if(StringUtils.isNotBlank(uploadType) && Integer.valueOf(uploadType)==3){
                    Map<String,Object> map=new HashMap<String, Object>();
                    map.put("tuserIsDisplay",Constant.NORMAL);
                    if(StringUtils.isNotBlank(teamUserId)){
                        map.put("teamUserId",teamUserId);
                    }
                    CmsTeamUser teamUser= cmsTeamUserMapper.queryAppTeamUserById(map);
                    if(teamUser==null){
                        json=UploadFile.toResultFormat(101112,"团体用户不存在!");
                    }
                    teamUser.setTuserPicture(fileUrl.toString());
                    //进行编辑团体用户头像url
                    status= cmsTeamUserMapper.editAppTeamUserById(teamUser);
                }
                if(status>0){
                    json = UploadFile.toResultFormat(0, appFileUrl);
                }
                /***************新添加代码 end*******************/
            }
        }catch (Exception e) {
            e.printStackTrace();
            logger.error("文件上传出错!"+e.getMessage());
        }
             return json;
    }

    /**
     * app编辑用户信息
     * @param updateTerminalUser 更新对象
     * @param terminalUser   用户对象
     * @return
     */
    @Override
    public String editTerminalUserById(CmsTerminalUser updateTerminalUser,CmsTerminalUser terminalUser) throws ParseException {
        String json="";
        int count=0;
        if(updateTerminalUser!=null) {
            if (terminalUser!=null && StringUtils.isNotBlank(terminalUser.getUserName())) {
                updateTerminalUser.setUserName(EmojiFilter.filterEmoji(terminalUser.getUserName()));
            }
            if (terminalUser!=null && terminalUser.getUserSex()!=0) {
                updateTerminalUser.setUserSex(Integer.valueOf(terminalUser.getUserSex()));
            }
            if (terminalUser!=null &&  StringUtils.isNotBlank(terminalUser.getUserBirthStr())) {
                SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                updateTerminalUser.setUserBirth(format.parse(terminalUser.getUserBirthStr()));
            }
            if(terminalUser!=null && StringUtils.isNotBlank(terminalUser.getUserEmail())){
                updateTerminalUser.setUserEmail(terminalUser.getUserEmail());
            }
            if(terminalUser!=null && StringUtils.isNotBlank(terminalUser.getUserTelephone())){
                updateTerminalUser.setUserTelephone(terminalUser.getUserTelephone());
            }
            if(terminalUser!=null && StringUtils.isNotBlank(terminalUser.getUserArea())){
                updateTerminalUser.setUserArea(terminalUser.getUserArea().replace(":", ","));
            }
            if(terminalUser!=null && StringUtils.isNotBlank(terminalUser.getUserHeadImgUrl())){
                updateTerminalUser.setUserHeadImgUrl(terminalUser.getUserHeadImgUrl());
            }
            count= userMapper.editTerminalUserById(updateTerminalUser);
            if (count > 0) {
                json=JSONResponse.commonResultFormat(0,"更新信息成功",null);
            } else {
                json=JSONResponse.commonResultFormat(1,"更新信息失败",null);
            }
        }else{
            json=JSONResponse.commonResultFormat(13108,"查无此人",null);
        }
        return json;
    }

    /**
     * app根据用户id获取用户信息
     * @param userId 用户id
     * @return
     */
    @Override
    public CmsTerminalUser queryTerminalUserByUserId(String userId) {
        return userMapper.queryTerminalUserById(userId);
    }

    /**
     * app修改用户密码
     * @param updateTerminalUser 更新对象
     * @param password 原密码
     * @param newPassword 新密码
     * @return
     */
    @Override
    public String editTerminalUserPwdById(CmsTerminalUser updateTerminalUser, String password, String newPassword) {
        String json="";
        int flag=0;
        if (password.equals(updateTerminalUser.getUserPwd())) {
            updateTerminalUser.setUserPwd(newPassword);
            flag = userMapper.editTerminalUserById(updateTerminalUser);
            if (flag > 0) {

                //同步文化云用户至文化嘉定云
                final CmsTerminalUser finalCmsTerminalUser = updateTerminalUser;
                Runnable runnable = new Runnable() {
                    @Override
                    public void run() {
                        if(staticServer.isSyncServerState()){
                            finalCmsTerminalUser.setFunctionCode(TerminalUserConstant.UPDATE_USER_PASSWORD);
                            syncCmsTerminalUserService.editTerminalUser(finalCmsTerminalUser);
                        }
                    }
                };
                Thread thread=new Thread(runnable);
                thread.start();

                json=JSONResponse.commonResultFormat(0,"修改密码成功!",null);
            } else {
                json=JSONResponse.commonResultFormat(0,"修改密码失败!",null);
            }
        } else {
            json=JSONResponse.commonResultFormat(10120,"原密码错误!",null);
        }
        return json;
    }

    /**
     * 获取用户信息
     * @param userId 用户id
     * @return
     */
    @Override
    public String queryCmsTerminalUserById(String userId) {
        List<Map<String,Object>> listMap=new ArrayList<Map<String, Object>>();
        CmsTerminalUser terminalUser= userMapper.queryTerminalUserById(userId);
        int total=cmsUserMessageMapper.countUserMessage(userId);
        if(terminalUser!=null){
            Map<String,Object> map=new HashMap<String, Object>();
            map.put("userId",terminalUser.getUserId()!=null?terminalUser.getUserId():"");
            map.put("userName",terminalUser.getUserName()!=null?terminalUser.getUserName():"");
            map.put("userPwd",terminalUser.getUserPwd()!=null?terminalUser.getUserPwd():"");
            map.put("userNickName",terminalUser.getUserNickName()!=null?terminalUser.getUserNickName():"");
            map.put("userEmail",terminalUser.getUserEmail()!=null?terminalUser.getUserEmail():"");
            map.put("userSex",terminalUser.getUserSex()!=null?terminalUser.getUserSex():"");
            map.put("userAge",terminalUser.getUserAge()!=null?terminalUser.getUserAge():"");
            map.put("userAddress",terminalUser.getUseAddress()!=null?terminalUser.getUseAddress():"");
            String userHeadImgUrl = "";
            if(StringUtils.isNotBlank(terminalUser.getUserHeadImgUrl())){
                if(terminalUser.getUserHeadImgUrl().contains("http://")){
                    userHeadImgUrl = terminalUser.getUserHeadImgUrl();
                }else{
                    userHeadImgUrl = staticServer.getStaticServerUrl() + terminalUser.getUserHeadImgUrl();
                }
            }
            map.put("userHeadImgUrl",userHeadImgUrl);
            long borthTimes = 0L;
            Date userBirth=terminalUser.getUserBirth();
            if(userBirth!=null){
                borthTimes = userBirth.getTime();
            }
            map.put("userBirth",borthTimes/1000);
            map.put("userIsLogin",terminalUser.getUserIsLogin()!=null?terminalUser.getUserIsLogin():"");
            map.put("userIsDisable",terminalUser.getUserIsDisable()!=null?terminalUser.getUserIsDisable():"");
            map.put("userMobileNo",terminalUser.getUserMobileNo()!=null?terminalUser.getUserMobileNo():"");
            map.put("userTelephone",terminalUser.getUserTelephone()!=null?terminalUser.getUserTelephone():"");
            map.put("userQq",terminalUser.getUserQq()!=null?terminalUser.getUserQq():"");
            map.put("userRemark",terminalUser.getUserRemark()!=null?terminalUser.getUserRemark():"");
            map.put("registerCode",terminalUser.getRegisterCode()!=null?terminalUser.getRegisterCode():"");
            map.put("registerCount",terminalUser.getRegisterCount()!=null?terminalUser.getRegisterCount():"");
            map.put("userProvince",terminalUser.getUserProvince()!=null?terminalUser.getUserProvince():"");
            map.put("userCity",terminalUser.getUserCity()!=null?terminalUser.getUserCity():"");
            map.put("userArea",terminalUser.getUserArea()!=null?terminalUser.getUserArea():"");
            map.put("userType",terminalUser.getUserType()!=null?terminalUser.getUserType():"");
            map.put("userCardNo",terminalUser.getUserCardNo()!=null?terminalUser.getUserCardNo():"");
            map.put("commentStatus",terminalUser.getCommentStatus()!=null?terminalUser.getCommentStatus():"");
            //用户注册来源方式
            /*if(StringUtils.isNotBlank(terminalUser.getUserMobileNo())){
            	Map<String, Object> params = new HashMap<String, Object>();
                params.put("userTelephone", terminalUser.getUserMobileNo());
                params.put("userIsDisable", Constant.USER_IS_ACTIVATE);
            	List<CmsTerminalUser> userList = userMapper.queryTerminalUserByCondition(params);	//查询该账号相关第三方账号
            	String registerOrigin = "1";
                if(userList!=null){
                    for(CmsTerminalUser user:userList){
                    	if(user.getRegisterOrigin()!=null){
                    		registerOrigin += "," + user.getRegisterOrigin();
                    	}
                    }
                }
                map.put("registerOrigin",registerOrigin);
            }else{*/
            	map.put("registerOrigin",terminalUser.getRegisterOrigin()!=null?terminalUser.getRegisterOrigin():"");
            /*}*/
            // 用户积分	
            UserIntegral userIntegral=userIntegralMapper.selectUserIntegralByUserId(userId);
            
            if(userIntegral!=null)
            	// 当前积分
            	map.put("userIntegral", userIntegral.getIntegralNow());
            else
            {
            	userIntegral=new UserIntegral();
            	
            	userIntegral.setUserId(userId);
            	userIntegral.setIntegralId(UUIDUtils.createUUId());
            	userIntegral.setIntegralNow(0);
            	userIntegral.setIntegralHis(0);
            	
            	userIntegralMapper.insert(userIntegral);
            	
            	map.put("userIntegral", 0);
            	
            }
            	 
            
            List<CmsTeamUser> teamUsers=cmsTeamUserService.queryTeamUserList(userId);
            
            map.put("teamUserSize", teamUsers.size());
            	
            listMap.add(map);
            
            return JSONResponse.toAppActivityResultFormat(0, listMap,total);
        }
        else
        	return JSONResponse.toAppActivityResultFormat(1, listMap,total);
    }

    /**
     * app根据电话号码找回密码
     * @param userMobileNo 电话号码
     * @param newPassword 新密码
     * @param code 验证码
     * @return
     */
    @Override
    public String queryTerminalUserByMobile(String userMobileNo,String newPassword,String code) {
        String json="";
        int count=0;
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("userMobileNo", userMobileNo);
        param.put("userIsDisable", Constant.USER_IS_ACTIVATE);
        CmsTerminalUser terminalUser=userMapper.queryTerminalUserByMobile(param);
        if(terminalUser!=null){
            if(newPassword.equals(terminalUser.getUserPwd())){
                json=JSONResponse.commonResultFormat(14146,"密码与原密码相同,请直接登录!",null);
                return json;
            }
            if (!terminalUser.getRegisterCode().equals(code)) {
                json=JSONResponse.commonResultFormat(14147,"验证码错误",null);
                return json;
            }
            terminalUser.setUserPwd(newPassword);
            terminalUser.setCreateTime(new Date());
            count=userMapper.editTerminalUserById(terminalUser);
            if(count>0){

                json=JSONResponse.commonResultFormat(0,"找回密码成功",null);
            }
            else {
                json=JSONResponse.commonResultFormat(1,"找回密码失败",null);
            }
        }else {
            json=JSONResponse.commonResultFormat(14145,"该号码不存在或未激活!",null);
        }
        return json;
    }

    /**
     * app根据手机号码获取验证码
     * @param userMobileNo 手机号码
     * @return
     */
    @Override
    public String sendTerminUserCode(final String userMobileNo) {
        int count=0;
        int flag=0;
        final String registerCode =SmsUtil.getValidateCode();
        //final String smsContent = "文化云注册激活码 "+registerCode+" ,30分钟内有效,请及时输入。如非本人操作，请忽略。";
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("userMobileNo", userMobileNo);
        CmsTerminalUser terminalUser=userMapper.queryTerminalUserByMobile(param);
   /*     Map<String, Object> param = new HashMap<String, Object>();
        param.put("userMobileNo", userMobileNo);
        param.put("userIsDisable", Constant.USER_IS_ACTIVATE);
        CmsTerminalUser terminalUser=userMapper.queryTerminalUserByMobile(param);
        if (terminalUser!=null) {
            return  JSONResponse.commonResultFormat(13105, "手机号码已注册!", null);
        }
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("userMobileNo", userMobileNo);
        params.put("userIsDisable", Constant.USER_NOT_ACTIVATE);
        CmsTerminalUser user=userMapper.queryTerminalUserByMobile(params);*/
        if(terminalUser!=null && terminalUser.getUserIsDisable()==1){
            return  JSONResponse.commonResultFormat(13105, "手机号码已注册", null);
        }
        if(terminalUser!=null && terminalUser.getUserIsDisable()==2){
            return  JSONResponse.commonResultFormat(13106,"手机号码已冻结",null);
        }
        // 已经发送过(未激活的号码已经存在)
        if (terminalUser!=null) {
            if (terminalUser.getLastSendSmsTime().after(TimeUtil.getTimesmorning()) && terminalUser.getLastSendSmsTime().before(TimeUtil.getTimesnight())) {
                // 当天发送
                int registerCount = terminalUser.getRegisterCount() == null ? 0 : terminalUser.getRegisterCount();
                if (registerCount >= 3) {
                    return  JSONResponse.commonResultFormat(13106, "一天最多发送3次!", null);
                }
                terminalUser.setRegisterCount(registerCount + 1);
            } else {
                terminalUser.setRegisterCount(1);
            }
            //使用线程发送短信
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                    Map<String,Object> smsParams = new HashMap<String,Object>();
                    smsParams.put("product",Constant.PRODUCT);
                    smsParams.put("code",registerCode);
                    SmsUtil.sendRegisterCode(userMobileNo,smsParams);
                }
            };
            Thread t = new Thread(runnable);
            t.start();
            //线程发送短信 end
            terminalUser.setRegisterCode(registerCode);
            terminalUser.setLastSendSmsTime(new Date());
            terminalUser.setCreateTime(new Date());
            count=userMapper.editTerminalUserById(terminalUser);
            if(count>0) {
                return JSONResponse.commonResultFormat(0, registerCode, null);
            }else {
                return JSONResponse.commonResultFormat(1, "短信验证码失败!", null);
            }
        }
        // 该号码不存在，可以发送
        //使用线程发送短信
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                Map<String,Object> smsParams = new HashMap<String,Object>();
                smsParams.put("product",Constant.PRODUCT);
                smsParams.put("code",registerCode);
                SmsUtil.sendRegisterCode(userMobileNo,smsParams);
                //SendSmsMessage.sendSmsMessage(userMobileNo, smsContent, smsConfig, logger);
            }
        };
        Thread t = new Thread(runnable);
        t.start();
        //线程发送短信 end
        CmsTerminalUser newUser = new CmsTerminalUser();
        newUser.setUserType(1);
        newUser.setUserId(UUIDUtils.createUUId());
        newUser.setCreateTime(new Date());
        newUser.setUserIsDisable(Constant.USER_NOT_ACTIVATE);
        newUser.setUserIsLogin(Constant.LOGIN_ERROR);
        newUser.setRegisterCode(registerCode);
        newUser.setRegisterCount(1);
        newUser.setUserMobileNo(userMobileNo);
        newUser.setLastSendSmsTime(new Date());
       // newUser.setRegisterOrigin(Constant.REGISTER_ORIGIN_WHY);
        flag=userMapper.addTerminalUser(newUser);
        if (flag > 0) {
            return JSONResponse.commonResultFormat(0, registerCode, null);
        }else {
            return JSONResponse.commonResultFormat(1, "短信验证码失败", null);
        }
    }

    /**
     * app根据手机号码查询用户信息  找回密码
     * @param userMobileNo 手机号码
     * @return
     */
    @Override
    public String queryTerminalUserByMobileNo(final  String userMobileNo) {
        String json="";
        final String registerCode = RandomStringUtils.random(6, false, true);
        int flag=0;
        // 查找手机是否已经注册
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("userMobileNo", userMobileNo);
        param.put("userIsDisable", Constant.USER_IS_ACTIVATE);
        //final String smsContent = "文化云注册激活码 " + registerCode + " 请及时输入。如非本人操作，请忽略。";
        CmsTerminalUser terminalUser = userMapper.queryTerminalUserByMobile(param);
        if(terminalUser!=null){
            if (terminalUser.getLastSendSmsTime().after(TimeUtil.getTimesmorning()) && terminalUser.getLastSendSmsTime().before(TimeUtil.getTimesnight())) {
                // 当天发送
                int registerCount = terminalUser.getRegisterCount() == null ? 0 : terminalUser.getRegisterCount();
                if (registerCount >= 3) {
                    return JSONResponse.commonResultFormat(13106,"当日发送次数超过3次!",null);
                }
                //使用线程发送短信
                Runnable runnable = new Runnable() {
                    @Override
                    public void run() {
                        Map<String,Object> smsParams = new HashMap<String,Object>();
                        smsParams.put("product",Constant.PRODUCT);
                        smsParams.put("code",registerCode);
                        SmsUtil.sendForgetCode(userMobileNo, smsParams);

                        //SendSmsMessage.sendSmsMessage(userMobileNo, smsContent, smsConfig, logger);
                    }
                };
                Thread t = new Thread(runnable);
                t.start();
                //更新RegisterCount
                terminalUser.setRegisterCount(registerCount + 1);
                terminalUser.setRegisterCode(registerCode);
                terminalUser.setLastSendSmsTime(new Date());
                flag = userMapper.editTerminalUserById(terminalUser);
                if (flag > 0) {
                    json= JSONResponse.commonResultFormat(0,registerCode,null);
                } else {
                    json=JSONResponse.commonResultFormat(1,"发送消息失败",null);
                }
            }
            else{
                // 隔天发送
                Runnable runnable=new Runnable() {
                    @Override
                    public void run() {

                        Map<String,Object> smsParams = new HashMap<String,Object>();
                        smsParams.put("product",Constant.PRODUCT);
                        smsParams.put("code",registerCode);
                        SmsUtil.sendForgetCode(userMobileNo,smsParams);

                        //SendSmsMessage.sendSmsMessage(userMobileNo, smsContent, smsConfig, logger);
                    }
                };
                Thread t = new Thread(runnable);
                t.start();
                terminalUser.setRegisterCount(1);
                terminalUser.setRegisterCode(registerCode);
                terminalUser.setLastSendSmsTime(new Date());
                flag = userMapper.editTerminalUserById(terminalUser);
                if (flag > 0) {
                    json=JSONResponse.commonResultFormat(0,registerCode,null);
                } else {
                    json=JSONResponse.commonResultFormat(1,"发送消息失败",null);
                }

            }
        }else{
            json=JSONResponse.commonResultFormat(14141,"手机号码未注册",null);
        }
        return json;
    }

    /**
     * app绑定手机号码
     * @param userId 用户id
     * @param userMobileNo 手机号码
     * @return
     */
    @Override
    public String bindingMobileNo(String userId, final String userMobileNo) {
        int flag=0;
        final String registerCode = RandomStringUtils.random(6, false, true);
        //final String smsContent = "文化云绑定手机号激活码 "+registerCode+" 请及时输入。如非本人操作，请忽略。";
        CmsTerminalUser terminalUser = userMapper.queryTerminalUserById(userId);
        //该用户不存在
        if (terminalUser == null) {
            return JSONResponse.commonResultFormat(10111,"用户不存在",null);
        }
        // 查找手机是否已经注册
        Map<String, Object> param = new HashMap<String, Object>();
        param.put("userMobileNo", userMobileNo);
        param.put("userIsDisable", Constant.USER_IS_ACTIVATE);
        CmsTerminalUser user = userMapper.queryTerminalUserByMobile(param);
        if (user!=null) {
            return JSONResponse.commonResultFormat(13105,"手机号码已注册",null);
        }else{
            //使用线程发送短信
            Runnable runnable = new Runnable() {
                @Override
                public void run() {

                    Map<String,Object> smsParams = new HashMap<String,Object>();
                    smsParams.put("product",Constant.PRODUCT);
                    smsParams.put("code",registerCode);
                    SmsUtil.sendForgetCode(userMobileNo,smsParams);
                }
            };
            Thread t = new Thread(runnable);
            t.start();
            //线程发送短信 end
            terminalUser.setRegisterCode(registerCode);
            terminalUser.setLastSendSmsTime(new Date());
            flag = userMapper.editTerminalUserById(terminalUser);
            if(flag>0){
                session.setAttribute("userMobileNo", userMobileNo);
                return JSONResponse.commonResultFormat(0,registerCode,null);
            }else {
                return JSONResponse.commonResultFormat(1,"绑定手机失败!",null);
            }
        }

    }

    /**
     * app绑定手机时验证手机号码与验证码是否一致(已废弃)
     * @param cmsTerminalUser 用户对象
     */
    @Override
    public String queryAppValidateCode(final  CmsTerminalUser cmsTerminalUser) {
        String json="";
        int flag=0;
        CmsTerminalUser updateTerminalUser = userMapper.queryTerminalUserById(cmsTerminalUser.getUserId());
        if(cmsTerminalUser.getRegisterCode().equals(updateTerminalUser.getRegisterCode()) && cmsTerminalUser.getUserMobileNo().equals((String)session.getAttribute("userMobileNo"))){
            final  String passWord ="why"+RandomStringUtils.random(6, false, true);
            updateTerminalUser.setUserMobileNo(cmsTerminalUser.getUserMobileNo());
            updateTerminalUser.setUserPwd(MD5Util.toMd5(passWord));
            updateTerminalUser.setLastLoginTime(new Date());
            flag = userMapper.editTerminalUserById(updateTerminalUser);
            //使用线程发送短信
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                    //SendSmsMessage.sendSmsMessage(cmsTerminalUser.getUserMobileNo(),"您已成功绑定手机号码:"+cmsTerminalUser.getUserMobileNo()+"登录密码:"+passWord+",可以预定活动了", smsConfig, logger);
                }
            };
            Thread t = new Thread(runnable);
            t.start();

            if(flag>0){
                json= JSONResponse.commonResultFormat(0,"绑定手机号码成功,可以进行预定活动",null);
            }else {
                json= JSONResponse.commonResultFormat(1,"绑定手机失败!",null);
            }
        }else{
            json=JSONResponse.commonResultFormat(10119,"手机号码验证失败!",null);
        }
        return json;
    }



    /**
     * app绑定第三方账号
     * @param userId 用户id
     * @param openId 第三方登陆返回的openid
     * @param register_type 该账户绑定方式 2 QQ  3 新浪微博 4 微信
     * @return
     */
    @Override
    public String queryTerminalUserById(String userId, String openId,String register_type) {
        String json="";
        int flag=0;
        int count=0;
        try {
			//判断operId是否存在
			if(openId!=null && StringUtils.isNotBlank(openId)){
			    CmsTerminalUser terminalUser=userMapper.queryTerminalUserById(userId);
			    flag=userMapper.queryTerminalCountById(openId,Constant.NORMAL);
			    if(flag>0){//将原来第三方登录账号添加手机
			        Map<String, Object> params = new HashMap<String, Object>();
			        params.put("operId", openId);
			        CmsTerminalUser terminalUserByOpenId=userMapper.queryTerminalUserListById(params);		//根据openId查询用户
			    	if(terminalUser!=null&&StringUtils.isNotBlank(terminalUser.getUserMobileNo())){
			    		terminalUserByOpenId.setUserTelephone(terminalUser.getUserMobileNo());
			    	}
			    	count=userMapper.editTerminalUserById(terminalUserByOpenId);
			        if (count > 0) {
			            json= JSONResponse.commonResultFormat(0, "绑定第三方账号成功!", null);
			        } else {
			            json=JSONResponse.commonResultFormat(1,"绑定第三方账号失败!",null);
			        }
			    }else {//新建第三方登录账号
			        if(terminalUser!=null){
			        	CmsTerminalUser terminalUserNew = new CmsTerminalUser();
			            if(openId!=null && StringUtils.isNotBlank(openId)){
			            	terminalUserNew.setOperId(openId);
			            }
			            if(register_type!=null && StringUtils.isNotBlank(register_type)){
			            	terminalUserNew.setRegisterOrigin(Integer.valueOf(register_type));
			            }
			            if (terminalUser.getUserSex()!=0) {
			            	terminalUserNew.setUserSex(Integer.valueOf(terminalUser.getUserSex()));
			            }
			            if (terminalUser.getUserBirth()!=null) {
			            	terminalUserNew.setUserBirth(terminalUser.getUserBirth());
			            }
			            if (StringUtils.isNotBlank(terminalUser.getUserHeadImgUrl())) {
			            	terminalUserNew.setUserHeadImgUrl(terminalUser.getUserHeadImgUrl());
			            }
			            if(StringUtils.isNotBlank(terminalUser.getUserNickName())){
			            	terminalUserNew.setUserNickName(terminalUser.getUserNickName());
			            }else{
			            	terminalUserNew.setUserNickName("why_"+UUIDUtils.createUUId());
			            }
			            if(StringUtils.isNotBlank(terminalUser.getUserName())){
			            	terminalUserNew.setUserName(terminalUser.getUserName());
			            }else{
			            	terminalUserNew.setUserName("why_"+UUIDUtils.createUUId());
			            }
			            if(StringUtils.isNotBlank(terminalUser.getUserMobileNo())){
			            	terminalUserNew.setUserTelephone(terminalUser.getUserMobileNo());
			        	}
			            terminalUserNew.setUserId(UUIDUtils.createUUId());
			            terminalUserNew.setLoginType(Constant.LOGIN_TYPE_APP);
			            terminalUserNew.setCreateTime(new Date());
			            terminalUserNew.setUserIsDisable(Constant.USER_IS_ACTIVATE);
			            terminalUserNew.setUserType(Constant.USER_TYPE1);
			            terminalUserNew.setCommentStatus(Constant.NORMAL);
			            terminalUserNew.setLastLoginTime(new Date());
			            count=userMapper.addTerminalUser(terminalUserNew);
			            if (count > 0) {
			                json= JSONResponse.commonResultFormat(0, "绑定第三方账号成功!", null);
			            } else {
			                json=JSONResponse.commonResultFormat(1,"绑定第三方账号失败!",null);
			            }
			        }
			    }
			    //还原原来账号相关信息
			    terminalUser.setRegisterOrigin(1);
			    terminalUser.setOperId("");
			    userMapper.editTerminalUserById(terminalUser);
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}
        return json;
    }

    /**
     * app根据手机号码查询用户信息
     * @param user 用户对象
     * @param code 验证码
     * @return
     */
    @Override
    public String queryTerminalUserMobileExist(String code,CmsTerminalUser user) {
        int count=0;
        String json="";
        Map<String, Object> map = new HashMap<String, Object>();
        if(user!=null && StringUtils.isNotBlank(user.getUserMobileNo())){
            map.put("userMobile",user.getUserMobileNo());
        }
      /*  if(code!=null && StringUtils.isNotBlank(code)){
            map.put("code",code);
        }
       Map<String, Object> param = new HashMap<String, Object>();
        param.put("userMobileNo", user.getUserMobileNo());
        param.put("userIsDisable", Constant.USER_IS_ACTIVATE);
        CmsTerminalUser cmsTerminalUser=userMapper.queryTerminalUserByMobile(param);
        if (cmsTerminalUser!=null) {
            return  JSONResponse.commonResultFormat(13105, "手机号码已注册", null);
        }*/
        CmsTerminalUser terminalUser= userMapper.terminalUserMobileExists(map);
        if (terminalUser != null) {
            if(terminalUser.getUserIsDisable()==1){
                return  JSONResponse.commonResultFormat(13105, "手机号码已注册", null);
            }
            if (terminalUser.getRegisterCode().equals(code)) {
                //user.setUserName(user.getUserName());
             //   terminalUser.setRegisterOrigin(Constant.REGISTER_ORIGIN_WHY);
                terminalUser.setUserPwd(user.getUserPwd());
                terminalUser.setUserName(user.getUserName());
                terminalUser.setCreateTime(new Date());
                terminalUser.setUserIsDisable(Constant.USER_IS_ACTIVATE);
              //  user.setUserId(terminalUser.getUserId());
         //       terminalUser.setUserType(1);
                count = userMapper.editTerminalUserById(terminalUser);
                if (count > 0) {
                    Map<String, Object> params = new HashMap<String, Object>();
                    params.put("userName", terminalUser.getUserName());
                    String message = userMessageService.sendSystemMessage(Constant.SYSTEM_NOTICE, params, terminalUser.getUserId());
                    if (message.equals(Constant.RESULT_STR_SUCCESS)) {
                        //同步文化云用户至文化嘉定云
                        final CmsTerminalUser finalCmsTerminalUser = terminalUser;
                        Runnable runnable = new Runnable() {
                            @Override
                            public void run() {
                                if(staticServer.isSyncServerState()){
                                    finalCmsTerminalUser.setSourceCode(TerminalUserConstant.SOURCE_CODE_SHANGHAI);
                                    finalCmsTerminalUser.setFunctionCode(TerminalUserConstant.INSERT_USER_INFO);
                                    syncCmsTerminalUserService.addTerminalUser(finalCmsTerminalUser);
                                }
                            }
                        };
                        Thread thread=new Thread(runnable);
                        thread.start();
                        userIntegralDetailService.registerAddIntegral(terminalUser.getUserId());
                        json = JSONResponse.commonResultFormat(0, "注册成功!", terminalUser.getUserId());
                    }
                } else {
                    json = JSONResponse.commonResultFormat(1, "注册失败!", terminalUser.getUserId());
                }
            } else {
                json = JSONResponse.commonResultFormat(13120, "验证码错误!", null);
            }
        }else{
            json = JSONResponse.commonResultFormat(13120, "用户请先获取验证码才能注册!", null);
        }
        return   json;
    }

    /**
     * app用户登录
     * @param user 用户对象
     * @return
     */
    @Override
    public String terminalLogin(CmsTerminalUser user) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userName", user.getUserMobileNo());
        map.put("userPwd",user.getUserPwd());
        CmsTerminalUser terminalUser = userMapper.queryTerminalByMobileOrPwd(map);
        if(terminalUser != null){
            if(Constant.USER_NOT_ACTIVATE.equals(terminalUser.getUserIsDisable())){
                return JSONResponse.commonResultFormat(11102, "会员未激活!", null);
            }else if(Constant.USER_IS_FREEZE.equals(terminalUser.getUserIsDisable())){
                return JSONResponse.commonResultFormat(12106, "用户已冻结!", null);
            }
            terminalUser.setLastLoginTime(new Date());
            terminalUser.setLoginType(Constant.LOGIN_TYPE_APP);
            int count = userMapper.editTerminalUserById(terminalUser);
            if(count > 0){
            	Map<String, Object> params = new HashMap<String, Object>();
                params.put("userTelephone", terminalUser.getUserMobileNo());
                params.put("userIsDisable", Constant.USER_IS_ACTIVATE);
            	List<CmsTerminalUser> userList = userMapper.queryTerminalUserByCondition(params);	//查询该账号相关第三方账号
                List<Map<String, Object>> listMap=toResultTerminalUser(terminalUser,staticServer,userList);
                session.setAttribute("terminalUser", terminalUser);
                return  JSONResponse.toAppResultFormat(0, listMap);
            }else {
                return JSONResponse.commonResultFormat(12105, "手机号码或密码错误!", null);
            }
        }
               return JSONResponse.commonResultFormat(12105, "手机号码或密码错误!", null);
    }

    /**
     * app根据operId获取用户信息
     * @param user 用户对象
     * @return
     */
    @Override
    public String queryTerminalUserByOpenId(CmsTerminalUser user) throws ParseException {
        int flag = 0;
        Map<String, Object> params = new HashMap<String, Object>();
        List<Map<String, Object>> listMap=null;
        if(user!=null && StringUtils.isNotBlank(user.getOperId())){
            params.put("operId", user.getOperId());
        }
        CmsTerminalUser terminalUser=userMapper.queryTerminalUserListById(params);
        if(terminalUser!=null){//openid已被注册
            listMap= toResultTerminalUser(terminalUser,staticServer,null);

        	/*if(StringUtils.isNotBlank(terminalUser.getUserMobileNo())){
        	//从原来账号剥离出来新的第三方账号
        		CmsTerminalUser terminalUserNew = new CmsTerminalUser();
	            if(StringUtils.isNotBlank(terminalUser.getOperId())){
	            	terminalUserNew.setOperId(terminalUser.getOperId());
	            }
	            if(terminalUser.getRegisterOrigin()!=null){
	            	terminalUserNew.setRegisterOrigin(terminalUser.getRegisterOrigin());
	            }
	            if (terminalUser.getUserSex()!=0) {
	            	terminalUserNew.setUserSex(Integer.valueOf(terminalUser.getUserSex()));
	            }
	            if (terminalUser.getUserBirth()!=null) {
	            	terminalUserNew.setUserBirth(terminalUser.getUserBirth());
	            }
	            if (StringUtils.isNotBlank(terminalUser.getUserHeadImgUrl())) {
	            	terminalUserNew.setUserHeadImgUrl(terminalUser.getUserHeadImgUrl());
	            }
	            if(StringUtils.isNotBlank(terminalUser.getUserNickName())){
	            	terminalUserNew.setUserNickName(terminalUser.getUserNickName());
	            }else{
	            	terminalUserNew.setUserNickName("why_"+UUIDUtils.createUUId());
	            }
	            if(StringUtils.isNotBlank(terminalUser.getUserName())){
	            	terminalUserNew.setUserName(terminalUser.getUserName());
	            }else{
	            	terminalUserNew.setUserName("why_"+UUIDUtils.createUUId());
	            }
	            if(StringUtils.isNotBlank(terminalUser.getUserMobileNo())){
	            	terminalUserNew.setUserTelephone(terminalUser.getUserMobileNo());
	        	}
	            terminalUserNew.setUserId(UUIDUtils.createUUId());
	            terminalUserNew.setLoginType(Constant.LOGIN_TYPE_APP);
	            terminalUserNew.setCreateTime(new Date());
	            terminalUserNew.setUserIsDisable(Constant.USER_IS_ACTIVATE);
	            terminalUserNew.setUserType(Constant.USER_TYPE1);
	            terminalUserNew.setCommentStatus(Constant.NORMAL);
	            terminalUserNew.setLastLoginTime(new Date());
	            flag=userMapper.addTerminalUser(terminalUserNew);
                //还原原来账号相关信息
			    terminalUser.setRegisterOrigin(1);
			    terminalUser.setOperId("");
			    userMapper.editTerminalUserById(terminalUser);
                if (flag > 0) {
                    listMap = toResultTerminalUser(terminalUserNew,staticServer,null);
                    session.setAttribute("terminalUser", terminalUserNew);
                } else {
                    return JSONResponse.commonResultFormat(13106, "第三方登录失败!", null);
                }
        	}else{
        		listMap= toResultTerminalUser(terminalUser,staticServer,null);
        		session.setAttribute("terminalUser", terminalUser);
        	}*/
        } else {
          //openid未被注册，直接新建
            if (user.getUserSex()!=0) {
                user.setUserSex(Integer.valueOf(user.getUserSex()));
            }
            if (StringUtils.isNotBlank(user.getUserBirthStr()) && !user.getUserBirthStr().equals("")) {
                SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                user.setUserBirth(format.parse(user.getUserBirthStr()));
            }
            if(user!=null && StringUtils.isNotBlank(user.getUserNickName())){
                user.setUserName(user.getUserNickName());
            }else {
                if(StringUtils.isNotBlank(user.getUserName())){
                    user.setUserName(EmojiFilter.filterEmoji(user.getUserName()));
                }else{
                    user.setUserName("why_"+UUIDUtils.createUUId());
                }
            }
            user.setRegisterOrigin(user.getRegisterOrigin());
            user.setOperId(user.getOperId());
            user.setLoginType(Constant.LOGIN_TYPE_APP);
            user.setUserId(UUIDUtils.createUUId());
            user.setCreateTime(new Date());
            user.setUserIsDisable(Constant.USER_IS_ACTIVATE);
            user.setUserType(Constant.USER_TYPE1);
            //评论状态
            user.setCommentStatus(Constant.NORMAL);
            //最后登陆时间
            user.setLastLoginTime(new Date());
            flag = userMapper.addTerminalUser(user);
            if (flag > 0) {
            	
            	userIntegralDetailService.registerAddIntegral(user.getUserId());

                //同步文化云用户至文化嘉定云
                final CmsTerminalUser finalCmsTerminalUser = user;
                Runnable runnable = new Runnable() {
                    @Override
                    public void run() {
                        if(staticServer.isSyncServerState()){
                            finalCmsTerminalUser.setSourceCode(TerminalUserConstant.SOURCE_CODE_SHANGHAI);
                            finalCmsTerminalUser.setFunctionCode(TerminalUserConstant.INSERT_THIRD_LOGIN);
                            syncCmsTerminalUserService.addTerminalUser(finalCmsTerminalUser);
                        }
                    }
                };
                Thread thread=new Thread(runnable);
                thread.start();

                listMap = toResultTerminalUser(user,staticServer,null);
                session.setAttribute("terminalUser", user);
            } else {
                return JSONResponse.commonResultFormat(13106, "第三方登录失败!", null);
            }
        }
        return JSONResponse.toAppResultFormat(0, listMap);
    }




    public static  List<Map<String, Object>> toResultTerminalUser(CmsTerminalUser terminalUser,StaticServer staticServer,List<CmsTerminalUser> userList) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("userId", terminalUser.getUserId() != null ? terminalUser.getUserId() : "");
        map.put("userName", terminalUser.getUserName() != null ? terminalUser.getUserName() : "");
        map.put("userPwd", terminalUser.getUserPwd() != null ? terminalUser.getUserPwd() : "");
        map.put("userNickName", terminalUser.getUserNickName() != null ? terminalUser.getUserNickName() : "");
        map.put("userEmail", terminalUser.getUserEmail() != null ? terminalUser.getUserEmail() : "");
        map.put("userSex", terminalUser.getUserSex() != null ? terminalUser.getUserSex() : "");
        map.put("userAge", terminalUser.getUserAge() != null ? terminalUser.getUserAge() : "");
        map.put("userAddress", terminalUser.getUseAddress() != null ? terminalUser.getUseAddress() : "");
        String userHeadImgUrl = "";
        if (org.apache.commons.lang3.StringUtils.isNotBlank(terminalUser.getUserHeadImgUrl()) && terminalUser.getUserHeadImgUrl().contains("http://")) {
            userHeadImgUrl = terminalUser.getUserHeadImgUrl();
        } else if(org.apache.commons.lang3.StringUtils.isNotBlank(terminalUser.getUserHeadImgUrl())){
            userHeadImgUrl = staticServer.getStaticServerUrl() +terminalUser.getUserHeadImgUrl();
        }
        map.put("userHeadImgUrl",userHeadImgUrl);
        map.put("userBirth",terminalUser.getUserBirth()!=null? terminalUser.getUserBirth().getTime()/ 1000:"");
        map.put("userIsLogin", terminalUser.getUserIsLogin() != null ? terminalUser.getUserIsLogin() : 0);
        map.put("userIsDisable", terminalUser.getUserIsDisable() != null ? terminalUser.getUserIsDisable() : "");
        map.put("userMobileNo", terminalUser.getUserMobileNo() != null ? terminalUser.getUserMobileNo() : "");
        map.put("userTelephone",terminalUser.getUserTelephone()!=null?terminalUser.getUserTelephone():"");
        map.put("userQq", terminalUser.getUserQq() != null ? terminalUser.getUserQq() : "");
        map.put("userRemark", terminalUser.getUserRemark() != null ? terminalUser.getUserRemark() : "");
        map.put("registerCode", terminalUser.getRegisterCode() != null ? terminalUser.getRegisterCode() : "");
        map.put("registerCount", terminalUser.getRegisterCount() != null ? terminalUser.getRegisterCount() : "");
        map.put("userProvince", terminalUser.getUserProvince() != null ? terminalUser.getUserProvince() : "");
        map.put("userCity", terminalUser.getUserCity() != null ? terminalUser.getUserCity() : "");
        map.put("userArea", terminalUser.getUserArea() != null ? terminalUser.getUserArea() : "");
        map.put("userType", terminalUser.getUserType() != null ? terminalUser.getUserType() : "");
        map.put("userCardNo", terminalUser.getUserCardNo() != null ? terminalUser.getUserCardNo() : "");
        map.put("commentStatus", terminalUser.getCommentStatus() != null ? terminalUser.getCommentStatus() : "");
        map.put("loginType",Constant.LOGIN_TYPE_APP);
        String registerOrigin = "1";
        if(userList!=null){
            for(CmsTerminalUser user:userList){
            	if(user.getRegisterOrigin()!=null){
            		registerOrigin += "," + user.getRegisterOrigin();
            	}
            }
        }
        map.put("registerOrigin",registerOrigin);
        
        //生成token值
        String token="anonymous";
        if(StringUtils.isNotBlank(terminalUser.getUserName())){
            token= TokenHelper.generateToken(terminalUser.getUserName());
        }
        map.put("token",token);
        listMap.add(map);
        return listMap;
    }

	@Override
	public String sendAuthCode(CmsTerminalUser tuser,String userMobileNo) {

    	final String code = SmsUtil.getValidateCode();
    	
    	tuser.setRegisterCode(code);
    	tuser.setLastSendSmsTime(new Date());
    	
    	int flag=userMapper.editTerminalUserById(tuser);
    	
    	Map<String,Object> smsParams = new HashMap<>();
        smsParams.put("code",code);
        smsParams.put("product",Constant.PRODUCT);
        SmsUtil.sendUpdateCode(userMobileNo, smsParams);
        
        if (flag > 0) {
            return JSONResponse.toAppResultObject(0, "短信发送成功", code);
        }else {
            return JSONResponse.commonResultFormat(1, "短信验证码失败", null);
        }
        
	}

	@Override
	public String userAuth(String userId, String nickName,String userTelephone, String code, String idCardNo, String idCardPhotoUrl,String userEmail) {

		String json="";
        int count=0;
        
        CmsTerminalUser tuser = userMapper.queryTerminalUserById(userId);
    	
        if (!code.equals(tuser.getRegisterCode())){
        	
        	json = JSONResponse.commonResultFormat(13120, "验证码错误!", null);
        	return json;
        }
        tuser.setUserNickName(nickName);
        tuser.setUserCardNo(idCardNo);
        tuser.setUserEmail(userEmail);
        tuser.setUserTelephone(userTelephone);
        
        if(StringUtils.isNotBlank(idCardPhotoUrl)){
        	
            int index=idCardPhotoUrl.indexOf("front");
            idCardPhotoUrl = idCardPhotoUrl.substring(index,idCardPhotoUrl.length());
            tuser.setIdCardPhotoUrl(idCardPhotoUrl);
        }
        
        UserOperationEnum userOperationEnum= UserOperationEnum.AUTH_RE_SUBMIT;
        
        // 初次认证
        if(tuser.getUserType()==1)
        	userOperationEnum=UserOperationEnum.AUTH_SUBMIT;
        else if(tuser.getUserType()==Constant.USER_TYPE3)
        	userOperationEnum=UserOperationEnum.EDIT_INFO;
        
        // 待认证
        tuser.setUserType(Constant.USER_TYPE3);
    	
       count = userMapper.editTerminalUserById(tuser);
       
       if(count>=0)
       {
    	   
    	   CmsUserOperatorLog record= CmsUserOperatorLog.createInstance(tuser.getUserId(), null, null, tuser.getUserId(), CmsUserOperatorLog.USER_TYPE_NORMAL, userOperationEnum);
      	 
    	   cmsUserOperatorLogMapper.insert(record);
    	   
    	   json=JSONResponse.commonResultFormat(0,"提交认证成功!",null);
       } 
       else
    	   json=JSONResponse.commonResultFormat(1,"提交认证失败!",null);
		
		return json;
	}

	@Override
	public String queryUserIntegralDetail(PaginationApp pageApp, String userId,Date beforeDate) {
		
		String json="";
		
		Map<String, Object> result = new HashMap<String, Object>();
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		 map.put("userId", userId);
		
		if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
	         map.put("firstResult", pageApp.getFirstResult());
	         map.put("rows", pageApp.getRows());
	    }      
		
		  // 用户积分	
        UserIntegral userIntegral=userIntegralMapper.selectUserIntegralByUserId(userId);
        
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        
        if(userIntegral==null)
        {
        	userIntegral=new UserIntegral();
        	
        	userIntegral.setUserId(userId);
        	userIntegral.setIntegralId(UUIDUtils.createUUId());
        	userIntegral.setIntegralNow(0);
        	userIntegral.setIntegralHis(0);
        	
        	userIntegralMapper.insert(userIntegral);
        	
        	result.put("integralNow", 0);
        }
        else
        {
        	String integralId=userIntegral.getIntegralId();
        	
        	map.put("integralId", integralId);
        	
        	if(beforeDate!=null)
             
            map.put("beforeDate",beforeDate);
            
            result.put("integralNow", 0);
        	
        	List<UserIntegralDetail> userIntegralDetails=userIntegralDetailMapper.queryUserIntegralDetailByIntegralId(map);
        	
        	SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");   
        	
        	for (UserIntegralDetail userIntegralDetail : userIntegralDetails) {
        		
        		Map<String, Object> dataIntegral = new HashMap<String, Object>();
        		
        		// 积分类型
        		IntegralTypeEnum integralType=IntegralTypeEnum.getIntegralType(userIntegralDetail.getIntegralType());
			
        		dataIntegral.put("name", integralType.getName());
        		
        		dataIntegral.put("description", integralType.getDescription());
        		
        		//0:增加、1:扣除
        		dataIntegral.put("changeType", userIntegralDetail.getChangeType());
        		
        		dataIntegral.put("date", format.format(userIntegralDetail.getCreateTime()));
        		
        		dataIntegral.put("integralChange", userIntegralDetail.getIntegralChange());
        		
        		listMap.add(dataIntegral);
        		
        	}
        	
        	result.put("integralNow", userIntegral.getIntegralNow());
        	
        }
        
    	result.put("userIntegralDetails", listMap);
        
        json=JSONResponse.toAppResultFormat(1, result);
		
		return json;
	}
}
