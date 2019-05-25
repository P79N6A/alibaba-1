package com.culturecloud.dao.dto.vote;

import com.culturecloud.model.bean.vote.CcpVoteItem;

public class CcpVoteItemDto extends CcpVoteItem{

	
	private Integer isVote;
	
	private Integer voteCount;

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
	
	
}
