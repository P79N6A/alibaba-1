package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;

public class CmsApplyJoinTeam extends Pagination implements Serializable {
    private String applyId;

    private String tuserId;

    private String userId;

    private String applyReason;

    private Date applyTime;

    private Integer applyCheckState;

    private Date applyCheckTime;

    private String applyCheckReason;

    private Integer applyIsState;

    private Date applyCreateTime;

    private Date applyUpdateTime;

    private String applyCreateUser;

    private String applyUpdateUser;

    public String getApplyId() {
        return applyId;
    }

    public void setApplyId(String applyId) {
        this.applyId = applyId == null ? null : applyId.trim();
    }

    public String getTuserId() {
        return tuserId;
    }

    public void setTuserId(String tuserId) {
        this.tuserId = tuserId == null ? null : tuserId.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getApplyReason() {
        return applyReason;
    }

    public void setApplyReason(String applyReason) {
        this.applyReason = applyReason == null ? null : applyReason.trim();
    }

    public Date getApplyTime() {
        return applyTime;
    }

    public void setApplyTime(Date applyTime) {
        this.applyTime = applyTime;
    }

    public Integer getApplyCheckState() {
        return applyCheckState;
    }

    public void setApplyCheckState(Integer applyCheckState) {
        this.applyCheckState = applyCheckState;
    }

    public Date getApplyCheckTime() {
        return applyCheckTime;
    }

    public void setApplyCheckTime(Date applyCheckTime) {
        this.applyCheckTime = applyCheckTime;
    }

    public String getApplyCheckReason() {
        return applyCheckReason;
    }

    public void setApplyCheckReason(String applyCheckReason) {
        this.applyCheckReason = applyCheckReason == null ? null : applyCheckReason.trim();
    }

    public Integer getApplyIsState() {
        return applyIsState;
    }

    public void setApplyIsState(Integer applyIsState) {
        this.applyIsState = applyIsState;
    }

    public Date getApplyCreateTime() {
        return applyCreateTime;
    }

    public void setApplyCreateTime(Date applyCreateTime) {
        this.applyCreateTime = applyCreateTime;
    }

    public Date getApplyUpdateTime() {
        return applyUpdateTime;
    }

    public void setApplyUpdateTime(Date applyUpdateTime) {
        this.applyUpdateTime = applyUpdateTime;
    }

    public String getApplyCreateUser() {
        return applyCreateUser;
    }

    public void setApplyCreateUser(String applyCreateUser) {
        this.applyCreateUser = applyCreateUser == null ? null : applyCreateUser.trim();
    }

    public String getApplyUpdateUser() {
        return applyUpdateUser;
    }

    public void setApplyUpdateUser(String applyUpdateUser) {
        this.applyUpdateUser = applyUpdateUser == null ? null : applyUpdateUser.trim();
    }
}