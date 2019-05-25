package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpNyImg {
    private String nyImgId;

    private String userId;

    private String nyImgUrl;
    
    private String nyImgContent;

    private Date createTime;
    
    private Integer nyStatus;//审核状态，0：未审核；1：审核通过；2：审核不通过；
    
    //虚拟属性
    private Integer isMe = 0;		//1:筛选自己上传的图片
    
    private Integer isVoteSort = 0;		//1:根据投票数排序
    
    private Integer isVote;		//0：今日未投票；1：今日已投票
    
    private Integer voteCount;	//投票数
    
    private Integer rows = 20;
	
	private Integer firstResult;
	
	private String userName;
	
	private String userHeadImgUrl;
	
	private String nyImgIds;
	
	private Integer ranking;
	
	private String userRealName;
	
	private String userMobile;
	
	public CcpNyImg() {
		super();
	}

	public CcpNyImg(String nyImgId) {
		super();
		this.nyImgId = nyImgId;
	}
	
    public String getNyImgId() {
        return nyImgId;
    }

    public void setNyImgId(String nyImgId) {
        this.nyImgId = nyImgId == null ? null : nyImgId.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getNyImgUrl() {
        return nyImgUrl;
    }

    public void setNyImgUrl(String nyImgUrl) {
        this.nyImgUrl = nyImgUrl == null ? null : nyImgUrl.trim();
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

	public String getNyImgContent() {
		return nyImgContent;
	}

	public void setNyImgContent(String nyImgContent) {
		this.nyImgContent = nyImgContent;
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

	public String getNyImgIds() {
		return nyImgIds;
	}

	public void setNyImgIds(String nyImgIds) {
		this.nyImgIds = nyImgIds;
	}

	public Integer getRanking() {
		return ranking;
	}

	public void setRanking(Integer ranking) {
		this.ranking = ranking;
	}

	public String getUserRealName() {
		return userRealName;
	}

	public void setUserRealName(String userRealName) {
		this.userRealName = userRealName;
	}

	public String getUserMobile() {
		return userMobile;
	}

	public void setUserMobile(String userMobile) {
		this.userMobile = userMobile;
	}

	public Integer getNyStatus() {
		return nyStatus;
	}

	public void setNyStatus(Integer nyStatus) {
		this.nyStatus = nyStatus;
	}
	
	
	
}