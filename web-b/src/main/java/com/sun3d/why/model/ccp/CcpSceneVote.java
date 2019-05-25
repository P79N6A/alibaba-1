package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpSceneVote {
    private String sceneVoteId;

    private String sceneImgId;

    private String userId;

    private Date createTime;

    public String getSceneVoteId() {
        return sceneVoteId;
    }

    public void setSceneVoteId(String sceneVoteId) {
        this.sceneVoteId = sceneVoteId == null ? null : sceneVoteId.trim();
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

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}