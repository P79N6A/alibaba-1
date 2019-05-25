package com.culturecloud.model.request.contest;


import com.culturecloud.bean.BaseRequest;

import javax.validation.constraints.NotNull;
import java.util.Date;

public class ContestUserInfoVO extends BaseRequest {

    private String contestUserId;

    @NotNull(message = "用户id不能为空")
    private String userId;

    private String userName;

    private String userTelephone;

    private String shareHelpImg;

    private String shareSuccessImg;

    private String helpuserId;

    private Integer contestResult;

    private Integer codeCount;

    private Integer contestScores;

    private Date successTime;

    @NotNull(message = "用户类型不能为空")
    private Integer contestSystemType;

    public String getContestUserId() {
        return contestUserId;
    }

    public void setContestUserId(String contestUserId) {
        this.contestUserId = contestUserId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Integer getContestSystemType() {
        return contestSystemType;
    }

    public void setContestSystemType(Integer contestSystemType) {
        this.contestSystemType = contestSystemType;
    }

    public String getHelpuserId() {
        return helpuserId;
    }

    public void setHelpuserId(String helpuserId) {
        this.helpuserId = helpuserId;
    }


    public String getShareHelpImg() {
        return shareHelpImg;
    }

    public void setShareHelpImg(String shareHelpImg) {
        this.shareHelpImg = shareHelpImg;
    }

    public String getShareSuccessImg() {
        return shareSuccessImg;
    }

    public void setShareSuccessImg(String shareSuccessImg) {
        this.shareSuccessImg = shareSuccessImg;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserTelephone() {
        return userTelephone;
    }

    public void setUserTelephone(String userTelephone) {
        this.userTelephone = userTelephone;
    }

    public Integer getContestResult() {
        return contestResult;
    }

    public void setContestResult(Integer contestResult) {
        this.contestResult = contestResult;
    }

    public Integer getCodeCount() {
        return codeCount;
    }

    public void setCodeCount(Integer codeCount) {
        this.codeCount = codeCount;
    }

    public Integer getContestScores() {
        return contestScores;
    }

    public void setContestScores(Integer contestScores) {
        this.contestScores = contestScores;
    }

    public Date getSuccessTime() {
        return successTime;
    }

    public void setSuccessTime(Date successTime) {
        this.successTime = successTime;
    }
}
