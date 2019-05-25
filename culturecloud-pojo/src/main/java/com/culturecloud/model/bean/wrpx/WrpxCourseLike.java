package com.culturecloud.model.bean.wrpx;

import java.io.Serializable;
import java.util.Date;

public class WrpxCourseLike implements Serializable{
    /**
	 * 
	 */
	private static final long serialVersionUID = 2277077068710725230L;

	private String courseLikedId;

    private String wrpxUserId;

    private String wrpxCourseId;

    private Date createDate;

    private Boolean deleted;

    public String getCourseLikedId() {
        return courseLikedId;
    }

    public void setCourseLikedId(String courseLikedId) {
        this.courseLikedId = courseLikedId == null ? null : courseLikedId.trim();
    }

    public String getWrpxUserId() {
        return wrpxUserId;
    }

    public void setWrpxUserId(String wrpxUserId) {
        this.wrpxUserId = wrpxUserId == null ? null : wrpxUserId.trim();
    }

    public String getWrpxCourseId() {
        return wrpxCourseId;
    }

    public void setWrpxCourseId(String wrpxCourseId) {
        this.wrpxCourseId = wrpxCourseId == null ? null : wrpxCourseId.trim();
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Boolean getDeleted() {
        return deleted;
    }

    public void setDeleted(Boolean deleted) {
        this.deleted = deleted;
    }
}