package com.sun3d.why.model.peopleTrain;

import java.sql.Timestamp;
import java.util.Date;

public class CourseOrder {
	private String orderId;
	private String courseId;
	private String userId;
	private String trainTime;
	private String trainAddress;
	//订单状态
	private Integer orderStatus;
	private String createTime;
	//课程名
	private String courseTitle;
	//课程名
	private String coursePhoneNum;
	private String userName;
	private Integer userSex;
	private String idNumber;
	private String userMobileNo;
	private String  unitArea;
	private String userEmail;
	//单位名称
	private String  unitName;
	//职务
	private String jobPosition;
	//职称
	private String jobTitle;
	//短信发送状态(审核报名) 1.未发送 2.已发送
	private Integer messageState;
	//是否参加培训  1未参加 2已参加
	private Integer attendState;
	//课时
	private Integer classTimes;
	//真实姓名
	private String realName;
	//字典编码，关联字典库
	private String typeCode;

	private String verificationCode;
	
	//课程开始时间
	private String startTime;
	//课程结束时间
	private String endTime;
	private String updateUser;
	private Date updateTime;
//群发状态 1未群发。2已群发
	private Integer allSmsState;
	
	public String getOrderId() {
		return orderId;
	}
	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}
	public String getCourseId() {
		return courseId;
	}
	public void setCourseId(String courseId) {
		this.courseId = courseId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}


	public String getCreateTime() {
		return createTime;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public String getCourseTitle() {
		return courseTitle;
	}
	public void setCourseTitle(String courseTitle) {
		this.courseTitle = courseTitle;
	}
	public Integer getOrderStatus() {
		return orderStatus;
	}
	public void setOrderStatus(Integer orderStatus) {
		this.orderStatus = orderStatus;
	}
	public String getTrainTime() {
		return trainTime;
	}
	public void setTrainTime(String trainTime) {
		this.trainTime = trainTime;
	}
	public String getTrainAddress() {
		return trainAddress;
	}
	public void setTrainAddress(String trainAddress) {
		this.trainAddress = trainAddress;
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
	public String getIdNumber() {
		return idNumber;
	}
	public void setIdNumber(String idNumber) {
		this.idNumber = idNumber;
	}
	public String getUserMobileNo() {
		return userMobileNo;
	}
	public void setUserMobileNo(String userMobileNo) {
		this.userMobileNo = userMobileNo;
	}
	public Integer getMessageState() {
		return messageState;
	}
	public void setMessageState(Integer messageState) {
		this.messageState = messageState;
	}
	public Integer getAttendState() {
		return attendState;
	}
	public void setAttendState(Integer attendState) {
		this.attendState = attendState;
	}
	public Integer getClassTimes() {
		return classTimes;
	}
	public void setClassTimes(Integer classTimes) {
		this.classTimes = classTimes;
	}
	public String getUnitArea() {
		return unitArea;
	}
	public void setUnitArea(String unitArea) {
		this.unitArea = unitArea;
	}
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
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
	public String getTypeCode() {
		return typeCode;
	}
	public void setTypeCode(String typeCode) {
		this.typeCode = typeCode;
	}
	public String getRealName() {
		return realName;
	}
	public void setRealName(String realName) {
		this.realName = realName;
	}
	public String getVerificationCode() {
		return verificationCode;
	}
	public void setVerificationCode(String verificationCode) {
		this.verificationCode = verificationCode;
	}

	public Integer getAllSmsState() {
		return allSmsState;
	}
	public void setAllSmsState(Integer allSmsState) {
		this.allSmsState = allSmsState;
	}
	public String getStartTime() {
		return startTime;
	}
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}
	public String getEndTime() {
		return endTime;
	}
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	public String getUpdateUser() {
		return updateUser;
	}
	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}
	public Date getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	public String getCoursePhoneNum() {
		return coursePhoneNum;
	}
	public void setCoursePhoneNum(String coursePhoneNum) {
		this.coursePhoneNum = coursePhoneNum;
	}
	
}
