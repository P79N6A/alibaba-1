package com.sun3d.why.model.extmodel;

import java.io.Serializable;

/**
 * Created by Administrator on 2015/5/11.
 * 短信参数配置
 */
public class SmsConfig implements Serializable{
    public  String smsUrl;
    public  String uId;
    public  String pwd;

    public String getSmsUrl() {
        return smsUrl;
    }

    public void setSmsUrl(String smsUrl) {
        this.smsUrl = smsUrl;
    }

    public String getuId() {
        return uId;
    }

    public void setuId(String uId) {
        this.uId = uId;
    }

    public String getPwd() {
        return pwd;
    }

    public void setPwd(String pwd) {
        this.pwd = pwd;
    }
}
