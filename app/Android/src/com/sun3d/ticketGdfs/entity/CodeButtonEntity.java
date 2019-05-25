/**
 * @author ZhouTanPing E-mail:strong.ping@foxmail.com 
 * @version 创建时间：2015-9-22 下午7:54:47 
 */
package com.sun3d.ticketGdfs.entity;

/**
 * @author zhoutanping
 * 
 * 活动验证的Button实体类
 *
 */
public class CodeButtonEntity {
	
	private String seat;
	private String showSeat;
	private String state;
	private String minorState;
	private String totalState;
	
	
	public String getTotalState() {
		return totalState;
	}
	public void setTotalState(String totalState) {
		this.totalState = totalState;
	}
	public String getSeat() {
		return seat;
	}
	public void setSeat(String seat) {
		this.seat = seat;
	}
	public String getShowSeat() {
		return showSeat;
	}
	public void setShowSeat(String showSeat) {
		this.showSeat = showSeat;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getMinorState() {
		return minorState;
	}
	public void setMinorState(String minorState) {
		this.minorState = minorState;
	}
	@Override
	public String toString() {
		return "CodeButtonEntity [seat=" + seat + ", showSeat=" + showSeat
				+ ", state=" + state + ", minorState=" + minorState
				+ ", totalState=" + totalState + "]";
	}
	
	

}
