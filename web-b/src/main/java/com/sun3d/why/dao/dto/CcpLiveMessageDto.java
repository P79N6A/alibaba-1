package com.sun3d.why.dao.dto;

import com.culturecloud.model.bean.live.CcpLiveMessage;

public class CcpLiveMessageDto extends CcpLiveMessage{

	private String messageCreateUserName;
	
	private String liveActivityName;

	public String getMessageCreateUserName() {
		return messageCreateUserName;
	}

	public void setMessageCreateUserName(String messageCreateUserName) {
		this.messageCreateUserName = messageCreateUserName;
	}

	public String getLiveActivityName() {
		return liveActivityName;
	}

	public void setLiveActivityName(String liveActivityName) {
		this.liveActivityName = liveActivityName;
	}
	
	
}
