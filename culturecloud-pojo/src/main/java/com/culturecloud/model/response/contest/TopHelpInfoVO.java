package com.culturecloud.model.response.contest;

/**
 * @author zhangshun
 *
 */
public class TopHelpInfoVO {

	// 总参与人数
	private Integer ranking;

	// 总完成人数
	private String name;

	private String headImg;

	private Integer helpCount;

	public Integer getRanking() {
		return ranking;
	}

	public void setRanking(Integer ranking) {
		this.ranking = ranking;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getHelpCount() {
		return helpCount;
	}

	public void setHelpCount(Integer helpCount) {
		this.helpCount = helpCount;
	}

	public String getHeadImg() {
		return headImg;
	}

	public void setHeadImg(String headImg) {
		this.headImg = headImg;
	}
}
