package com.sun3d.why.model.temp;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;

public class ActivityForCompare extends Pagination implements Serializable {

    private String activityId;

    private String activityName;

    //数据库可以预定的余票
    private Integer dataBaseCount;

    //redis可以预定的余票
    private Integer redisCount;

    //同步后可以预定的票数
    private Integer rightCount;

    //放票总数量
    private Integer totalCount;

    //有效的订单总票数
    private Integer bookCount;

    //入座方式
    private String type;

    // 场次时间
    private String eventDateTime;

    //场次id
    private String eventId;


    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }

    public String getEventDateTime() {
        return eventDateTime;
    }

    public void setEventDateTime(String eventDateTime) {
        this.eventDateTime = eventDateTime;
    }



    public Integer getBookCount() {
        return bookCount;
    }

    public void setBookCount(Integer bookCount) {
        this.bookCount = bookCount;
    }

    public Integer getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(Integer totalCount) {
        this.totalCount = totalCount;
    }

    public Integer getRightCount() {
        return rightCount;
    }

    public void setRightCount(Integer rightCount) {
        this.rightCount = rightCount;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName;
    }

    public Integer getDataBaseCount() {
        return dataBaseCount;
    }

    public void setDataBaseCount(Integer dataBaseCount) {
        this.dataBaseCount = dataBaseCount;
    }

    public Integer getRedisCount() {
        return redisCount;
    }

    public void setRedisCount(Integer redisCount) {
        this.redisCount = redisCount;
    }
}