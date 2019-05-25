package com.culturecloud.model.request.activity;

import com.culturecloud.bean.BaseRequest;


public class SysUserAnalyseVO extends BaseRequest {

    private String userId;

    private String tagId;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getTagId() {
        return tagId;
    }

    public void setTagId(String tagId) {
        this.tagId = tagId;
    }
}
