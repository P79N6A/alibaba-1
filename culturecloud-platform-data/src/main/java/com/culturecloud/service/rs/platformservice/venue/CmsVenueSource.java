package com.culturecloud.service.rs.platformservice.venue;

import java.util.List;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.model.request.venue.SearchVenueVO;
import com.culturecloud.model.response.venue.CmsVenueVO;
import com.culturecloud.service.local.venue.CmsVenueService;

@Component
@Path("/venue")
public class CmsVenueSource {
	
	@Resource
	private CmsVenueService cmsVenueService;

	@POST
	@Path("/searchVenue")
	@SysBusinessLog(remark="搜索场馆列表")
	@Produces(MediaType.APPLICATION_JSON)
	public List<CmsVenueVO> searchVenue(SearchVenueVO request)
	{
		String keyword=request.getKeyword();
		
		int limit=50;
		
		return cmsVenueService.searchVenue(limit,keyword);
	}
}
