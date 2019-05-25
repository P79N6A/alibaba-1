package com.culturecloud.service.rs.platformservice.common;

import java.util.List;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.model.request.common.QueryRelateTagSubListVO;
import com.culturecloud.model.response.common.CmsTagSubVO;
import com.culturecloud.service.local.common.CmsTagSubService;

@Component
@Path("/tagSub")
public class CmsTagSubResource {

	@Resource
	private CmsTagSubService cmsTagSubService;
	
	@POST
	@Path("/relateTagSubList")
	@SysBusinessLog(remark="获取实体关联标签")
	@Produces(MediaType.APPLICATION_JSON)
	public List<CmsTagSubVO> relateTagSubList(QueryRelateTagSubListVO request){
		
		String relateId=request.getRelateId();
		
		return 	cmsTagSubService.queryRelateTagSubList(relateId);
	}
}
