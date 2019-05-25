package com.sun3d.why.dao.dto;

import com.culturecloud.model.bean.live.CcpLiveActivity;

public class CcpLiveActivityDto extends CcpLiveActivity {

	private static final long serialVersionUID = 3779135851954233309L;

	// 直播活动状态 0.不限 1.正在直播 2.尚未开始 3.已结束
	private Integer liveActivityTimeStatus;
	
	private String userName;
	
	private String userHeadImgUrl;

	public Integer getLiveActivityTimeStatus() {
		return liveActivityTimeStatus;
	}

	public void setLiveActivityTimeStatus(Integer liveActivityTimeStatus) {
		this.liveActivityTimeStatus = liveActivityTimeStatus;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserHeadImgUrl() {
		return userHeadImgUrl;
	}

	public void setUserHeadImgUrl(String userHeadImgUrl) {
		this.userHeadImgUrl = userHeadImgUrl;
	}
	
	
}
