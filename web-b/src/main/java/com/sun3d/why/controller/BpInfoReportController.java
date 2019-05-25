package com.sun3d.why.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.CmsReport;
import com.sun3d.why.service.BpReportService;
import com.sun3d.why.util.Pagination;

@Controller
@RequestMapping("beipiaoInfoReport")
public class BpInfoReportController {

	@Autowired
	private BpReportService cbpReportService;

	@RequestMapping("reportList")
	public ModelAndView reportList(ModelAndView mv, Pagination page, Model model, String content) {

		CmsReport cmsReport = new CmsReport();
		List<CmsReport> reportList = cbpReportService.queryReportList(cmsReport, content, page);
		model.addAttribute("reportList", reportList);
		model.addAttribute("page", page);
		model.addAttribute("content", content);
		mv.setViewName("admin/beipiaoInfo/reportList");
		return mv;
	}
}
