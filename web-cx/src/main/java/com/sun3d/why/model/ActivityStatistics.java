package com.sun3d.why.model;

import java.io.Serializable;
import java.util.Date;

/**
 * @author  yjb
 */
public class ActivityStatistics  implements Serializable {
    private Integer sid;

    private String area;

    private Integer statisticsType;

    private Integer activityCount;

    private Integer preActivityCount;

    private Date statisticsTime;

    private Integer sort;

    private Integer todayPublic;

    private Integer weekPublic;

    private Integer monthPublic;

    private Integer seasonPublic;

    private Integer yearPublic;

    private Integer numLook;

    private Integer numOrder;

    private Integer bookOrder;

    private Integer useOrder;

    private String preOrder;

    private String preUse;

    private String activityArea;

    private String tagName;

    private Integer numActivity;

    private Integer numMessage;

    private String activityName;

    private String activityId;

    private String commentRkId;

    private String commentRemark;

    private Date commentTime;
    //评论人昵称
    private  String commentUserNickName;

    private String commentImgUrl;

    private Integer twoTodayPublic;

    private Integer twoWeekPublic;

    private Integer twoMonthPublic;

    private Integer twoSeasonPublic;

    private Integer twoYearPublic;
    /**
     * 活动开始时间
     */
    private String activityStartTime;

    /**
     * 活动结束时间
     */
    private String activityEndTime;

    private Integer commentCount;


    public Integer getSid() {
        return sid;
    }

    public void setSid(Integer sid) {
        this.sid = sid;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area == null ? null : area.trim();
    }

    public Integer getStatisticsType() {
        return statisticsType;
    }

    public void setStatisticsType(Integer statisticsType) {
        this.statisticsType = statisticsType;
    }

    public Integer getActivityCount() {
        return activityCount;
    }

    public void setActivityCount(Integer activityCount) {
        this.activityCount = activityCount;
    }

    public Integer getPreActivityCount() {
        return preActivityCount;
    }

    public void setPreActivityCount(Integer preActivityCount) {
        this.preActivityCount = preActivityCount;
    }

    public Date getStatisticsTime() {
        return statisticsTime;
    }

    public void setStatisticsTime(Date statisticsTime) {
        this.statisticsTime = statisticsTime;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    public Integer getTodayPublic() {
        return todayPublic;
    }

    public void setTodayPublic(Integer todayPublic) {
        this.todayPublic = todayPublic;
    }

    public Integer getWeekPublic() {
        return weekPublic;
    }

    public void setWeekPublic(Integer weekPublic) {
        this.weekPublic = weekPublic;
    }

    public Integer getMonthPublic() {
        return monthPublic;
    }

    public void setMonthPublic(Integer monthPublic) {
        this.monthPublic = monthPublic;
    }


    public Integer getSeasonPublic() {
        return seasonPublic;
    }

    public void setSeasonPublic(Integer seasonPublic) {
        this.seasonPublic = seasonPublic;
    }

    public Integer getYearPublic() {
        return yearPublic;
    }

    public void setYearPublic(Integer yearPublic) {
        this.yearPublic = yearPublic;
    }

    public Integer getNumLook() {
        return numLook;
    }

    public void setNumLook(Integer numLook) {
        this.numLook = numLook;
    }

    public Integer getNumOrder() {
        return numOrder;
    }

    public void setNumOrder(Integer numOrder) {
        this.numOrder = numOrder;
    }

    public Integer getBookOrder() {
        return bookOrder;
    }

    public void setBookOrder(Integer bookOrder) {
        this.bookOrder = bookOrder;
    }




    public String getActivityArea() {
        return activityArea;
    }

    public void setActivityArea(String activityArea) {
        this.activityArea = activityArea;
    }



    public Integer getNumActivity() {
        return numActivity;
    }

    public void setNumActivity(Integer numActivity) {
        this.numActivity = numActivity;
    }

    public String getTagName() {
        return tagName;
    }

    public void setTagName(String tagName) {
        this.tagName = tagName;
    }

    public Integer getNumMessage() {
        return numMessage;
    }

    public void setNumMessage(Integer numMessage) {
        this.numMessage = numMessage;
    }


    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    public String getCommentRkId() {
        return commentRkId;
    }

    public void setCommentRkId(String commentRkId) {
        this.commentRkId = commentRkId;
    }

    public String getCommentRemark() {
        return commentRemark;
    }

    public void setCommentRemark(String commentRemark) {
        this.commentRemark = commentRemark;
    }

    public Date getCommentTime() {
        return commentTime;
    }

    public void setCommentTime(Date commentTime) {
        this.commentTime = commentTime;
    }

    public String getCommentUserNickName() {
        return commentUserNickName;
    }

    public void setCommentUserNickName(String commentUserNickName) {
        this.commentUserNickName = commentUserNickName;
    }

    public String getCommentImgUrl() {
        return commentImgUrl;
    }

    public void setCommentImgUrl(String commentImgUrl) {
        this.commentImgUrl = commentImgUrl;
    }

    public Integer getTwoTodayPublic() {
        return twoTodayPublic;
    }

    public void setTwoTodayPublic(Integer twoTodayPublic) {
        this.twoTodayPublic = twoTodayPublic;
    }

    public Integer getTwoWeekPublic() {
        return twoWeekPublic;
    }

    public void setTwoWeekPublic(Integer twoWeekPublic) {
        this.twoWeekPublic = twoWeekPublic;
    }

    public Integer getTwoMonthPublic() {
        return twoMonthPublic;
    }

    public void setTwoMonthPublic(Integer twoMonthPublic) {
        this.twoMonthPublic = twoMonthPublic;
    }

    public Integer getTwoSeasonPublic() {
        return twoSeasonPublic;
    }

    public void setTwoSeasonPublic(Integer twoSeasonPublic) {
        this.twoSeasonPublic = twoSeasonPublic;
    }

    public Integer getTwoYearPublic() {
        return twoYearPublic;
    }

    public void setTwoYearPublic(Integer twoYearPublic) {
        this.twoYearPublic = twoYearPublic;
    }

    public String getActivityStartTime() {
        return activityStartTime;
    }

    public void setActivityStartTime(String activityStartTime) {
        this.activityStartTime = activityStartTime;
    }

    public String getActivityEndTime() {
        return activityEndTime;
    }

    public void setActivityEndTime(String activityEndTime) {
        this.activityEndTime = activityEndTime;
    }

    public Integer getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(Integer commentCount) {
        this.commentCount = commentCount;
    }

    public String getPreOrder() {
        return preOrder;
    }

    public void setPreOrder(String preOrder) {
        this.preOrder = preOrder;
    }

    public Integer getUseOrder() {
        return useOrder;
    }

    public void setUseOrder(Integer useOrder) {
        this.useOrder = useOrder;
    }

    public String getPreUse() {
        return preUse;
    }

    public void setPreUse(String preUse) {
        this.preUse = preUse;
    }
}