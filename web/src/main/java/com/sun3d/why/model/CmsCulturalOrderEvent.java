package com.sun3d.why.model;

import java.io.Serializable;
import java.util.Date;

public class CmsCulturalOrderEvent implements Serializable{
	private String culturalOrderEventId;
	private String culturalOrderId;
	private Date culturalOrderEventDate;
	private String culturalOrderEventTime;
	private Integer eventTicketNum;
	
	private Integer usedTicketNum;
	private String culturalOrderEventDateStr;
	private Integer userHasOrder;
	public String getCulturalOrderEventId() {
		return culturalOrderEventId;
	}
	public void setCulturalOrderEventId(String culturalOrderEventId) {
		this.culturalOrderEventId = culturalOrderEventId;
	}
	public String getCulturalOrderId() {
		return culturalOrderId;
	}
	public void setCulturalOrderId(String culturalOrderId) {
		this.culturalOrderId = culturalOrderId;
	}
	public String getCulturalOrderEventTime() {
		return culturalOrderEventTime;
	}
	public void setCulturalOrderEventTime(String culturalOrderEventTime) {
		this.culturalOrderEventTime = culturalOrderEventTime;
	}
	public Integer getEventTicketNum() {
		return eventTicketNum;
	}
	public void setEventTicketNum(Integer eventTicketNum) {
		this.eventTicketNum = eventTicketNum;
	}
	public Date getCulturalOrderEventDate() {
		return culturalOrderEventDate;
	}
	public void setCulturalOrderEventDate(Date culturalOrderEventDate) {
		this.culturalOrderEventDate = culturalOrderEventDate;
	}
	public Integer getUsedTicketNum() {
		return usedTicketNum;
	}
	public void setUsedTicketNum(Integer usedTicketNum) {
		this.usedTicketNum = usedTicketNum;
	}
	public String getCulturalOrderEventDateStr() {
		return culturalOrderEventDateStr;
	}
	public void setCulturalOrderEventDateStr(String culturalOrderEventDateStr) {
		this.culturalOrderEventDateStr = culturalOrderEventDateStr;
	}
	public Integer getUserHasOrder() {
		return userHasOrder;
	}
	public void setUserHasOrder(Integer userHasOrder) {
		this.userHasOrder = userHasOrder;
	}
	
}
