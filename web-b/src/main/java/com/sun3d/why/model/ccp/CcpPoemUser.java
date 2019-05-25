package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpPoemUser {
    private String userId;

    private String poemId;

    private Date createTime;
    
    //虚拟属性
    private Date firstCompleteTime;	//首次完成答题时间
    
    private Integer poemCompleteCount;	//用户已完成的题目总数
    
    private String userName;
    
    private String userMobile;

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

	public Integer getPoemCompleteCount() {
		return poemCompleteCount;
	}

	public void setPoemCompleteCount(Integer poemCompleteCount) {
		this.poemCompleteCount = poemCompleteCount;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public Date getFirstCompleteTime() {
		return firstCompleteTime;
	}

	public void setFirstCompleteTime(Date firstCompleteTime) {
		this.firstCompleteTime = firstCompleteTime;
	}

	public String getUserMobile() {
		return userMobile;
	}

	public void setUserMobile(String userMobile) {
		this.userMobile = userMobile;
	}
	
}