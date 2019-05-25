package com.culturecloud.model.bean.beautycity;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="ccp_beautycity")
public class CcpBeautycity implements BaseEntity{
    
	private static final long serialVersionUID = -8399608457419781428L;

	@Id
	@Column(name="BEAUTYCITY_ID")
	private String beautycityId;

	@Column(name="USER_ID")
    private String userId;

	@Column(name="USER_NAME")
    private String userName;

	@Column(name="USER_MOBILE")
    private String userMobile;
	
	@Column(name="FINISH_VENUE_RANKING")
    private String finishVenueRanking;

	@Column(name="CREATE_TIME")
    private Date createTime;

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