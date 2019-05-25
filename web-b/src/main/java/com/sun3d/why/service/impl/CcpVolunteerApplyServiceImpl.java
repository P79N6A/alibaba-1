package com.sun3d.why.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.model.bean.volunteer.CcpVolunteerApply;
import com.sun3d.why.dao.CcpVolunteerApplyMapper;
import com.sun3d.why.dao.dto.CcpVolunteerApplyDto;
import com.sun3d.why.service.CcpVolunteerApplyService;
import com.sun3d.why.util.Pagination;

@Service
@Transactional
public class CcpVolunteerApplyServiceImpl implements CcpVolunteerApplyService{
	
	@Autowired
	private CcpVolunteerApplyMapper ccpVolunteerApplyMapper;

	@Override
	public List<CcpVolunteerApplyDto> queryCcpVolunteerApply(CcpVolunteerApply volunteerApply, Pagination page) {

		  Map<String, Object> map = new HashMap<String, Object>();
		  
	        if (page != null) {
	        	
	        	int total=ccpVolunteerApplyMapper.queryCcpVolunteerApplyByMap(map).size();
	        	
	        	page.setTotal(total);
	        	
	            map.put("firstResult",page.getFirstResult());
	            map.put("rows",page.getRows());
	        }
	        return ccpVolunteerApplyMapper.queryCcpVolunteerApplyByMap(map);
	}

}
