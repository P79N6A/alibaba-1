package com.sun3d.why.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.model.bean.ticketmachine.TicketMachineHeart;
import com.sun3d.why.dao.TicketMachineHeartMapper;
import com.sun3d.why.dao.dto.TicketMachineHeartDto;
import com.sun3d.why.service.TicketMachineHeartService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

@Service
@Transactional
public class TicketMachineHeartServiceImpl implements TicketMachineHeartService {
	
	@Autowired
	private TicketMachineHeartMapper ticketMachineHeartMapper;

	@Override
	public List<TicketMachineHeartDto> searchTicketMachineHeartList(TicketMachineHeart ticketMachineHeart,
			Pagination page) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
        if (ticketMachineHeart != null && StringUtils.isNotBlank(ticketMachineHeart.getMachineCode())) {
            map.put("machineCode", ticketMachineHeart.getMachineCode().trim());
        }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
        }
        int total = ticketMachineHeartMapper.searchTicketMachineHeartCount(map);
        //设置分页的总条数来获取总页数
        page.setTotal(total);
        return ticketMachineHeartMapper.searchTicketMachineHeartList(map);
	}

	@Override
	public List<TicketMachineHeartDto> getAllTicketMachine() {
		
		return ticketMachineHeartMapper.getAllTicketMachine();
	}

}
