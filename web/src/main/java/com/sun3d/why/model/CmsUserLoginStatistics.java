package com.sun3d.why.model;

import java.util.Date;

public class CmsUserLoginStatistics {
    private String sId;

    private Integer sType;

    private Integer sCategory;

    private Integer sCount;

    private Date sTime;

    public String getsId() {
        return sId;
    }

    public void setsId(String sId) {
        this.sId = sId == null ? null : sId.trim();
    }

    public Integer getsType() {
        return sType;
    }

    public void setsType(Integer sType) {
        this.sType = sType;
    }

    public Integer getsCategory() {
        return sCategory;
    }

    public void setsCategory(Integer sCategory) {
        this.sCategory = sCategory;
    }

    public Integer getsCount() {
        return sCount;
    }

    public void setsCount(Integer sCount) {
        this.sCount = sCount;
    }

    public Date getsTime() {
        return sTime;
    }

    public void setsTime(Date sTime) {
        this.sTime = sTime;
    }
}