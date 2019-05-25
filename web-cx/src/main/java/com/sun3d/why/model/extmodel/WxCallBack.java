package com.sun3d.why.model.extmodel;

/**
 * Created by niubiao on 2016/3/21.
 */
public class WxCallBack {

    //静默回调地址
    private String wxSilentCallBack;

    //授权回调地址
    private String wxAuthorizeCallBack;

    public String getWxSilentCallBack() {
        return wxSilentCallBack;
    }

    public void setWxSilentCallBack(String wxSilentCallBack) {
        this.wxSilentCallBack = wxSilentCallBack;
    }

    public String getWxAuthorizeCallBack() {
        return wxAuthorizeCallBack;
    }

    public void setWxAuthorizeCallBack(String wxAuthorizeCallBack) {
        this.wxAuthorizeCallBack = wxAuthorizeCallBack;
    }
}
