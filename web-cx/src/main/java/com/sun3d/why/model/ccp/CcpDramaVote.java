package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpDramaVote {
    private String dramaVoteId;

    private String dramaId;

    private String userId;

    private Date createTime;

    public String getDramaVoteId() {
        return dramaVoteId;
    }

    public void setDramaVoteId(String dramaVoteId) {
        this.dramaVoteId = dramaVoteId == null ? null : dramaVoteId.trim();
    }

    public String getDramaId() {
        return dramaId;
    }

    public void setDramaId(String dramaId) {
        this.dramaId = dramaId == null ? null : dramaId.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}