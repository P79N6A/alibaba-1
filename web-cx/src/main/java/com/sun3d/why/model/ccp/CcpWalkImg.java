package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpWalkImg {
    private String walkImgId;

    private String userId;

    private String walkImgName;
    
    private String walkImgUrl;
    
    private String walkImgContent;
    
    private String walkImgTime;
    
    private String walkImgSite;

    private Integer walkStatus;

    private Date createTime;
    
	//虚拟属性
    private Integer isMe = 0;		//1:筛选自己上传的图片
    
    private Integer isVoteSort = 0;		//1:根据投票数排序
    
    private Integer isVote;		//0：今日未投票；1：今日已投票
    
    private Integer voteCount;	//投票数
    
    private Integer rows = 20;
	
	private Integer firstResult;
	
	private String userName;
	
	private String userHeadImgUrl;
	
	private String walkImgIds;
	
	private Integer ranking;
	
	public CcpWalkImg() {
		super();
	}

	public CcpWalkImg(String walkImgId) {
		super();
		this.walkImgId = walkImgId;
	}
	
	public Integer getWalkStatus() {
		return walkStatus;
	}

	public void setWalkStatus(Integer walkStatus) {
		this.walkStatus = walkStatus;
	}
	
    public String getWalkImgId() {
        return walkImgId;
    }

    public void setWalkImgId(String walkImgId) {
        this.walkImgId = walkImgId == null ? null : walkImgId.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getWalkImgUrl() {
        return walkImgUrl;
    }

    public void setWalkImgUrl(String walkImgUrl) {
        this.walkImgUrl = walkImgUrl == null ? null : walkImgUrl.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
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

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserHeadImgUrl() {
		return userHeadImgUrl;
	}

	public void setUserHeadImgUrl(String userHeadImgUrl) {
		this.userHeadImgUrl = userHeadImgUrl;
	}

	public String getWalkImgContent() {
		return walkImgContent;
	}

	public void setWalkImgContent(String walkImgContent) {
		this.walkImgContent = walkImgContent;
	}

	public Integer getIsMe() {
		return isMe;
	}

	public void setIsMe(Integer isMe) {
		this.isMe = isMe;
	}

	public Integer getIsVoteSort() {
		return isVoteSort;
	}

	public void setIsVoteSort(Integer isVoteSort) {
		this.isVoteSort = isVoteSort;
	}

	public String getWalkImgIds() {
		return walkImgIds;
	}

	public void setWalkImgIds(String walkImgIds) {
		this.walkImgIds = walkImgIds;
	}

	public Integer getRanking() {
		return ranking;
	}

	public void setRanking(Integer ranking) {
		this.ranking = ranking;
	}

	public String getWalkImgName() {
		return walkImgName;
	}

	public void setWalkImgName(String walkImgName) {
		this.walkImgName = walkImgName;
	}

	public String getWalkImgTime() {
		return walkImgTime;
	}

	public void setWalkImgTime(String walkImgTime) {
		this.walkImgTime = walkImgTime;
	}

	public String getWalkImgSite() {
		return walkImgSite;
	}

	public void setWalkImgSite(String walkImgSite) {
		this.walkImgSite = walkImgSite;
	}
	
}