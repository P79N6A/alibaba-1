package com.culturecloud.model.bean.contest;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

import javax.persistence.Column;
import java.util.Date;
@Table(value="ccp_contest_user_info")
public class CcpContestUserInfo implements BaseEntity {

    private static final long serialVersionUID = -4288939106396494320L;

    @Id
    @Column(name="contest_user_id")
    private String contestUserId;

    @Column(name="user_id")
    private String userId;

    @Column(name="user_name")
    private String userName;

    @Column(name="user_telephone")
    private String userTelephone;

    @Column(name="contest_score")
    private Integer contestScore;

    @Column(name="contest_result")
    private Integer contestResult;

    @Column(name="share_help_img")
    private String shareHelpImg;

    @Column(name="share_success_img")
    private String shareSuccessImg;

    @Column(name="chance_temporary_number")
    private Integer chanceTemporaryNumber;

    @Column(name="chance_permanent_number")
    private Integer chancePermanentNumber;

    @Column(name="help_number")
    private Integer helpNumber;

    @Column(name="contest_system_type")
    private Integer contestSystemType;

    @Column(name="last_login_time")
    private Date lastLoginTime;

    @Column(name="success_time")
    private Date successTime;

    @Column(name="create_time")
    private Date createTime;

    @Column(name="help_user_id")
    private String helpUserId;

    @Column(name="success_ranking")
    private Integer successRanking;


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

    public Integer getContestScore() {
        return contestScore;
    }

    public void setContestScore(Integer contestScore) {
        this.contestScore = contestScore;
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

    public Integer getContestSystemType() {
        return contestSystemType;
    }

    public void setContestSystemType(Integer contestSystemType) {
        this.contestSystemType = contestSystemType;
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

    public String getHelpUserId() {
        return helpUserId;
    }

    public void setHelpUserId(String helpUserId) {
        this.helpUserId = helpUserId;
    }

    public Integer getSuccessRanking() {
        return successRanking;
    }

    public void setSuccessRanking(Integer successRanking) {
        this.successRanking = successRanking;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}
