package com.sun3d.why.model;

import java.util.Date;

public class BpInfoTag {
	private String tagId;
	private String tagName;
	private String tagParentId;
	private Integer tagState;
	private String tagCreateUser;
	private String tagUpdateUser;
	private Date tagCreateTime;
	private Date tagUpdateTime;
	private Integer tagAmount;
	private String userAccount;
	private String tagCode;

	/**
	 * 所属模块：WHZX,文化资讯;YSJS,艺术鉴赏;PTCC:评弹传承;PPWH:品牌文化
	 */
	private String module;

	public String getModule() {
		return module;
	}

	public void setModule(String module) {
		this.module = module;
	}

	public String getTagCode() {
		return tagCode;
	}

	public void setTagCode(String tagCode) {
		this.tagCode = tagCode;
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
}