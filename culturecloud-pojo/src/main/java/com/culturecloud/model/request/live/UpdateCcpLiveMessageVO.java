package com.culturecloud.model.request.live;

import java.util.Date;

import javax.persistence.Column;
import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class UpdateCcpLiveMessageVO extends BaseRequest{

	@NotNull(message = "直播内容ID不能为空")
	private String messageId;
	
	private String messageContent;

	private Integer messageIsTop;

	private Integer messageIsDel;

	private String messageVideo;

	private String messageImg;
	
	private Integer messageIsInteraction;

	private Integer messageIsRecommend;
	
	private String messageVideoImg;

	public String getMessageId() {
		return messageId;
	}

	public void setMessageId(String messageId) {
		this.messageId = messageId;
	}

	public String getMessageContent() {
		return messageContent;
	}

	public void setMessageContent(String messageContent) {
		this.messageContent = messageContent;
	}

	public Integer getMessageIsTop() {
		return messageIsTop;
	}

	public void setMessageIsTop(Integer messageIsTop) {
		this.messageIsTop = messageIsTop;
	}

	public Integer getMessageIsDel() {
		return messageIsDel;
	}

	public void setMessageIsDel(Integer messageIsDel) {
		this.messageIsDel = messageIsDel;
	}

	public String getMessageVideo() {
		return messageVideo;
	}

	public void setMessageVideo(String messageVideo) {
		this.messageVideo = messageVideo;
	}

	public String getMessageImg() {
		return messageImg;
	}

	public void setMessageImg(String messageImg) {
		this.messageImg = messageImg;
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

	public String getMessageVideoImg() {
		return messageVideoImg;
	}

	public void setMessageVideoImg(String messageVideoImg) {
		this.messageVideoImg = messageVideoImg;
	}
	
	
}
