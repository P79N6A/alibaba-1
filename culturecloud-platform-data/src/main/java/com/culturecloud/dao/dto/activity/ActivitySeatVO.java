package com.culturecloud.dao.dto.activity;

public class ActivitySeatVO {
	private String activitySeatId;

    private Long seatPrice;

    private Integer seatStatus;

    private Integer ticket;

    /*private String activityId;*/

    /*private String eventId;*/

    private Integer seatRow;

    private Integer seatColumn;
    
    private Integer seatIsSold;

    /*private String seatArea;*/

    /*private String seatCode;

    private String seatCreateUser;

    private String seatUpdateUser;

    private Date seatCreateTime;

    private Date seatUpdateTime;

    private String seatId;

    private String seatVal;*/

	public String getActivitySeatId() {
		return activitySeatId;
	}

	public void setActivitySeatId(String activitySeatId) {
		this.activitySeatId = activitySeatId;
	}

	public Long getSeatPrice() {
		return seatPrice;
	}

	public void setSeatPrice(Long seatPrice) {
		this.seatPrice = seatPrice;
	}

	public Integer getSeatStatus() {
		return seatStatus;
	}

	public void setSeatStatus(Integer seatStatus) {
		this.seatStatus = seatStatus;
	}

	public Integer getTicket() {
		return ticket;
	}

	public void setTicket(Integer ticket) {
		this.ticket = ticket;
	}

	public Integer getSeatRow() {
		return seatRow;
	}

	public void setSeatRow(Integer seatRow) {
		this.seatRow = seatRow;
	}

	public Integer getSeatColumn() {
		return seatColumn;
	}

	public void setSeatColumn(Integer seatColumn) {
		this.seatColumn = seatColumn;
	}

	public Integer getSeatIsSold() {
		return seatIsSold;
	}

	public void setSeatIsSold(Integer seatIsSold) {
		this.seatIsSold = seatIsSold;
	}

}