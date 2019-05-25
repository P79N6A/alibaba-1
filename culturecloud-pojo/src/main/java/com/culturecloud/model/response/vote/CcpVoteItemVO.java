package com.culturecloud.model.response.vote;

import com.culturecloud.model.bean.vote.CcpVoteItem;

public class CcpVoteItemVO extends CcpVoteItem {
	
	private static final long serialVersionUID = 42824132937857292L;

	private Integer isVote;

	private Integer voteCount;
	
	private Integer number;

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

	public Integer getNumber() {
		return number;
	}

	public void setNumber(Integer number) {
		this.number = number;
	}

	
	
}
