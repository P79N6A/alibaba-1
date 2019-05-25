package com.culturecloud.service.openrs;

import java.util.List;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.culturecloud.dao.dto.openrs.BpInfoTagOpenDTO;
import com.culturecloud.dao.openrs.BpInfoTagOpenApiMapper;
import com.culturecloud.exception.BizException;
import com.culturecloud.req.openrs.ExceptionCodeEnum;
import com.culturecloud.req.openrs.GetBpInfoTags;
import com.culturecloud.req.openrs.SysSourceToDept;
import com.culturecloud.utils.PpsConfig;

@Component
@Path("open/api/bpInfoTag")
public class BpInfoTagOpenResource {

	@Resource
	private BpInfoTagOpenApiMapper bpInfoTagOpenApiMapper;
	
	/**
	 * 活动相关数据
	 * */
	@POST
	@Path("/getBpInfoTags")
	@Produces(MediaType.APPLICATION_JSON)
	public List<BpInfoTagOpenDTO> getBpInfoList(GetBpInfoTags open)
	{
		String source = SysSourceToDept.toDept(open.getSysSource());
		if(source != null)
		{
			List<BpInfoTagOpenDTO> list = null;
			list = bpInfoTagOpenApiMapper.getBpInfoTags(source,open.getUpdateTime(),PpsConfig.getString("staticServerUrl"));
			return list;
		}
		else
		{
			BizException.Throw(ExceptionCodeEnum.SYS_SOURCE_ERROR.getCode().toString(), ExceptionCodeEnum.SYS_SOURCE_ERROR.toString());
		}
		return null;
	}
	
}
