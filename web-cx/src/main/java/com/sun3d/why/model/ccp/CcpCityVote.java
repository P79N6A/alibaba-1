package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpCityVote {
    private String cityVoteId;

    private String cityImgId;

    private String userId;

    private Integer cityType;

    private Date createTime;

    public String getCityVoteId() {
        return cityVoteId;
    }

    public void setCityVoteId(String cityVoteId) {
        this.cityVoteId = cityVoteId == null ? null : cityVoteId.trim();
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
}