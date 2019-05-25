package com.culturecloud.service.openrs;

import java.util.List;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.culturecloud.dao.dto.openrs.BpInfoOpenDTO;
import com.culturecloud.dao.openrs.BpInfoOpenApiMapper;
import com.culturecloud.exception.BizException;
import com.culturecloud.req.openrs.ExceptionCodeEnum;
import com.culturecloud.req.openrs.GetBpInfos;
import com.culturecloud.req.openrs.SysSourceToDept;
import com.culturecloud.utils.PpsConfig;

@Component
@Path("/open/api/bpInfo")
public class BpInfoOpenResource {

	@Resource
	private BpInfoOpenApiMapper bpInfoOpenApiMapper;
	
	/**
	 * 活动相关数据
	 * */
	@POST
	@Path("/getBpInfos")
	@Produces(MediaType.APPLICATION_JSON)
	public List<BpInfoOpenDTO> getBpInfoList(GetBpInfos open)
	{
		String source = SysSourceToDept.toDept(open.getSysSource());
		if(source != null)
		{
			List<BpInfoOpenDTO> list = null;
			list = bpInfoOpenApiMapper.getBpInfos(source,open.getUpdateTime(),PpsConfig.getString("staticServerUrl"));
			return list;
		}
		else
		{
			BizException.Throw(ExceptionCodeEnum.SYS_SOURCE_ERROR.getCode().toString(), ExceptionCodeEnum.SYS_SOURCE_ERROR.toString());
		}
		return null;
	}
	
}
