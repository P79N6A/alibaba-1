package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;

public class CmsCollect extends Pagination implements Serializable {
    private String userId;

    private String relateId;

    private Integer type;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getRelateId() {
        return relateId;
    }

    public void setRelateId(String relateId) {
        this.relateId = relateId == null ? null : relateId.trim();
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }
}