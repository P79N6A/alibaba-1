package com.sun3d.ticketGdfs.entity;

/**
 * 活动验证
 * **/
public class VerificationInfo {
	
	private String orderNumber;  	//订单号
	private String state; 			//验证状态֤
	private String activityTitle;	//活动标题
	private String address;			//地点ַ
	private String screenings;		//场次
	private String seat;			//座位
	private String number;			//人数
	private String ticketCode;		//取票码
	private String phoneNumber;		//手机号码
	private String seatStatus;		//单个座位状态
	
	
	public String getSeatStatus() {
		return seatStatus;
	}
	public void setSeatStatus(String seatStatus) {
		this.seatStatus = seatStatus;
	}
	public VerificationInfo(){
		
	}
	public String getOrderNumber() {
		return orderNumber;
	}
	public void setOrderNumber(String orderNumber) {
		this.orderNumber = orderNumber;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getActivityTitle() {
		return activityTitle;
	}
	public void setActivityTitle(String activityTitle) {
		this.activityTitle = activityTitle;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getScreenings() {
		return screenings;
	}
	public void setScreenings(String screenings) {
		this.screenings = screenings;
	}
	public String getSeat() {
		return seat;
	}
	public void setSeat(String seat) {
		this.seat = seat;
	}
	public String getNumber() {
		return number;
	}
	public void setNumber(String number) {
		this.number = number;
	}
	public String getTicketCode() {
		return ticketCode;
	}
	public void setTicketCode(String ticketCode) {
		this.ticketCode = ticketCode;
	}
	public String getPhoneNumber() {
		return phoneNumber;
	}
	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
	@Override
	public String toString() {
		return "VerificationInfo [orderNumber=" + orderNumber + ", state="
				+ state + ", activityTitle=" + activityTitle + ", address="
				+ address + ", screenings=" + screenings + ", seat=" + seat
				+ ", number=" + number + ", ticketCode=" + ticketCode
				+ ", phoneNumber=" + phoneNumber + ", seatStatus=" + seatStatus
				+ "]";
	}
	

}
