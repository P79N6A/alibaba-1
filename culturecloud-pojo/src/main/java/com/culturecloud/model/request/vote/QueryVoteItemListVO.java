package com.culturecloud.model.request.vote;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BasePageRequest;

public class QueryVoteItemListVO extends BasePageRequest{

	@NotNull(message = "投票项目ID不能为空")
	private String voteId;
	
	private String userId;
	
	//1：时间降序；2：投票数降序
	@NotNull(message = "排序不能为空")
	private Integer sort;
	
	private String voteItemId;

	public String getVoteId() {
		return voteId;
	}

	public void setVoteId(String voteId) {
		this.voteId = voteId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}

	public String getVoteItemId() {
		return voteItemId;
	}

	public void setVoteItemId(String voteItemId) {
		this.voteItemId = voteItemId;
	}
	
	
}
