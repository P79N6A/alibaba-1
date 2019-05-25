package com.sun3d.why.model;

import java.io.Serializable;
import java.util.Date;

public class SysLog implements Serializable {
    private String logId;

    private String logUserId;

    private String logNickName;

    private String logIp;

    private String logModuleName;

    private String logRemark;

    private Date logOperTime;

    public String getLogId() {
        return logId;
    }

    public void setLogId(String logId) {
        this.logId = logId == null ? null : logId.trim();
    }

    public String getLogUserId() {
        return logUserId;
    }

    public void setLogUserId(String logUserId) {
        this.logUserId = logUserId == null ? null : logUserId.trim();
    }

    public String getLogNickName() {
        return logNickName;
    }

    public void setLogNickName(String logNickName) {
        this.logNickName = logNickName == null ? null : logNickName.trim();
    }

    public String getLogIp() {
        return logIp;
    }

    public void setLogIp(String logIp) {
        this.logIp = logIp == null ? null : logIp.trim();
    }

    public String getLogModuleName() {
        return logModuleName;
    }

    public void setLogModuleName(String logModuleName) {
        this.logModuleName = logModuleName == null ? null : logModuleName.trim();
    }

    public String getLogRemark() {
        return logRemark;
    }

    public void setLogRemark(String logRemark) {
        this.logRemark = logRemark == null ? null : logRemark.trim();
    }

    public Date getLogOperTime() {
        return logOperTime;
    }

    public void setLogOperTime(Date logOperTime) {
        this.logOperTime = logOperTime;
    }
}