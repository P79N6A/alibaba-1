package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpDrama {
    private String dramaId;

    private String dramaName;

    private String dramaImg;

    private String dramaTag;

    private String dramaTime;

    private String dramaAddress;

    private String dramaIntro;

    private Date createTime;
    
    //虚拟属性
    private Integer sort;	//1：时间降序；2：投票数降序；3：评论数降序
    
    private Integer isVote;		//0：今日未投票；1：今日已投票
    
    private Integer voteCount;	//投票数
    
    private Integer commentCount;	//评论数
    
    private String userId;

    public String getDramaId() {
        return dramaId;
    }

    public void setDramaId(String dramaId) {
        this.dramaId = dramaId == null ? null : dramaId.trim();
    }

    public String getDramaName() {
        return dramaName;
    }

    public void setDramaName(String dramaName) {
        this.dramaName = dramaName == null ? null : dramaName.trim();
    }

    public String getDramaImg() {
        return dramaImg;
    }

    public void setDramaImg(String dramaImg) {
        this.dramaImg = dramaImg == null ? null : dramaImg.trim();
    }

    public String getDramaTag() {
        return dramaTag;
    }

    public void setDramaTag(String dramaTag) {
        this.dramaTag = dramaTag == null ? null : dramaTag.trim();
    }

    public String getDramaTime() {
        return dramaTime;
    }

    public void setDramaTime(String dramaTime) {
        this.dramaTime = dramaTime == null ? null : dramaTime.trim();
    }

    public String getDramaAddress() {
        return dramaAddress;
    }

    public void setDramaAddress(String dramaAddress) {
        this.dramaAddress = dramaAddress == null ? null : dramaAddress.trim();
    }

    public String getDramaIntro() {
        return dramaIntro;
    }

    public void setDramaIntro(String dramaIntro) {
        this.dramaIntro = dramaIntro == null ? null : dramaIntro.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
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

	public Integer getCommentCount() {
		return commentCount;
	}

	public void setCommentCount(Integer commentCount) {
		this.commentCount = commentCount;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}
	
}