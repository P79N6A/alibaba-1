package com.sun3d.why.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.bean.vote.CcpVote;
import com.culturecloud.model.bean.vote.CcpVoteItem;
import com.sun3d.why.dao.dto.CcpVoteItemDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpVoteItemService;
import com.sun3d.why.service.CcpVoteService;
import com.sun3d.why.util.Pagination;

/**
 * @author zhangshun
 *
 */
@RequestMapping("/voteItem")
@Controller
public class CcpVoteItemController {

	@Autowired
	private HttpSession session;

	@Autowired
	private CcpVoteItemService ccpVoteItemService;
	
	@Autowired
	private CcpVoteService ccpVoteService;
	
	@Autowired
	private StaticServer staticServer;

	@RequestMapping("/managerVoteItem")
	public ModelAndView managerVoteItem(@RequestParam String voteId, Pagination page) {

		ModelAndView model = new ModelAndView();

		List<CcpVoteItemDto> ccpVoteItemlist = ccpVoteItemService.queryCcpVoteItems(voteId, page);

		model.addObject("voteItemList", ccpVoteItemlist);
		model.addObject("page", page);
		model.addObject("voteId", voteId);
		model.setViewName("admin/vote/managerVoteItem");
		return model;
	}

	@RequestMapping("/preAddVoteItem")
	public ModelAndView preAddVoteItem(@RequestParam String voteId) {

		ModelAndView model = new ModelAndView();
		
		CcpVote vote=ccpVoteService.queryCcpVoteById(voteId);
		

		String aliImgUrl = staticServer.getAliImgUrl();

		model.addObject("aliImgUrl", aliImgUrl);

		model.addObject("vote", vote);
		model.addObject("voteId", voteId);
		model.setViewName("admin/vote/addVoteItem");

		return model;
	}

	@RequestMapping("/saveVoteItem")
	@ResponseBody
	public String saveVoteItem(CcpVoteItem voteItem) {

		try {
			SysUser loginUser = (SysUser) session.getAttribute("user");

			if (loginUser == null) {
				return "user";
			}

			ccpVoteItemService.saveCcpVoteItem(voteItem, loginUser);

			return "success";
		} catch (Exception ex) {
			ex.printStackTrace();
			return "error";	
		}
	}

	@RequestMapping("/preEditVoteItem")
	public ModelAndView preEditVoteItem(@RequestParam String voteItemId) {

		ModelAndView model = new ModelAndView();

		CcpVoteItem voteItem = ccpVoteItemService.queryVoteItemById(voteItemId);
		
		CcpVote vote=ccpVoteService.queryCcpVoteById(voteItem.getVoteId());
		
		String aliImgUrl = staticServer.getAliImgUrl();

		model.addObject("aliImgUrl", aliImgUrl);

		model.addObject("vote", vote);
		
		model.addObject("voteItem", voteItem);

		model.setViewName("admin/vote/addVoteItem");
		return model;
	}
}
