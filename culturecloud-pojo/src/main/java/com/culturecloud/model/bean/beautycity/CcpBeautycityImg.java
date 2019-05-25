package com.culturecloud.model.bean.beautycity;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="ccp_beautycity_img")
public class CcpBeautycityImg implements BaseEntity {

	private static final long serialVersionUID = 6399594473968933439L;

	@Id
	@Column(name="BEAUTYCITY_IMG_ID")
	private String beautycityImgId;

	@Column(name="USER_ID")
    private String userId;

	@Column(name="BEAUTYCITY_IMG_URL")
    private String beautycityImgUrl;

	@Column(name="BEAUTYCITY_VENUE_ID")
    private String beautycityVenueId;

	@Column(name="CREATE_TIME")
    private Date createTime;

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
}