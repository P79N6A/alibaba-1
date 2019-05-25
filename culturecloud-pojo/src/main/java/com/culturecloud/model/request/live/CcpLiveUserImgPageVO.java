package com.culturecloud.model.request.live;


import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BasePageRequest;

public class CcpLiveUserImgPageVO extends BasePageRequest {

	private String userId;
	
	@NotNull(message = "直播活动不能为空")
	private String liveActivity;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getLiveActivity() {
		return liveActivity;
	}

	public void setLiveActivity(String liveActivity) {
		this.liveActivity = liveActivity;
	}

	
}
