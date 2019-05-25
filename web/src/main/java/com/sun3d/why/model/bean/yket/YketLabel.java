package com.sun3d.why.model.bean.yket;

import java.util.Date;

public class YketLabel {
    private String labelId;

    private String labelName;

    private Integer courseNumber;

    private Boolean deleted;

    private Integer sort;

    private Integer labelType;

    private String msg;

    private String createUser;

    private String updateUser;

    private Date createDate;

    private Date updateDate;

    public String getLabelId() {
        return labelId;
    }

    public void setLabelId(String labelId) {
        this.labelId = labelId == null ? null : labelId.trim();
    }

    public String getLabelName() {
        return labelName;
    }

    public void setLabelName(String labelName) {
        this.labelName = labelName == null ? null : labelName.trim();
    }

    public Integer getCourseNumber() {
        return courseNumber;
    }

    public void setCourseNumber(Integer courseNumber) {
        this.courseNumber = courseNumber;
    }

    public Boolean getDeleted() {
        return deleted;
    }

    public void setDeleted(Boolean deleted) {
        this.deleted = deleted;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    public Integer getLabelType() {
        return labelType;
    }

    public void setLabelType(Integer labelType) {
        this.labelType = labelType;
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
		return "YketLabel [labelId=" + labelId + ", labelName=" + labelName + ", courseNumber=" + courseNumber
				+ ", deleted=" + deleted + ", sort=" + sort + ", labelType=" + labelType + ", msg=" + msg
				+ ", createUser=" + createUser + ", updateUser=" + updateUser + ", createDate=" + createDate
				+ ", updateDate=" + updateDate + "]";
	}
    
    
}