package com.sun3d.why.model.bean.yket;

import java.util.Date;

public class YketTeacherInfo {
    private String teacherId;
    
    @Deprecated
    private String courseId;

    private String teacherName;

    private String teacherTitle;

    private String teacherIntro;

    private String teacherHeaderImg;

    private Date createTime;

    private String createUser;

    private Date updateTime;

    private String updateUser;

    private Boolean deleted;

    public String getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(String teacherId) {
        this.teacherId = teacherId == null ? null : teacherId.trim();
    }

    public String getCourseId() {
        return courseId;
    }

    public void setCourseId(String courseId) {
        this.courseId = courseId == null ? null : courseId.trim();
    }

   

    public String getTeacherName() {
		return teacherName;
	}

	public void setTeacherName(String teacherName) {
		this.teacherName = teacherName;
	}

	public String getTeacherTitle() {
        return teacherTitle;
    }

    public void setTeacherTitle(String teacherTitle) {
        this.teacherTitle = teacherTitle == null ? null : teacherTitle.trim();
    }

    public String getTeacherIntro() {
        return teacherIntro;
    }

    public void setTeacherIntro(String teacherIntro) {
        this.teacherIntro = teacherIntro == null ? null : teacherIntro.trim();
    }

    public String getTeacherHeaderImg() {
        return teacherHeaderImg;
    }

    public void setTeacherHeaderImg(String teacherHeaderImg) {
        this.teacherHeaderImg = teacherHeaderImg == null ? null : teacherHeaderImg.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser == null ? null : createUser.trim();
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser == null ? null : updateUser.trim();
    }

    public Boolean getDeleted() {
        return deleted;
    }

    public void setDeleted(Boolean deleted) {
        this.deleted = deleted;
    }

	@Override
	public String toString() {
		return "yketTeacherInfo [teacherId=" + teacherId + ", courseId=" + courseId + ", treacherName=" + teacherName
				+ ", teacherTitle=" + teacherTitle + ", teacherIntro=" + teacherIntro + ", teacherHeaderImg="
				+ teacherHeaderImg + ", createTime=" + createTime + ", createUser=" + createUser + ", updateTime="
				+ updateTime + ", updateUser=" + updateUser + ", deleted=" + deleted + "]";
	}
    
}