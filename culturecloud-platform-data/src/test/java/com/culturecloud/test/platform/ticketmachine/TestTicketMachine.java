package com.culturecloud.test.platform.ticketmachine;

import org.junit.Test;

import com.culturecloud.model.request.ticketmachine.TicketMachineHeartVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestTicketMachine extends TestRestService{

	@Test
	public void heartBeat()
	{
		TicketMachineHeartVO o=new TicketMachineHeartVO();
		o.setMachineCode("FX-01");
		System.out.println(HttpRequest.sendPost(BASE_URL+"/ticketMachine/heartBeat", o));
	}
}
