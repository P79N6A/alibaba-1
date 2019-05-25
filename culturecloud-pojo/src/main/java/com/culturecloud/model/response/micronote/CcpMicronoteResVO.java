package com.culturecloud.model.response.micronote;

import com.culturecloud.model.bean.micronote.CcpMicronote;

public class CcpMicronoteResVO extends CcpMicronote{
	
	private static final long serialVersionUID = 195258104957723610L;

	private Integer noteIsVote;		//是否投票
		
	private Integer voteCount;		//总投票数
	
	private Integer ranking;	//排名
	
	private String userHeadImgUrl;		//头像
	
	public Integer getNoteIsVote() {
		return noteIsVote;
	}

	public void setNoteIsVote(Integer noteIsVote) {
		this.noteIsVote = noteIsVote;
	}

	public Integer getVoteCount() {
		return voteCount;
	}

	public void setVoteCount(Integer voteCount) {
		this.voteCount = voteCount;
	}

	public Integer getRanking() {
		return ranking;
	}

	public void setRanking(Integer ranking) {
		this.ranking = ranking;
	}

	public String getUserHeadImgUrl() {
		return userHeadImgUrl;
	}

	public void setUserHeadImgUrl(String userHeadImgUrl) {
		this.userHeadImgUrl = userHeadImgUrl;
	}
	
}