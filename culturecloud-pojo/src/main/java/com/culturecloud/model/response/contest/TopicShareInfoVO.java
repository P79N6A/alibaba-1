package com.culturecloud.model.response.contest;


public class TopicShareInfoVO {
	
	// 主题名称
	private String topicName;
	// 主题副标题
	private String topicTitle;
	//通关称号
	private String passName;
	//通关文案
	private String passText;
	//通关排名
	private String ranking;
	

	public String getTopicName() {
		return topicName;
	}

	public void setTopicName(String topicName) {
		this.topicName = topicName;
	}

	public String getTopicTitle() {
		return topicTitle;
	}

	public void setTopicTitle(String topicTitle) {
		this.topicTitle = topicTitle;
	}

	public String getPassName() {
		return passName;
	}

	public void setPassName(String passName) {
		this.passName = passName;
	}

	public String getPassText() {
		return passText;
	}

	public void setPassText(String passText) {
		this.passText = passText;
	}

	public String getRanking() {
		return ranking;
	}

	public void setRanking(String ranking) {
		this.ranking = ranking;
	}

}
