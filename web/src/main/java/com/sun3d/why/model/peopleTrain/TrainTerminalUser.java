package com.sun3d.why.model.peopleTrain;

import java.io.Serializable;
import java.util.Date;

import com.sun3d.why.util.Pagination;

public class TrainTerminalUser extends Pagination implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String id;
	//用户Id
	private String userId;
	private String userEmail;
	//身份证号
	private String idNumber;
	//单位所在区县
	private String  unitArea;
	//单位名称
	private String  unitName;
	//职务
	private String jobPosition;
	//职称
	private String jobTitle;
	//从事领域
	private String engagedField;
	//证书编号
	private String ertificateNumber;
	//验证码
	private String verificationCode;
	//报名时间
	private Date createTime;
	//更新时间
	private Date updateTime;
	//用户名称
	private String userName;
	//用户姓名
	private Integer userSex;
    //用户手机
	private String userMobileNo;
	
	private Integer classTimes;
	
	private String jobName;
	
	private String titleName;
	
	private String fieldName;
	//真实姓名
	private String realName;
	
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	public String getIdNumber() {
		return idNumber;
	}
	public void setIdNumber(String idNumber) {
		this.idNumber = idNumber;
	}
	public String getUnitArea() {
		return unitArea;
	}
	public void setUnitArea(String unitArea) {
		this.unitArea = unitArea;
	}
	public String getUnitName() {
		return unitName;
	}
	public void setUnitName(String unitName) {
		this.unitName = unitName;
	}
	public String getJobPosition() {
		return jobPosition;
	}
	public void setJobPosition(String jobPosition) {
		this.jobPosition = jobPosition;
	}
	public String getJobTitle() {
		return jobTitle;
	}
	public void setJobTitle(String jobTitle) {
		this.jobTitle = jobTitle;
	}
	public String getEngagedField() {
		return engagedField;
	}
	public void setEngagedField(String engagedField) {
		this.engagedField = engagedField;
	}
	public String getErtificateNumber() {
		return ertificateNumber;
	}
	public void setErtificateNumber(String ertificateNumber) {
		this.ertificateNumber = ertificateNumber;
	}
	public String getVerificationCode() {
		return verificationCode;
	}
	public void setVerificationCode(String verificationCode) {
		this.verificationCode = verificationCode;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public Date getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public Integer getUserSex() {
		return userSex;
	}
	public void setUserSex(Integer userSex) {
		this.userSex = userSex;
	}
	public String getUserMobileNo() {
		return userMobileNo;
	}
	public void setUserMobileNo(String userMobileNo) {
		this.userMobileNo = userMobileNo;
	}
	public String getJobName() {
		return jobName;
	}
	public void setJobName(String jobName) {
		this.jobName = jobName;
	}
	public String getTitleName() {
		return titleName;
	}
	public void setTitleName(String titleName) {
		this.titleName = titleName;
	}
	public String getFieldName() {
		return fieldName;
	}
	public void setFieldName(String fieldName) {
		this.fieldName = fieldName;
	}
	
	public Integer getClassTimes() {
		return classTimes;
	}
	public void setClassTimes(Integer classTimes) {
		this.classTimes = classTimes;
	}
	public String getRealName() {
		return realName;
	}
	public void setRealName(String realName) {
		this.realName = realName;
	}
	
}
