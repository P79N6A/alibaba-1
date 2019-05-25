package com.culturecloud.dao.dto.openrs;

public class UserCollectDTO {

	public String collectId;
	
	public String type;//场馆-1 活动-2 藏品-3 团体-4

	public String getCollectId() {
		return collectId;
	}

	public void setCollectId(String collectId) {
		this.collectId = collectId;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	
}
