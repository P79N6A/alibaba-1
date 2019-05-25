package com.sun3d.why.dao.dto;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.culturecloud.model.bean.special.CcpSpecialCustomer;

public class CcpSpecialCustomerDto extends CcpSpecialCustomer{

	private String projectName;
	
	private String enterName;
	
	private String pageName;
	
	private String enterLogoImageUrl;
	
	private String enterParamePath;
	
	private String customerCreateUserName;
	
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date ycodeStartTime;
	
	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm")
	private Date ycodeEndTime;

	public String getProjectName() {
		return projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}

	public String getEnterName() {
		return enterName;
	}

	public void setEnterName(String enterName) {
		this.enterName = enterName;
	}

	public String getPageName() {
		return pageName;
	}

	public void setPageName(String pageName) {
		this.pageName = pageName;
	}

	public String getEnterParamePath() {
		return enterParamePath;
	}

	public void setEnterParamePath(String enterParamePath) {
		this.enterParamePath = enterParamePath;
	}

	public String getCustomerCreateUserName() {
		return customerCreateUserName;
	}

	public void setCustomerCreateUserName(String customerCreateUserName) {
		this.customerCreateUserName = customerCreateUserName;
	}

	public Date getYcodeStartTime() {
		return ycodeStartTime;
	}

	public void setYcodeStartTime(Date ycodeStartTime) {
		this.ycodeStartTime = ycodeStartTime;
	}

	public Date getYcodeEndTime() {
		return ycodeEndTime;
	}

	public void setYcodeEndTime(Date ycodeEndTime) {
		this.ycodeEndTime = ycodeEndTime;
	}

	public String getEnterLogoImageUrl() {
		return enterLogoImageUrl;
	}

	public void setEnterLogoImageUrl(String enterLogoImageUrl) {
		this.enterLogoImageUrl = enterLogoImageUrl;
	}
	
  	
	
}
