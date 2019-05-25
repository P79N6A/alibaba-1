package com.culturecloud.service.rs.platformservice.venue;


import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.model.request.venue.CmsAntiqueListVO;
import com.culturecloud.service.local.venue.CmsAntiqueService;

@Component
@Path("/antique")
public class CmsAntiqueSource {

	@Resource
	private CmsAntiqueService cmsAntiqueService;

	@POST
	@Path("/create")
	@SysBusinessLog(remark="搜索场馆列表")
	@Produces(MediaType.APPLICATION_JSON)
	public void create(CmsAntiqueListVO antiqueList)
	{
		 cmsAntiqueService.createCmsAntique(antiqueList.getList());
	}
}
