package com.culturecloud.model.response.contest;

import java.util.List;

/**
 * @author zhangshun
 *
 */
public class TopHelpListVO {

	// 个人排名
	private TopHelpInfoVO userRank;

	// 总排名
	private List<TopHelpInfoVO> topRank;

	public TopHelpInfoVO getUserRank() {
		return userRank;
	}

	public void setUserRank(TopHelpInfoVO userRank) {
		this.userRank = userRank;
	}

	public List<TopHelpInfoVO> getTopRank() {
		return topRank;
	}

	public void setTopRank(List<TopHelpInfoVO> topRank) {
		this.topRank = topRank;
	}
}
