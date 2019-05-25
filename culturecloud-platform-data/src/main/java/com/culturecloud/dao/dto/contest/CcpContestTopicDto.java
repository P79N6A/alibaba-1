package com.culturecloud.dao.dto.contest;

import java.util.Date;

import com.culturecloud.model.bean.contest.CcpContestTopic;

public class CcpContestTopicDto extends CcpContestTopic{
	
	private static final long serialVersionUID = 3337050695822978817L;

	private String templateName;
	private String coverImgUrl;
	private String backgroundImgUrl;
	private Integer templateIsSystem;
	
	
	public String getTemplateName() {
		return templateName;
	}
	public void setTemplateName(String templateName) {
		this.templateName = templateName;
	}
	public String getCoverImgUrl() {
		return coverImgUrl;
	}
	public void setCoverImgUrl(String coverImgUrl) {
		this.coverImgUrl = coverImgUrl;
	}
	public String getBackgroundImgUrl() {
		return backgroundImgUrl;
	}
	public void setBackgroundImgUrl(String backgroundImgUrl) {
		this.backgroundImgUrl = backgroundImgUrl;
	}
	public Integer getTemplateIsSystem() {
		return templateIsSystem;
	}
	public void setTemplateIsSystem(Integer templateIsSystem) {
		this.templateIsSystem = templateIsSystem;
	}
	
	
	
}