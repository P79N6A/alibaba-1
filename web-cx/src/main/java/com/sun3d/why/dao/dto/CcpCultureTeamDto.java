package com.sun3d.why.dao.dto;

import com.sun3d.why.model.ccp.CcpCultureTeam;

public class CcpCultureTeamDto extends CcpCultureTeam{

    private Integer isVote;		//0：今日未投票；1：今日已投票
    
    private Integer voteCount;	//投票数
    
    private Integer reviewType; //6:H5也首页,7:排名页
    
    private String  userId;     //用户Id
    
    public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Integer getIsVote() {
		return isVote;
	}

	public void setIsVote(Integer isVote) {
		this.isVote = isVote;
	}

	public Integer getVoteCount() {
		return voteCount;
	}

	public void setVoteCount(Integer voteCount) {
		this.voteCount = voteCount;
	}
	
	public Integer getReviewType() {
		return reviewType;
	}

	public void setReviewType(Integer reviewType) {
		this.reviewType = reviewType;
	}
	
	
}
