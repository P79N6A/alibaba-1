package com.sun3d.why.model;

import java.util.Date;

public class CmsActivityVoteRelevance {
    private String voteRelevanceId;

    private String voteId;

    private String voteContent;

    private String voteImgUrl;

    private Date voteRelevanceDate;

    private int voteCount;

    private int voteSort;

    public String getVoteRelevanceId() {
        return voteRelevanceId;
    }

    public void setVoteRelevanceId(String voteRelevanceId) {
        this.voteRelevanceId = voteRelevanceId == null ? null : voteRelevanceId.trim();
    }

    public String getVoteId() {
        return voteId;
    }

    public void setVoteId(String voteId) {
        this.voteId = voteId == null ? null : voteId.trim();
    }

    public String getVoteContent() {
        return voteContent;
    }

    public void setVoteContent(String voteContent) {
        this.voteContent = voteContent == null ? null : voteContent.trim();
    }

    public String getVoteImgUrl() {
        return voteImgUrl;
    }

    public void setVoteImgUrl(String voteImgUrl) {
        this.voteImgUrl = voteImgUrl == null ? null : voteImgUrl.trim();
    }

    public Date getVoteRelevanceDate() {
        return voteRelevanceDate;
    }

    public void setVoteRelevanceDate(Date voteRelevanceDate) {
        this.voteRelevanceDate = voteRelevanceDate;
    }

    public int getVoteCount() {
        return voteCount;
    }

    public void setVoteCount(int voteCount) {
        this.voteCount = voteCount;
    }

    public int getVoteSort() {
        return voteSort;
    }

    public void setVoteSort(int voteSort) {
        this.voteSort = voteSort;
    }
}