package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpWalkVote {
    private String walkVoteId;

    private String walkImgId;

    private String userId;

    private Date createTime;

    public String getWalkVoteId() {
        return walkVoteId;
    }

    public void setWalkVoteId(String walkVoteId) {
        this.walkVoteId = walkVoteId == null ? null : walkVoteId.trim();
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

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}