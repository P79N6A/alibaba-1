package com.culturecloud.model.bean.ticketmachine;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="ticket_machine_heart")
public class TicketMachineHeart implements BaseEntity{

	private static final long serialVersionUID = -2135928442967772368L;

	/** 主键*/
	@Id
	@Column(name="machine_id")
	private String machineId;
	
	/** 机器编号*/
	@Column(name="machine_code")
	private String machineCode;
	
	/** 时间*/
	@Column(name="date_time")
	private Date dateTime;

	public String getMachineId() {
		return machineId;
	}

	public void setMachineId(String machineId) {
		this.machineId = machineId;
	}

	public String getMachineCode() {
		return machineCode;
	}

	public void setMachineCode(String machineCode) {
		this.machineCode = machineCode;
	}

	public Date getDateTime() {
		return dateTime;
	}

	public void setDateTime(Date dateTime) {
		this.dateTime = dateTime;
	}
	
	
}
