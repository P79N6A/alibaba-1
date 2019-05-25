package com.culturecloud.dao.dto.openrs;

import java.util.Date;

public class BpInfoTagOpenDTO {
	private String tagId;
	private String tagName;
	private String tagCode;
	private String tagParentId;
	private Integer tagState;
	private String tagCreateUser;
	private String tagUpdateUser;
	private Date tagCreateTime;
	private Date tagUpdateTime;
	private Integer tagAmount;
	private String userAccount;
	public String getTagId() {
		return tagId;
	}
	public void setTagId(String tagId) {
		this.tagId = tagId;
	}
	public String getTagName() {
		return tagName;
	}
	public void setTagName(String tagName) {
		this.tagName = tagName;
	}
	public String getTagCode() {
		return tagCode;
	}
	public void setTagCode(String tagCode) {
		this.tagCode = tagCode;
	}
	public String getTagParentId() {
		return tagParentId;
	}
	public void setTagParentId(String tagParentId) {
		this.tagParentId = tagParentId;
	}
	public Integer getTagState() {
		return tagState;
	}
	public void setTagState(Integer tagState) {
		this.tagState = tagState;
	}
	public String getTagCreateUser() {
		return tagCreateUser;
	}
	public void setTagCreateUser(String tagCreateUser) {
		this.tagCreateUser = tagCreateUser;
	}
	public String getTagUpdateUser() {
		return tagUpdateUser;
	}
	public void setTagUpdateUser(String tagUpdateUser) {
		this.tagUpdateUser = tagUpdateUser;
	}
	public Date getTagCreateTime() {
		return tagCreateTime;
	}
	public void setTagCreateTime(Date tagCreateTime) {
		this.tagCreateTime = tagCreateTime;
	}
	public Date getTagUpdateTime() {
		return tagUpdateTime;
	}
	public void setTagUpdateTime(Date tagUpdateTime) {
		this.tagUpdateTime = tagUpdateTime;
	}
	public Integer getTagAmount() {
		return tagAmount;
	}
	public void setTagAmount(Integer tagAmount) {
		this.tagAmount = tagAmount;
	}
	public String getUserAccount() {
		return userAccount;
	}
	public void setUserAccount(String userAccount) {
		this.userAccount = userAccount;
	}
	
	
}
