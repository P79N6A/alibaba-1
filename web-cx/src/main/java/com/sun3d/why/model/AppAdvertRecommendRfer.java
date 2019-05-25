package com.sun3d.why.model;

import java.util.Date;

public class AppAdvertRecommendRfer {
    private String advertId;

    private String advertUrl;

    private String advertImgUrl;

    private Integer advertSort;

    private String advertReferId;

    private String createBy;

    private String updateBy;

    private Date createTime;

    private Date updateTime;

    public String getAdvertId() {
        return advertId;
    }

    public void setAdvertId(String advertId) {
        this.advertId = advertId == null ? null : advertId.trim();
    }

    public String getAdvertUrl() {
        return advertUrl;
    }

    public void setAdvertUrl(String advertUrl) {
        this.advertUrl = advertUrl == null ? null : advertUrl.trim();
    }

    public String getAdvertImgUrl() {
        return advertImgUrl;
    }

    public void setAdvertImgUrl(String advertImgUrl) {
        this.advertImgUrl = advertImgUrl == null ? null : advertImgUrl.trim();
    }

    public Integer getAdvertSort() {
        return advertSort;
    }

    public void setAdvertSort(Integer advertSort) {
        this.advertSort = advertSort;
    }

    public String getAdvertReferId() {
        return advertReferId;
    }

    public void setAdvertReferId(String advertReferId) {
        this.advertReferId = advertReferId == null ? null : advertReferId.trim();
    }

    public String getCreateBy() {
        return createBy;
    }

    public void setCreateBy(String createBy) {
        this.createBy = createBy == null ? null : createBy.trim();
    }

    public String getUpdateBy() {
        return updateBy;
    }

    public void setUpdateBy(String updateBy) {
        this.updateBy = updateBy == null ? null : updateBy.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
}