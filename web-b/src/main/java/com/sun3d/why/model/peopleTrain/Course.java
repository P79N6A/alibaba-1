package com.sun3d.why.model.peopleTrain;

import java.util.Date;

public class Course {
	private String courseId;
	//课程标题
	private String courseTitle;
	//培训方式
	private String courseType;
	//课程批次
	private String courseRank;
	//课程图片
	private String pictureUrl;
	//最大报名人数
	private Integer peopleNumber;
	//课程领域
	private String courseField;
	//院校属性
	private String collegesAttributes;
	//课程描述
	private String courseDescription;
	//课程创建时间
	private Date createTime;
	//课程创建人
	private String createUser;
	//专业类别
	private String majorType;
	//培训地点
	private String trainAddress;
   //目标学员
	private String targetAudienc;
	//师资简介
	private String teacherIntro;
	//培训时间描述
	private String trainTime;
	//状态  1 上架 2下架 3删除
	private Integer courseState;
	
	private Integer orderNum;
	//课程审核
	private Integer courseCheck;
	//课程创建人ID
	private String createUserId;
	private String updateUser;
	private String updateUserId;
	private Date updateTime;
	//课程开始时间
	private String courseStartTime;
	//课程结束时间
	private String courseEndTime;
	//课程联系方式
	private String coursePhoneNum;
	
	public String getCourseId() {
		return courseId;
	}
	public void setCourseId(String courseId) {
		this.courseId = courseId;
	}
	public String getCourseTitle() {
		return courseTitle;
	}
	public void setCourseTitle(String courseTitle) {
		this.courseTitle = courseTitle;
	}
	public String getCourseType() {
		return courseType;
	}
	public void setCourseType(String courseType) {
		this.courseType = courseType;
	}
	
	public String getCourseRank() {
		return courseRank;
	}
	public void setCourseRank(String courseRank) {
		this.courseRank = courseRank;
	}
	public String getPictureUrl() {
		return pictureUrl;
	}
	public void setPictureUrl(String pictureUrl) {
		this.pictureUrl = pictureUrl;
	}
	
	public Integer getPeopleNumber() {
		return peopleNumber;
	}
	public void setPeopleNumber(Integer peopleNumber) {
		this.peopleNumber = peopleNumber;
	}

	public String getCourseField() {
		return courseField;
	}
	public void setCourseField(String courseField) {
		this.courseField = courseField;
	}
	public String getCollegesAttributes() {
		return collegesAttributes;
	}
	public void setCollegesAttributes(String collegesAttributes) {
		this.collegesAttributes = collegesAttributes;
	}
	public String getCreateUser() {
		return createUser;
	}
	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}
	public String getCourseDescription() {
		return courseDescription;
	}
	public void setCourseDescription(String courseDescription) {
		this.courseDescription = courseDescription;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public String getMajorType() {
		return majorType;
	}
	public void setMajorType(String majorType) {
		this.majorType = majorType;
	}
	public String getTrainAddress() {
		return trainAddress;
	}
	public void setTrainAddress(String trainAddress) {
		this.trainAddress = trainAddress;
	}
	public String getTargetAudienc() {
		return targetAudienc;
	}
	public void setTargetAudienc(String targetAudienc) {
		this.targetAudienc = targetAudienc;
	}
	public String getTeacherIntro() {
		return teacherIntro;
	}
	public void setTeacherIntro(String teacherIntro) {
		this.teacherIntro = teacherIntro;
	}
	public String getTrainTime() {
		return trainTime;
	}
	public void setTrainTime(String trainTime) {
		this.trainTime = trainTime;
	}
	public Integer getCourseState() {
		return courseState;
	}
	public void setCourseState(Integer courseState) {
		this.courseState = courseState;
	}
	public Integer getOrderNum() {
		return orderNum;
	}
	public void setOrderNum(Integer orderNum) {
		this.orderNum = orderNum;
	}
	public Integer getCourseCheck() {
		return courseCheck;
	}
	public void setCourseCheck(Integer courseCheck) {
		this.courseCheck = courseCheck;
	}
	public String getCreateUserId() {
		return createUserId;
	}
	public void setCreateUserId(String createUserId) {
		this.createUserId = createUserId;
	}
	public String getUpdateUser() {
		return updateUser;
	}
	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}
	public String getUpdateUserId() {
		return updateUserId;
	}
	public void setUpdateUserId(String updateUserId) {
		this.updateUserId = updateUserId;
	}
	public Date getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	public String getCourseStartTime() {
		return courseStartTime;
	}
	public void setCourseStartTime(String courseStartTime) {
		this.courseStartTime = courseStartTime;
	}
	public String getCourseEndTime() {
		return courseEndTime;
	}
	public void setCourseEndTime(String courseEndTime) {
		this.courseEndTime = courseEndTime;
	}
	public String getCoursePhoneNum() {
		return coursePhoneNum;
	}
	public void setCoursePhoneNum(String coursePhoneNum) {
		this.coursePhoneNum = coursePhoneNum;
	}
	
}
