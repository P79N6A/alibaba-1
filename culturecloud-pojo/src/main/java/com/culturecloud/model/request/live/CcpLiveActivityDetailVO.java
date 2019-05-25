package com.culturecloud.model.request.live;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class CcpLiveActivityDetailVO extends BaseRequest{

	@NotNull(message = "直播ID不能为空")
    private String liveActivityId;

	public String getLiveActivityId() {
		return liveActivityId;
	}

	public void setLiveActivityId(String liveActivityId) {
		this.liveActivityId = liveActivityId;
	}
	
	
}
