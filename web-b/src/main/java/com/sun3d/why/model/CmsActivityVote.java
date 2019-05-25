package com.sun3d.why.model;

import java.util.Date;
import java.util.List;

public class CmsActivityVote {
    /**该内容投票总数 **/
    private Integer totals;

    public Integer getTotals() {
        return totals;
    }

    public void setTotals(Integer totals) {
        this.totals = totals;
    }

    /** 投票数 **/

    private Integer voteCount;

    public Integer getVoteCount() {
        return voteCount;
    }

    public void setVoteCount(Integer voteCount) {
        this.voteCount = voteCount;
    }

    /**投票内容 **/
    private String voteContent;

    public String getVoteContent() {
        return voteContent;
    }

    public void setVoteContent(String voteContent) {
        this.voteContent = voteContent;
    }

    private String voteId;

    private String activityId;

    private String voteTitel;

    private Integer voteIsDel;

    private Date voteDate;

    private Date updateDate;

    private String activityName;

    private String  voteDescribe;

    private String voteCoverImgUrl;

    private List<CmsActivityVoteRelevance> relateList;

    public String getVoteId() {
        return voteId;
    }

    public void setVoteId(String voteId) {
        this.voteId = voteId == null ? null : voteId.trim();
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId == null ? null : activityId.trim();
    }

    public String getVoteTitel() {
        return voteTitel;
    }

    public void setVoteTitel(String voteTitel) {
        this.voteTitel = voteTitel == null ? null : voteTitel.trim();
    }

    public Integer getVoteIsDel() {
        return voteIsDel;
    }

    public void setVoteIsDel(Integer voteIsDel) {
        this.voteIsDel = voteIsDel;
    }

    public Date getVoteDate() {
        return voteDate;
    }

    public void setVoteDate(Date voteDate) {
        this.voteDate = voteDate;
    }

    public Date getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Date updateDate) {
        this.updateDate = updateDate;
    }

    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName;
    }

    public String getVoteDescribe() {
        return voteDescribe;
    }

    public void setVoteDescribe(String voteDescribe) {
        this.voteDescribe = voteDescribe;
    }

    public String getVoteCoverImgUrl() {
        return voteCoverImgUrl;
    }

    public void setVoteCoverImgUrl(String voteCoverImgUrl) {
        this.voteCoverImgUrl = voteCoverImgUrl;
    }

    public List<CmsActivityVoteRelevance> getRelateList() {
        return relateList;
    }

    public void setRelateList(List<CmsActivityVoteRelevance> relateList) {
        this.relateList = relateList;
    }
}