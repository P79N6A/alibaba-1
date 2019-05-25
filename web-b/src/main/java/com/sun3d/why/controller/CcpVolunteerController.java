package com.sun3d.why.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.bean.volunteer.CcpVolunteerApply;
import com.sun3d.why.dao.dto.CcpVolunteerApplyDto;
import com.sun3d.why.service.CcpVolunteerApplyService;
import com.sun3d.why.util.Pagination;

@RequestMapping("/volunteer")
@Controller
public class CcpVolunteerController {
	
	@Autowired
	private CcpVolunteerApplyService ccpVolunteerApplyService;
	
	/**
	 * 志愿者申请列表
	 * 
	 * @return
	 */
	@RequestMapping("/volunteerApplyIndex")
	public ModelAndView volunteerApplyIndex(CcpVolunteerApply volunteerApply,Pagination page){
		
		 ModelAndView model = new ModelAndView();
		 
		List<CcpVolunteerApplyDto> list= ccpVolunteerApplyService.queryCcpVolunteerApply(volunteerApply, page);
		 
		 model.addObject("list",list);
		
		 model.addObject("page",page);
		 
		 model.setViewName("admin/volunteer/volunteerApplyIndex");
		 
		 return model;
	}
}
