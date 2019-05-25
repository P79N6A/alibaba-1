package com.sun3d.why.model;

import java.util.Date;

public class DcScore {
    private String scoreId;

    private String userId;

    private String videoId;

    private Integer videoScore;

    private String videoReason;

    private Date createTime;
    
    public DcScore() {
		super();
	}

	public DcScore(String userId, String videoId) {
		super();
		this.userId = userId;
		this.videoId = videoId;
	}

	public String getScoreId() {
        return scoreId;
    }

    public void setScoreId(String scoreId) {
        this.scoreId = scoreId == null ? null : scoreId.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getVideoId() {
        return videoId;
    }

    public void setVideoId(String videoId) {
        this.videoId = videoId == null ? null : videoId.trim();
    }

    public Integer getVideoScore() {
        return videoScore;
    }

    public void setVideoScore(Integer videoScore) {
        this.videoScore = videoScore;
    }

    public String getVideoReason() {
        return videoReason;
    }

    public void setVideoReason(String videoReason) {
        this.videoReason = videoReason == null ? null : videoReason.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}