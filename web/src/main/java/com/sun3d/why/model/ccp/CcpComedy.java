package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpComedy {
    private String userId;

    private String userName;

    private String userMobile;

    private String comedyUrl;
    
    private Integer comedyCode;

    private Date createTime;
    
    //虚拟属性
    private String tuserName;
    
    private String userHeadImgUrl;
    
    private Integer rows = 20;
	
	private Integer firstResult;

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

    public String getComedyUrl() {
        return comedyUrl;
    }

    public void setComedyUrl(String comedyUrl) {
        this.comedyUrl = comedyUrl == null ? null : comedyUrl.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

	public Integer getComedyCode() {
		return comedyCode;
	}

	public void setComedyCode(Integer comedyCode) {
		this.comedyCode = comedyCode;
	}

	public String getTuserName() {
		return tuserName;
	}

	public void setTuserName(String tuserName) {
		this.tuserName = tuserName;
	}

	public String getUserHeadImgUrl() {
		return userHeadImgUrl;
	}

	public void setUserHeadImgUrl(String userHeadImgUrl) {
		this.userHeadImgUrl = userHeadImgUrl;
	}

	public Integer getRows() {
		return rows;
	}

	public void setRows(Integer rows) {
		this.rows = rows;
	}

	public Integer getFirstResult() {
		return firstResult;
	}

	public void setFirstResult(Integer firstResult) {
		this.firstResult = firstResult;
	}

}