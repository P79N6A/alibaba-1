package com.sun3d.why.controller;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import scala.collection.mutable.ArrayBuilder.ofBoolean;

import com.culturecloud.model.bean.ticketmachine.TicketMachineHeart;
import com.sun3d.why.dao.dto.TicketMachineHeartDto;
import com.sun3d.why.service.TicketMachineHeartService;
import com.sun3d.why.util.Pagination;

@RequestMapping("/ticketMachine")
@Controller
public class CcpTicketMachineController {

	@Autowired
	private TicketMachineHeartService ticketMachineHeartService;

	@RequestMapping("/list")
	public ModelAndView list(TicketMachineHeart ticketMachineHeart, Pagination page) {
		ModelAndView model = new ModelAndView();
		try {
			
			List<TicketMachineHeartDto> allTicketMachineList=ticketMachineHeartService.getAllTicketMachine();
			
			  if (ticketMachineHeart != null && StringUtils.isNotBlank(ticketMachineHeart.getMachineCode())) {
					
					List<TicketMachineHeartDto> searchList = ticketMachineHeartService
							.searchTicketMachineHeartList(ticketMachineHeart, page);
					model.addObject("list", searchList);
		        }
		
			model.setViewName("admin/ticketMachine/ticketMachineIndex");
			
			model.addObject("allTicketMachineList", allTicketMachineList);
			model.addObject("page", page);
			model.addObject("ticketMachine", ticketMachineHeart);
		} catch (Exception e) {
			e.printStackTrace();
			return model; 
		}
		return model;
	}

}
