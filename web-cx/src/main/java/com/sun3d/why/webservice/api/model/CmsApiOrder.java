package com.sun3d.why.webservice.api.model;
/*
**
**@author lijing
**@version 1.0 2015年8月27日 上午9:39:20
*/
public class CmsApiOrder {

	private int code;
	private String msg;
	private String contentId;
	private String sysNo;
	//取票码
	private String orderValidateCode;

	//订单号
	private String orderNumber;
	
	private Integer orderNum;
	private Integer ticketNum;
	private boolean status;
	
	public int getCode() {
		return code;
	}
	public void setCode(int code) {
		this.code = code;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public String getContentId() {
		return contentId;
	}
	public void setContentId(String contentId) {
		this.contentId = contentId;
	}
	
	public Integer getOrderNum() {
		return orderNum;
	}
	public void setOrderNum(Integer orderNum) {
		this.orderNum = orderNum;
	}
	public Integer getTicketNum() {
		return ticketNum;
	}
	public void setTicketNum(Integer ticketNum) {
		this.ticketNum = ticketNum;
	}
	public boolean isStatus() {
		return status;
	}
	public void setStatus(boolean status) {
		this.status = status;
	}
	public String getSysNo() {
		return sysNo;
	}
	public void setSysNo(String sysNo) {
		this.sysNo = sysNo;
	}


	public String getOrderNumber() {
		return orderNumber;
	}

	public void setOrderNumber(String orderNumber) {
		this.orderNumber = orderNumber;
	}

	public String getOrderValidateCode() {
		return orderValidateCode;
	}

	public void setOrderValidateCode(String orderValidateCode) {
		this.orderValidateCode = orderValidateCode;
	}
}
