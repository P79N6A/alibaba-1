package com.culturecloud.model.response.contest;

public class QuestionShareInfoVO {
	
	//过关称号
	private String passName;
	
	//超越人数
	private String ranking;
	
	// 主题名称
	private String topicName;
	
	// 主题副标题
	private String topicTitle;

	public String getPassName() {
		return passName;
	}

	public void setPassName(String passName) {
		this.passName = passName;
	}

	public String getRanking() {
		return ranking;
	}

	public void setRanking(String ranking) {
		this.ranking = ranking;
	}

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
	
}
