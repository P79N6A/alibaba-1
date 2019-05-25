package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.ticketmachine.TicketMachineHeart;
import com.sun3d.why.dao.dto.TicketMachineHeartDto;
import com.sun3d.why.util.Pagination;

public interface TicketMachineHeartService {
	
	public List<TicketMachineHeartDto> getAllTicketMachine();

	public List<TicketMachineHeartDto> searchTicketMachineHeartList(TicketMachineHeart ticketMachineHeart,Pagination page);
}
