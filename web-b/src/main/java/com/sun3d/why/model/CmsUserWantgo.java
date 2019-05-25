package com.sun3d.why.model;

import java.io.Serializable;
import java.util.Date;

import com.sun3d.why.util.Pagination;

public class CmsUserWantgo extends Pagination implements Serializable {
    private String sid;
    
    private String userId;
    
    private String relateId;

	private Integer relateType;
    
    private String userName;

    private Date createTime;
    
    private Integer userSex;
    
    private Date userBirth;
    
    private String userHeadImgUrl;

	public String getSid() {
		return sid;
	}

	public void setSid(String sid) {
		this.sid = sid;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getRelateId() {
		return relateId;
	}

	public void setRelateId(String relateId) {
		this.relateId = relateId;
	}

	public Integer getRelateType() {
		return relateType;
	}

	public void setRelateType(Integer relateType) {
		this.relateType = relateType;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Integer getUserSex() {
		return userSex;
	}

	public void setUserSex(Integer userSex) {
		this.userSex = userSex;
	}

	public Date getUserBirth() {
		return userBirth;
	}

	public void setUserBirth(Date userBirth) {
		this.userBirth = userBirth;
	}

	public String getUserHeadImgUrl() {
		return userHeadImgUrl;
	}

	public void setUserHeadImgUrl(String userHeadImgUrl) {
		this.userHeadImgUrl = userHeadImgUrl;
	}
	
    
}