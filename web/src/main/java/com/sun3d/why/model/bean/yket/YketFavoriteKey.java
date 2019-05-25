package com.sun3d.why.model.bean.yket;

public class YketFavoriteKey {
    private String userId;

    private Integer favoriteType;

    private String objectId;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public Integer getFavoriteType() {
        return favoriteType;
    }

    public void setFavoriteType(Integer favoriteType) {
        this.favoriteType = favoriteType;
    }

    public String getObjectId() {
        return objectId;
    }

    public void setObjectId(String objectId) {
        this.objectId = objectId == null ? null : objectId.trim();
    }
}