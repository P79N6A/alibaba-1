package com.culturecloud.model.request.beautycity;

import com.culturecloud.bean.BaseRequest;

public class CcpBeautycityVenueReqVO extends BaseRequest{

    private String userId;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

}