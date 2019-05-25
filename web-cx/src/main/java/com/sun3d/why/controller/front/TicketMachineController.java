package com.sun3d.why.controller.front;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.culturecloud.model.request.ticketmachine.TicketMachineHeartVO;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.util.CallUtils;
import com.sun3d.why.webservice.api.util.HttpResponseText;

@Controller
@RequestMapping("/ticketMachine")
public class TicketMachineController {
	
    @Autowired
    private StaticServer staticServer;

	@RequestMapping("/index")
	public String index(String machineCode,HttpServletRequest request){
		
		if(StringUtils.isNotBlank(machineCode)){
			
			TicketMachineHeartVO vo=new TicketMachineHeartVO();
			
			vo.setMachineCode(machineCode);
			
			HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl()+"ticketMachine/heartBeat",vo);
		}
		
		request.setAttribute("machineCode", machineCode);
		
		return "/index/Ticket-machine";
	}
}
