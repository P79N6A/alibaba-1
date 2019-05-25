package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;

public class CmsTerminalUser extends Pagination implements Serializable {

	private static final long serialVersionUID = 8455119154583323192L;

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

    private String expiresIn;

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

    // 身份证照片路径
    private String idCardPhotoUrl;

    private Integer integralNow;

    public Date getLastSendSmsTime() {
        return lastSendSmsTime;
    }

    public void setLastSendSmsTime(Date lastSendSmsTime) {
        this.lastSendSmsTime = lastSendSmsTime;
    }

    private  Date lastSendSmsTime;

    // 用户收藏数量
    private Integer collectCount;

    private Integer registerCount;

    // 申请时间
    private Date applyTime;

    // 团体名称
    private String tuserName;

    // 申请理由
    private String applyReason;

    // 申请id
    private String applyId;

    // 申请表（是否管理员）
    private Integer applyIsState;

    // 团体id
    private String tuserId;

    //团体成员最大限度
    private Integer tuserLimit;

    private String activityThemeTagId;		//用户选择类型（虚拟属性）


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

    private String sysId;
    private String sysNo;

    private String readerCard;//读者证号

    public String getSysId() {
        return sysId;
    }

    public void setSysId(String sysId) {
        this.sysId = sysId;
    }

    public String getSysNo() {
        return sysNo;
    }

    public void setSysNo(String sysNo) {
        this.sysNo = sysNo;
    }

    public Integer getLoginType() {
        return loginType;
    }

    public void setLoginType(Integer loginType) {
        this.loginType = loginType;
    }

    public String getTuserId() {
        return tuserId;
    }

    public void setTuserId(String tuserId) {
        this.tuserId = tuserId == null ? null : tuserId.trim();
    }

    public Integer getTuserLimit() {
        return tuserLimit;
    }

    public void setTuserLimit(Integer tuserLimit) {
        this.tuserLimit = tuserLimit;
    }

    public Date getLastLoginTime() {
        return lastLoginTime;
    }

    public void setLastLoginTime(Date lastLoginTime) {
        this.lastLoginTime = lastLoginTime;
    }

    public Integer getCommentStatus() {
        return commentStatus;
    }

    public void setCommentStatus(Integer commentStatus) {
        this.commentStatus = commentStatus;
    }

    //注册账号来源 1 文化云 2 QQ  3 新浪微博 4 微信
    private  Integer registerOrigin;

    public Integer getRegisterOrigin() {
        return registerOrigin;
    }

    public void setRegisterOrigin(Integer registerOrigin) {
        this.registerOrigin = registerOrigin;
    }

    public String getUserCardNo() {
        return userCardNo;
    }

    public void setUserCardNo(String userCardNo) {
        this.userCardNo = userCardNo == null ? null : userCardNo.trim();
    }

    public Integer getApplyIsState() {
        return applyIsState;
    }

    public void setApplyIsState(Integer applyIsState) {
        this.applyIsState = applyIsState;
    }

    public Integer getUserType() {
        return userType;
    }

    public void setUserType(Integer userType) {
        this.userType = userType;
    }

    public String getUserProvince() {
        return userProvince;
    }

    public void setUserProvince(String userProvince) {
        this.userProvince = userProvince == null ? null : userProvince.trim();
    }

    public String getUserCity() {
        return userCity;
    }

    public void setUserCity(String userCity) {
        this.userCity = userCity == null ? null : userCity.trim();
    }

    public String getUserArea() {
        return userArea;
    }

    public void setUserArea(String userArea) {
        this.userArea = userArea == null ? null : userArea.trim();
    }

    public String getApplyId() {
        return applyId;
    }

    public void setApplyId(String applyId) {
        this.applyId = applyId == null ? null : applyId.trim();
    }

    public String getApplyReason() {
        return applyReason;
    }

    public void setApplyReason(String applyReason) {
        this.applyReason = applyReason == null ? null : applyReason.trim();
    }

    public String getTuserName() {
        return tuserName;
    }

    public void setTuserName(String tuserName) {
        this.tuserName = tuserName == null ? null : tuserName.trim();
    }

    public Date getApplyTime() {
        return applyTime;
    }

    public void setApplyTime(Date applyTime) {
        this.applyTime = applyTime;
    }

    public Integer getRegisterCount() {
        return registerCount;
    }

    public void setRegisterCount(Integer registerCount) {
        this.registerCount = registerCount;
    }

    public Integer getCollectCount() {
        return collectCount;
    }

    public void setCollectCount(Integer collectCount) {
        this.collectCount = collectCount;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName == null ? null : userName.trim();
    }

    public String getUserPwd() {
        return userPwd;
    }

    public void setUserPwd(String userPwd) {
        this.userPwd = userPwd == null ? null : userPwd.trim();
    }

    public String getUserNickName() {
        return userNickName;
    }

    public void setUserNickName(String userNickName) {
        this.userNickName = userNickName == null ? null : userNickName.trim();
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail == null ? null : userEmail.trim();
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
        this.useAddress = useAddress == null ? null : useAddress.trim();
    }

    public String getUserHeadImgUrl() {
        return userHeadImgUrl;
    }

    public void setUserHeadImgUrl(String userHeadImgUrl) {
        this.userHeadImgUrl = userHeadImgUrl == null ? null : userHeadImgUrl.trim();
    }

    public String getUserImei() {
        return userImei;
    }

    public void setUserImei(String userImei) {
        this.userImei = userImei == null ? null : userImei.trim();
    }

    public String getUserImsi() {
        return userImsi;
    }

    public void setUserImsi(String userImsi) {
        this.userImsi = userImsi == null ? null : userImsi.trim();
    }

    public String getUserEquipmentId() {
        return userEquipmentId;
    }

    public void setUserEquipmentId(String userEquipmentId) {
        this.userEquipmentId = userEquipmentId == null ? null : userEquipmentId.trim();
    }

    public String getUserGps() {
        return userGps;
    }

    public void setUserGps(String userGps) {
        this.userGps = userGps == null ? null : userGps.trim();
    }

    public String getUserIp() {
        return userIp;
    }

    public void setUserIp(String userIp) {
        this.userIp = userIp == null ? null : userIp.trim();
    }

    public String getUserMac() {
        return userMac;
    }

    public void setUserMac(String userMac) {
        this.userMac = userMac == null ? null : userMac.trim();
    }

    public String getUserMobileType() {
        return userMobileType;
    }

    public void setUserMobileType(String userMobileType) {
        this.userMobileType = userMobileType == null ? null : userMobileType.trim();
    }

    public String getUserInternetway() {
        return userInternetway;
    }

    public void setUserInternetway(String userInternetway) {
        this.userInternetway = userInternetway == null ? null : userInternetway.trim();
    }

    public String getUserSiteId() {
        return userSiteId;
    }

    public void setUserSiteId(String userSiteId) {
        this.userSiteId = userSiteId == null ? null : userSiteId.trim();
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
        this.operId = operId == null ? null : operId.trim();
    }

    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken == null ? null : accessToken.trim();
    }

    public String getExpiresIn() {
        return expiresIn;
    }

    public void setExpiresIn(String expiresIn) {
        this.expiresIn = expiresIn == null ? null : expiresIn.trim();
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
        this.userDeviceToken = userDeviceToken == null ? null : userDeviceToken.trim();
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
        this.userTelephone = userTelephone == null ? null : userTelephone.trim();
    }

    public String getUserMobileNo() {
        return userMobileNo;
    }

    public void setUserMobileNo(String userMobileNo) {
        this.userMobileNo = userMobileNo == null ? null : userMobileNo.trim();
    }

    public String getUserQq() {
        return userQq;
    }

    public void setUserQq(String userQq) {
        this.userQq = userQq == null ? null : userQq.trim();
    }

    public String getUserRemark() {
        return userRemark;
    }

    public void setUserRemark(String userRemark) {
        this.userRemark = userRemark == null ? null : userRemark.trim();
    }

    public String getRegisterCode() {
        return registerCode;
    }

    public void setRegisterCode(String registerCode) {
        this.registerCode = registerCode == null ? null : registerCode.trim();
    }

	public String getActivityThemeTagId() {
		return activityThemeTagId;
	}

	public void setActivityThemeTagId(String activityThemeTagId) {
		this.activityThemeTagId = activityThemeTagId;
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

	public String getIdCardPhotoUrl() {
		return idCardPhotoUrl;
	}

	public void setIdCardPhotoUrl(String idCardPhotoUrl) {
		this.idCardPhotoUrl = idCardPhotoUrl;
	}

	public Integer getIntegralNow() {
		return integralNow;
	}

	public void setIntegralNow(Integer integralNow) {
		this.integralNow = integralNow;
	}

    public String getReaderCard() {
        return readerCard;
    }

    public void setReaderCard(String readerCard) {
        this.readerCard = readerCard;
    }
}