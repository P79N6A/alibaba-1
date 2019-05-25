package com.culturecloud.model.bean.wrpx;

import java.io.Serializable;
import java.util.Date;

/***
 * @author Administrator
 */
public class WrpxBatch implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -4186041145717919794L;

	private String batchId;

	private String year;

	private String title;

	private Date startDate;

	private Date endDate;

	private String createuser;

	private String updateuser;

	private Date createDate;

	private Date updateDate;

	private String notice;

	private Boolean deleted;

	public String getBatchId() {
		return batchId;
	}

	public void setBatchId(String batchId) {
		this.batchId = batchId == null ? null : batchId.trim();
	}

	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year == null ? null : year.trim();
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title == null ? null : title.trim();
	}

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public String getCreateuser() {
		return createuser;
	}

	public void setCreateuser(String createuser) {
		this.createuser = createuser == null ? null : createuser.trim();
	}

	public String getUpdateuser() {
		return updateuser;
	}

	public void setUpdateuser(String updateuser) {
		this.updateuser = updateuser == null ? null : updateuser.trim();
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

	public String getNotice() {
		return notice;
	}

	public void setNotice(String notice) {
		this.notice = notice == null ? null : notice.trim();
	}

	public Boolean getDeleted() {
		return deleted;
	}

	public void setDeleted(Boolean deleted) {
		this.deleted = deleted;
	}

	@Override
	public String toString() {
		return "WrpxBatch [batchId=" + batchId + ", year=" + year + ", title=" + title + ", startDate=" + startDate
				+ ", endDate=" + endDate + ", createuser=" + createuser + ", updateuser=" + updateuser + ", createDate="
				+ createDate + ", updateDate=" + updateDate + ", notice=" + notice + ", deleted=" + deleted + "]";
	}

}