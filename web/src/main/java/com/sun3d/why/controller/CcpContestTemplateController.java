package com.sun3d.why.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sun3d.why.dao.dto.CcpContestTemplateDto;
import com.sun3d.why.service.CcpContestTemplateService;

@Controller
@RequestMapping("/contestTemplate")
public class CcpContestTemplateController {
	
	@Autowired
	private CcpContestTemplateService ccpContestTemplateService;

	@RequestMapping("/selectTemplate")
	public String selectTemplate(String templateId,HttpServletRequest request) {
		
		List<CcpContestTemplateDto> list=ccpContestTemplateService.selectTemplate();
		
		request.setAttribute("list", list);
		
		request.setAttribute("templateId", templateId);

		return "admin/contestQuiz/templateSelect";
	}
}
