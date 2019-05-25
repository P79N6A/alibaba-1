package com.sun3d.why.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.culturecloud.model.bean.contest.CcpContestTemplate;
import com.culturecloud.model.bean.contest.CcpContestTopic;
import com.culturecloud.model.bean.vote.CcpVote;
import com.culturecloud.model.bean.vote.CcpVoteUser;
import com.sun3d.why.dao.dto.CcpVoteDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpVoteService;
import com.sun3d.why.util.Pagination;

@RequestMapping("/vote")
@Controller
public class CcpVoteController {

	@Autowired
	private CcpVoteService ccpVoteService;

	@Autowired
	private StaticServer staticServer;

	@Autowired
	private HttpSession session;

	@RequestMapping("/voteIndex")
	public ModelAndView voteIndex(CcpVote vote, Pagination page) {

		ModelAndView model = new ModelAndView();
		List<CcpVoteDto> list = null;
		try {
			
			SysUser loginUser = (SysUser)session.getAttribute("user");
        	 
        	 if(loginUser!=null)
        	 {
        		 if(loginUser.getUserIsManger()==null||loginUser.getUserIsManger()!=1)
            	 {
					vote.setVoteCreateUser(loginUser.getUserId());
            	 }
        		 
        			list = ccpVoteService.queryVoteByCondition(vote, page);
        			model.addObject("voteList", list);
        			model.addObject("vote", vote);
        			model.addObject("page", page);
        			model.setViewName("admin/vote/voteIndex");
        	 }
        	 else
           		 model.setViewName("admin/main");
   
		} catch (Exception e) {
			e.printStackTrace();
		}

		return model;
	}

	@RequestMapping("/preAddVote")
	public ModelAndView preAddVote() {

		ModelAndView model = new ModelAndView();
		String aliImgUrl = staticServer.getAliImgUrl();

		model.addObject("aliImgUrl", aliImgUrl);

		model.setViewName("admin/vote/addVote");
		return model;
	}

	@RequestMapping("/preEditVote")
	public ModelAndView preEditVote(@RequestParam String voteId) {

		ModelAndView model = new ModelAndView();

		CcpVote vote = ccpVoteService.queryCcpVoteById(voteId);

		model.addObject("vote", vote);

		String aliImgUrl = staticServer.getAliImgUrl();

		model.addObject("aliImgUrl", aliImgUrl);

		model.setViewName("admin/vote/addVote");
		return model;
	}

	@RequestMapping("/saveVote")
	@ResponseBody
	public String saveVote(CcpVote vote) {

		try {
			SysUser loginUser = (SysUser) session.getAttribute("user");

			if (loginUser == null) {
				return "user";
			}

			int result = ccpVoteService.saveCcpVote(vote, loginUser);

			if (result > 0)
				return "success";
			else
				return "error";
		} catch (Exception ex) {
			ex.printStackTrace();
			return "error";
		}
	}
	/**
	 * 用户信息
	 * @param voteId
	 * @param voteUser
	 * @param page
	 * @return
	 */
	@RequestMapping("/userList")
	public ModelAndView userList(@RequestParam String voteId,CcpVoteUser voteUser,Pagination page){
		ModelAndView model=new ModelAndView();
		List<CcpVoteUser> userList=ccpVoteService.userList(voteId,page,voteUser);
		model.addObject("voteUser", voteUser);
		model.addObject("page",page);
		model.addObject("userList",userList);
		model.addObject("voteId",voteId);
		model.setViewName("admin/vote/userList");
		return model;
	}
	
	

}
