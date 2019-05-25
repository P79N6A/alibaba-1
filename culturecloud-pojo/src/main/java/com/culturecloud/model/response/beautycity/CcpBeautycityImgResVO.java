package com.culturecloud.model.response.beautycity;

import com.culturecloud.model.bean.beautycity.CcpBeautycityImg;

public class CcpBeautycityImgResVO extends CcpBeautycityImg{
	
	private static final long serialVersionUID = 1611745065491595095L;

	private Integer beautycityImgIsVote;		//是否投票
	
	private Integer voteCount;		//总投票数
	
	private String userHeadImgUrl;		//头像
	
	private String userName;		//用户名
	
	private String venueName;		//场馆名
	
	private Integer ranking;		//排名

	public Integer getBeautycityImgIsVote() {
		return beautycityImgIsVote;
	}

	public void setBeautycityImgIsVote(Integer beautycityImgIsVote) {
		this.beautycityImgIsVote = beautycityImgIsVote;
	}

	public Integer getVoteCount() {
		return voteCount;
	}

	public void setVoteCount(Integer voteCount) {
		this.voteCount = voteCount;
	}

	public String getUserHeadImgUrl() {
		return userHeadImgUrl;
	}

	public void setUserHeadImgUrl(String userHeadImgUrl) {
		this.userHeadImgUrl = userHeadImgUrl;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public Integer getRanking() {
		return ranking;
	}

	public void setRanking(Integer ranking) {
		this.ranking = ranking;
	}

	public String getVenueName() {
		return venueName;
	}

	public void setVenueName(String venueName) {
		this.venueName = venueName;
	}

}