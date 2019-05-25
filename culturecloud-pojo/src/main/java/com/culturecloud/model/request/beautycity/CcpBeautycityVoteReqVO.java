package com.culturecloud.model.request.beautycity;

import java.util.Date;

import com.culturecloud.bean.BasePageRequest;

public class CcpBeautycityVoteReqVO extends BasePageRequest{
    private String beautycityVoteId;

    private String beautycityImgId;

    private String userId;

    private Date createTime;

    public String getBeautycityVoteId() {
        return beautycityVoteId;
    }

    public void setBeautycityVoteId(String beautycityVoteId) {
        this.beautycityVoteId = beautycityVoteId == null ? null : beautycityVoteId.trim();
    }

    public String getBeautycityImgId() {
        return beautycityImgId;
    }

    public void setBeautycityImgId(String beautycityImgId) {
        this.beautycityImgId = beautycityImgId == null ? null : beautycityImgId.trim();
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