package com.culturecloud.model.bean.common;


import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

import javax.persistence.Column;
import java.util.Date;

@Table(value="cms_terminal_user")
public class CmsTerminalUser implements BaseEntity {

    private static final long serialVersionUID = -3586841584989510841L;

    @Id
    @Column(name="USER_ID")
    private String userId;

    @Column(name="USER_NAME")
    private String userName;

    @Column(name="USER_PWD")
    private String userPwd;

    @Column(name="USER_NICK_NAME")
    private String userNickName;

    @Column(name="USER_EMAIL")
    private String userEmail;

    @Column(name="USER_SEX")
    private Integer userSex;

    @Column(name="USER_AGE")
    private Integer userAge;

    @Column(name="USE_ADDRESS")
    private String useAddress;

    @Column(name="USER_HEAD_IMG_URL")
    private String userHeadImgUrl;

    @Column(name="USER_IMEI")
    private String userImei;

    @Column(name="USER_IMSI")
    private String userImsi;

    @Column(name="USER_EQUIPMENT_ID")
    private String userEquipmentId;

    @Column(name="USER_GPS")
    private String userGps;

    @Column(name="USER_IP")
    private String userIp;

    @Column(name="USER_MAC")
    private String userMac;

    @Column(name="USER_MOBILE_TYPE")
    private String userMobileType;

    @Column(name="USER_INTERNETWAY")
    private String userInternetway;

    @Column(name="USER_SITE_ID")
    private String userSiteId;

    @Column(name="SNSTYPE")
    private Integer snstype;

    @Column(name="OPER_ID")
    private String operId;

    @Column(name="ACCESS_TOKEN")
    private String accessToken;

    @Column(name="EXPIRES_IN")
    private String expiresIn;

    @Column(name="CREATE_TIME")
    private Date createTime;

    @Column(name="USER_DEVICE_TOKEN")
    private String userDeviceToken;

    @Column(name="USER_IS_LOGIN")
    private Integer userIsLogin;

    @Column(name="USER_IS_DISABLE")
    private Integer userIsDisable;

    @Column(name="USER_BIRTH")
    private Date userBirth;

    @Column(name="USER_TELEPHONE")
    private String userTelephone;

    @Column(name="USER_MOBILE_NO")
    private String userMobileNo;

    @Column(name="USER_QQ")
    private String userQq;

    @Column(name="USER_REMARK")
    private String userRemark;

    @Column(name="REGISTER_CODE")
    private String registerCode;

    @Column(name="USER_PROVINCE")
    private String userProvince;

    @Column(name="USER_CITY")
    private String userCity;

    @Column(name="USER_AREA")
    private String userArea;

    @Column(name="USER_TYPE")
    private Integer userType;

    @Column(name="USER_CARD_NO")
    private String userCardNo;

    @Column(name="COMMENT_STATUS")
    private Integer commentStatus;

    @Column(name="LAST_SENDSMS_TIME")
    private Date lastSendsmsTime;

    @Column(name="LAST_LOGIN_TIME")
    private Date lastLoginTime;

    @Column(name="LOGIN_TYPE")
    private Integer loginType;

    @Column(name="REGISTER_COUNT")
    private Integer RegisterCount;
    // 身份证照片路径
    @Column(name="USER_IDCARD_PHOTO_URL")
    private String idCardPhotoUrl;

    /**
     * 数据来源 0代表文化上海云，1代表文化嘉定云
     * 对应TerminalUserConstant
     */
    @Column(name="SOURCE_CODE")
    private Integer sourceCode;

    //注册账号来源 1 文化云 2 QQ  3 新浪微博 4 微信
    @Column(name="REGISTER_ORIGIN")
    private  Integer registerOrigin;

    @Column(name="SYS_ID")
    private String sysId;
    
    @Column(name="USER_IDCARD_PHOTO_URL")
    private String userIdcardPhotoUrl;
    

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

    public String getExpiresIn() {
        return expiresIn;
    }

    public void setExpiresIn(String expiresIn) {
        this.expiresIn = expiresIn;
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

    public String getIdCardPhotoUrl() {
		return idCardPhotoUrl;
	}

	public void setIdCardPhotoUrl(String idCardPhotoUrl) {
		this.idCardPhotoUrl = idCardPhotoUrl;
	}

	public Integer getSourceCode() {
        return sourceCode;
    }

    public void setSourceCode(Integer sourceCode) {
        this.sourceCode = sourceCode;
    }

    public Integer getRegisterOrigin() {
        return registerOrigin;
    }

    public void setRegisterOrigin(Integer registerOrigin) {
        this.registerOrigin = registerOrigin;
    }

    public String getSysId() {
        return sysId;
    }

    public void setSysId(String sysId) {
        this.sysId = sysId;
    }

    public String getUserPwd() {
        return userPwd;
    }

    public void setUserPwd(String userPwd) {
        this.userPwd = userPwd;
    }

    public Integer getRegisterCount() {
        return RegisterCount;
    }

    public void setRegisterCount(Integer registerCount) {
        RegisterCount = registerCount;
    }

	public String getUserIdcardPhotoUrl() {
		return userIdcardPhotoUrl;
	}

	public void setUserIdcardPhotoUrl(String userIdcardPhotoUrl) {
		this.userIdcardPhotoUrl = userIdcardPhotoUrl;
	}

	public Date getLastSendsmsTime() {
		return lastSendsmsTime;
	}

	public void setLastSendsmsTime(Date lastSendsmsTime) {
		this.lastSendsmsTime = lastSendsmsTime;
	}
    
	
}
