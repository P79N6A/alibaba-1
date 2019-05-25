package com.culturecloud.model.request.vote;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class CcpVoteDetailVO extends BaseRequest{

	@NotNull(message = "投票项目ID不能为空")
	private String voteId;

	public String getVoteId() {
		return voteId;
	}

	public void setVoteId(String voteId) {
		this.voteId = voteId;
	}
	
	
	
}
