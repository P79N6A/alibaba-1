package com.sun3d.why.model;

import java.io.Serializable;
import java.util.Date;


/**
 * @author  yjb
 */
public class ActivityCircleStatistics implements Serializable{
    private String area;

    private String activityCircle;

    private String circleName;

    private Double percentage;

    private Date statisticsTime;

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getActivityCircle() {
        return activityCircle;
    }

    public void setActivityCircle(String activityCircle) {
        this.activityCircle = activityCircle == null ? null : activityCircle.trim();
    }

    public String getCircleName() {
        return circleName;
    }

    public void setCircleName(String circleName) {
        this.circleName = circleName == null ? null : circleName.trim();
    }

    public Double getPercentage() {
        return percentage;
    }

    public void setPercentage(Double percentage) {
        this.percentage = percentage;
    }

    public Date getStatisticsTime() {
        return statisticsTime;
    }

    public void setStatisticsTime(Date statisticsTime) {
        this.statisticsTime = statisticsTime;
    }
}