package com.sun3d.why.model;

import java.util.Date;

public class UserIntegralDetail {

    private String integralDetailId;


    private String integralId;


    private Integer integralChange;


    private Date createTime;


    private Integer changeType;


    private String integralFrom;


    private Integer integralType;
    
    //虚拟属性
    private String [] userIds;
    
    private String userId;
    
    private Integer updateType;		//0：原明细不做修改；1：修改原明细


    public String getIntegralDetailId() {
        return integralDetailId;
    }


    public void setIntegralDetailId(String integralDetailId) {
        this.integralDetailId = integralDetailId;
    }


    public String getIntegralId() {
        return integralId;
    }


    public void setIntegralId(String integralId) {
        this.integralId = integralId;
    }


    public Integer getIntegralChange() {
        return integralChange;
    }


    public void setIntegralChange(Integer integralChange) {
        this.integralChange = integralChange;
    }


    public Date getCreateTime() {
        return createTime;
    }


    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }


    public Integer getChangeType() {
        return changeType;
    }


    public void setChangeType(Integer changeType) {
        this.changeType = changeType;
    }


    public String getIntegralFrom() {
        return integralFrom;
    }


    public void setIntegralFrom(String integralFrom) {
        this.integralFrom = integralFrom;
    }


    public Integer getIntegralType() {
        return integralType;
    }


    public void setIntegralType(Integer integralType) {
        this.integralType = integralType;
    }


	public String[] getUserIds() {
		return userIds;
	}


	public void setUserIds(String[] userIds) {
		this.userIds = userIds;
	}


	public String getUserId() {
		return userId;
	}


	public void setUserId(String userId) {
		this.userId = userId;
	}


	public Integer getUpdateType() {
		return updateType;
	}


	public void setUpdateType(Integer updateType) {
		this.updateType = updateType;
	}
    
}