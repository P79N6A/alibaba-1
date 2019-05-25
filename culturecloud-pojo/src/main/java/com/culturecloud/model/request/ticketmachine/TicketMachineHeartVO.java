package com.culturecloud.model.request.ticketmachine;

import com.culturecloud.bean.BaseRequest;

public class TicketMachineHeartVO extends BaseRequest{

	/** 机器编号*/
	private String machineCode;

	public String getMachineCode() {
		return machineCode;
	}

	public void setMachineCode(String machineCode) {
		this.machineCode = machineCode;
	}
	
	
}
