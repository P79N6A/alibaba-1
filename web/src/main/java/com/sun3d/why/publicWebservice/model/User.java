package com.sun3d.why.publicWebservice.model;

import java.io.Serializable;

/**
 * 用户基础信息
 * Created by niubiao on 2016/4/5.
 */
public class User implements Serializable {

    private String userId;

    private String userName;

    private Integer userSex;

    private String userHeadImgUrl;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Integer getUserSex() {
        return userSex;
    }

    public void setUserSex(Integer userSex) {
        this.userSex = userSex;
    }

    public String getUserHeadImgUrl() {
        return userHeadImgUrl;
    }

    public void setUserHeadImgUrl(String userHeadImgUrl) {
        this.userHeadImgUrl = userHeadImgUrl;
    }
}
