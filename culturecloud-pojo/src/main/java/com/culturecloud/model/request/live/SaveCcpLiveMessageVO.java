package com.culturecloud.model.request.live;

import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class SaveCcpLiveMessageVO extends BaseRequest{

	
	private String messageContent;
	
	private String messageImg;
	
	private String messageVideo;
	
	@NotNull(message = "直播ID不能为空")
	private String messageActivity;
	
	@NotNull(message = "直播内容创建人不能为空")
	private String messageCreateUser;
	
	private Integer messageIsInteraction;
	
	private String messageVideoImg;

	public String getMessageContent() {
		return messageContent;
	}

	public void setMessageContent(String messageContent) {
		this.messageContent = messageContent;
	}

	public String getMessageImg() {
		return messageImg;
	}

	public void setMessageImg(String messageImg) {
		this.messageImg = messageImg;
	}

	public String getMessageVideo() {
		return messageVideo;
	}

	public void setMessageVideo(String messageVideo) {
		this.messageVideo = messageVideo;
	}

	public String getMessageActivity() {
		return messageActivity;
	}

	public void setMessageActivity(String messageActivity) {
		this.messageActivity = messageActivity;
	}

	public String getMessageCreateUser() {
		return messageCreateUser;
	}

	public void setMessageCreateUser(String messageCreateUser) {
		this.messageCreateUser = messageCreateUser;
	}

	public Integer getMessageIsInteraction() {
		return messageIsInteraction;
	}

	public void setMessageIsInteraction(Integer messageIsInteraction) {
		this.messageIsInteraction = messageIsInteraction;
	}

	public String getMessageVideoImg() {
		return messageVideoImg;
	}

	public void setMessageVideoImg(String messageVideoImg) {
		this.messageVideoImg = messageVideoImg;
	}
	
	
	
}
