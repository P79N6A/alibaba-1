package com.sun3d.why.dao.dto;

import java.io.Serializable;

import com.sun3d.why.model.qyg.QygProjectEntry;

public class QygProjectEntryDto extends QygProjectEntry {

	//虚拟属性
    private Integer reviewType;	//(1：技术评审；2：海选评审；3：海选复审；4：专家评分；5：评分汇总；6：H5首页；7：H5排名)
    
    private Integer isVote;//0：今日未投票；1：今日已投票
    
    private Integer voteCount;	//投票数
    
    private String userId;
    
    private Integer searchType = 1;	//(1：作品名称；2：指导员；3：参演团队)
    
    private Integer rows = 20;
	
	private Integer firstResult;
	
	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Integer getReviewType() {
		return reviewType;
	}

	public void setReviewType(Integer reviewType) {
		this.reviewType = reviewType;
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

	public Integer getSearchType() {
		return searchType;
	}

	public void setSearchType(Integer searchType) {
		this.searchType = searchType;
	}

	public Integer getRows() {
		return rows;
	}

	public void setRows(Integer rows) {
		this.rows = rows;
	}

	public Integer getFirstResult() {
		return firstResult;
	}

	public void setFirstResult(Integer firstResult) {
		this.firstResult = firstResult;
	}
	
	
	
}
