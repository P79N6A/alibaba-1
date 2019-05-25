package com.culturecloud.service.rs.platformservice.association;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.dao.association.CcpAssociationMapper;
import com.culturecloud.dao.dto.activity.CmsActivityDto;
import com.culturecloud.model.bean.activity.CmsActivity;
import com.culturecloud.model.request.association.AssociationActivityVO;
import com.culturecloud.model.request.association.AssociationByRecruitListVO;
import com.culturecloud.model.request.association.GetAssociationDetailVO;
import com.culturecloud.model.response.activity.CmsActivityVO;
import com.culturecloud.model.response.association.CcpAssociationDetailVO;
import com.culturecloud.model.response.association.CcpAssociationVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.service.local.association.CcpAssociationService;

@Component
@Path("/association")
public class CcpAssociationResource {

	@Resource
	private CcpAssociationService ccpAssociationService;
	@Resource
	private CcpAssociationMapper ccpAssociationMapper;

	@Resource
	private BaseService baseService;

	@POST
	@Path("/getAssociationList")
	@SysBusinessLog(remark="获取社团列表")
	@Produces(MediaType.APPLICATION_JSON)
	public List<CcpAssociationVO> getAssociationList(AssociationByRecruitListVO request){
		Map<String,Object> param=new HashMap<String, Object>();
		Integer recruitStatus = null;
		if(request.getRecruitStatus()!= null){
			param.put("recruitStatus", recruitStatus);
		}
		if(request.getAssnName()!= null){
			param.put("assnName", request.getAssnName());
		}
		List<CcpAssociationVO> resultList=ccpAssociationService.getAllAssociation(param);

		return resultList;
	}

	@POST
	@Path("/getAssociationListPC")
	@SysBusinessLog(remark="PC获取社团列表")
	@Produces(MediaType.APPLICATION_JSON)
	public Map<String,Object> getAssociationListPC(AssociationByRecruitListVO request){
		Map<String,Object> result = new HashMap<String,Object>();
		Map<String,Object> param=new HashMap<String, Object>();
		if(request.getRecruitStatus()!= null){
			param.put("recruitStatus", request.getRecruitStatus());
		}
		if(request.getAssnName()!= null){
			param.put("assnName", request.getAssnName());
		}
		int total=ccpAssociationMapper.getAllAssociationCount(param);
		if(request.getResultSize()!=null){
			param.put("resultSize", request.getResultSize());
		}
		if(request.getResultSize()!=null){
			param.put("resultFirst", request.getResultFirst());
		}
		List<CcpAssociationVO> resultList=ccpAssociationService.getAllAssociationPc(param);
		result.put("list", resultList);
		result.put("total", total);
		return result;
	}

	@POST
	@Path("/getAssociationDetail")
	@SysBusinessLog(remark="获取社团详情")
	@Produces(MediaType.APPLICATION_JSON)
	public CcpAssociationDetailVO getAssociationDetail(GetAssociationDetailVO request){

		String associationId=request.getAssociationId();
		String userId=request.getUserId();

		CcpAssociationDetailVO associationDetailVO=ccpAssociationService.getAssociationDetail(associationId, userId);

		return associationDetailVO;

	}


	@POST
	@Path("/associationActivity")
	@SysBusinessLog(remark="获取社团进行中活动")
	@Produces(MediaType.APPLICATION_JSON)
	public List<CmsActivityVO> associationActivity(AssociationActivityVO request){

		String assnId=request.getAssociationId();

		List<CmsActivityVO> result=new ArrayList<>();

		if(StringUtils.isNotBlank(assnId))
		{
			result=ccpAssociationService.getAssociationActivity(assnId);
		}
		return result;
	}



	@POST
	@Path("/associationHistoryActivity")
	@SysBusinessLog(remark="获取社团历史活动")
	@Produces(MediaType.APPLICATION_JSON)
	public List<CmsActivityVO> associationHistoryActivity(AssociationActivityVO request){

		String assnId=request.getAssociationId();

		List<CmsActivityVO> result=new ArrayList<>();

		if(StringUtils.isNotBlank(assnId))
		{
			result=ccpAssociationService.getAssociationHistoryActivity(assnId);
		}

		return result;
	}

	@POST
	@Path("/associationHistoryActivityPC")
	@SysBusinessLog(remark="获取社团历史活动")
	@Produces(MediaType.APPLICATION_JSON)
	public  Map<String,Object> associationHistoryActivityPC(AssociationActivityVO request){
		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();
		String assnId = request.getAssociationId();
		param.put("assnId", assnId);
		if (request.getResultSize() != null) {
			param.put("resultSize", request.getResultSize());
		}
		if (request.getResultSize() != null) {
			param.put("resultFirst", request.getResultFirst());
		}
		int total = 0;
		if (StringUtils.isNotBlank(assnId)) {
			total = ccpAssociationService.getAssociationHistoryActivityCount(param);
		}
		List<CmsActivityDto> list = new ArrayList<>();

		if (StringUtils.isNotBlank(assnId)) {
			list = ccpAssociationService.getAssociationHistoryActivityPC(param);
		}
		result.put("list", list);
		result.put("total", total);
		return result;
	}

}
