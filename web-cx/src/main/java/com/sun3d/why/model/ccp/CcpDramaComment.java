package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpDramaComment {
    private String dramaCommentId;

    private String dramaId;

    private String userId;

    private String dramaCommentRemark;

    private Integer dramaStatus;

    private Date createTime;

    private Date updateTime;
    
    //虚拟属性
	private Integer rows = 20;
	
	private Integer firstResult;
	
	private String userName;
	
	private String userHeadImgUrl;
	
	private String dramaName;

    public String getDramaCommentId() {
        return dramaCommentId;
    }

    public void setDramaCommentId(String dramaCommentId) {
        this.dramaCommentId = dramaCommentId == null ? null : dramaCommentId.trim();
    }

    public String getDramaId() {
        return dramaId;
    }

    public void setDramaId(String dramaId) {
        this.dramaId = dramaId == null ? null : dramaId.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getDramaCommentRemark() {
        return dramaCommentRemark;
    }

    public void setDramaCommentRemark(String dramaCommentRemark) {
        this.dramaCommentRemark = dramaCommentRemark == null ? null : dramaCommentRemark.trim();
    }

    public Integer getDramaStatus() {
        return dramaStatus;
    }

    public void setDramaStatus(Integer dramaStatus) {
        this.dramaStatus = dramaStatus;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
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

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserHeadImgUrl() {
		return userHeadImgUrl;
	}

	public void setUserHeadImgUrl(String userHeadImgUrl) {
		this.userHeadImgUrl = userHeadImgUrl;
	}

	public String getDramaName() {
		return dramaName;
	}

	public void setDramaName(String dramaName) {
		this.dramaName = dramaName;
	}

}