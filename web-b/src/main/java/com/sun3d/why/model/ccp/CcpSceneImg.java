package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpSceneImg {
    private String sceneImgId;

    private String userId;

    private String sceneImgUrl;
    
    private String sceneImgVenueId;
    
    private String sceneImgContent;
    
    private Integer sceneStatus;//审核状态

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
	
	private String sceneImgIds;
	
	private Integer ranking;
	
	private String userRealName;
	
	private String userMobile;
	
	
	public CcpSceneImg() {
		super();
	}

	public CcpSceneImg(String sceneImgId) {
		super();
		this.sceneImgId = sceneImgId;
	}

	public String getSceneImgId() {
        return sceneImgId;
    }

    public void setSceneImgId(String sceneImgId) {
        this.sceneImgId = sceneImgId == null ? null : sceneImgId.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getSceneImgUrl() {
        return sceneImgUrl;
    }

    public void setSceneImgUrl(String sceneImgUrl) {
        this.sceneImgUrl = sceneImgUrl == null ? null : sceneImgUrl.trim();
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

	public String getSceneImgContent() {
		return sceneImgContent;
	}

	public void setSceneImgContent(String sceneImgContent) {
		this.sceneImgContent = sceneImgContent;
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

	public String getSceneImgIds() {
		return sceneImgIds;
	}

	public void setSceneImgIds(String sceneImgIds) {
		this.sceneImgIds = sceneImgIds;
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

	public String getSceneImgVenueId() {
		return sceneImgVenueId;
	}

	public void setSceneImgVenueId(String sceneImgVenueId) {
		this.sceneImgVenueId = sceneImgVenueId;
	}
	
	public Integer getSceneStatus() {
		return sceneStatus;
	}

	public void setSceneStatus(Integer sceneStatus) {
		this.sceneStatus = sceneStatus;
	}
}