package com.culturecloud.model.bean.common;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value = "sys_user")
public class SysUser implements BaseEntity {

	private static final long serialVersionUID = 5313100926202801205L;

	@Id
	@Column(name = "USER_ID")
	private String userId;

	@Column(name = "USER_ACCOUNT")
	private String userAccount;

	@Column(name = "USER_NICK_NAME")
	private String userNickName;

	@Column(name = "USER_PASSWORD")
	private String userPassword;

	@Column(name = "USER_SEX")
	private Integer userSex;

	@Column(name = "USER_PROVINCE")
	private String userProvince;

	@Column(name = "USER_CITY")
	private String userCity;

	@Column(name = "USER_COUNTY")
	private String userCounty;

	@Column(name = "USER_ADDRESS")
	private String userAddress;

	@Column(name = "USER_MOBILE_PHONE")
	private String userMobilePhone;

	@Column(name = "USER_TELEPHONE")
	private String userTelephone;

	@Column(name = "USER_QQ")
	private String userQq;

	@Column(name = "USER_BIRTHDAY")
	private Date userBirthday;

	@Column(name = "USER_ID_CARD_NO")
	private String userIdCardNo;

	@Column(name = "USER_EMAIL")
	private String userEmail;

	@Column(name = "USER_ISDISPLAY")
	private Integer userIsdisplay;

	@Column(name = "USER_STATE")
	private Integer userState;

	@Column(name = "USER_DEPT_ID")
	private String userDeptId;

	@Column(name = "USER_CREATE_USER")
	private String userCreateUser;

	@Column(name = "USER_CREATE_TIME")
	private Date userCreateTime;

	@Column(name = "USER_UPDATE_USER")
	private String userUpdateUser;

	@Column(name = "USER_UPDATE_TIME")
	private Date userUpdateTime;

	@Column(name = "USER_IS_MANGER")
	private Integer userIsManger;

	@Column(name = "USER_IS_ASSIGN")
	private Integer userIsAssign;

	@Column(name = "USER_LABEL1")
	private Integer userLabel1;

	@Column(name = "USER_LABEL2")
	private Integer userLabel2;

	@Column(name = "USER_LABEL3")
	private Integer userLabel3;

	@Column(name = "USER_HEAD_IMG_URL")
	private String userHeadImgUrl;

	@Column(name = "USER_DEPT_PATH")
	private String userDeptPath;

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_ID
	 *
	 * @return the value of sys_user.USER_ID
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public String getUserId() {
		return userId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_ID
	 *
	 * @param userId
	 *            the value for sys_user.USER_ID
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_ACCOUNT
	 *
	 * @return the value of sys_user.USER_ACCOUNT
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public String getUserAccount() {
		return userAccount;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_ACCOUNT
	 *
	 * @param userAccount
	 *            the value for sys_user.USER_ACCOUNT
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserAccount(String userAccount) {
		this.userAccount = userAccount;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_NICK_NAME
	 *
	 * @return the value of sys_user.USER_NICK_NAME
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public String getUserNickName() {
		return userNickName;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_NICK_NAME
	 *
	 * @param userNickName
	 *            the value for sys_user.USER_NICK_NAME
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserNickName(String userNickName) {
		this.userNickName = userNickName;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_PASSWORD
	 *
	 * @return the value of sys_user.USER_PASSWORD
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public String getUserPassword() {
		return userPassword;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_PASSWORD
	 *
	 * @param userPassword
	 *            the value for sys_user.USER_PASSWORD
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_SEX
	 *
	 * @return the value of sys_user.USER_SEX
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public Integer getUserSex() {
		return userSex;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_SEX
	 *
	 * @param userSex
	 *            the value for sys_user.USER_SEX
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserSex(Integer userSex) {
		this.userSex = userSex;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_PROVINCE
	 *
	 * @return the value of sys_user.USER_PROVINCE
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public String getUserProvince() {
		return userProvince;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_PROVINCE
	 *
	 * @param userProvince
	 *            the value for sys_user.USER_PROVINCE
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserProvince(String userProvince) {
		this.userProvince = userProvince;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_CITY
	 *
	 * @return the value of sys_user.USER_CITY
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public String getUserCity() {
		return userCity;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_CITY
	 *
	 * @param userCity
	 *            the value for sys_user.USER_CITY
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserCity(String userCity) {
		this.userCity = userCity;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_COUNTY
	 *
	 * @return the value of sys_user.USER_COUNTY
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public String getUserCounty() {
		return userCounty;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_COUNTY
	 *
	 * @param userCounty
	 *            the value for sys_user.USER_COUNTY
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserCounty(String userCounty) {
		this.userCounty = userCounty;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_ADDRESS
	 *
	 * @return the value of sys_user.USER_ADDRESS
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public String getUserAddress() {
		return userAddress;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_ADDRESS
	 *
	 * @param userAddress
	 *            the value for sys_user.USER_ADDRESS
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserAddress(String userAddress) {
		this.userAddress = userAddress;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_MOBILE_PHONE
	 *
	 * @return the value of sys_user.USER_MOBILE_PHONE
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public String getUserMobilePhone() {
		return userMobilePhone;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_MOBILE_PHONE
	 *
	 * @param userMobilePhone
	 *            the value for sys_user.USER_MOBILE_PHONE
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserMobilePhone(String userMobilePhone) {
		this.userMobilePhone = userMobilePhone;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_TELEPHONE
	 *
	 * @return the value of sys_user.USER_TELEPHONE
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public String getUserTelephone() {
		return userTelephone;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_TELEPHONE
	 *
	 * @param userTelephone
	 *            the value for sys_user.USER_TELEPHONE
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserTelephone(String userTelephone) {
		this.userTelephone = userTelephone;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_QQ
	 *
	 * @return the value of sys_user.USER_QQ
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public String getUserQq() {
		return userQq;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_QQ
	 *
	 * @param userQq
	 *            the value for sys_user.USER_QQ
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserQq(String userQq) {
		this.userQq = userQq;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_BIRTHDAY
	 *
	 * @return the value of sys_user.USER_BIRTHDAY
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public Date getUserBirthday() {
		return userBirthday;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_BIRTHDAY
	 *
	 * @param userBirthday
	 *            the value for sys_user.USER_BIRTHDAY
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserBirthday(Date userBirthday) {
		this.userBirthday = userBirthday;
	}
	
	public void setUserBirthday(java.sql.Date userBirthday) {
		this.userBirthday = userBirthday;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_ID_CARD_NO
	 *
	 * @return the value of sys_user.USER_ID_CARD_NO
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public String getUserIdCardNo() {
		return userIdCardNo;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_ID_CARD_NO
	 *
	 * @param userIdCardNo
	 *            the value for sys_user.USER_ID_CARD_NO
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserIdCardNo(String userIdCardNo) {
		this.userIdCardNo = userIdCardNo;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_EMAIL
	 *
	 * @return the value of sys_user.USER_EMAIL
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public String getUserEmail() {
		return userEmail;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_EMAIL
	 *
	 * @param userEmail
	 *            the value for sys_user.USER_EMAIL
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_ISDISPLAY
	 *
	 * @return the value of sys_user.USER_ISDISPLAY
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public Integer getUserIsdisplay() {
		return userIsdisplay;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_ISDISPLAY
	 *
	 * @param userIsdisplay
	 *            the value for sys_user.USER_ISDISPLAY
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserIsdisplay(Integer userIsdisplay) {
		this.userIsdisplay = userIsdisplay;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_STATE
	 *
	 * @return the value of sys_user.USER_STATE
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public Integer getUserState() {
		return userState;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_STATE
	 *
	 * @param userState
	 *            the value for sys_user.USER_STATE
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserState(Integer userState) {
		this.userState = userState;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_DEPT_ID
	 *
	 * @return the value of sys_user.USER_DEPT_ID
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public String getUserDeptId() {
		return userDeptId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_DEPT_ID
	 *
	 * @param userDeptId
	 *            the value for sys_user.USER_DEPT_ID
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserDeptId(String userDeptId) {
		this.userDeptId = userDeptId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_CREATE_USER
	 *
	 * @return the value of sys_user.USER_CREATE_USER
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public String getUserCreateUser() {
		return userCreateUser;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_CREATE_USER
	 *
	 * @param userCreateUser
	 *            the value for sys_user.USER_CREATE_USER
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserCreateUser(String userCreateUser) {
		this.userCreateUser = userCreateUser;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_CREATE_TIME
	 *
	 * @return the value of sys_user.USER_CREATE_TIME
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public Date getUserCreateTime() {
		return userCreateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_CREATE_TIME
	 *
	 * @param userCreateTime
	 *            the value for sys_user.USER_CREATE_TIME
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserCreateTime(Date userCreateTime) {
		this.userCreateTime = userCreateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_UPDATE_USER
	 *
	 * @return the value of sys_user.USER_UPDATE_USER
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public String getUserUpdateUser() {
		return userUpdateUser;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_UPDATE_USER
	 *
	 * @param userUpdateUser
	 *            the value for sys_user.USER_UPDATE_USER
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserUpdateUser(String userUpdateUser) {
		this.userUpdateUser = userUpdateUser;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_UPDATE_TIME
	 *
	 * @return the value of sys_user.USER_UPDATE_TIME
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public Date getUserUpdateTime() {
		return userUpdateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_UPDATE_TIME
	 *
	 * @param userUpdateTime
	 *            the value for sys_user.USER_UPDATE_TIME
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserUpdateTime(Date userUpdateTime) {
		this.userUpdateTime = userUpdateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_IS_MANGER
	 *
	 * @return the value of sys_user.USER_IS_MANGER
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public Integer getUserIsManger() {
		return userIsManger;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_IS_MANGER
	 *
	 * @param userIsManger
	 *            the value for sys_user.USER_IS_MANGER
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserIsManger(Integer userIsManger) {
		this.userIsManger = userIsManger;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_IS_ASSIGN
	 *
	 * @return the value of sys_user.USER_IS_ASSIGN
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public Integer getUserIsAssign() {
		return userIsAssign;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_IS_ASSIGN
	 *
	 * @param userIsAssign
	 *            the value for sys_user.USER_IS_ASSIGN
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserIsAssign(Integer userIsAssign) {
		this.userIsAssign = userIsAssign;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_LABEL1
	 *
	 * @return the value of sys_user.USER_LABEL1
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public Integer getUserLabel1() {
		return userLabel1;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_LABEL1
	 *
	 * @param userLabel1
	 *            the value for sys_user.USER_LABEL1
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserLabel1(Integer userLabel1) {
		this.userLabel1 = userLabel1;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_LABEL2
	 *
	 * @return the value of sys_user.USER_LABEL2
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public Integer getUserLabel2() {
		return userLabel2;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_LABEL2
	 *
	 * @param userLabel2
	 *            the value for sys_user.USER_LABEL2
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserLabel2(Integer userLabel2) {
		this.userLabel2 = userLabel2;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_LABEL3
	 *
	 * @return the value of sys_user.USER_LABEL3
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public Integer getUserLabel3() {
		return userLabel3;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_LABEL3
	 *
	 * @param userLabel3
	 *            the value for sys_user.USER_LABEL3
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserLabel3(Integer userLabel3) {
		this.userLabel3 = userLabel3;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_HEAD_IMG_URL
	 *
	 * @return the value of sys_user.USER_HEAD_IMG_URL
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public String getUserHeadImgUrl() {
		return userHeadImgUrl;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_HEAD_IMG_URL
	 *
	 * @param userHeadImgUrl
	 *            the value for sys_user.USER_HEAD_IMG_URL
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserHeadImgUrl(String userHeadImgUrl) {
		this.userHeadImgUrl = userHeadImgUrl;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column sys_user.USER_DEPT_PATH
	 *
	 * @return the value of sys_user.USER_DEPT_PATH
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public String getUserDeptPath() {
		return userDeptPath;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column sys_user.USER_DEPT_PATH
	 *
	 * @param userDeptPath
	 *            the value for sys_user.USER_DEPT_PATH
	 *
	 * @mbggenerated Thu Jan 12 14:59:37 CST 2017
	 */
	public void setUserDeptPath(String userDeptPath) {
		this.userDeptPath = userDeptPath;
	}
}