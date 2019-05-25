package com.sun3d.ticketGdfs.entity;

/**
 * 活动室实体类
 * */
public class VeriVenueInfo {
	
	private String roomOrderNo;  	//订单号
	private String bookStatus; 			//验证状态
	private String venueName;			//场馆
	private String venueAddress;		//地点
	private String roomName;		//活动室名称
	private String curDate;			//开放日期
	private String openPeriod;		//活动室使用时间
	private String tuserTeamName;		//活动室使用团体
	private String validCode;		//取票码
	private String orderTel;		//手机号码
	private String orderIds;		//场次ID
	private String orderStatus;		//订单场次的状态
	private String roomOderId;		//活动室订单
	
	public String getRoomOderId() {
		return roomOderId;
	}
	public void setRoomOderId(String roomOderId) {
		this.roomOderId = roomOderId;
	}
	public String getRoomOrderNo() {
		return roomOrderNo;
	}
	public void setRoomOrderNo(String roomOrderNo) {
		this.roomOrderNo = roomOrderNo;
	}
	public String getBookStatus() {
		return bookStatus;
	}
	public void setBookStatus(String bookStatus) {
		this.bookStatus = bookStatus;
	}
	public String getVenueName() {
		return venueName;
	}
	public void setVenueName(String venueName) {
		this.venueName = venueName;
	}
	public String getVenueAddress() {
		return venueAddress;
	}
	public void setVenueAddress(String venueAddress) {
		this.venueAddress = venueAddress;
	}
	public String getRoomName() {
		return roomName;
	}
	public void setRoomName(String roomName) {
		this.roomName = roomName;
	}
	public String getCurDate() {
		return curDate;
	}
	public void setCurDate(String curDate) {
		this.curDate = curDate;
	}
	public String getOpenPeriod() {
		return openPeriod;
	}
	public void setOpenPeriod(String openPeriod) {
		this.openPeriod = openPeriod;
	}
	public String getTuserTeamName() {
		return tuserTeamName;
	}
	public void setTuserTeamName(String tuserTeamName) {
		this.tuserTeamName = tuserTeamName;
	}
	public String getValidCode() {
		return validCode;
	}
	public void setValidCode(String validCode) {
		this.validCode = validCode;
	}
	public String getOrderTel() {
		return orderTel;
	}
	public void setOrderTel(String orderTel) {
		this.orderTel = orderTel;
	}
	public String getOrderIds() {
		return orderIds;
	}
	public void setOrderIds(String orderIds) {
		this.orderIds = orderIds;
	}
	public String getOrderStatus() {
		return orderStatus;
	}
	public void setOrderStatus(String orderStatus) {
		this.orderStatus = orderStatus;
	}
	@Override
	public String toString() {
		return "VeriVenueInfo [roomOrderNo=" + roomOrderNo + ", bookStatus="
				+ bookStatus + ", venueName=" + venueName + ", venueAddress="
				+ venueAddress + ", roomName=" + roomName + ", curDate="
				+ curDate + ", openPeriod=" + openPeriod + ", tuserTeamName="
				+ tuserTeamName + ", validCode=" + validCode + ", orderTel="
				+ orderTel + ", orderIds=" + orderIds + ", orderStatus="
				+ orderStatus + ", roomOderId=" + roomOderId + "]";
	}

}
