package com.culturecloud.model.bean.beautycity;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="ccp_beautycity_vote")
public class CcpBeautycityVote implements BaseEntity {
    
	private static final long serialVersionUID = 1641377148768461169L;

	@Id
	@Column(name="BEAUTYCITY_VOTE_ID")
	private String beautycityVoteId;

	@Column(name="BEAUTYCITY_IMG_ID")
    private String beautycityImgId;

	@Column(name="USER_ID")
    private String userId;

	@Column(name="CREATE_TIME")
    private Date createTime;

    public String getBeautycityVoteId() {
        return beautycityVoteId;
    }

    public void setBeautycityVoteId(String beautycityVoteId) {
        this.beautycityVoteId = beautycityVoteId == null ? null : beautycityVoteId.trim();
    }

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

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}