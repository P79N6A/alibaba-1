package com.culturecloud.model.response.contest;

import com.culturecloud.model.bean.contest.CcpContestTopic;

public class CcpContestTopicVO extends CcpContestTopic{
	
	private static final long serialVersionUID = -2439483501286758260L;
	
	private String templateName;
	private String coverImgUrl;
	private String backgroundImgUrl;
	private Integer templateIsSystem;
	
	public CcpContestTopicVO() {
	}

	public CcpContestTopicVO(CcpContestTopic ccpContestTopic) {
		
		this.setTopicId(ccpContestTopic.getTopicId());
		this.setTopicName(ccpContestTopic.getTopicName());
		this.setTopicTitle(ccpContestTopic.getTopicTitle());
		this.setIsLevelup(ccpContestTopic.getIsLevelup());
		this.setPassName(ccpContestTopic.getPassName());
		this.setPassText(ccpContestTopic.getPassText());
		this.setTopicStatus(ccpContestTopic.getTopicStatus());
		this.setCreateTime(ccpContestTopic.getCreateTime());
		this.setUpdateTime(ccpContestTopic.getUpdateTime());
		this.setCreateSysUserId(ccpContestTopic.getCreateSysUserId());
		this.setUpdateSysUserId(ccpContestTopic.getUpdateSysUserId());
		this.setTopicIcon(ccpContestTopic.getTopicIcon());
	}

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
