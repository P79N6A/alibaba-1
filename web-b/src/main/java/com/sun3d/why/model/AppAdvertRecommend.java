package com.sun3d.why.model;

import java.util.Date;
import java.util.List;

public class AppAdvertRecommend {
    private String advertId;

    private String advPostion;

    private Integer isContainActivtiyAdv;

    private Integer advBannerFIsLink;

    private Integer advBannerFLinkType;

    private String advBannerFUrl;

    private String advBannerFImgUrl;

    private Integer advBannerSIsLink;

    private Integer advBannerSLinkType;

    private String advBannerSUrl;

    private String advBannerSImgUrl;

    private Integer advBannerLIsLink;

    private Integer advBannerLLinkType;

    private String advBannerLUrl;

    private String advBannerLImgUrl;

    private Integer advState;

    private String createBy;

    private String updateBy;

    private Date createTime;

    private Date updateTime;

    private List<AppAdvertRecommendRfer> dataList;
    /**
     * 标签名称
     */
    private String tagName;


    public String getAdvertId() {
        return advertId;
    }

    public void setAdvertId(String advertId) {
        this.advertId = advertId == null ? null : advertId.trim();
    }

    public String getAdvPostion() {
        return advPostion;
    }

    public void setAdvPostion(String advPostion) {
        this.advPostion = advPostion == null ? null : advPostion.trim();
    }

    public Integer getIsContainActivtiyAdv() {
        return isContainActivtiyAdv;
    }

    public void setIsContainActivtiyAdv(Integer isContainActivtiyAdv) {
        this.isContainActivtiyAdv = isContainActivtiyAdv;
    }

    public Integer getAdvBannerFIsLink() {
        return advBannerFIsLink;
    }

    public void setAdvBannerFIsLink(Integer advBannerFIsLink) {
        this.advBannerFIsLink = advBannerFIsLink;
    }

    public Integer getAdvBannerFLinkType() {
        return advBannerFLinkType;
    }

    public void setAdvBannerFLinkType(Integer advBannerFLinkType) {
        this.advBannerFLinkType = advBannerFLinkType;
    }

    public String getAdvBannerFUrl() {
        return advBannerFUrl;
    }

    public void setAdvBannerFUrl(String advBannerFUrl) {
        this.advBannerFUrl = advBannerFUrl == null ? null : advBannerFUrl.trim();
    }

    public String getAdvBannerFImgUrl() {
        return advBannerFImgUrl;
    }

    public void setAdvBannerFImgUrl(String advBannerFImgUrl) {
        this.advBannerFImgUrl = advBannerFImgUrl == null ? null : advBannerFImgUrl.trim();
    }

    public Integer getAdvBannerSIsLink() {
        return advBannerSIsLink;
    }

    public void setAdvBannerSIsLink(Integer advBannerSIsLink) {
        this.advBannerSIsLink = advBannerSIsLink;
    }

    public Integer getAdvBannerSLinkType() {
        return advBannerSLinkType;
    }

    public void setAdvBannerSLinkType(Integer advBannerSLinkType) {
        this.advBannerSLinkType = advBannerSLinkType;
    }

    public String getAdvBannerSUrl() {
        return advBannerSUrl;
    }

    public void setAdvBannerSUrl(String advBannerSUrl) {
        this.advBannerSUrl = advBannerSUrl == null ? null : advBannerSUrl.trim();
    }

    public String getAdvBannerSImgUrl() {
        return advBannerSImgUrl;
    }

    public void setAdvBannerSImgUrl(String advBannerSImgUrl) {
        this.advBannerSImgUrl = advBannerSImgUrl == null ? null : advBannerSImgUrl.trim();
    }

    public Integer getAdvBannerLIsLink() {
        return advBannerLIsLink;
    }

    public void setAdvBannerLIsLink(Integer advBannerLIsLink) {
        this.advBannerLIsLink = advBannerLIsLink;
    }

    public Integer getAdvBannerLLinkType() {
        return advBannerLLinkType;
    }

    public void setAdvBannerLLinkType(Integer advBannerLLinkType) {
        this.advBannerLLinkType = advBannerLLinkType;
    }

    public String getAdvBannerLUrl() {
        return advBannerLUrl;
    }

    public void setAdvBannerLUrl(String advBannerLUrl) {
        this.advBannerLUrl = advBannerLUrl == null ? null : advBannerLUrl.trim();
    }

    public String getAdvBannerLImgUrl() {
        return advBannerLImgUrl;
    }

    public void setAdvBannerLImgUrl(String advBannerLImgUrl) {
        this.advBannerLImgUrl = advBannerLImgUrl == null ? null : advBannerLImgUrl.trim();
    }

    public Integer getAdvState() {
        return advState;
    }

    public void setAdvState(Integer advState) {
        this.advState = advState;
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


    public List<AppAdvertRecommendRfer> getDataList() {
        return dataList;
    }

    public void setDataList(List<AppAdvertRecommendRfer> dataList) {
        this.dataList = dataList;
    }

    public String getTagName() {
        return tagName;
    }

    public void setTagName(String tagName) {
        this.tagName = tagName;
    }
}