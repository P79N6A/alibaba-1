package com.culturecloud.service.rs.platformservice.vote;

import java.util.Date;
import java.util.List;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.bean.BasePageResultListVO;
import com.culturecloud.dao.common.CmsTerminalUserMapper;
import com.culturecloud.dao.dto.common.CmsTerminalUserDto;
import com.culturecloud.model.bean.common.CmsTerminalUser;
import com.culturecloud.model.bean.vote.CcpVote;
import com.culturecloud.model.bean.vote.CcpVoteUser;
import com.culturecloud.model.request.vote.CcpVoteDetailVO;
import com.culturecloud.model.request.vote.QueryVoteItemListVO;
import com.culturecloud.model.request.vote.QueryVoteUserVO;
import com.culturecloud.model.request.vote.SaveUserTicketVO;
import com.culturecloud.model.request.vote.SaveVoteUserVO;
import com.culturecloud.model.response.vote.CcpVoteItemVO;
import com.culturecloud.model.response.vote.CcpVoteUserVO;
import com.culturecloud.model.response.vote.CcpVoteVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.service.local.vote.CcpVoteItemService;
import com.culturecloud.service.local.vote.CcpVoteTicketService;

@Component
@Path("/vote")
public class CcpVoteSource {
	
	@Autowired
	private BaseService baseService;
	@Autowired
	private CcpVoteItemService voteItemService;
	@Autowired
	private CcpVoteTicketService voteTicketService;
	@Autowired
	private CmsTerminalUserMapper cmsTerminalUserMapper;

	@POST
	@Path("/voteDtatil")
	@SysBusinessLog(remark="投票项目详情")
	@Produces(MediaType.APPLICATION_JSON)
	public CcpVoteVO voteDtatil(CcpVoteDetailVO request){
		
		String voteId=request.getVoteId();
		
		CcpVote vote=baseService.findById(CcpVote.class, voteId);
		
		return new CcpVoteVO(vote);
	}
	
	
	@POST
	@Path("/voteItemList")
	@SysBusinessLog(remark="投票项目选项列表")
	@Produces(MediaType.APPLICATION_JSON)
	public BasePageResultListVO<CcpVoteItemVO> voteItemList(QueryVoteItemListVO request){
		
		return voteItemService.queryVoteItemList(request);
		
	}
	
	@POST
	@Path("/saveUserTicket")
	@SysBusinessLog(remark="投票项目用户投票")
	@Produces(MediaType.APPLICATION_JSON)
	public String saveUserTicket(SaveUserTicketVO request){
		
		String userId=request.getUserId();
		
		String voteItemId=request.getVoteItemId();
		
		return voteTicketService.saveCcpVoteTicket(userId, voteItemId);
		
	}
	
	@POST
	@Path("/queryVoteUser")
	@SysBusinessLog(remark="获取投票用户信息")
	@Produces(MediaType.APPLICATION_JSON)
	public CcpVoteUserVO queryVoteUser(QueryVoteUserVO request){
		
		String userId=request.getUserId();
		
		CcpVoteUser model=new CcpVoteUser();
		model.setUserId(userId);
		
		List<CcpVoteUser> userList=baseService.findByModel(model);
		
		CcpVoteUserVO vo=new CcpVoteUserVO();
		
		if(userList.size()>0)
			vo=new CcpVoteUserVO(userList.get(0));
		
		return vo;
	}
	
	@POST
	@Path("/saveVoteUser")
	@SysBusinessLog(remark="保存投票用户信息")
	@Produces(MediaType.APPLICATION_JSON)
	public void saveVoteUser(SaveVoteUserVO request){
		
		String userId=request.getUserId();
		
		CcpVoteUser model=new CcpVoteUser();
		model.setUserId(userId);
		
		List<CcpVoteUser> userList=baseService.findByModel(model);
		
		CcpVoteUser user=null;
		
		if(userList.size()==0){
			user=new CcpVoteUser();
			
			user.setUserId(userId);
			user.setUserName(request.getUserName());
			user.setUserMobile(request.getUserMobile());
			user.setCreateTime(new Date());
			baseService.create(user);
		}
		else
		{
			user=userList.get(0);
			user.setUserName(request.getUserName());
			user.setUserMobile(request.getUserMobile());
			baseService.update(user, "where user_id='"+userId+"'");
		}
		CmsTerminalUser cmsTerminalUser=new CmsTerminalUser();
		
		cmsTerminalUser.setUserId(user.getUserId());
		cmsTerminalUser.setUserTelephone(user.getUserMobile());
		cmsTerminalUser.setUserNickName(user.getUserName());
		
		cmsTerminalUserMapper.editTerminalUserById(cmsTerminalUser);
		
	}
	
}
