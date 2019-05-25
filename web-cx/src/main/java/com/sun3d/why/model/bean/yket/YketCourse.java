package com.sun3d.why.model.bean.yket;

import java.util.Date;

public class YketCourse {
    private String courseId;

    private String courseName;

    private String courseImgUrl;

    private String labelId;

    private String coursePress;

    private String teacherName;

    private String teacherPosition;

    private String teacherImgUrl;

    private Boolean deleted;

    private String teacherIntro;

    private String msg;

    private String createUser;

    private String updateUser;

    private Date createDate;

    private Date updateDate;

    public String getCourseId() {
        return courseId;
    }

    public void setCourseId(String courseId) {
        this.courseId = courseId == null ? null : courseId.trim();
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName == null ? null : courseName.trim();
    }

    public String getCourseImgUrl() {
        return courseImgUrl;
    }

    public void setCourseImgUrl(String courseImgUrl) {
        this.courseImgUrl = courseImgUrl == null ? null : courseImgUrl.trim();
    }

    public String getLabelId() {
        return labelId;
    }

    public void setLabelId(String labelId) {
        this.labelId = labelId == null ? null : labelId.trim();
    }

    public String getCoursePress() {
        return coursePress;
    }

    public void setCoursePress(String coursePress) {
        this.coursePress = coursePress == null ? null : coursePress.trim();
    }

    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName == null ? null : teacherName.trim();
    }

    public String getTeacherPosition() {
        return teacherPosition;
    }

    public void setTeacherPosition(String teacherPosition) {
        this.teacherPosition = teacherPosition == null ? null : teacherPosition.trim();
    }

    public String getTeacherImgUrl() {
        return teacherImgUrl;
    }

    public void setTeacherImgUrl(String teacherImgUrl) {
        this.teacherImgUrl = teacherImgUrl == null ? null : teacherImgUrl.trim();
    }

    public Boolean getDeleted() {
        return deleted;
    }

    public void setDeleted(Boolean deleted) {
        this.deleted = deleted;
    }

    public String getTeacherIntro() {
        return teacherIntro;
    }

    public void setTeacherIntro(String teacherIntro) {
        this.teacherIntro = teacherIntro == null ? null : teacherIntro.trim();
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg == null ? null : msg.trim();
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser == null ? null : createUser.trim();
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser == null ? null : updateUser.trim();
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Date getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Date updateDate) {
        this.updateDate = updateDate;
    }

	@Override
	public String toString() {
		return "YketCourse [courseId=" + courseId + ", courseName=" + courseName + ", courseImgUrl=" + courseImgUrl
				+ ", labelId=" + labelId + ", coursePress=" + coursePress + ", teacherName=" + teacherName
				+ ", teacherPosition=" + teacherPosition + ", teacherImgUrl=" + teacherImgUrl + ", deleted=" + deleted
				+ ", teacherIntro=" + teacherIntro + ", msg=" + msg + ", createUser=" + createUser + ", updateUser="
				+ updateUser + ", createDate=" + createDate + ", updateDate=" + updateDate + "]";
	}
    
}