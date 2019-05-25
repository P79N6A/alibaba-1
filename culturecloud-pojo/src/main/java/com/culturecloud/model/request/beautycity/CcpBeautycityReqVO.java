package com.culturecloud.model.request.beautycity;

import java.util.Date;

import com.culturecloud.bean.BasePageRequest;

public class CcpBeautycityReqVO extends BasePageRequest{
    private String beautycityId;

    private String userId;

    private String userName;

    private String userMobile;
    
    private String finishVenueRanking;

    private Date createTime;
    
    public CcpBeautycityReqVO() {
		super();
	}

	public CcpBeautycityReqVO(String userId) {
		super();
		this.userId = userId;
	}

	public String getBeautycityId() {
        return beautycityId;
    }

    public void setBeautycityId(String beautycityId) {
        this.beautycityId = beautycityId == null ? null : beautycityId.trim();
    }

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

	public String getFinishVenueRanking() {
		return finishVenueRanking;
	}

	public void setFinishVenueRanking(String finishVenueRanking) {
		this.finishVenueRanking = finishVenueRanking;
	}

}