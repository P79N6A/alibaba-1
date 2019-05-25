package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class SysUser extends Pagination implements Serializable{
    /**
     * 主键
     */
    private String userId;
    /**
     * 用户账号
     */
    private String userAccount;
    /**
     * 昵称
     */
    private String userNickName;
    /**
     * 登录密码
     */
    private String userPassword;

    /**
     * 性别1-男 2-女
     */
    private Integer userSex;
    /**
     * 所属省份
     */
    private String userProvince;
    /**
     * 所属市
     */
    private String userCity;
    /**
     * 所属区县
     */
    private String userCounty;
    /**
     * 详细地址街道
     */
    private String userAddress;
    /**
     * 手机号码
     */
    private String userMobilePhone;
    /**
     * 座机号码
     */
    private String userTelephone;
    /**
     * qq号码
     */
    private String userQq;
    /**
     * 生日
     */
    private Date userBirthday;
    /**
     * 身份证号码
     */
    private String userIdCardNo;
    /**
     *邮箱
     */
    private String userEmail;
    /**
     * 是否启用 1-启用 2-禁用
     */
    private Integer userIsdisplay;
    /**
     * 状态 1-正常 2-删除
     */
    private Integer userState;
    /**
     * 所属部门
     */
    private String userDeptId;
    /**
     * 操作员
     */
    private String userCreateUser;
    /**
     * 录入时间
     */
    private Date userCreateTime;
    /**
     * 更新人
     */
    private String userUpdateUser;
    /**
     * 更新时间
     */
    private Date userUpdateTime;

    /**
     * 用户部门路径
     */
    private String userDeptPath;

    /**
     * 用户是否为区级管理员
     */
    private Integer userIsManger;

    /**
     * 用户是否已经分配场馆  1. 未分配   2. 已经分配
     */
    private Integer userIsAssign;

    /**
     * app添加字段
     */
    private  String roleName;
    private  String deptName;

    /**
     * 权限标签(文广体系、独立商家、其他)
     */
    private Integer userLabel1;
    private Integer userLabel2;
    private Integer userLabel3;
    
    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public Integer getUserIsAssign() {
        return userIsAssign;
    }

    public void setUserIsAssign(Integer userIsAssign) {
        this.userIsAssign = userIsAssign;
    }

    public Integer getUserIsManger() {
        return userIsManger;
    }

    public void setUserIsManger(Integer userIsManger) {
        this.userIsManger = userIsManger;
    }

    private List<SysModule> sysModuleList;

    public List<SysModule> getSysModuleList() {
        return sysModuleList;
    }

    public void setSysModuleList(List<SysModule> sysModuleList) {
        this.sysModuleList = sysModuleList;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getUserAccount() {
        return userAccount;
    }

    public void setUserAccount(String userAccount) {
        this.userAccount = userAccount;
    }

    public String getUserNickName() {
        return userNickName;
    }

    public void setUserNickName(String userNickName) {
        this.userNickName = userNickName == null ? null : userNickName.trim();
    }

    public String getUserPassword() {
        return userPassword;
    }

    public void setUserPassword(String userPassword) {
        this.userPassword = userPassword;
    }

    public Integer getUserSex() {
        return userSex;
    }

    public void setUserSex(Integer userSex) {
        this.userSex = userSex;
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

    public String getUserCounty() {
        return userCounty;
    }

    public void setUserCounty(String userCounty) {
        this.userCounty = userCounty == null ? null : userCounty.trim();
    }

    public String getUserAddress() {
        return userAddress;
    }

    public void setUserAddress(String userAddress) {
        this.userAddress = userAddress == null ? null : userAddress.trim();
    }

    public String getUserMobilePhone() {
        return userMobilePhone;
    }

    public void setUserMobilePhone(String userMobilePhone) {
        this.userMobilePhone = userMobilePhone == null ? null : userMobilePhone.trim();
    }

    public String getUserTelephone() {
        return userTelephone;
    }

    public void setUserTelephone(String userTelephone) {
        this.userTelephone = userTelephone == null ? null : userTelephone.trim();
    }

    public String getUserQq() {
        return userQq;
    }

    public void setUserQq(String userQq) {
        this.userQq = userQq == null ? null : userQq.trim();
    }

    public Date getUserBirthday() {
        return userBirthday;
    }

    public void setUserBirthday(Date userBirthday) {
        this.userBirthday = userBirthday;
    }

    public String getUserIdCardNo() {
        return userIdCardNo;
    }

    public void setUserIdCardNo(String userIdCardNo) {
        this.userIdCardNo = userIdCardNo == null ? null : userIdCardNo.trim();
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail == null ? null : userEmail.trim();
    }

    public Integer getUserIsdisplay() {
        return userIsdisplay;
    }

    public void setUserIsdisplay(Integer userIsdisplay) {
        this.userIsdisplay = userIsdisplay;
    }

    public Integer getUserState() {
        return userState;
    }

    public void setUserState(Integer userState) {
        this.userState = userState;
    }

    public String getUserDeptId() {
        return userDeptId;
    }

    public void setUserDeptId(String userDeptId) {
        this.userDeptId = userDeptId == null ? null : userDeptId.trim();
    }

    public String getUserCreateUser() {
        return userCreateUser;
    }

    public void setUserCreateUser(String userCreateUser) {
        this.userCreateUser = userCreateUser == null ? null : userCreateUser.trim();
    }

    public Date getUserCreateTime() {
        return userCreateTime;
    }

    public void setUserCreateTime(Date userCreateTime) {
        this.userCreateTime = userCreateTime;
    }

    public String getUserUpdateUser() {
        return userUpdateUser;
    }

    public void setUserUpdateUser(String userUpdateUser) {
        this.userUpdateUser = userUpdateUser == null ? null : userUpdateUser.trim();
    }

    public Date getUserUpdateTime() {
        return userUpdateTime;
    }

    public void setUserUpdateTime(Date userUpdateTime) {
        this.userUpdateTime = userUpdateTime;
    }

    public String getUserDeptPath() {
        return userDeptPath;
    }

    public void setUserDeptPath(String userDeptPath) {
        this.userDeptPath = userDeptPath == null ? null : userDeptPath.trim();
    }

	public Integer getUserLabel1() {
		return userLabel1;
	}

	public void setUserLabel1(Integer userLabel1) {
		this.userLabel1 = userLabel1;
	}

	public Integer getUserLabel2() {
		return userLabel2;
	}

	public void setUserLabel2(Integer userLabel2) {
		this.userLabel2 = userLabel2;
	}

	public Integer getUserLabel3() {
		return userLabel3;
	}

	public void setUserLabel3(Integer userLabel3) {
		this.userLabel3 = userLabel3;
	}

}