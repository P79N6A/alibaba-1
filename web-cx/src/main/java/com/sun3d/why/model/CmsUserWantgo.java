package com.sun3d.why.model;

import java.io.Serializable;
import java.util.Date;

import com.sun3d.why.util.Pagination;

public class CmsUserWantgo extends Pagination implements Serializable {
    private String sid;
    
    private String userId;
    
    private String relateId;

	private Integer relateType;	//1-场馆 2-活动 3-采编 4-非遗 5-藏品 6-艺术培训 7-专题活动(城市名片、我在现场、文化新年、行走故事)8-通知 9-直播 10-重大品牌活动
    
    private String userName;

    private Date createTime;
    
    private Integer userSex;
    
    private Date userBirth;
    
    private String userHeadImgUrl;
    
	public CmsUserWantgo() {
		super();
	}

	public CmsUserWantgo(String userId, String relateId) {
		super();
		this.userId = userId;
		this.relateId = relateId;
	}

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