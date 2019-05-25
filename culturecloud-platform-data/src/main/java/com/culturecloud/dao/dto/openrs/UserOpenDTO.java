package com.culturecloud.dao.dto.openrs;

public class UserOpenDTO {

	private String userId;
	
	private String userNickName;
	
	private String telphone;
	
	private String mobilephone;
	
	private String headUrl;
	
	private String integralNow;
	
	private String sex;
	
	private String realName;
	
	private String userName;
	
    private Integer userType;

    private String userCardNo;
    
    private Integer sourceCode;		//0代表文化上海云  1代表文化嘉定云 2 pt  3  hp  4 js 5 hk 6 pd 7 cm 8 bs 9 mh

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserNickName() {
		return userNickName;
	}

	public void setUserNickName(String userNickName) {
		this.userNickName = userNickName;
	}

	public String getTelphone() {
		return telphone;
	}

	public void setTelphone(String telphone) {
		this.telphone = telphone;
	}

	public String getHeadUrl() {
		return headUrl;
	}

	public void setHeadUrl(String headUrl) {
		this.headUrl = headUrl;
	}

	public String getIntegralNow() {
		return integralNow;
	}

	public void setIntegralNow(String integralNow) {
		this.integralNow = integralNow;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public String getRealName() {
		return realName;
	}

	public void setRealName(String realName) {
		this.realName = realName;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
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

	public String getMobilephone() {
		return mobilephone;
	}

	public void setMobilephone(String mobilephone) {
		this.mobilephone = mobilephone;
	}

	public Integer getSourceCode() {
		return sourceCode;
	}

	public void setSourceCode(Integer sourceCode) {
		this.sourceCode = sourceCode;
	}
	
}
