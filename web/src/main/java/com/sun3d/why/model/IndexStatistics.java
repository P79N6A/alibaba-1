package com.sun3d.why.model;

import java.util.Date;

public class IndexStatistics {
    private String area;

    private Integer statisticsCount;

    private Integer statisticsType;

    private Date statisticsTime;
    
    /***************************************************************************/
    
    //活动所在市
    private String activityCity;
    //活动所在区
    private String activityArea;
    //场馆
 	private String venueId;
 	//部门
 	private String venueDeptId;
    //创建时间
    private String activityCreateTime;
    
    //场馆名
    private String venueName;
    //活动发布数
    private Integer activityCount;
    //馆均活动发布数
    private String averageActivityCount;
    //可预约活动数
    private Integer reserveActivityCount;
    //可预约活动比例
    private String reserveActivityProportion;
    //可预约活动室数
    private Integer reserveActivityRoomCount;
    
    
    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area == null ? null : area.trim();
    }

    public Integer getStatisticsCount() {
        return statisticsCount;
    }

    public void setStatisticsCount(Integer statisticsCount) {
        this.statisticsCount = statisticsCount;
    }

    public Integer getStatisticsType() {
        return statisticsType;
    }

    public void setStatisticsType(Integer statisticsType) {
        this.statisticsType = statisticsType;
    }

    public Date getStatisticsTime() {
        return statisticsTime;
    }

    public void setStatisticsTime(Date statisticsTime) {
        this.statisticsTime = statisticsTime;
    }

	public String getActivityCity() {
		return activityCity;
	}

	public void setActivityCity(String activityCity) {
		this.activityCity = activityCity;
	}

	public String getActivityArea() {
		return activityArea;
	}

	public void setActivityArea(String activityArea) {
		this.activityArea = activityArea;
	}

	public String getVenueId() {
		return venueId;
	}

	public void setVenueId(String venueId) {
		this.venueId = venueId;
	}

	public String getActivityCreateTime() {
		return activityCreateTime;
	}

	public void setActivityCreateTime(String activityCreateTime) {
		this.activityCreateTime = activityCreateTime;
	}

	public Integer getActivityCount() {
		return activityCount;
	}

	public void setActivityCount(Integer activityCount) {
		this.activityCount = activityCount;
	}

	public String getAverageActivityCount() {
		return averageActivityCount;
	}

	public void setAverageActivityCount(String averageActivityCount) {
		this.averageActivityCount = averageActivityCount;
	}

	public Integer getReserveActivityCount() {
		return reserveActivityCount;
	}

	public void setReserveActivityCount(Integer reserveActivityCount) {
		this.reserveActivityCount = reserveActivityCount;
	}

	public String getReserveActivityProportion() {
		return reserveActivityProportion;
	}

	public void setReserveActivityProportion(String reserveActivityProportion) {
		this.reserveActivityProportion = reserveActivityProportion;
	}

	public Integer getReserveActivityRoomCount() {
		return reserveActivityRoomCount;
	}

	public void setReserveActivityRoomCount(Integer reserveActivityRoomCount) {
		this.reserveActivityRoomCount = reserveActivityRoomCount;
	}

	public String getVenueName() {
		return venueName;
	}

	public void setVenueName(String venueName) {
		this.venueName = venueName;
	}

	public String getVenueDeptId() {
		return venueDeptId;
	}

	public void setVenueDeptId(String venueDeptId) {
		this.venueDeptId = venueDeptId;
	}
    
}