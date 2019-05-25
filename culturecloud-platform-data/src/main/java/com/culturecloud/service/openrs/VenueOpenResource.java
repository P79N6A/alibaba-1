package com.culturecloud.service.openrs;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.culturecloud.dao.dto.openrs.VenueOpenDTO;
import com.culturecloud.dao.openrs.VenueOpenApiMapper;
import com.culturecloud.exception.BizException;
import com.culturecloud.req.openrs.ExceptionCodeEnum;
import com.culturecloud.req.openrs.GetVenues;
import com.culturecloud.req.openrs.SysSourceToDept;
import com.culturecloud.utils.PpsConfig;

@Component
@Path("/open/api/venue")
public class VenueOpenResource {

	@Resource
	private VenueOpenApiMapper venueOpenApiMapper;
	
	/**
	 * 场馆相关数据
	 * */
	@POST
	@Path("/getvenues")
	@Produces(MediaType.APPLICATION_JSON)
	public List<VenueOpenDTO> getVenues(GetVenues open)
	{
		String source = SysSourceToDept.toDept(open.getSysSource());
		if(source != null)
		{
			List<VenueOpenDTO> list = null;
			list = venueOpenApiMapper.getVenues(source,open.getUpdateTime(),PpsConfig.getString("staticServerUrl"));
			for(VenueOpenDTO dto: list){
				int extActivityCount = venueOpenApiMapper.queryAppActivityCountByVenueId(dto.getVenueId());
				dto.setExtActivityCount(String.valueOf(extActivityCount));
				int extRoomCount = venueOpenApiMapper.queryAppRoomCountByVenueId(dto.getVenueId());
				dto.setExtRoomCount(String.valueOf(extRoomCount));
			}
			return list;
		}
		else
		{
			BizException.Throw(ExceptionCodeEnum.SYS_SOURCE_ERROR.getCode().toString(), ExceptionCodeEnum.SYS_SOURCE_ERROR.toString());
		}
		
		return null;
	}
	
}
