package com.sun3d.why.model;

import java.io.Serializable;
import java.util.Date;

public class ManagementInformation implements Serializable {
    private String informationId;

    private String informationTags;

    private String informationTitle;

    private String authorName;

    private String publisherName;

    private Double informationLon;

    private Double informationLat;

    private String shareTitle;

    private String shareSummary;

    private Integer shareCount;

    private Integer browseCount;

    private String informationIconUrl;

    private String shareIconUrl;

    private Integer informationFooter;

    private Date informationCreateTime;

    private Date informationUpdateTime;

    private String informationCreateUser;

    private String informationUpdateUser;

    private String informationContent;


    public String getInformationId() {
        return informationId;
    }

    public void setInformationId(String informationId) {
        this.informationId = informationId;
    }

    public String getInformationTags() {
        return informationTags;
    }

    public void setInformationTags(String informationTags) {
        this.informationTags = informationTags;
    }

    public String getInformationTitle() {
        return informationTitle;
    }

    public void setInformationTitle(String informationTitle) {
        this.informationTitle = informationTitle;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public String getPublisherName() {
        return publisherName;
    }

    public void setPublisherName(String publisherName) {
        this.publisherName = publisherName;
    }

    public Double getInformationLon() {
        return informationLon;
    }

    public void setInformationLon(Double informationLon) {
        this.informationLon = informationLon;
    }

    public Double getInformationLat() {
        return informationLat;
    }

    public void setInformationLat(Double informationLat) {
        this.informationLat = informationLat;
    }

    public String getShareTitle() {
        return shareTitle;
    }

    public void setShareTitle(String shareTitle) {
        this.shareTitle = shareTitle;
    }

    public String getShareSummary() {
        return shareSummary;
    }

    public void setShareSummary(String shareSummary) {
        this.shareSummary = shareSummary;
    }

    public Integer getShareCount() {
        return shareCount;
    }

    public void setShareCount(Integer shareCount) {
        this.shareCount = shareCount;
    }

    public Integer getBrowseCount() {
        return browseCount;
    }

    public void setBrowseCount(Integer browseCount) {
        this.browseCount = browseCount;
    }

    public String getInformationIconUrl() {
        return informationIconUrl;
    }

    public void setInformationIconUrl(String informationIconUrl) {
        this.informationIconUrl = informationIconUrl;
    }

    public String getShareIconUrl() {
        return shareIconUrl;
    }

    public void setShareIconUrl(String shareIconUrl) {
        this.shareIconUrl = shareIconUrl;
    }

    public Integer getInformationFooter() {
        return informationFooter;
    }

    public void setInformationFooter(Integer informationFooter) {
        this.informationFooter = informationFooter;
    }

    public Date getInformationCreateTime() {
        return informationCreateTime;
    }

    public void setInformationCreateTime(Date informationCreateTime) {
        this.informationCreateTime = informationCreateTime;
    }

    public Date getInformationUpdateTime() {
        return informationUpdateTime;
    }

    public void setInformationUpdateTime(Date informationUpdateTime) {
        this.informationUpdateTime = informationUpdateTime;
    }

    public String getInformationCreateUser() {
        return informationCreateUser;
    }

    public void setInformationCreateUser(String informationCreateUser) {
        this.informationCreateUser = informationCreateUser;
    }

    public String getInformationUpdateUser() {
        return informationUpdateUser;
    }

    public void setInformationUpdateUser(String informationUpdateUser) {
        this.informationUpdateUser = informationUpdateUser;
    }

    public String getInformationContent() {
        return informationContent;
    }

    public void setInformationContent(String informationContent) {
        this.informationContent = informationContent;
    }
}