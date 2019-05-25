package com.culturecloud.model.request.live;

import com.culturecloud.bean.BasePageRequest;

public class CcpLiveActivityPageVO extends BasePageRequest{

	private String liveActivityId;
	
	private String liveCreateUser;
	
	// 直播活动状态 1.正在直播 2.尚未开始 3.已结束
	private Integer liveActivityTimeStatus;
	
	// 直播状态 0.未发布 1.已发布 
	private Integer liveStatus;
	
	private Integer liveType;
	
	private Integer liveCheck;

	public String getLiveCreateUser() {
		return liveCreateUser;
	}

	public void setLiveCreateUser(String liveCreateUser) {
		this.liveCreateUser = liveCreateUser;
	}

	public Integer getLiveActivityTimeStatus() {
		return liveActivityTimeStatus;
	}

	public void setLiveActivityTimeStatus(Integer liveActivityTimeStatus) {
		this.liveActivityTimeStatus = liveActivityTimeStatus;
	}

	public Integer getLiveStatus() {
		return liveStatus;
	}

	public void setLiveStatus(Integer liveStatus) {
		this.liveStatus = liveStatus;
	}

	public Integer getLiveType() {
		return liveType;
	}

	public void setLiveType(Integer liveType) {
		this.liveType = liveType;
	}

	public String getLiveActivityId() {
		return liveActivityId;
	}

	public void setLiveActivityId(String liveActivityId) {
		this.liveActivityId = liveActivityId;
	}

	public Integer getLiveCheck() {
		return liveCheck;
	}

	public void setLiveCheck(Integer liveCheck) {
		this.liveCheck = liveCheck;
	}
	
	

}
