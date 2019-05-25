package com.sun3d.why.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.bean.drama.CcpDrama;
import com.culturecloud.model.bean.drama.CcpDramaComment;
import com.sun3d.why.dao.dto.CcpDramaCommentDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpDramaCommentService;
import com.sun3d.why.service.CcpDramaService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

@RequestMapping("/drama")
@Controller
public class CcpDramaCommentController {

	@Autowired
	private CcpDramaCommentService ccpDramaCommentService;
	@Autowired
	private CcpDramaService ccpDramaService;

	@Autowired
	private HttpSession session;

	@RequestMapping("/commentIndex")
	public ModelAndView commentIndex(CcpDramaComment comment, Pagination page) {

		ModelAndView model = new ModelAndView();

		List<CcpDramaCommentDto> list = ccpDramaCommentService.queryDramaCommentByCondition(comment, page);
		model.addObject("list", list);
		model.addObject("page", page);
		model.addObject("entity", comment);
		model.setViewName("admin/drama/commentIndex");

		return model;
	}

	@RequestMapping("/updateDramaComment")
	@ResponseBody
	public String updateDramaComment(CcpDramaComment comment) {

		try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if (sysUser != null) {
				int result = ccpDramaCommentService.updateDramaComment(comment);
				if (result > 0) {
					return Constant.RESULT_STR_SUCCESS;
				} else {
					return Constant.RESULT_STR_FAILURE;
				}
			} else {
				return "login";
			}
		} catch (Exception e) {
			return Constant.RESULT_STR_FAILURE;
		}
	}
	
	@RequestMapping("/dramaSelectList")
	@ResponseBody
	public List<CcpDrama> dramaSelectList(String dramaId){
		
		return ccpDramaService.getAllCcpDrama();
	}
}
