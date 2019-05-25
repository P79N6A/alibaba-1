package com.culturecloud.service.openrs;

import java.util.List;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.culturecloud.dao.dto.openrs.ActivityOpenDTO;
import com.culturecloud.dao.openrs.ActivityOpenApiMapper;
import com.culturecloud.exception.BizException;
import com.culturecloud.req.openrs.ExceptionCodeEnum;
import com.culturecloud.req.openrs.GetActivitys;
import com.culturecloud.req.openrs.SysSourceToDept;
import com.culturecloud.utils.PpsConfig;

@Component
@Path("/open/api/activity")
public class ActivityOpenResource {

	@Resource
	private ActivityOpenApiMapper activityOpenApiMapper;
	
	/**
	 * 活动相关数据
	 * */
	@POST
	@Path("/getactivitys")
	@Produces(MediaType.APPLICATION_JSON)
	public List<ActivityOpenDTO> getActiviyList(GetActivitys open)
	{
		String source = SysSourceToDept.toDept(open.getSysSource());
		if(source != null)
		{
			List<ActivityOpenDTO> list = null;
			list = activityOpenApiMapper.getAcivitys(source,open.getUpdateTime(),PpsConfig.getString("staticServerUrl"));
			return list;
		}
		else
		{
			BizException.Throw(ExceptionCodeEnum.SYS_SOURCE_ERROR.getCode().toString(), ExceptionCodeEnum.SYS_SOURCE_ERROR.toString());
		}
		return null;
	}
	
}
