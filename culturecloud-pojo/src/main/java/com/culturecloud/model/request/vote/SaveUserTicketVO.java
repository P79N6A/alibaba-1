package com.culturecloud.model.request.vote;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class SaveUserTicketVO  extends BaseRequest{

	@NotNull(message = "用户id不能为空")
	private String userId;
	
	@NotNull(message = "投票选项id不能为空")
	private String voteItemId;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getVoteItemId() {
		return voteItemId;
	}

	public void setVoteItemId(String voteItemId) {
		this.voteItemId = voteItemId;
	}
	
	
}
