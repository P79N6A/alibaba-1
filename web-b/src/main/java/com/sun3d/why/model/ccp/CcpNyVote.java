package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpNyVote {
    private String nyVoteId;

    private String nyImgId;

    private String userId;

    private Date createTime;

    public String getNyVoteId() {
        return nyVoteId;
    }

    public void setNyVoteId(String nyVoteId) {
        this.nyVoteId = nyVoteId == null ? null : nyVoteId.trim();
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

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}