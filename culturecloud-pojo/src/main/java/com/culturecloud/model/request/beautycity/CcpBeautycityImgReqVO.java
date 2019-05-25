package com.culturecloud.model.request.beautycity;

import java.util.Date;

import com.culturecloud.bean.BasePageRequest;

public class CcpBeautycityImgReqVO extends BasePageRequest{
    private String beautycityImgId;

    private String userId;

    private String beautycityImgUrl;

    private String beautycityVenueId;

    private Date createTime;
    
    private Integer isMe = 0;		//1:筛选自己上传的图片

    public String getBeautycityImgId() {
        return beautycityImgId;
    }

    public void setBeautycityImgId(String beautycityImgId) {
        this.beautycityImgId = beautycityImgId == null ? null : beautycityImgId.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getBeautycityImgUrl() {
        return beautycityImgUrl;
    }

    public void setBeautycityImgUrl(String beautycityImgUrl) {
        this.beautycityImgUrl = beautycityImgUrl == null ? null : beautycityImgUrl.trim();
    }

    public String getBeautycityVenueId() {
		return beautycityVenueId;
	}

	public void setBeautycityVenueId(String beautycityVenueId) {
		this.beautycityVenueId = beautycityVenueId;
	}

	public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

	public Integer getIsMe() {
		return isMe;
	}

	public void setIsMe(Integer isMe) {
		this.isMe = isMe;
	}
    
}