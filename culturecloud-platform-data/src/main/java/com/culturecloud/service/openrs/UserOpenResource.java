package com.culturecloud.service.openrs;

import java.util.List;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.culturecloud.dao.dto.openrs.UserCollectDTO;
import com.culturecloud.dao.dto.openrs.UserOpenDTO;
import com.culturecloud.dao.openrs.UserOpenApiMapper;
import com.culturecloud.openapi.user.UserAuthRequest;
import com.culturecloud.openapi.user.UserCollectRequest;
import com.culturecloud.openapi.user.UserRequest;
import com.culturecloud.req.openrs.SysSourceToDept;
import com.culturecloud.service.BaseService;

@Component
@Path("/open/api/user")
public class UserOpenResource {

	@Resource
	private UserOpenApiMapper userOpenApiMapper;
	@Resource
	private BaseService baseService;
	
	/** 
	 * 用户相关数据
	 * */
	@POST
	@Path("/getuser")
	@Produces(MediaType.APPLICATION_JSON)
	public UserOpenDTO getUser(UserRequest request)
	{
		String source=SysSourceToDept.toDept(request.getSysSource());
		if(source!=null)
		{
			if(request.getUserId()!=null)
			{
				UserOpenDTO o=userOpenApiMapper.getUser(request.getUserId());
				return o;
			}
		}
		return null;
	}
	
	/**
	 * 用户认证
	 * */
	@POST
	@Path("/userauth")
	@Produces(MediaType.APPLICATION_JSON)
	public UserOpenDTO userAuth(UserAuthRequest request)
	{
		String source=SysSourceToDept.toDept(request.getSysSource());
		if(source!=null)
		{
			if(request.getUsername()!=null&&request.getPassword()!=null)
			{
				UserOpenDTO o=userOpenApiMapper.userAuth(request.getUsername(), request.getPassword());
				if(o!=null)
				{
					return o;
				}
				return null;
			}
		}
		return null;
	}
	
	
	/** 用户收藏*/
	@POST
	@Path("/usercollect")
	@Produces(MediaType.APPLICATION_JSON)
	public List<UserCollectDTO> usercollect(UserCollectRequest request)
	{
		String source=SysSourceToDept.toDept(request.getSysSource());
		if(source!=null)
		{
			List<UserCollectDTO> list=userOpenApiMapper.usercollect(request.getUserId());
			return list;
		}
		return null;
		
	}
	
	
	
}
