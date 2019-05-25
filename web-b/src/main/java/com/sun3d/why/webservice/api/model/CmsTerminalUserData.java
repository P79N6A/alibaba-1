package com.sun3d.why.webservice.api.model;

import java.util.Date;

/**
 * Created by chenjie on 2016/3/1.
 */
public class CmsTerminalUserData {

    private String userId;

    private String userName;

    private String userPwd;

    private String userNickName;

    private String userEmail;

    private Integer userSex;

    private Integer userAge;

    private String useAddress;

    private String userHeadImgUrl;

    private String userImei;

    private String userImsi;

    private String userEquipmentId;

    private String userGps;

    private String userIp;

    private String userMac;

    private String userMobileType;

    private String userInternetway;

    private String userSiteId;

    private Integer snstype;

    private String operId;

    private String accessToken;

    private Date createTime;

    private String userDeviceToken;

    private Integer userIsLogin;

    private Integer userIsDisable;

    private Date userBirth;

    // 前端传参专用
    private String userBirthStr;

    private String userTelephone;

    private String userMobileNo;

    private String userQq;

    private String userRemark;

    private String registerCode;

    private String userProvince;

    private String userCity;

    private String userArea;

    private Integer userType;

    private String userCardNo;

    private Integer commentStatus;

    private Date lastLoginTime;

    private Integer loginType;

    private  Date lastSendSmsTime;

    private Integer registerCount;

    /**
     * 数据来源 0代表文化上海云，1代表文化嘉定云
     * 对应TerminalUserConstant
     */
    private Integer sourceCode;
    /**
     * 操作编号 如101代表插入用户信息，201代表修改用户信息
     * 对应TerminalUserConstant
     */
    private Integer functionCode;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserPwd() {
        return userPwd;
    }

    public void setUserPwd(String userPwd) {
        this.userPwd = userPwd;
    }

    public String getUserNickName() {
        return userNickName;
    }

    public void setUserNickName(String userNickName) {
        this.userNickName = userNickName;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public Integer getUserSex() {
        return userSex;
    }

    public void setUserSex(Integer userSex) {
        this.userSex = userSex;
    }

    public Integer getUserAge() {
        return userAge;
    }

    public void setUserAge(Integer userAge) {
        this.userAge = userAge;
    }

    public String getUseAddress() {
        return useAddress;
    }

    public void setUseAddress(String useAddress) {
        this.useAddress = useAddress;
    }

    public String getUserHeadImgUrl() {
        return userHeadImgUrl;
    }

    public void setUserHeadImgUrl(String userHeadImgUrl) {
        this.userHeadImgUrl = userHeadImgUrl;
    }

    public String getUserImei() {
        return userImei;
    }

    public void setUserImei(String userImei) {
        this.userImei = userImei;
    }

    public String getUserImsi() {
        return userImsi;
    }

    public void setUserImsi(String userImsi) {
        this.userImsi = userImsi;
    }

    public String getUserEquipmentId() {
        return userEquipmentId;
    }

    public void setUserEquipmentId(String userEquipmentId) {
        this.userEquipmentId = userEquipmentId;
    }

    public String getUserGps() {
        return userGps;
    }

    public void setUserGps(String userGps) {
        this.userGps = userGps;
    }

    public String getUserIp() {
        return userIp;
    }

    public void setUserIp(String userIp) {
        this.userIp = userIp;
    }

    public String getUserMac() {
        return userMac;
    }

    public void setUserMac(String userMac) {
        this.userMac = userMac;
    }

    public String getUserMobileType() {
        return userMobileType;
    }

    public void setUserMobileType(String userMobileType) {
        this.userMobileType = userMobileType;
    }

    public String getUserInternetway() {
        return userInternetway;
    }

    public void setUserInternetway(String userInternetway) {
        this.userInternetway = userInternetway;
    }

    public String getUserSiteId() {
        return userSiteId;
    }

    public void setUserSiteId(String userSiteId) {
        this.userSiteId = userSiteId;
    }

    public Integer getSnstype() {
        return snstype;
    }

    public void setSnstype(Integer snstype) {
        this.snstype = snstype;
    }

    public String getOperId() {
        return operId;
    }

    public void setOperId(String operId) {
        this.operId = operId;
    }

    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getUserDeviceToken() {
        return userDeviceToken;
    }

    public void setUserDeviceToken(String userDeviceToken) {
        this.userDeviceToken = userDeviceToken;
    }

    public Integer getUserIsLogin() {
        return userIsLogin;
    }

    public void setUserIsLogin(Integer userIsLogin) {
        this.userIsLogin = userIsLogin;
    }

    public Integer getUserIsDisable() {
        return userIsDisable;
    }

    public void setUserIsDisable(Integer userIsDisable) {
        this.userIsDisable = userIsDisable;
    }

    public Date getUserBirth() {
        return userBirth;
    }

    public void setUserBirth(Date userBirth) {
        this.userBirth = userBirth;
    }

    public String getUserBirthStr() {
        return userBirthStr;
    }

    public void setUserBirthStr(String userBirthStr) {
        this.userBirthStr = userBirthStr;
    }

    public String getUserTelephone() {
        return userTelephone;
    }

    public void setUserTelephone(String userTelephone) {
        this.userTelephone = userTelephone;
    }

    public String getUserMobileNo() {
        return userMobileNo;
    }

    public void setUserMobileNo(String userMobileNo) {
        this.userMobileNo = userMobileNo;
    }

    public String getUserQq() {
        return userQq;
    }

    public void setUserQq(String userQq) {
        this.userQq = userQq;
    }

    public String getUserRemark() {
        return userRemark;
    }

    public void setUserRemark(String userRemark) {
        this.userRemark = userRemark;
    }

    public String getRegisterCode() {
        return registerCode;
    }

    public void setRegisterCode(String registerCode) {
        this.registerCode = registerCode;
    }

    public String getUserProvince() {
        return userProvince;
    }

    public void setUserProvince(String userProvince) {
        this.userProvince = userProvince;
    }

    public String getUserCity() {
        return userCity;
    }

    public void setUserCity(String userCity) {
        this.userCity = userCity;
    }

    public String getUserArea() {
        return userArea;
    }

    public void setUserArea(String userArea) {
        this.userArea = userArea;
    }

    public Integer getUserType() {
        return userType;
    }

    public void setUserType(Integer userType) {
        this.userType = userType;
    }

    public String getUserCardNo() {
        return userCardNo;
    }

    public void setUserCardNo(String userCardNo) {
        this.userCardNo = userCardNo;
    }

    public Integer getCommentStatus() {
        return commentStatus;
    }

    public void setCommentStatus(Integer commentStatus) {
        this.commentStatus = commentStatus;
    }

    public Date getLastLoginTime() {
        return lastLoginTime;
    }

    public void setLastLoginTime(Date lastLoginTime) {
        this.lastLoginTime = lastLoginTime;
    }

    public Integer getLoginType() {
        return loginType;
    }

    public void setLoginType(Integer loginType) {
        this.loginType = loginType;
    }

    public Date getLastSendSmsTime() {
        return lastSendSmsTime;
    }

    public void setLastSendSmsTime(Date lastSendSmsTime) {
        this.lastSendSmsTime = lastSendSmsTime;
    }

    public Integer getRegisterCount() {
        return registerCount;
    }

    public void setRegisterCount(Integer registerCount) {
        this.registerCount = registerCount;
    }

    public Integer getSourceCode() {
        return sourceCode;
    }

    public void setSourceCode(Integer sourceCode) {
        this.sourceCode = sourceCode;
    }

    public Integer getFunctionCode() {
        return functionCode;
    }

    public void setFunctionCode(Integer functionCode) {
        this.functionCode = functionCode;
    }
}
