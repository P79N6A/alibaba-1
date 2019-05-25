/**
 * @author ZhouTanPing E-mail:strong.ping@foxmail.com 
 * @version 创建时间：2015-9-23 下午4:01:53 
 */
package com.sun3d.ticketGdfs.entity;

/**
 * @author zhoutanping
 * 活动室，单个验证按钮实体类
 *
 */
public class VenueCodeButtonEntity {
	
	private String roomNames;
	private String orderIds;
	private String curDates;
	private String openPeriods;
	private String bookStatus;
	private String minorState;
	
	public String getMinorState() {
		return minorState;
	}
	public void setMinorState(String minorState) {
		this.minorState = minorState;
	}
	public String getRoomNames() {
		return roomNames;
	}
	public void setRoomNames(String roomNames) {
		this.roomNames = roomNames;
	}
	public String getOrderIds() {
		return orderIds;
	}
	public void setOrderIds(String orderIds) {
		this.orderIds = orderIds;
	}
	public String getCurDates() {
		return curDates;
	}
	public void setCurDates(String curDates) {
		this.curDates = curDates;
	}
	public String getOpenPeriods() {
		return openPeriods;
	}
	public void setOpenPeriods(String openPeriods) {
		this.openPeriods = openPeriods;
	}
	public String getBookStatus() {
		return bookStatus;
	}
	public void setBookStatus(String bookStatus) {
		this.bookStatus = bookStatus;
	}
	@Override
	public String toString() {
		return "VenueCodeButtonEntity [roomNames=" + roomNames + ", orderIds="
				+ orderIds + ", curDates=" + curDates + ", openPeriods="
				+ openPeriods + ", bookStatus=" + bookStatus + ", minorState="
				+ minorState + "]";
	}

}
