package com.culturecloud.service.openrs;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.culturecloud.dao.dto.openrs.StatisticsCommonOpenDTO;
import com.culturecloud.dao.openrs.ActivityOpenApiMapper;
import com.culturecloud.dao.openrs.UserOpenApiMapper;
import com.culturecloud.dao.openrs.VenueOpenApiMapper;
import com.culturecloud.exception.BizException;
import com.culturecloud.req.openrs.ExceptionCodeEnum;
import com.culturecloud.req.openrs.GetStatisticsCommon;
import com.culturecloud.req.openrs.SysSourceToDept;

@Component
@Path("/open/api/statistics")
public class StatisticsOpenResource {
	
	@Resource
	private ActivityOpenApiMapper activityOpenApiMapper;
	@Resource
	private VenueOpenApiMapper venueOpenApiMapper;
	@Resource
	private UserOpenApiMapper userOpenApiMapper;
	
	/**
	 * 评论、发布统计数量
	 * */
	@POST
	@Path("/getStatisticsCommonCount")
	@Produces(MediaType.APPLICATION_JSON)
	public StatisticsCommonOpenDTO getStatisticsCommonCount(GetStatisticsCommon vo)
	{
		String source=SysSourceToDept.toDept(vo.getSysSource());
		
		if(source!=null){
			
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			
			StatisticsCommonOpenDTO dto = new StatisticsCommonOpenDTO();
			int activityCommentCount = activityOpenApiMapper.getActivityCommentCount(source,df.format(new Date(new Date().getTime()-24*60*60*1000)));
			dto.setActivityCommentCount(activityCommentCount);
			int venueCommentCount = venueOpenApiMapper.getVenueCommentCount(source,df.format(new Date(new Date().getTime()-24*60*60*1000)));
			dto.setVenueCommentCount(venueCommentCount);
			int activityPublishCount = activityOpenApiMapper.getActivityPublishCount(source,df.format(new Date(new Date().getTime()-24*60*60*1000)));
			dto.setActivityPublishCount(activityPublishCount);
			int venuePublishCount = venueOpenApiMapper.getVenuePublishCount(source,df.format(new Date(new Date().getTime()-24*60*60*1000)));
			dto.setVenuePublishCount(venuePublishCount);
			return dto;
			
		}else{
			BizException.Throw(ExceptionCodeEnum.SYS_SOURCE_ERROR.getCode().toString(), ExceptionCodeEnum.SYS_SOURCE_ERROR.toString());
		}
		
		return null;
	}
	
}
