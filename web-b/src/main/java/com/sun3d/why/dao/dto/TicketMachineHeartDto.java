package com.sun3d.why.dao.dto;

import com.culturecloud.model.bean.ticketmachine.TicketMachineHeart;

public class TicketMachineHeartDto extends TicketMachineHeart{

	
	private static final long serialVersionUID = -9117579899056616224L;

	private String orderNumber;
	private String activityName;
	private Integer ticketCount;
	public String getOrderNumber() {
		return orderNumber;
	}
	public void setOrderNumber(String orderNumber) {
		this.orderNumber = orderNumber;
	}
	public String getActivityName() {
		return activityName;
	}
	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}
	public Integer getTicketCount() {
		return ticketCount;
	}
	public void setTicketCount(Integer ticketCount) {
		this.ticketCount = ticketCount;
	}
	
	
	
	
}
