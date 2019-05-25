package com.culturecloud.service.rs.platformservice.beautycity;

import java.util.List;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.bean.BasePageResultListVO;
import com.culturecloud.model.request.beautycity.CcpBeautycityImgReqVO;
import com.culturecloud.model.request.beautycity.CcpBeautycityReqVO;
import com.culturecloud.model.request.beautycity.CcpBeautycityVenueReqVO;
import com.culturecloud.model.request.beautycity.CcpBeautycityVoteReqVO;
import com.culturecloud.model.request.micronote.CcpMicronoteReqVO;
import com.culturecloud.model.response.beautycity.CcpBeautycityImgResVO;
import com.culturecloud.model.response.beautycity.CcpBeautycityResVO;
import com.culturecloud.model.response.beautycity.CcpBeautycityVenueResVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.service.local.beautycity.CcpBeautycityService;

@Component
@Path("/beautycity")
public class CcpBeautycityResource {

	@Resource
	private CcpBeautycityService ccpBeautycityService;
	@Resource
	private BaseService baseService;
	
	@POST
	@Path("/getBeautycityImgList")
	@SysBusinessLog(remark="获取最美城市图片列表")
	@Produces(MediaType.APPLICATION_JSON)
	public BasePageResultListVO<CcpBeautycityImgResVO> getBeautycityImgList(CcpBeautycityImgReqVO request){
		return ccpBeautycityService.getBeautycityImgList(request);
	}
	
	@POST
	@Path("/getBeautycityImgRankingList")
	@SysBusinessLog(remark="获取最美城市图片排名列表")
	@Produces(MediaType.APPLICATION_JSON)
	public List<CcpBeautycityImgResVO> getBeautycityImgRankingList(CcpBeautycityImgReqVO request){
		return ccpBeautycityService.getBeautycityImgRankingList(request);
	}
	
	@POST
	@Path("/saveBeautycity")
	@SysBusinessLog(remark="保存用户信息")
	@Produces(MediaType.APPLICATION_JSON)
	public void saveBeautycity(CcpBeautycityReqVO request){
		ccpBeautycityService.saveBeautycity(request);
	}
	
	@POST
	@Path("/saveBeautycityImg")
	@SysBusinessLog(remark="保存最美城市图片")
	@Produces(MediaType.APPLICATION_JSON)
	public void saveBeautycityImg(CcpBeautycityImgReqVO request){
		ccpBeautycityService.saveBeautycityImg(request);
	}
	
	@POST
	@Path("/voteBeautycityImg")
	@SysBusinessLog(remark="最美城市图片投票")
	@Produces(MediaType.APPLICATION_JSON)
	public void voteBeautycityImg(CcpBeautycityVoteReqVO request){
		ccpBeautycityService.voteBeautycityImg(request);
	}
	
	@POST
	@Path("/getBeautycityVenueList")
	@SysBusinessLog(remark="获取最美城市场馆列表")
	@Produces(MediaType.APPLICATION_JSON)
	public List<CcpBeautycityVenueResVO> getBeautycityVenueList(CcpBeautycityVenueReqVO request){
		return ccpBeautycityService.getBeautycityVenueList(request);
	}
	
	@POST
	@Path("/getBeautycityList")
	@SysBusinessLog(remark="获取最美城市用户信息列表")
	@Produces(MediaType.APPLICATION_JSON)
	public BasePageResultListVO<CcpBeautycityResVO> getBeautycityList(CcpBeautycityReqVO request){
		return ccpBeautycityService.getBeautycityList(request);
	}
	
	@POST
	@Path("/deleteBeautycityImg")
	@SysBusinessLog(remark="删除最美城市图片")
	@Produces(MediaType.APPLICATION_JSON)
	public void deleteBeautycityImg(CcpBeautycityImgReqVO request){
		ccpBeautycityService.deleteBeautycityImg(request);
	}
}
