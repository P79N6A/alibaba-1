package com.sun3d.why.model;

public class CmsSuperOrderActivity {
    private String activityId;
    
    private String userId;

    //虚拟属性
    private String activityName;
    
    private String activityStartTime;
    
    private String activityEndTime;
    
    private Integer availableCount;
    
    private Integer activityIsPast;
    
    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId == null ? null : activityId.trim();
    }

	public String getActivityName() {
		return activityName;
	}

	public void setActivityName(String activityName) {
		this.activityName = activityName;
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

	public Integer getAvailableCount() {
		return availableCount;
	}

	public void setAvailableCount(Integer availableCount) {
		this.availableCount = availableCount;
	}

	public Integer getActivityIsPast() {
		return activityIsPast;
	}

	public void setActivityIsPast(Integer activityIsPast) {
		this.activityIsPast = activityIsPast;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}
    
}