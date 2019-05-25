package com.culturecloud.model.request.live;

import java.util.Date;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BasePageRequest;

public class CcpLiveMessagePageVO  extends BasePageRequest{

	private Integer messageIsTop;
	
	@NotNull(message = "直播活动不能为空")
	private String messageActivity;
	
	private Integer messageIsInteraction;
	
	private Integer messageIsRecommend;
	
	private String messageCreateUser;
	
	private Long resultStartTime;
	
	private Long resultEndTime;
	
	private Integer liveStatus;

	public Integer getMessageIsTop() {
		return messageIsTop;
	}

	public void setMessageIsTop(Integer messageIsTop) {
		this.messageIsTop = messageIsTop;
	}

	public String getMessageActivity() {
		return messageActivity;
	}

	public void setMessageActivity(String messageActivity) {
		this.messageActivity = messageActivity;
	}

	public Integer getMessageIsInteraction() {
		return messageIsInteraction;
	}

	public void setMessageIsInteraction(Integer messageIsInteraction) {
		this.messageIsInteraction = messageIsInteraction;
	}

	public Integer getMessageIsRecommend() {
		return messageIsRecommend;
	}

	public void setMessageIsRecommend(Integer messageIsRecommend) {
		this.messageIsRecommend = messageIsRecommend;
	}

	public String getMessageCreateUser() {
		return messageCreateUser;
	}

	public void setMessageCreateUser(String messageCreateUser) {
		this.messageCreateUser = messageCreateUser;
	}

	public Long getResultStartTime() {
		return resultStartTime;
	}

	public void setResultStartTime(Long resultStartTime) {
		this.resultStartTime = resultStartTime;
	}

	public Long getResultEndTime() {
		return resultEndTime;
	}

	public void setResultEndTime(Long resultEndTime) {
		this.resultEndTime = resultEndTime;
	}

	public Integer getLiveStatus() {
		return liveStatus;
	}

	public void setLiveStatus(Integer liveStatus) {
		this.liveStatus = liveStatus;
	}


	
}


