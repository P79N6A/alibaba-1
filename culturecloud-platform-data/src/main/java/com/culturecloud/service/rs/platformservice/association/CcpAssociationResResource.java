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

import com.culturecloud.dao.association.CcpAssociationResMapper;
import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.model.bean.association.CcpAssociation;
import com.culturecloud.model.bean.association.CcpAssociationRes;
import com.culturecloud.model.request.association.AssociationResourceListVO;
import com.culturecloud.model.response.association.CcpAssociationResVO;
import com.culturecloud.service.BaseService;

@Component
@Path("/associationRes")
public class CcpAssociationResResource {
	
	@Resource
	private BaseService baseService;
	@Resource
	private CcpAssociationResMapper ccpAssociationResMapper;

	@POST
	@Path("/associationResourceList") 	
	@SysBusinessLog(remark="获取社团资源列表")
	@Produces(MediaType.APPLICATION_JSON)
	public List<CcpAssociationResVO> associationResourceList(AssociationResourceListVO request){
		
		 String associationId=request.getAssociationId();
			
		// 资源类型（1:图片；2:视频）
		 Integer resType=request.getResType();
		 
		 CcpAssociationRes model=new CcpAssociationRes();
		 model.setAssnId(associationId);
		 model.setResType(resType);
		 
		 List<CcpAssociationRes> resList=baseService.findByModel(model);
		 
		 List<CcpAssociationResVO> result=new ArrayList<CcpAssociationResVO>();
		
		 for (CcpAssociationRes res : resList) {
			 result.add(new CcpAssociationResVO(res));
		}
		
		return result;
	}

	@POST
	@Path("/associationResourceListPC")
	@SysBusinessLog(remark="PC获取社团资源列表")
	@Produces(MediaType.APPLICATION_JSON)
	public Map<String,Object> associationResourceListPC(AssociationResourceListVO request){
		Map<String,Object> result = new HashMap<String,Object>();
		Map<String,Object> param=new HashMap<String, Object>();
		String associationId=request.getAssociationId();
		// 资源类型（1:图片；2:视频）
		Integer resType=request.getResType();
		if(resType!=null){
			param.put("resType", resType);
		}
		param.put("associationId", associationId);
		if(request.getResultSize()!=null){
			param.put("resultSize", request.getResultSize());
		}
		if(request.getResultSize()!=null){
			param.put("resultFirst", request.getResultFirst());
		}
		int total=ccpAssociationResMapper.getAssociationResCount(param);
		List<CcpAssociationRes> list = ccpAssociationResMapper.getAssociationRes(param);
	    /*List<CcpAssociationResVO> resultList = new ArrayList<CcpAssociationResVO>();
	    for (CcpAssociationRes res : list) {
	    	resultList.add(new CcpAssociationResVO(res));
		}*/
		result.put("list", list);
		result.put("total", total);
		return result;
	}
}
