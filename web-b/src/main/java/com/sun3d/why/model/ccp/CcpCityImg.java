package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpCityImg {
    private String cityImgId;

    private String userId;

    private String cityImgUrl;
    
    private String cityImgContent;

    private Integer cityType;

    private Date createTime;
    
    private Integer cityStatus;
    
	//虚拟属性
    private Integer isMe = 0;		//1:筛选自己上传的图片
    
    private Integer isVoteSort = 0;		//1:根据投票数排序
    
    private Integer isVote;		//0：今日未投票；1：今日已投票
    
    private Integer voteCount;	//投票数
    
    private Integer rows = 20;
	
	private Integer firstResult;
	
	private String userName;
	
	private String userHeadImgUrl;
	
	private String cityImgIds;
	
	private Integer ranking;
	
	private String userRealName;
	
	private String userMobile;
	
    public CcpCityImg() {
		super();
	}

	public CcpCityImg(String cityImgId) {
		super();
		this.cityImgId = cityImgId;
	}

	public String getCityImgId() {
        return cityImgId;
    }

    public void setCityImgId(String cityImgId) {
        this.cityImgId = cityImgId == null ? null : cityImgId.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getCityImgUrl() {
        return cityImgUrl;
    }

    public void setCityImgUrl(String cityImgUrl) {
        this.cityImgUrl = cityImgUrl == null ? null : cityImgUrl.trim();
    }

    public Integer getCityType() {
        return cityType;
    }

    public void setCityType(Integer cityType) {
        this.cityType = cityType;
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

	public String getCityImgContent() {
		return cityImgContent;
	}

	public void setCityImgContent(String cityImgContent) {
		this.cityImgContent = cityImgContent;
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

	public String getCityImgIds() {
		return cityImgIds;
	}

	public void setCityImgIds(String cityImgIds) {
		this.cityImgIds = cityImgIds;
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
	
	public Integer getCityStatus() {
		return cityStatus;
	}

	public void setCityStatus(Integer cityStatus) {
		this.cityStatus = cityStatus;
	}
}