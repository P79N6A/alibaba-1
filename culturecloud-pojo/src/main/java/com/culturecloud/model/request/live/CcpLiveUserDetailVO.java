package com.culturecloud.model.request.live;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class CcpLiveUserDetailVO extends BaseRequest{

	@NotNull(message = "直播用户id不能为空")
	private String liveUserId;
	
	@NotNull(message = "直播活动不能为空")
	private String liveActivity;

	public String getLiveUserId() {
		return liveUserId;
	}

	public void setLiveUserId(String liveUserId) {
		this.liveUserId = liveUserId;
	}

	public String getLiveActivity() {
		return liveActivity;
	}

	public void setLiveActivity(String liveActivity) {
		this.liveActivity = liveActivity;
	}



	

}
