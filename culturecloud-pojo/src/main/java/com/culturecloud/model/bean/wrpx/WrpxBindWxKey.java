package com.culturecloud.model.bean.wrpx;

public class WrpxBindWxKey {
    private String wrpxUserId;

    private String wxUserId;

    public String getWrpxUserId() {
        return wrpxUserId;
    }

    public void setWrpxUserId(String wrpxUserId) {
        this.wrpxUserId = wrpxUserId == null ? null : wrpxUserId.trim();
    }

    public String getWxUserId() {
        return wxUserId;
    }

    public void setWxUserId(String wxUserId) {
        this.wxUserId = wxUserId == null ? null : wxUserId.trim();
    }
}