package com.sun3d.why.model;

public class CmsActivityRecommendTag {
    private String tagRecommendActivityId;

    private String relationId;

    private Integer state;

    private String userId;

    public String getTagRecommendActivityId() {
        return tagRecommendActivityId;
    }

    public void setTagRecommendActivityId(String tagRecommendActivityId) {
        this.tagRecommendActivityId = tagRecommendActivityId == null ? null : tagRecommendActivityId.trim();
    }

    public String getRelationId() {
        return relationId;
    }

    public void setRelationId(String relationId) {
        this.relationId = relationId == null ? null : relationId.trim();
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }
}