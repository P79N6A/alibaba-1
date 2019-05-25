package com.culturecloud.model.response.contest;


import java.io.Serializable;
import java.util.Date;

public class CcpContestUserInfoVO implements Serializable {

    private static final long serialVersionUID = -3894734489235929162L;


    private String userName;

    private String userTelephone;

    private Integer[] contestScores;

    private Integer contestResult;

    private String shareHelpImg;

    private String shareSuccessImg;

    private Integer chanceTemporaryNumber;

    private Integer chancePermanentNumber;

    private Integer helpNumber;

    private Integer successRanking;

    private Date lastLoginTime;

    private Date successTime;


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

    public Integer getChanceTemporaryNumber() {
        return chanceTemporaryNumber;
    }

    public void setChanceTemporaryNumber(Integer chanceTemporaryNumber) {
        this.chanceTemporaryNumber = chanceTemporaryNumber;
    }

    public Integer getChancePermanentNumber() {
        return chancePermanentNumber;
    }

    public void setChancePermanentNumber(Integer chancePermanentNumber) {
        this.chancePermanentNumber = chancePermanentNumber;
    }

    public Integer getHelpNumber() {
        return helpNumber;
    }

    public void setHelpNumber(Integer helpNumber) {
        this.helpNumber = helpNumber;
    }

    public Integer getSuccessRanking() {
        return successRanking;
    }

    public void setSuccessRanking(Integer successRanking) {
        this.successRanking = successRanking;
    }

    public Integer[] getContestScores() {
        return contestScores;
    }

    public void setContestScores(Integer[] contestScores) {
        this.contestScores = contestScores;
    }

    public Date getLastLoginTime() {
        return lastLoginTime;
    }

    public void setLastLoginTime(Date lastLoginTime) {
        this.lastLoginTime = lastLoginTime;
    }

    public Date getSuccessTime() {
        return successTime;
    }

    public void setSuccessTime(Date successTime) {
        this.successTime = successTime;
    }
}
