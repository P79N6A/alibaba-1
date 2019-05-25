package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpWalkUser {

    private String userId;

    private String userName;

    private String userMobile;
    
    private Integer userMaxVote;
    
    private String userMaxImg;

    private Date createTime;
    
    //虚拟属性
    private String walkImgUrl;
    
    private String walkImgContent;
    
    private String userNickName;
	
	private String userHeadImgUrl;
	
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName == null ? null : userName.trim();
    }

    public String getUserMobile() {
        return userMobile;
    }

    public void setUserMobile(String userMobile) {
        this.userMobile = userMobile == null ? null : userMobile.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

	public Integer getUserMaxVote() {
		return userMaxVote;
	}

	public void setUserMaxVote(Integer userMaxVote) {
		this.userMaxVote = userMaxVote;
	}

	public String getUserMaxImg() {
		return userMaxImg;
	}

	public void setUserMaxImg(String userMaxImg) {
		this.userMaxImg = userMaxImg;
	}

	public String getWalkImgUrl() {
		return walkImgUrl;
	}

	public void setWalkImgUrl(String walkImgUrl) {
		this.walkImgUrl = walkImgUrl;
	}

	public String getWalkImgContent() {
		return walkImgContent;
	}

	public void setWalkImgContent(String walkImgContent) {
		this.walkImgContent = walkImgContent;
	}

	public String getUserNickName() {
		return userNickName;
	}

	public void setUserNickName(String userNickName) {
		this.userNickName = userNickName;
	}

	public String getUserHeadImgUrl() {
		return userHeadImgUrl;
	}

	public void setUserHeadImgUrl(String userHeadImgUrl) {
		this.userHeadImgUrl = userHeadImgUrl;
	}

}