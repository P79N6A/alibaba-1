package com.sun3d.why.model;

import java.util.Date;

public class DcVideo {
    private String videoId;

    private String userId;

    private String videoGuide;
    
    private String videoActivityCenter;

    private String videoTelephone;

    private String videoType;

    private String videoTeamName;

    private Integer videoTeamCount;

    private String videoTeamRemark;

    private String videoUrl;

    private String videoImgUrl;

    private String videoName;

    private Integer videoLength;

    private String videoIntro;

    private Integer videoStatus;	//(1：技术待评审；2：技术评审不通过；3：技术评审通过(海选待评审)；4：海选不通过；5海选通过)

    private String videoTreviewUser;

    private Date videoTreviewTime;
    
    private String videoSreviewUser;

    private Date videoSreviewTime;
    
    private String videoSreviewReason;
    
    private String videoExpertScore;
    
    private String videoPublicScore;
    
    private String videoTotalScore;

    private String createUser;

    private Date createTime;
    
    //虚拟属性
    private Integer reviewType;	//(1：技术评审；2：海选评审；3：海选复审；4：专家评分；5：评分汇总；6：H5首页；7：H5排名)
    
    private String userArea;
    
    private String searchKey;
    
    private Integer searchType = 1;	//(1：作品名称；2：指导员；3：参演团队)
    
    private String videoReviewUser;		//海选\专家评审
    
    private String videoReviewTime;
    
    private String videoReviewResult;		//海选结果\专家评分
    
    private String videoReviewReason;
    
    private Integer isVote;		//0：今日未投票；1：今日已投票
    
    private Integer voteCount;	//投票数
    
    private Integer rows = 20;
	
	private Integer firstResult;
    
	public DcVideo() {
		super();
	}

	public DcVideo(String videoId, Integer reviewType) {
		super();
		this.videoId = videoId;
		this.reviewType = reviewType;
	}

	public String getVideoId() {
        return videoId;
    }

    public void setVideoId(String videoId) {
        this.videoId = videoId == null ? null : videoId.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getVideoGuide() {
        return videoGuide;
    }

    public void setVideoGuide(String videoGuide) {
        this.videoGuide = videoGuide == null ? null : videoGuide.trim();
    }

    public String getVideoTelephone() {
        return videoTelephone;
    }

    public void setVideoTelephone(String videoTelephone) {
        this.videoTelephone = videoTelephone == null ? null : videoTelephone.trim();
    }

    public String getVideoType() {
        return videoType;
    }

    public void setVideoType(String videoType) {
        this.videoType = videoType == null ? null : videoType.trim();
    }

    public String getVideoTeamName() {
        return videoTeamName;
    }

    public void setVideoTeamName(String videoTeamName) {
        this.videoTeamName = videoTeamName == null ? null : videoTeamName.trim();
    }

    public Integer getVideoTeamCount() {
        return videoTeamCount;
    }

    public void setVideoTeamCount(Integer videoTeamCount) {
        this.videoTeamCount = videoTeamCount;
    }

    public String getVideoTeamRemark() {
        return videoTeamRemark;
    }

    public void setVideoTeamRemark(String videoTeamRemark) {
        this.videoTeamRemark = videoTeamRemark == null ? null : videoTeamRemark.trim();
    }

    public String getVideoUrl() {
        return videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl == null ? null : videoUrl.trim();
    }

    public String getVideoImgUrl() {
        return videoImgUrl;
    }

    public void setVideoImgUrl(String videoImgUrl) {
        this.videoImgUrl = videoImgUrl == null ? null : videoImgUrl.trim();
    }

    public String getVideoName() {
        return videoName;
    }

    public void setVideoName(String videoName) {
        this.videoName = videoName == null ? null : videoName.trim();
    }

    public Integer getVideoLength() {
        return videoLength;
    }

    public void setVideoLength(Integer videoLength) {
        this.videoLength = videoLength;
    }

    public String getVideoIntro() {
        return videoIntro;
    }

    public void setVideoIntro(String videoIntro) {
        this.videoIntro = videoIntro == null ? null : videoIntro.trim();
    }

    public Integer getVideoStatus() {
        return videoStatus;
    }

    public void setVideoStatus(Integer videoStatus) {
        this.videoStatus = videoStatus;
    }

    public String getVideoTreviewUser() {
        return videoTreviewUser;
    }

    public void setVideoTreviewUser(String videoTreviewUser) {
        this.videoTreviewUser = videoTreviewUser == null ? null : videoTreviewUser.trim();
    }

    public Date getVideoTreviewTime() {
        return videoTreviewTime;
    }

    public void setVideoTreviewTime(Date videoTreviewTime) {
        this.videoTreviewTime = videoTreviewTime;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser == null ? null : createUser.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

	public Integer getReviewType() {
		return reviewType;
	}

	public void setReviewType(Integer reviewType) {
		this.reviewType = reviewType;
	}

	public String getUserArea() {
		return userArea;
	}

	public void setUserArea(String userArea) {
		this.userArea = userArea;
	}

	public String getSearchKey() {
		return searchKey;
	}

	public void setSearchKey(String searchKey) {
		this.searchKey = searchKey;
	}

	public Integer getSearchType() {
		return searchType;
	}

	public void setSearchType(Integer searchType) {
		this.searchType = searchType;
	}

	public String getVideoActivityCenter() {
		return videoActivityCenter;
	}

	public void setVideoActivityCenter(String videoActivityCenter) {
		this.videoActivityCenter = videoActivityCenter;
	}

	public String getVideoReviewUser() {
		return videoReviewUser;
	}

	public void setVideoReviewUser(String videoReviewUser) {
		this.videoReviewUser = videoReviewUser;
	}

	public String getVideoReviewTime() {
		return videoReviewTime;
	}

	public void setVideoReviewTime(String videoReviewTime) {
		this.videoReviewTime = videoReviewTime;
	}

	public String getVideoReviewResult() {
		return videoReviewResult;
	}

	public void setVideoReviewResult(String videoReviewResult) {
		this.videoReviewResult = videoReviewResult;
	}

	public String getVideoReviewReason() {
		return videoReviewReason;
	}

	public void setVideoReviewReason(String videoReviewReason) {
		this.videoReviewReason = videoReviewReason;
	}

	public String getVideoSreviewUser() {
		return videoSreviewUser;
	}

	public void setVideoSreviewUser(String videoSreviewUser) {
		this.videoSreviewUser = videoSreviewUser;
	}

	public Date getVideoSreviewTime() {
		return videoSreviewTime;
	}

	public void setVideoSreviewTime(Date videoSreviewTime) {
		this.videoSreviewTime = videoSreviewTime;
	}

	public String getVideoSreviewReason() {
		return videoSreviewReason;
	}

	public void setVideoSreviewReason(String videoSreviewReason) {
		this.videoSreviewReason = videoSreviewReason;
	}

	public String getVideoExpertScore() {
		return videoExpertScore;
	}

	public void setVideoExpertScore(String videoExpertScore) {
		this.videoExpertScore = videoExpertScore;
	}

	public String getVideoPublicScore() {
		return videoPublicScore;
	}

	public void setVideoPublicScore(String videoPublicScore) {
		this.videoPublicScore = videoPublicScore;
	}

	public String getVideoTotalScore() {
		return videoTotalScore;
	}

	public void setVideoTotalScore(String videoTotalScore) {
		this.videoTotalScore = videoTotalScore;
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