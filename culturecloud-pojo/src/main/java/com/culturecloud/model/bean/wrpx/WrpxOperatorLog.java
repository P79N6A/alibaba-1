package com.culturecloud.model.bean.wrpx;

import java.util.Date;

public class WrpxOperatorLog {
    private String logId;

    private String operator;

    private Integer opertType;

    private String logDesc;

    private String result;

    private Date createdate;

    public String getLogId() {
        return logId;
    }

    public void setLogId(String logId) {
        this.logId = logId == null ? null : logId.trim();
    }

    public String getOperator() {
        return operator;
    }

    public void setOperator(String operator) {
        this.operator = operator == null ? null : operator.trim();
    }

    public Integer getOpertType() {
        return opertType;
    }

    public void setOpertType(Integer opertType) {
        this.opertType = opertType;
    }

    public String getLogDesc() {
        return logDesc;
    }

    public void setLogDesc(String logDesc) {
        this.logDesc = logDesc == null ? null : logDesc.trim();
    }

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result == null ? null : result.trim();
    }

    public Date getCreatedate() {
        return createdate;
    }

    public void setCreatedate(Date createdate) {
        this.createdate = createdate;
    }
}