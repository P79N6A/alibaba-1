package com.culturecloud.service.rs.cacheservice;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.culturecloud.bean.BaseRequest;
import com.culturecloud.exception.BizException;

@Component
@Path("/cachedemo")
public class CacheDemoResource {

	
	@POST
	@Path("/getDemo")
	@Produces(MediaType.APPLICATION_JSON)
	public String getDemo(BaseRequest request)
	{
		//BizException.Throw("123", "123");
//		return request.getSource();
		return null;
	}
	
}
