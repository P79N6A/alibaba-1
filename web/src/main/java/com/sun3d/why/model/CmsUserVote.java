package com.sun3d.why.model;

import java.util.Date;

public class CmsUserVote {
    private String userVoteId;

    private String userId;

    private String voteId;

    private String voteRelateId;

    private Date voteTime;

    public String getUserVoteId() {
        return userVoteId;
    }

    public void setUserVoteId(String userVoteId) {
        this.userVoteId = userVoteId == null ? null : userVoteId.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getVoteId() {
        return voteId;
    }

    public void setVoteId(String voteId) {
        this.voteId = voteId == null ? null : voteId.trim();
    }

    public String getVoteRelateId() {
        return voteRelateId;
    }

    public void setVoteRelateId(String voteRelateId) {
        this.voteRelateId = voteRelateId == null ? null : voteRelateId.trim();
    }

    public Date getVoteTime() {
        return voteTime;
    }

    public void setVoteTime(Date voteTime) {
        this.voteTime = voteTime;
    }
}