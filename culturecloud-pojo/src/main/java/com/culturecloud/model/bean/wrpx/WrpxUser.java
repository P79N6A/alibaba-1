package com.culturecloud.model.bean.wrpx;

import java.io.Serializable;
import java.util.Date;

public class WrpxUser implements Serializable{
    /**
	 * 
	 */
	private static final long serialVersionUID = -2988531348841388617L;

	private String wrpxUserId;

    private String realName;

    private String phoneNo;

    private String password;

    private String captcha;

    private Date captchaOvertime;

    private Integer sex;

    private String userEmail;

    private String userHeadImg;

    private String idNumber;

    private String unitArea;

    private String unitName;

    private String jobPosition;

    private String jobTitle;

    private String engagedField;

    private String ertficateNumber;

    private String verification;

    private Integer userSource;

    private String createUser;

    private Date createDate;

    private String updateUser;

    private Date updateDate;

    private Boolean deleted;

    private Boolean activity;

    private Integer score;
    
    private String userName;

    public String getWrpxUserId() {
        return wrpxUserId;
    }

    public void setWrpxUserId(String wrpxUserId) {
        this.wrpxUserId = wrpxUserId == null ? null : wrpxUserId.trim();
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName == null ? null : realName.trim();
    }

    public String getPhoneNo() {
        return phoneNo;
    }

    public void setPhoneNo(String phoneNo) {
        this.phoneNo = phoneNo == null ? null : phoneNo.trim();
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password == null ? null : password.trim();
    }

    public String getCaptcha() {
        return captcha;
    }

    public void setCaptcha(String captcha) {
        this.captcha = captcha == null ? null : captcha.trim();
    }

    public Date getCaptchaOvertime() {
        return captchaOvertime;
    }

    public void setCaptchaOvertime(Date captchaOvertime) {
        this.captchaOvertime = captchaOvertime;
    }

    public Integer getSex() {
        return sex;
    }

    public void setSex(Integer sex) {
        this.sex = sex;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail == null ? null : userEmail.trim();
    }

    public String getUserHeadImg() {
        return userHeadImg;
    }

    public void setUserHeadImg(String userHeadImg) {
        this.userHeadImg = userHeadImg == null ? null : userHeadImg.trim();
    }

    public String getIdNumber() {
        return idNumber;
    }

    public void setIdNumber(String idNumber) {
        this.idNumber = idNumber == null ? null : idNumber.trim();
    }

    public String getUnitArea() {
        return unitArea;
    }

    public void setUnitArea(String unitArea) {
        this.unitArea = unitArea == null ? null : unitArea.trim();
    }

    public String getUnitName() {
        return unitName;
    }

    public void setUnitName(String unitName) {
        this.unitName = unitName == null ? null : unitName.trim();
    }

    public String getJobPosition() {
        return jobPosition;
    }

    public void setJobPosition(String jobPosition) {
        this.jobPosition = jobPosition == null ? null : jobPosition.trim();
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle == null ? null : jobTitle.trim();
    }

    public String getEngagedField() {
        return engagedField;
    }

    public void setEngagedField(String engagedField) {
        this.engagedField = engagedField == null ? null : engagedField.trim();
    }

    public String getErtficateNumber() {
        return ertficateNumber;
    }

    public void setErtficateNumber(String ertficateNumber) {
        this.ertficateNumber = ertficateNumber == null ? null : ertficateNumber.trim();
    }

    public String getVerification() {
        return verification;
    }

    public void setVerification(String verification) {
        this.verification = verification == null ? null : verification.trim();
    }

    public Integer getUserSource() {
        return userSource;
    }

    public void setUserSource(Integer userSource) {
        this.userSource = userSource;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser == null ? null : createUser.trim();
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser == null ? null : updateUser.trim();
    }

    public Date getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Date updateDate) {
        this.updateDate = updateDate;
    }

    public Boolean getDeleted() {
        return deleted;
    }

    public void setDeleted(Boolean deleted) {
        this.deleted = deleted;
    }

    public Boolean getActivity() {
        return activity;
    }

    public void setActivity(Boolean activity) {
        this.activity = activity;
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
    
    
}