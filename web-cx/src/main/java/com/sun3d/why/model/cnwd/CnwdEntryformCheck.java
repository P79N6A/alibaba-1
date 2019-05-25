package com.sun3d.why.model.cnwd;

import java.util.Date;

public class CnwdEntryformCheck {
    private String checkId;

    private String checkEntryformId;

    private String checkSysUserId;

    private Date checkTime;

    private Integer checkStatus;

    private String refusalReason;

    public String getCheckId() {
        return checkId;
    }

    public void setCheckId(String checkId) {
        this.checkId = checkId == null ? null : checkId.trim();
    }

    public String getCheckEntryformId() {
        return checkEntryformId;
    }

    public void setCheckEntryformId(String checkEntryformId) {
        this.checkEntryformId = checkEntryformId == null ? null : checkEntryformId.trim();
    }

    public String getCheckSysUserId() {
        return checkSysUserId;
    }

    public void setCheckSysUserId(String checkSysUserId) {
        this.checkSysUserId = checkSysUserId == null ? null : checkSysUserId.trim();
    }

    public Date getCheckTime() {
        return checkTime;
    }

    public void setCheckTime(Date checkTime) {
        this.checkTime = checkTime;
    }

    public Integer getCheckStatus() {
        return checkStatus;
    }

    public void setCheckStatus(Integer checkStatus) {
        this.checkStatus = checkStatus;
    }

    public String getRefusalReason() {
        return refusalReason;
    }

    public void setRefusalReason(String refusalReason) {
        this.refusalReason = refusalReason == null ? null : refusalReason.trim();
    }
}