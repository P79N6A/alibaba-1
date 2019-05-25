package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpPoemUser {
    private String userId;

    private String poemId;

    private Date createTime;
    
    public CcpPoemUser() {
		super();
	}

	public CcpPoemUser(String userId) {
		super();
		this.userId = userId;
	}

	public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getPoemId() {
        return poemId;
    }

    public void setPoemId(String poemId) {
        this.poemId = poemId == null ? null : poemId.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}