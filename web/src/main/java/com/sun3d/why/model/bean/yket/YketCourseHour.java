package com.sun3d.why.model.bean.yket;

import java.util.Date;

public class YketCourseHour {
    private String hourId;

    private String hourName;

    private String courseId;

    private String courseDuration;

    private Integer sort;

    private Boolean deleted;

    private String videoUrl;

    private String msg;

    private String createUser;

    private String updateUser;

    private Date createDate;

    private Date updateDate;

    public String getHourId() {
        return hourId;
    }

    public void setHourId(String hourId) {
        this.hourId = hourId == null ? null : hourId.trim();
    }

    public String getHourName() {
        return hourName;
    }

    public void setHourName(String hourName) {
        this.hourName = hourName == null ? null : hourName.trim();
    }

    public String getCourseId() {
        return courseId;
    }

    public void setCourseId(String courseId) {
        this.courseId = courseId == null ? null : courseId.trim();
    }

    public String getCourseDuration() {
        return courseDuration;
    }

    public void setCourseDuration(String courseDuration) {
        this.courseDuration = courseDuration;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    public Boolean getDeleted() {
        return deleted;
    }

    public void setDeleted(Boolean deleted) {
        this.deleted = deleted;
    }

    public String getVideoUrl() {
        return videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl == null ? null : videoUrl.trim();
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
		return "YketCourseHour [hourId=" + hourId + ", hourName=" + hourName + ", courseId=" + courseId
				+ ", courseDuration=" + courseDuration + ", sort=" + sort + ", deleted=" + deleted + ", videoUrl="
				+ videoUrl + ", msg=" + msg + ", createUser=" + createUser + ", updateUser=" + updateUser
				+ ", createDate=" + createDate + ", updateDate=" + updateDate + "]";
	}
    
}