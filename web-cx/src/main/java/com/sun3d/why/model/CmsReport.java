package com.sun3d.why.model;

import java.util.Date;

public class CmsReport {

    private String reportId;	
    
    private String reportType;	//举报类型(关联SYS_DICT表)
    
    private String reportActivityId;	//被举报活动ID
    
    private String reportContent;	//举报内容(其它选项中所填写文本)
    
    private String reportUserId;	//前端举报用户ID
    
    private Date reportTime;	//举报时间
    
    private String reportTypeName;	//举报类型名称
    
    private String activityName;
    private String userMobileNo;
    private String userName;
    
    
	public String getReportId() {
		return reportId;
	}

	public void setReportId(String reportId) {
		this.reportId = reportId;
	}

	public String getReportType() {
		return reportType;
	}

	public void setReportType(String reportType) {
		this.reportType = reportType;
	}

	public String getReportActivityId() {
		return reportActivityId;
	}

	public void setReportActivityId(String reportActivityId) {
		this.reportActivityId = reportActivityId;
	}

	public String getReportContent() {
		return reportContent;
	}

	public void setReportContent(String reportContent) {
		this.reportContent = reportContent;
	}

	public String getReportUserId() {
		return reportUserId;
	}

	public void setReportUserId(String reportUserId) {
		this.reportUserId = reportUserId;
	}

	public Date getReportTime() {
		return reportTime;
	}

	public void setReportTime(Date reportTime) {
		this.reportTime = reportTime;
	}

	public String getActivityName() {
		return activityName;
	}

	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}

	public String getUserMobileNo() {
		return userMobileNo;
	}

	public void setUserMobileNo(String userMobileNo) {
		this.userMobileNo = userMobileNo;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getReportTypeName() {
		return reportTypeName;
	}

	public void setReportTypeName(String reportTypeName) {
		this.reportTypeName = reportTypeName;
	}
	
}