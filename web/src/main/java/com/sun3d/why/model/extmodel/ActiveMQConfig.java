package com.sun3d.why.model.extmodel;

import java.io.Serializable;

/**
 * Created by yujinbing on 2015/7/15.
 */
public class ActiveMQConfig implements Serializable{

    private String userName;

    private String userPwd;

    private String mqUrl;

    private String activeMqFailover;


    public String getActiveMqFailover() {
        return activeMqFailover;
    }

    public void setActiveMqFailover(String activeMqFailover) {
        this.activeMqFailover = activeMqFailover;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getMqUrl() {
        return mqUrl;
    }

    public void setMqUrl(String mqUrl) {
        this.mqUrl = mqUrl;
    }

    public String getUserPwd() {
        return userPwd;
    }

    public void setUserPwd(String userPwd) {
        this.userPwd = userPwd;
    }
}
