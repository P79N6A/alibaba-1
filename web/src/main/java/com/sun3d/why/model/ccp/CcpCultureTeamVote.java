package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpCultureTeamVote {
    private String voteId;

    private String cultureTeamId;

    private String userId;

    private Date createTime;

    public String getVoteId() {
        return voteId;
    }

    public void setVoteId(String voteId) {
        this.voteId = voteId == null ? null : voteId.trim();
    }

    public String getCultureTeamId() {
        return cultureTeamId;
    }

    public void setCultureTeamId(String cultureTeamId) {
        this.cultureTeamId = cultureTeamId == null ? null : cultureTeamId.trim();
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