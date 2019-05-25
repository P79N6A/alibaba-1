package com.culturecloud.service.rs.platformservice.micronote;

import java.util.List;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.bean.BasePageResultListVO;
import com.culturecloud.model.bean.micronote.CcpMicronote;
import com.culturecloud.model.request.micronote.CcpMicronoteReqVO;
import com.culturecloud.model.request.micronote.CcpMicronoteVoteReqVO;
import com.culturecloud.model.response.micronote.CcpMicronoteResVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.service.local.micronote.CcpMicronoteService;

@Component
@Path("/micronote")
public class CcpMicronoteResource {

	@Resource
	private CcpMicronoteService ccpMicronoteService;
	@Resource
	private BaseService baseService;
	
	@POST
	@Path("/getMicronoteList")
	@SysBusinessLog(remark="获取微笔记列表")
	@Produces(MediaType.APPLICATION_JSON)
	public BasePageResultListVO<CcpMicronoteResVO> getMicronoteList(CcpMicronoteReqVO request){
		return ccpMicronoteService.getMicronoteList(request);
	}
	
	@POST
	@Path("/getMicronoteRankingList")
	@SysBusinessLog(remark="获取微笔记排名列表")
	@Produces(MediaType.APPLICATION_JSON)
	public List<CcpMicronoteResVO> getMicronoteRankingList(CcpMicronoteReqVO request){
		return ccpMicronoteService.getMicronoteRankingList(request);
	}
	
	@POST
	@Path("/getMicronoteByCondition")
	@SysBusinessLog(remark="根据userId或noteId获取微笔记信息")
	@Produces(MediaType.APPLICATION_JSON)
	public CcpMicronoteResVO getMicronoteByCondition(CcpMicronoteReqVO request){
		return ccpMicronoteService.getMicronoteByCondition(request);
	}
	
	@POST
	@Path("/saveMicronote")
	@SysBusinessLog(remark="保存微笔记信息")
	@Produces(MediaType.APPLICATION_JSON)
	public int saveMicronote(CcpMicronoteReqVO request){
		return ccpMicronoteService.saveMicronote(request);
	}
	
	@POST
	@Path("/deleteMicronote")
	@SysBusinessLog(remark="删除微笔记")
	@Produces(MediaType.APPLICATION_JSON)
	public void deleteMicronote(CcpMicronoteReqVO request){
		ccpMicronoteService.deleteMicronote(request);
	}
	
	@POST
	@Path("/voteMicronote")
	@SysBusinessLog(remark="微笔记投票")
	@Produces(MediaType.APPLICATION_JSON)
	public void voteMironote(CcpMicronoteVoteReqVO request){
		ccpMicronoteService.voteMicronote(request);
	}
}
