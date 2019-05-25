package com.culturecloud.model.response.contest;

/**
 * @author zhangshun
 *
 */
public class JoinUserInfoVO {

	// 总参与人数
	private Integer totalUserCount;

	// 总完成人数
	private Integer finishUserCount;

	// 当日完成人数
	private Integer todayFinishUserCount;

	public Integer getTotalUserCount() {
		return totalUserCount;
	}

	public void setTotalUserCount(Integer totalUserCount) {
		this.totalUserCount = totalUserCount;
	}

	public Integer getFinishUserCount() {
		return finishUserCount;
	}

	public void setFinishUserCount(Integer finishUserCount) {
		this.finishUserCount = finishUserCount;
	}

	public Integer getTodayFinishUserCount() {
		return todayFinishUserCount;
	}

	public void setTodayFinishUserCount(Integer todayFinishUserCount) {
		this.todayFinishUserCount = todayFinishUserCount;
	}
}
